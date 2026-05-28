#!/usr/bin/env bash
set -euo pipefail

# Copilot postToolUse hook: run lightweight policy checks after edits.
# Output is advisory warnings only; this hook never blocks tool execution.

INPUT="$(cat)"
LOG_DIR=".github/hooks/logs"
WARN_FILE="$LOG_DIR/code-review-warnings.log"
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
print(data.get(field, ""))
PY
}

TOOL_NAME="$(extract_field "$INPUT" "toolName")"
if [ -z "$TOOL_NAME" ]; then
  TOOL_NAME="$(extract_field "$INPUT" "tool_name")"
fi

# Focus only on mutating tools to keep hook overhead low.
case "$TOOL_NAME" in
  edit|create)
    ;;
  *)
    exit 0
    ;;
esac

warnings=()

# 1) Hardcoded secret pattern scan.
if rg -n --hidden --glob '!bin/**' --glob '!obj/**' --glob '!.git/**' \
  '(?i)(api[_-]?key|secret|password|token|connectionstring)\s*[:=]\s*["\x27][^"\x27\s]{8,}["\x27]' . >/tmp/copilot-secrets-scan.log 2>&1; then
  warnings+=("Potential hardcoded secret patterns found. Review /tmp/copilot-secrets-scan.log")
fi

# 2) Detect DbContext usage inside Controllers (architecture boundary warning).
if rg -n 'LMSDbContext|\bDbContext\b' Controllers/*.cs >/tmp/copilot-dbcontext-controller.log 2>&1; then
  warnings+=("DbContext usage detected in Controllers. Prefer Service/Repository boundaries. See /tmp/copilot-dbcontext-controller.log")
fi

# 3) Heuristic async/await validation.
check_async_without_await() {
  local file="$1"
  awk '
  function reset_method() {
    inMethod=0; awaitSeen=0; startLine=0; sig=""; braceDepth=0; opened=0;
  }
  BEGIN { reset_method() }
  {
    line=$0
    if (!inMethod && line ~ /async[[:space:]]+Task(<[^>]+>)?[[:space:]]+[A-Za-z0-9_]+[[:space:]]*\(/) {
      inMethod=1
      startLine=FNR
      sig=line
      awaitSeen=0
      braceDepth=0
      opened=0
    }
    if (inMethod) {
      if (line ~ /await[[:space:]]+/) { awaitSeen=1 }
      opens=gsub(/\{/, "{", line)
      closes=gsub(/\}/, "}", line)
      braceDepth += opens - closes
      if (opens > 0) { opened=1 }
      if (opened && braceDepth <= 0) {
        if (!awaitSeen) {
          printf "%s:%d:%s\n", FILENAME, startLine, sig
        }
        reset_method()
      }
    }
  }
  END {
    if (inMethod && !awaitSeen) {
      printf "%s:%d:%s\n", FILENAME, startLine, sig
    }
  }' "$file"
}

: >/tmp/copilot-async-await.log
while IFS= read -r csfile; do
  check_async_without_await "$csfile" >>/tmp/copilot-async-await.log || true
done < <(find Controllers Services Repositories -type f -name '*.cs' 2>/dev/null)

if [ -s /tmp/copilot-async-await.log ]; then
  warnings+=("Async methods without await detected. Review /tmp/copilot-async-await.log")
fi

if [ "${#warnings[@]}" -gt 0 ]; then
  {
    printf '[%s] postToolUse warnings for tool=%s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$TOOL_NAME"
    for w in "${warnings[@]}"; do
      printf 'WARNING: %s\n' "$w"
    done
    printf '\n'
  } | tee -a "$WARN_FILE"
fi

exit 0
