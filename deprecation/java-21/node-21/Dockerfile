FROM maven:3-eclipse-temurin-21

RUN curl -sL https://deb.nodesource.com/nsolid_setup_deb.sh | bash -s 21
RUN apt-get update -qq && apt-get install -qq --no-install-recommends \
    nodejs \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -qq --no-install-recommends \
    yarn \
    && rm -rf /var/lib/apt/lists/*
