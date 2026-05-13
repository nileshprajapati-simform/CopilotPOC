#!/usr/bin/env bash
set -euo pipefail

# Copilot hook logger for security audit trails.
# Usage: security-audit.sh pre|post

PHASE="${1:-event}"
INPUT="$(cat)"
LOG_DIR=".github/hooks/logs"
LOG_FILE="$LOG_DIR/agent-logs.txt"
mkdir -p "$LOG_DIR"

extract_field() {
  local json="$1"
  local field="$2"
  python3 - "$field" <<'PY' <<<"$json"
import json
import sys
field = sys.argv[1]
try:
    data = json.load(sys.stdin)
except Exception:
    print("")
    raise SystemExit(0)
value = data.get(field, "")
if isinstance(value, str):
    print(value)
else:
    print("")
PY
}

extract_status() {
  local json="$1"
  python3 - <<'PY' <<<"$json"
import json
import sys
try:
    data = json.load(sys.stdin)
except Exception:
    print("unknown")
    raise SystemExit(0)

result = data.get("toolResult")
if isinstance(result, dict):
    status = result.get("resultType")
    if isinstance(status, str) and status.strip():
        print(status.strip())
        raise SystemExit(0)

status = data.get("status")
if isinstance(status, str) and status.strip():
    print(status.strip())
else:
    print("unknown")
PY
}

TOOL_NAME="$(extract_field "$INPUT" "toolName")"
if [ -z "$TOOL_NAME" ]; then
  TOOL_NAME="$(extract_field "$INPUT" "tool_name")"
fi
if [ -z "$TOOL_NAME" ]; then
  TOOL_NAME="unknown"
fi

TIMESTAMP="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

case "$PHASE" in
  pre)
    echo "[$TIMESTAMP] Tool execution initiated: $TOOL_NAME" >> "$LOG_FILE"
    ;;
  post)
    STATUS="$(extract_status "$INPUT")"
    echo "[$TIMESTAMP] Tool execution completed: $TOOL_NAME with status: $STATUS" >> "$LOG_FILE"
    ;;
  *)
    echo "[$TIMESTAMP] Hook event: $PHASE tool=$TOOL_NAME" >> "$LOG_FILE"
    ;;
esac

exit 0
