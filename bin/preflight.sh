#!/usr/bin/env bash
set -uo pipefail

BIN=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

PREFLIGHT=$(dirname "$BIN")/preflight
mkdir -p "$PREFLIGHT"

TEMP=$(mktemp)

check-yarn() {
    echo -n "yarn@1: "
    "$BIN/find-yarn-version.sh" | tee "$TEMP"
    if diff "$TEMP" "$PREFLIGHT/yarn@1.txt"; then
        echo "yarn@1 is NOT changed"
        return 1
    else
        mv "$TEMP" "$PREFLIGHT/yarn@1.txt"
    fi
}

check-java() {
    echo -n "java@$1: "
    "$BIN/find-image-digest.sh" maven "3-eclipse-temurin-$1" | tee "$TEMP"
    if diff "$TEMP" "$PREFLIGHT/java@$1.txt"; then
        echo "java@$1 is NOT changed"
        return 1
    else
        mv "$TEMP" "$PREFLIGHT/java@$1.txt"
    fi
}

check-node() {
    echo -n "node@$1: "
    "$BIN/find-node-version.sh" "$1" | tee "$TEMP"
    if diff "$TEMP" "$PREFLIGHT/node@$1.txt"; then
        echo "node@$1 is NOT changed"
        return 1
    else
        mv "$TEMP" "$PREFLIGHT/node@$1.txt"
    fi
}

contains() {
    local value=$1
    shift
    for item in "$@"; do
        [[ "$item" == "$value" ]] && return 0
    done
    return 1
}

KNOWN_JAVA=(8 11 17 21 24)
KNOWN_NODE=(18 20 22 24)

if check-yarn >&2; then
    echo "yarn@1 is changed">&2;
    declare -n JAVA=KNOWN_JAVA
    declare -n NODE=KNOWN_NODE

else
    JAVA=()
    for version in "${KNOWN_JAVA[@]}"; do
        echo "--------" >&2
        if check-java "$version" >&2; then
            echo "java@$version is changed" >&2;
            JAVA+=("$version")
        fi
    done

    NODE=()
    for version in "${KNOWN_NODE[@]}"; do
        echo "--------" >&2
        if check-node "$version" >&2; then
            echo "node@$version is changed" >&2;
            NODE+=("$version")
        fi
    done
fi

INCLUDE=()
if contains 22 "${NODE[@]}"; then
    if contains 21 "${JAVA[@]}"; then
        INCLUDE+=('{"java":21,"node":22,"tag":"lts"}')
    fi
    if contains 24 "${JAVA[@]}"; then
        INCLUDE+=('{"java":24,"node":22,"tag":"latest"}')
    fi
fi

echo "--------" >&2
if ((${#INCLUDE[@]})); then
    jq -n \
        --argjson java "$(printf '%s\n' "${JAVA[@]}" | jq -s 'map(tonumber)')" \
        --argjson node "$(printf '%s\n' "${NODE[@]}" | jq -s 'map(tonumber)')" \
        --argjson include "$(printf '%s\n' "${INCLUDE[@]}" | jq -s '.')" \
        '{java: $java, node: $node, include: $include}'
else
    jq -n \
        --argjson java "$(printf '%s\n' "${JAVA[@]}" | jq -s 'map(tonumber)')" \
        --argjson node "$(printf '%s\n' "${NODE[@]}" | jq -s 'map(tonumber)')" \
        '{java: $java, node: $node}'
fi
