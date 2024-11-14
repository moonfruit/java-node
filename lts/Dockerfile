ARG JAVA_MAJOR_VERSION=21

FROM maven:3-eclipse-temurin-${JAVA_MAJOR_VERSION}

ARG JAVA_MAJOR_VERSION
ARG NODE_MAJOR_VERSION=22

RUN echo "JAVA_MAJOR_VERSION=${JAVA_MAJOR_VERSION}" && \
    echo "NODE_MAJOR_VERSION=${NODE_MAJOR_VERSION}"

RUN curl -sL "https://deb.nodesource.com/setup_${NODE_MAJOR_VERSION}.x" | bash -
RUN apt-get update -qq && apt-get install -qq --no-install-recommends \
    nodejs \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -qq --no-install-recommends \
    yarn \
    && rm -rf /var/lib/apt/lists/*
