#!/usr/bin/env python3
"""Write and validate a Firebase service account key for CI deploy."""

from __future__ import annotations

import base64
import json
import os
import sys
import urllib.error
import urllib.request


def _load_service_account_data() -> dict:
    encoded = os.environ.get("FIREBASE_SERVICE_ACCOUNT_BASE64", "").strip()
    raw = os.environ.get("FIREBASE_SERVICE_ACCOUNT", "").strip()

    if encoded:
        try:
            decoded = base64.b64decode(encoded, validate=True)
            return json.loads(decoded)
        except (ValueError, json.JSONDecodeError) as error:
            print(f"::error::Invalid FIREBASE_SERVICE_ACCOUNT_BASE64: {error}")
            sys.exit(1)

    if raw:
        try:
            return json.loads(raw)
        except json.JSONDecodeError as error:
            print(f"::error::Invalid FIREBASE_SERVICE_ACCOUNT JSON: {error}")
            sys.exit(1)

    print(
        "::error::Missing credentials. Set FIREBASE_SERVICE_ACCOUNT_BASE64 "
        "(recommended) or FIREBASE_SERVICE_ACCOUNT in repository secrets."
    )
    sys.exit(1)


def _validate_fields(data: dict) -> None:
    project_id = data.get("project_id")
    client_email = data.get("client_email")
    private_key = data.get("private_key", "")

    if not project_id or not client_email:
        print("::error::Service account JSON is missing project_id or client_email.")
        sys.exit(1)

    if "BEGIN PRIVATE KEY" not in private_key:
        print(
            "::error::Service account JSON has an invalid private_key. "
            "Re-copy the full key from Firebase Console or use a BASE64 secret."
        )
        sys.exit(1)

    print(f"Service account project: {project_id}")
    print(f"Service account email: {client_email}")


def _verify_firebase_project(project_id: str, access_token: str) -> None:
    url = f"https://firebase.googleapis.com/v1beta1/projects/{project_id}"
    request = urllib.request.Request(
        url,
        headers={"Authorization": f"Bearer {access_token}"},
    )
    try:
        with urllib.request.urlopen(request, timeout=30) as response:
            if response.status != 200:
                print(f"::error::Unexpected Firebase API status: {response.status}")
                sys.exit(1)
    except urllib.error.HTTPError as error:
        body = error.read().decode("utf-8", errors="replace")
        print(f"::error::Firebase project check failed ({error.code}): {body}")
        print(
            "::error::Grant this service account the Firebase Admin role, or "
            "configure FIREBASE_TOKEN from `firebase login:ci`."
        )
        sys.exit(1)


def main() -> None:
    output_path = os.environ.get(
        "GOOGLE_APPLICATION_CREDENTIALS",
        os.path.join(os.environ.get("RUNNER_TEMP", "/tmp"), "gcp.json"),
    )

    data = _load_service_account_data()
    _validate_fields(data)

    with open(output_path, "w", encoding="utf-8") as handle:
        json.dump(data, handle)

    github_env = os.environ.get("GITHUB_ENV")
    if github_env:
        with open(github_env, "a", encoding="utf-8") as handle:
            handle.write(f"GOOGLE_APPLICATION_CREDENTIALS={output_path}\n")

    try:
        from google.oauth2 import service_account  # type: ignore
        import google.auth.transport.requests  # type: ignore
    except ImportError:
        print("google-auth not installed; skipping credential verification.")
        return

    credentials = service_account.Credentials.from_service_account_file(
        output_path,
        scopes=["https://www.googleapis.com/auth/cloud-platform"],
    )
    request = google.auth.transport.requests.Request()
    credentials.refresh(request)
    print("Service account authentication succeeded.")
    _verify_firebase_project(data["project_id"], credentials.token)


if __name__ == "__main__":
    main()
