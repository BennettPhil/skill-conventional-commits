#!/usr/bin/env bash
# Test contract for conventional-commits

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RUN="$SCRIPT_DIR/run.sh"
PASS=0; FAIL=0; TOTAL=0

assert_contains() {
  local desc="$1" needle="$2" haystack="$3"
  ((TOTAL++))
  if echo "$haystack" | grep -qiF -- "$needle"; then
    ((PASS++)); echo "  PASS: $desc"
  else
    ((FAIL++)); echo "  FAIL: $desc (missing '$needle')"
  fi
}

echo "=== Tests for conventional-commits ==="

# Test 1: Feature detection (in core)
DIFF1="
diff --git a/src/new_feature.py b/src/new_feature.py
+++ b/src/new_feature.py
+def new_awesome_feature(): pass
"
OUTPUT1=$(echo "$DIFF1" | "$RUN")
assert_contains "feat type" "feat" "$OUTPUT1"
assert_contains "core scope" "(core):" "$OUTPUT1"

# Test 2: Fix detection (in core)
DIFF2="
diff --git a/src/bug.py b/src/bug.py
--- a/src/bug.py
+++ b/src/bug.py
-    x = 1/0
+    x = 1
"
OUTPUT2=$(echo "$DIFF2" | "$RUN")
assert_contains "fix type" "fix" "$OUTPUT2"

# Test 3: Scope detection
DIFF3="
diff --git a/docs/readme.md b/docs/readme.md
+++ b/docs/readme.md
+Update docs
"
OUTPUT3=$(echo "$DIFF3" | "$RUN")
assert_contains "docs scope" "(docs):" "$OUTPUT3"

# Test 4: Help flag
assert_contains "help flag" "usage:" "$($RUN --help 2>&1)"

echo ""
echo "=== Results: $PASS/$TOTAL passed ==="
[ "$FAIL" -eq 0 ] || { echo "BLOCKED: $FAIL test(s) failed"; exit 1; }
