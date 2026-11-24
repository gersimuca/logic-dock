#!/usr/bin/env bash

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

FILE="${1:-}"
GOAL="${2:-}"

if [[ -z "$FILE" || -z "$GOAL" ]]; then
    echo 'Usage: ./scripts/query.sh path/to/file.pl "goal"' >&2
    exit 2
fi

cd "$ROOT"

export PROLOG_PROJECT_ROOT="$ROOT"

if [[ "$FILE" != /* ]]; then
    FILE="$ROOT/$FILE"
fi

docker compose run --rm prolog \
    -s "$FILE" \
    -g "$GOAL" \
    -t halt
