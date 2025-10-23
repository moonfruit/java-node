#!/usr/bin/env bash
set -euo pipefail

IMAGE="${1:-}"
TAG="${2:-latest}"

if [[ -z "$IMAGE" ]]; then
    echo "Usage: $0 <image> [tag]"
    echo "Example: $0 maven 3-eclipse-temurin-21"
    exit 1
fi

# 默认处理：无命名空间则视为 library 官方镜像
if [[ "$IMAGE" != *"/"* ]]; then
    REPO="library/$IMAGE"
else
    REPO="$IMAGE"
fi

# 获取 Bearer Token
TOKEN=$(curl -s \
    "https://auth.docker.io/token?service=registry.docker.io&scope=repository:${REPO}:pull" |
    jq -r .token)

# 请求 manifest 信息以获取 digest
curl -fsSL \
    -H "Authorization: Bearer $TOKEN" \
    -H "Accept: application/vnd.docker.distribution.manifest.v2+json" \
    "https://registry-1.docker.io/v2/${REPO}/manifests/${TAG}" |
    jq -r '.manifests[] | select(.platform.os == "linux" and .platform.architecture == "amd64") | .digest'
