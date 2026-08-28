#!/bin/bash
# Ensure Appium is listening on port 4723 before mobile tests run.
# Invoked from GitHub Actions (see .github/workflows/mobile-tests.yml).

set -euo pipefail

APPIUM_PORT="${APPIUM_PORT:-4723}"
APPIUM_BASE_PATH="${APPIUM_BASE_PATH:-/wd/hub}"
APPIUM_STATUS_URL="http://127.0.0.1:${APPIUM_PORT}${APPIUM_BASE_PATH}/status"
APPIUM_LOG="${APPIUM_LOG:-/tmp/appium.log}"
APPIUM_START_TIMEOUT_SEC="${APPIUM_START_TIMEOUT_SEC:-60}"

export ANDROID_HOME="${ANDROID_HOME:-${HOME}/Library/Android/sdk}"
export ANDROID_SDK_ROOT="${ANDROID_SDK_ROOT:-${ANDROID_HOME}}"
export PATH="${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${PATH}"

if curl -sf "$APPIUM_STATUS_URL" >/dev/null; then
  echo "Appium already running on port ${APPIUM_PORT}"
  exit 0
fi

APPIUM_BIN="$(command -v appium || true)"
if [[ -z "$APPIUM_BIN" ]]; then
  echo "appium not found in PATH" >&2
  exit 1
fi

if [[ ! -d "$ANDROID_HOME" ]]; then
  echo "Android SDK not found at ${ANDROID_HOME}" >&2
  echo "Set ANDROID_HOME if the SDK is installed elsewhere." >&2
  exit 1
fi

echo "Starting Appium (${APPIUM_BIN}) on port ${APPIUM_PORT}…"
nohup "$APPIUM_BIN" -p "$APPIUM_PORT" --base-path "$APPIUM_BASE_PATH" >>"$APPIUM_LOG" 2>&1 &

deadline=$((SECONDS + APPIUM_START_TIMEOUT_SEC))
while (( SECONDS < deadline )); do
  if curl -sf "$APPIUM_STATUS_URL" >/dev/null; then
    echo "Appium ready"
    exit 0
  fi
  sleep 2
done

echo "Appium failed to start within ${APPIUM_START_TIMEOUT_SEC}s" >&2
tail -50 "$APPIUM_LOG" >&2 || true
exit 1
