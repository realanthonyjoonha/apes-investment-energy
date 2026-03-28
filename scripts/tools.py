"""
Tool definitions and handlers for the Claude-powered investment research agents.
These replicate the MCP tool functionality for use with the Claude API directly.
"""

import os
import json
import time
import base64
import requests
import duckdb
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from google.oauth2.credentials import Credentials
from google.auth.transport.requests import Request
from googleapiclient.discovery import build

# ============================================================
# IN-MEMORY DATABASE FOR store_as / query_data
# ============================================================
DB = duckdb.connect(":memory:")
STORED_TABLES = {}


# ============================================================
# TOOL DEFINITIONS (Claude API format)
# ============================================================

TOOL_DEFINITIONS = [
    {
        "name": "mmd_search_endpoints",
        "description": "Search for Massive Market Data API endpoints by keyword. Returns matching endpoint patterns and descriptions. Use this FIRST to discover the right endpoint for stock prices, options, aggregates, etc.",
        "input_schema": {
            "type": "object",
            "properties": {
                "query": {
                    "type": "string",
                    "description": "Natural language search query (e.g., 'stock aggregates', 'options contracts', 'previous day bar')"
                }
            },
            "required": ["query"]
        }
    },
    {
        "name": "mmd_call_api",
        "description": "Call the Massive Market Data API (Polygon-compatible). Fetches stock prices, options, aggregates, etc. Only GET requests. Optionally store results as an in-memory table for SQL querying.",
        "input_schema": {
            "type": "object",
            "properties": {
                "path": {
                    "type": "string",
                    "description": "API endpoint path (e.g., /v2/aggs/ticker/AAPL/range/1/day/2024-01-01/2024-01-31)"
                },
                "params": {
                    "type": "object",
                    "description": "Query parameters as key-value pairs"
                },
                "store_as": {
                    "type": "string",
                    "description": "Table name to store results for SQL querying later"
                }
            },
            "required": ["path"]
        }
    },
    {
        "name": "mmd_query_data",
        "description": "Run SQL queries against stored market data tables (created via store_as parameter in mmd_call_api). Uses DuckDB SQL syntax.",
        "input_schema": {
            "type": "object",
            "properties": {
                "sql": {
                    "type": "string",
                    "description": "SQL query to run against stored tables"
                }
            },
            "required": ["sql"]
        }
    },
    {
        "name": "web_search",
        "description": "Search the web for current information. Returns search results with titles, snippets, and URLs.",
        "input_schema": {
            "type": "object",
            "properties": {
                "query": {
                    "type": "string",
                    "description": "Search query"
                }
            },
            "required": ["query"]
        }
    },
    {
        "name": "send_email",
        "description": "Send an email via Gmail API. Supports HTML content.",
        "input_schema": {
            "type": "object",
            "properties": {
                "to": {
                    "type": "string",
                    "description": "Comma-separated recipient email addresses"
                },
                "subject": {
                    "type": "string",
                    "description": "Email subject line"
                },
                "body": {
                    "type": "string",
                    "description": "Email body (HTML supported)"
                },
                "content_type": {
                    "type": "string",
                    "enum": ["text/plain", "text/html"],
                    "description": "Content type of the email body"
                }
            },
            "required": ["to", "subject", "body"]
        }
    },
    {
        "name": "read_config",
        "description": "Read a configuration file from the repository's config/ directory.",
        "input_schema": {
            "type": "object",
            "properties": {
                "filename": {
                    "type": "string",
                    "description": "Config filename (e.g., 'watchlist.json', 'flagged-tickers.json')"
                }
            },
            "required": ["filename"]
        }
    },
    {
        "name": "read_prompt",
        "description": "Read a prompt template from the repository's prompts/ directory.",
        "input_schema": {
            "type": "object",
            "properties": {
                "filename": {
                    "type": "string",
                    "description": "Prompt filename (e.g., 'morning-brief.md')"
                }
            },
            "required": ["filename"]
        }
    }
]


# ============================================================
# TOOL HANDLERS
# ============================================================

MMD_BASE_URL = "https://api.polygon.io"  # Massive Market Data uses Polygon-compatible API


