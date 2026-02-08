#!/usr/bin/env bash

# Conventional Commit Generator
# Analyzes diffs and suggests a commit message.

set -euo pipefail

usage() {
  echo "Usage: $0 [DIFF_FILE]"
  echo "Analyzes a git diff and suggests a conventional commit message."
  exit 1
}

if [[ "${1:-}" == "--help" ]]; then
  usage
fi

INPUT="${1:-/dev/stdin}"

if [[ ! -e "$INPUT" ]]; then
  echo "Error: Input '$INPUT' not found." >&2
  exit 2
fi

DIFF_CONTENT=$(cat "$INPUT")

# Simple logic for type
TYPE="feat"
if echo "$DIFF_CONTENT" | grep -qiE "fix|bug|issue|error|patch"; then
  TYPE="fix"
elif echo "$DIFF_CONTENT" | grep -qiE "test|unit|integration"; then
  TYPE="test"
elif echo "$DIFF_CONTENT" | grep -qiE "refactor|clean|cleanup"; then
  TYPE="refactor"
elif echo "$DIFF_CONTENT" | grep -qiE "docs|documentation|readme"; then
  TYPE="docs"
elif echo "$DIFF_CONTENT" | grep -qiE "chore|build|ci"; then
  TYPE="chore"
fi

# Simple logic for scope
SCOPE=""
if echo "$DIFF_CONTENT" | grep -qiE "docs/"; then
  SCOPE="(docs)"
elif echo "$DIFF_CONTENT" | grep -qiE "src/|lib/"; then
  SCOPE="(core)"
elif echo "$DIFF_CONTENT" | grep -qiE "tests/"; then
  SCOPE="(test)"
fi

echo "${TYPE}${SCOPE}: <summary of changes>"
