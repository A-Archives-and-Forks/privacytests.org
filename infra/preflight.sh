#!/bin/bash
# Shared preflight checks before desktop or mobile test runs.
# Invoked from .github/workflows/preflight.yml (and locally).

set -euo pipefail

curl -vf --http3-only https://altsvc.privacytests2.org:4433/protocol
curl -vf --http3-only https://altsvc.privacytests3.org:4435/protocol
curl -vf --http3-only https://h3.privacytests2.org:4434/connection_id
