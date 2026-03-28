#!/usr/bin/env python3
"""
Gmail OAuth2 Setup Helper

Run this script ONCE locally to generate the Gmail OAuth2 token.
Then store the token as a GitHub Actions secret (GMAIL_TOKEN).

Prerequisites:
1. Go to https://console.cloud.google.com
2. Create a project (or use existing)
3. Enable the Gmail API
4. Create OAuth 2.0 credentials (Desktop App type)
5. Download the credentials JSON file
6. Run this script: python setup_gmail_oauth.py --credentials path/to/credentials.json

The script will:
- Open your browser for Google login
- Generate a token with Gmail send permission
- Save the token JSON to stdout (copy it to GitHub secrets)
"""

import os
import sys
import json
import argparse
from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow

# Gmail send scope
SCOPES = ["https://www.googleapis.com/auth/gmail.send"]


def main():
    parser = argparse.ArgumentParser(description="Generate Gmail OAuth2 token for GitHub Actions")
    parser.add_argument(
        "--credentials",
        required=True,
        help="Path to OAuth2 credentials JSON file downloaded from Google Cloud Console"
    )
    parser.add_argument(
        "--output",
        default=None,
        help="Output file for token JSON (default: print to stdout)"
    )
    args = parser.parse_args()

    if not os.path.exists(args.credentials):
        print(f"ERROR: Credentials file not found: {args.credentials}")
        sys.exit(1)

    print("Starting OAuth2 flow...")
    print("Your browser will open for Google authentication.\n")

    flow = InstalledAppFlow.from_client_secrets_file(args.credentials, SCOPES)
    creds = flow.run_local_server(port=0)

    token_data = {
        "token": creds.token,
        "refresh_token": creds.refresh_token,
        "token_uri": creds.token_uri,
        "client_id": creds.client_id,
        "client_secret": creds.client_secret,
        "scopes": list(creds.scopes)
    }

    token_json = json.dumps(token_data)

    if args.output:
        with open(args.output, "w") as f:
            f.write(token_json)
        print(f"\nToken saved to: {args.output}")
    else:
        print("\n" + "=" * 60)
        print("GMAIL_TOKEN value (copy this entire string to GitHub Secrets):")
        print("=" * 60)
        print(token_json)
        print("=" * 60)

    print("\nNext steps:")
    print("1. Go to your GitHub repo → Settings → Secrets and variables → Actions")
    print("2. Add a new secret named 'GMAIL_TOKEN' with the JSON above")
    print("3. The token auto-refreshes, but if it expires after ~6 months,")
    print("   re-run this script to generate a new one.")


if __name__ == "__main__":
    main()
