---
name: conventional-commits
description: A tool that analyzes git diffs and suggests a conventional commit message.
version: 0.1.0
license: Apache-2.0
---

# Conventional Commit Generator

## Purpose
This skill helps maintain a consistent commit history by suggesting commit messages based on the Conventional Commits specification. It analyzes git diffs to detect the type of change (feat, fix, docs, etc.) and the affected scope (core, docs, test).

## Quick Start

```bash
# Get a suggestion for staged changes
$ git diff --staged | ./scripts/run.sh
feat(core): <summary of changes>
```

## Usage Examples

### Example: From a diff file

```bash
$ ./scripts/run.sh my_changes.diff
```

### Example: Piping direct diff

```bash
$ git diff origin/main | ./scripts/run.sh
```

## Options Reference
- `DIFF_FILE`: Path to a file containing a git diff (positional argument). If omitted, reads from stdin.

## Validation
This skill's correctness is validated by `scripts/test.sh`, which verifies type and scope detection across various diff scenarios.