def handle_mmd_search_endpoints(query: str) -> str:
    """Search MMD endpoints - returns a static mapping of common endpoints."""
    endpoints = {
        "previous day bar": "/v2/aggs/ticker/{ticker}/prev - Get previous day OHLCV bar",
        "aggregates range": "/v2/aggs/ticker/{ticker}/range/{multiplier}/{timespan}/{from}/{to} - Get aggregate bars over a date range",
        "ticker details": "/v3/reference/tickers/{ticker} - Get ticker details and fundamentals",
        "options contracts": "/v3/reference/options/contracts - List options contracts with filters",
        "options chain": "/v3/snapshot/options/{underlyingAsset} - Get full options chain snapshot",
        "stock snapshot": "/v2/snapshot/locale/us/markets/stocks/tickers/{ticker} - Get current snapshot",
        "grouped daily": "/v2/aggs/grouped/locale/us/market/stocks/{date} - Get all tickers for a date",
        "technical SMA": "/v1/indicators/sma/{ticker} - Simple Moving Average",
        "technical EMA": "/v1/indicators/ema/{ticker} - Exponential Moving Average",
        "technical MACD": "/v1/indicators/macd/{ticker} - MACD indicator",
        "technical RSI": "/v1/indicators/rsi/{ticker} - Relative Strength Index",
    }

    results = []
    query_lower = query.lower()
    for key, desc in endpoints.items():
        if any(word in key for word in query_lower.split()):
            results.append(desc)

    if not results:
        results = list(endpoints.values())

    return "Matching endpoints:\n" + "\n".join(f"- {r}" for r in results)


def handle_mmd_call_api(path: str, params: dict = None, store_as: str = None) -> str:
    """Call the Massive Market Data (Polygon) API."""
    api_key = os.environ.get("MMD_API_KEY")
    if not api_key:
        return "ERROR: MMD_API_KEY environment variable not set"

    url = f"{MMD_BASE_URL}{path}"

    if params is None:
        params = {}
    params["apiKey"] = api_key

    max_retries = 3
    for attempt in range(max_retries):
        try:
            response = requests.get(url, params=params, timeout=30)

            if response.status_code == 429:
                wait_time = 60 * (attempt + 1)
                print(f"Rate limited (429). Waiting {wait_time}s before retry...")
                time.sleep(wait_time)
                continue

            response.raise_for_status()
            data = response.json()

            # Store results if requested
            if store_as and "results" in data:
                try:
                    results = data["results"]
                    if isinstance(results, list) and len(results) > 0:
                        DB.execute(f"DROP TABLE IF EXISTS {store_as}")
                        DB.execute(
                            f"CREATE TABLE {store_as} AS SELECT * FROM read_json_auto(?)",
                            [json.dumps(results)]
                        )
                        STORED_TABLES[store_as] = len(results)
                except Exception as e:
                    return f"API call succeeded but storage failed: {e}\n\nRaw results (first 5):\n{json.dumps(data['results'][:5], indent=2)}"

            # Return formatted preview
            if "results" in data:
                results = data["results"]
                preview = results[:5] if isinstance(results, list) else results
                storage_note = f"\n\nStored as table '{store_as}' ({len(results)} rows)" if store_as else ""
                return json.dumps(preview, indent=2) + storage_note
            else:
                return json.dumps(data, indent=2)

        except requests.exceptions.RequestException as e:
            if attempt < max_retries - 1:
                time.sleep(5)
                continue
            return f"ERROR after {max_retries} attempts: {str(e)}"

    return "ERROR: Max retries exceeded due to rate limiting"


def handle_mmd_query_data(sql: str) -> str:
    """Run SQL query against stored market data tables."""
    try:
        result = DB.execute(sql).fetchdf()
        return result.to_string(index=False, max_rows=50)
    except Exception as e:
        available = list(STORED_TABLES.keys())
        return f"SQL Error: {str(e)}\n\nAvailable tables: {available}"


