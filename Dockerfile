FROM openjdk:12-alpine

ENV REDPEN_VERSION=redpen-1.10.4
ENV REVIEWDOG_VERSION=v0.9.17
RUN apk --update add git curl jq wget && \
    rm -rf /var/lib/apt/lists/* && \
    rm /var/cache/apk/*
RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}
RUN curl -sL https://api.github.com/repos/redpen-cc/redpen/releases/tags/${REDPEN_VERSION} -o - \
      | jq -r .assets[].browser_download_url \
      | grep -i "tar.gz" \
      | head -n 1 \
      | wget -qi - -O ${REDPEN_VERSION}.tar.gz && \
    tar xvfp ${REDPEN_VERSION}.tar.gz -C / && \
    rm *.tar.gz && \
    find . -maxdepth 1 -type d -name "redpen*" -print0 | xargs -0 -I{} mv {} redpen

ENV PATH="/redpen/bin:${PATH}"

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
