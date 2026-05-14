#!/usr/bin/env bash
# Generates opencode.json from opencode.json.template + opencode.properties

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE="$SCRIPT_DIR/opencode.json.template"
PROPERTIES="$SCRIPT_DIR/opencode.properties"
OUTPUT="$SCRIPT_DIR/opencode.json"

if [[ ! -f "$PROPERTIES" ]]; then
  echo "Error: $PROPERTIES not found. Copy opencode.properties.example and fill in your values."
  exit 1
fi

set -a
# shellcheck source=/dev/null
source "$PROPERTIES"
set +a

envsubst '${GOOGLE_OAUTH_CLIENT_ID} ${GOOGLE_OAUTH_CLIENT_SECRET} ${CONTEXT7_API_KEY}' < "$TEMPLATE" > "$OUTPUT"
echo "Generated $OUTPUT"
