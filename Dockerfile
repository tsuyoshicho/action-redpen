FROM node:current-alpine

ENV REDPEN_VERSION 1.10.1

RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ v0.9.13
RUN wget -O - -q https://github.com/redpen-cc/redpen/releases/download/redpen-${REDPEN_VERSION}/redpen-${REDPEN_VERSION}.tar.gz && \
    tar xvf redpen-${REDPEN_VERSION}.tar.gz && \
    mv redpen-distribution-${REDPEN_VERSION}/bin bin
RUN apk --update add git && \
    rm -rf /var/lib/apt/lists/* && \
    rm /var/cache/apk/*

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
