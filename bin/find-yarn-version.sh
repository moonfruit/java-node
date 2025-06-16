#!/usr/bin/env bash
set -euo pipefail

VERSION=$(curl -s https://api.github.com/repos/yarnpkg/yarn/releases |
    jq -r '[.[] | select(.prerelease == false) | select(.tag_name | test("^v1\\."))][0].tag_name')

if [[ -n "$VERSION" && $VERSION != null ]]; then
    echo "$VERSION"
else
    echo "No Node.js version found for major version $MAJOR"
    exit 1
fi
