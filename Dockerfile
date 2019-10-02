FROM alpine:3.10

ENV REDPEN_VERSION 1.10.1

RUN apk --update add git curl && \
    rm -rf /var/lib/apt/lists/* && \
    rm /var/cache/apk/*
RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ v0.9.13
RUN curl -sfLO https://github.com/redpen-cc/redpen/releases/download/redpen-${REDPEN_VERSION}/redpen-${REDPEN_VERSION}.tar.gz && \
    tar xvfp redpen-${REDPEN_VERSION}.tar.gz -C / && \
    rm *.tar.gz

ENV PATH="/redpen-distribution-${REDPEN_VERSION}/bin:${PATH}"

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
