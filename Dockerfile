# hadolint global ignore=DL3008

ARG JAVA_VERSION=21
FROM maven:3-eclipse-temurin-${JAVA_VERSION} AS base

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update -qq && apt-get install -qq --no-install-recommends yarn && \
    rm -rf /var/lib/apt/lists/*

FROM base AS final
ARG NODE_VERSION=22

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -sL "https://deb.nodesource.com/setup_${NODE_VERSION}.x" | bash - && \
    apt-get update -qq && apt-get install -qq --no-install-recommends nodejs && \
    rm -rf /var/lib/apt/lists/*
