FROM openjdk:12-alpine

ENV REDPEN_VERSION 1.10.3

RUN apk --update add git curl && \
    rm -rf /var/lib/apt/lists/* && \
    rm /var/cache/apk/*
RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ v0.9.14
RUN curl -sfL https://ci.appveyor.com/api/buildjobs/8tqt2j4gccbo1i0y/artifacts/redpen-distribution%2Ftarget%2Fredpen-distribution-1.10.4-SNAPSHOT-assembled.tar.gz -o redpen-${REDPEN_VERSION}.tar.gz && \
    tar xvfp redpen-${REDPEN_VERSION}.tar.gz -C / && \
    rm *.tar.gz

ENV PATH="/redpen-distribution-${REDPEN_VERSION}/bin:${PATH}"

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