def handle_web_search(query: str) -> str:
    """Search the web using Google Custom Search API or fallback to DuckDuckGo."""
    # Try Google Custom Search first
    google_api_key = os.environ.get("GOOGLE_SEARCH_API_KEY")
    google_cx = os.environ.get("GOOGLE_SEARCH_CX")

    if google_api_key and google_cx:
        try:
            url = "https://www.googleapis.com/customsearch/v1"
            params = {"key": google_api_key, "cx": google_cx, "q": query, "num": 8}
            response = requests.get(url, params=params, timeout=15)
            response.raise_for_status()
            data = response.json()

            results = []
            for item in data.get("items", []):
                results.append(f"**{item['title']}**\n{item.get('snippet', '')}\nURL: {item['link']}\n")

            return "\n".join(results) if results else "No results found."
        except Exception as e:
            print(f"Google Search failed: {e}, falling back to DuckDuckGo")

    # Fallback: DuckDuckGo instant answer API
    try:
        url = "https://api.duckduckgo.com/"
        params = {"q": query, "format": "json", "no_redirect": 1}
        response = requests.get(url, params=params, timeout=10)
        data = response.json()

        results = []
        if data.get("Abstract"):
            results.append(f"**{data.get('Heading', 'Result')}**\n{data['Abstract']}\nURL: {data.get('AbstractURL', '')}\n")

        for topic in data.get("RelatedTopics", [])[:5]:
            if isinstance(topic, dict) and "Text" in topic:
                results.append(f"- {topic['Text']}\n  URL: {topic.get('FirstURL', '')}\n")

        return "\n".join(results) if results else f"No instant results for '{query}'. This query may need manual research."
    except Exception as e:
        return f"Web search error: {str(e)}"


def handle_send_email(to: str, subject: str, body: str, content_type: str = "text/html") -> str:
    """Send email via Gmail API using OAuth2 credentials."""
    creds_json = os.environ.get("GMAIL_CREDENTIALS")
    token_json = os.environ.get("GMAIL_TOKEN")

    if not creds_json or not token_json:
        return "ERROR: GMAIL_CREDENTIALS or GMAIL_TOKEN environment variables not set. Please configure Gmail OAuth2."

    try:
        token_data = json.loads(token_json)
        creds = Credentials.from_authorized_user_info(token_data)

        if creds.expired and creds.refresh_token:
            creds.refresh(Request())
            # Note: In production, you'd want to update the stored token

        service = build("gmail", "v1", credentials=creds)

        message = MIMEMultipart("alternative")
        message["to"] = to
        message["subject"] = subject

        mime_part = MIMEText(body, "html" if content_type == "text/html" else "plain")
        message.attach(mime_part)

        raw = base64.urlsafe_b64encode(message.as_bytes()).decode()

        result = service.users().messages().send(
            userId="me",
            body={"raw": raw}
        ).execute()

        return f"Email sent successfully! Message ID: {result['id']}"

    except Exception as e:
        return f"Email send error: {str(e)}"


def handle_read_config(filename: str) -> str:
    """Read a config file from the repo."""
    filepath = os.path.join(os.path.dirname(os.path.dirname(__file__)), "config", filename)
    try:
        with open(filepath, "r") as f:
            return f.read()
    except FileNotFoundError:
        return f"ERROR: Config file not found: {filepath}"


def handle_read_prompt(filename: str) -> str:
    """Read a prompt file from the repo."""
    filepath = os.path.join(os.path.dirname(os.path.dirname(__file__)), "prompts", filename)
    try:
        with open(filepath, "r") as f:
            return f.read()
    except FileNotFoundError:
        return f"ERROR: Prompt file not found: {filepath}"


# ============================================================
# TOOL DISPATCHER
# ============================================================

def dispatch_tool(tool_name: str, tool_input: dict) -> str:
    """Route a tool call to the appropriate handler."""
    handlers = {
        "mmd_search_endpoints": lambda inp: handle_mmd_search_endpoints(inp["query"]),
        "mmd_call_api": lambda inp: handle_mmd_call_api(
            inp["path"], inp.get("params"), inp.get("store_as")
        ),
        "mmd_query_data": lambda inp: handle_mmd_query_data(inp["sql"]),
        "web_search": lambda inp: handle_web_search(inp["query"]),
        "send_email": lambda inp: handle_send_email(
            inp["to"], inp["subject"], inp["body"], inp.get("content_type", "text/html")
        ),
        "read_config": lambda inp: handle_read_config(inp["filename"]),
        "read_prompt": lambda inp: handle_read_prompt(inp["filename"]),
    }

    handler = handlers.get(tool_name)
    if handler:
        try:
            return handler(tool_input)
        except Exception as e:
            return f"Tool execution error ({tool_name}): {str(e)}"
    else:
        return f"Unknown tool: {tool_name}"
