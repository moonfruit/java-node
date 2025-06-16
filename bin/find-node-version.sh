#!/usr/bin/env bash
set -euo pipefail

MAJOR="${1:-22}"

VERSION=$(curl -s https://nodejs.org/dist/index.json |
    jq -r '[.[] | select(.version | test("^v'"$MAJOR"'\\."))][0].version')

if [[ -n "$VERSION" && $VERSION != null ]]; then
    echo "$VERSION"
else
    echo "No Node.js version found for major version $MAJOR"
    exit 1
fi
