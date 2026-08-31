#!/bin/bash
# Shared preflight checks before desktop or mobile test runs.
# Invoked from .github/workflows/preflight.yml (and locally).

set -euo pipefail

http3_curl () {
  if command -v curl >/dev/null && curl --help 2>&1 | grep -q http3-only; then
    command -v curl
    return
  fi
  for candidate in \
    /opt/homebrew/opt/curl/bin/curl \
    /usr/local/opt/curl/bin/curl; do
    if [[ -x "$candidate" ]] && "$candidate" --help 2>&1 | grep -q http3-only; then
      echo "$candidate"
      return
    fi
  done
  echo "curl with HTTP/3 support not found (need --http3-only)" >&2
  echo "On macOS: brew install curl" >&2
  exit 1
}

check_altsvc_http3 () {
  local url="${1:-https://altsvc.privacytests2.org:4433/set}"
  local curl_bin
  curl_bin="$(http3_curl)"
  echo "Checking Alt-Svc HTTP/3 server: ${url}"
  echo "Using curl: ${curl_bin} ($("$curl_bin" --version | head -1))"
  "$curl_bin" -vf --http3-only "$url"
  echo "Alt-Svc HTTP/3 server OK"
}

check_altsvc_http3
