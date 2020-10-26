FROM openjdk:12-alpine

# redpen
ENV REDPEN_VERSION=1.10.4

# reviewdog
ENV REVIEWDOG_VERSION=v0.11.0

RUN apk --update add git curl jq wget && \
    rm -rf /var/lib/apt/lists/* && \
    rm /var/cache/apk/*
RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}
RUN curl -sL https://api.github.com/repos/redpen-cc/redpen/releases/tags/redpen-${REDPEN_VERSION} -o - \
      | jq -r .assets[].browser_download_url \
      | grep -i "tar.gz" \
      | head -n 1 \
      | wget -qi - -O redpen-${REDPEN_VERSION}.tar.gz && \
    tar xvfp redpen-${REDPEN_VERSION}.tar.gz -C / && \
    rm *.tar.gz && \
    find . -maxdepth 1 -type d -name "redpen*" -print0 | xargs -0 -I{} mv {} redpen

ENV PATH="/redpen/bin:${PATH}"

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
