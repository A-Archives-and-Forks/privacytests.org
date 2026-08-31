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

check_http3 () {
  local label="$1"
  local url="$2"
  local curl_bin
  curl_bin="$(http3_curl)"
  echo "Checking ${label}: ${url}"
  echo "Using curl: ${curl_bin} ($("$curl_bin" --version | head -1))"
  "$curl_bin" -vf --http3-only "$url"
  echo "${label} OK"
}

check_http3 "Alt-Svc HTTP/3 server (privacytests2.org)" "https://altsvc.privacytests2.org:4433/protocol"
check_http3 "Alt-Svc HTTP/3 server (privacytests3.org)" "https://altsvc.privacytests3.org:4435/protocol"
check_http3 "HTTP/3 connection_id server" "https://h3.privacytests2.org:4434/connection_id"
