#!/usr/bin/env bash
set -euo pipefail

# Copilot preToolUse hook: validate .NET build/tests before file edits.
# Reads hook input JSON from stdin and returns permissionDecision JSON.

INPUT="$(cat)"

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
print(data.get(field, ""))
PY
}

TOOL_NAME="$(extract_field "$INPUT" "toolName")"
if [ -z "$TOOL_NAME" ]; then
  TOOL_NAME="$(extract_field "$INPUT" "tool_name")"
fi

# Only gate tools that can change files.
case "$TOOL_NAME" in
  edit|create)
    ;;
  *)
    echo '{"permissionDecision":"allow"}'
    exit 0
    ;;
esac

# Run validation before allowing an edit/create operation.
if ! dotnet build LMSWebAPI.sln --nologo >/tmp/copilot-pr-validation-build.log 2>&1; then
  echo '{"permissionDecision":"deny","permissionDecisionReason":"Blocked by PR validation: dotnet build failed. Fix compile errors before editing files."}'
  exit 0
fi

if ! dotnet test LMSWebAPI.sln --nologo --no-build >/tmp/copilot-pr-validation-test.log 2>&1; then
  echo '{"permissionDecision":"deny","permissionDecisionReason":"Blocked by PR validation: dotnet test failed. Fix failing tests before editing files."}'
  exit 0
fi

# Explicit allow makes behavior deterministic.
echo '{"permissionDecision":"allow"}'
