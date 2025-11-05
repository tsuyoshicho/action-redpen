FROM eclipse-temurin:19-jre-alpine@sha256:939a30c2e2eb4300ab19bde2c180b74520884aa2639405d0b87b66752c34d213

# redpen
ENV REDPEN_VERSION=1.10.4

# reviewdog
ENV REVIEWDOG_VERSION=v0.21.0

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
