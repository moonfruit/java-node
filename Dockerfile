ARG JAVA_VERSION=21

FROM maven:3-eclipse-temurin-${JAVA_VERSION}

ARG NODE_VERSION=22

RUN curl -sL "https://deb.nodesource.com/setup_${NODE_VERSION}.x" | bash -
RUN apt-get update -qq && apt-get install -qq --no-install-recommends \
    nodejs \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -qq --no-install-recommends \
    yarn \
    && rm -rf /var/lib/apt/lists/*
