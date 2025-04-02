FROM openjdk:19-alpine@sha256:1686909f4ca66f3e13463e2b00a1c53808aa155f81ae9a8aad8f4b89420d91ef

# redpen
ENV REDPEN_VERSION=1.10.4

# reviewdog
ENV REVIEWDOG_VERSION=v0.20.3

# hadolint ignore=DL3018
RUN apk add --no-cache git jq wget && \
    rm -rf /var/lib/apt/lists/*
# hadolint ignore=DL4006
RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}
# hadolint ignore=DL4006
RUN wget -O - -q https://api.github.com/repos/redpen-cc/redpen/releases/tags/redpen-${REDPEN_VERSION} \
      | jq -r .assets[].browser_download_url \
      | grep -i "tar.gz" \
      | head -n 1 \
      | wget -qi - -O redpen-${REDPEN_VERSION}.tar.gz && \
    tar xvfp redpen-${REDPEN_VERSION}.tar.gz -C / && \
    rm redpen-${REDPEN_VERSION}.tar.gz && \
    find . -maxdepth 1 -type d -name "redpen*" -print0 | xargs -0 -I{} mv {} redpen

ENV PATH="/redpen/bin:${PATH}"

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
