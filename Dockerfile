ARG ALPINE_VERSION=latest\
    DENO_VERSION

FROM gcr.io/distroless/cc-debian12:latest AS cc

FROM tundrasoft/alpine:${ALPINE_VERSION} AS sym

COPY --from=cc --chown=root:root --chmod=755 /lib/*-linux-gnu/ld-linux-* /usr/local/lib/

RUN mkdir -p /tmp/lib \
    && ln -s /usr/local/lib/ld-linux-* /tmp/lib/

FROM tundrasoft/alpine:${ALPINE_VERSION}

LABEL maintainer="Abhinav A V <36784+abhai2k@users.noreply.github.com>" \
      org.opencontainers.image.title="Deno Runtime on Alpine Linux" \
      org.opencontainers.image.description="Lightweight, secure Deno runtime image built on Alpine Linux with S6 overlay, comprehensive permissions management, and developer-friendly utilities" \
      org.opencontainers.image.vendor="TundraSoft" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.url="https://github.com/TundraSoft/deno" \
      org.opencontainers.image.documentation="https://github.com/TundraSoft/deno/blob/main/README.md" \
      org.opencontainers.image.source="https://github.com/TundraSoft/deno.git"

ARG DENO_VERSION \
  TARGETPLATFORM

ENV DENO_DIR=/deno-dir\
    ALLOW_ALL=\
    ALLOW_ENV=\
    ALLOW_FFI=\
    ALLOW_HRTIME=\
    ALLOW_NET=1\
    ALLOW_RUN=\
    ALLOW_SYS=\
    ALLOW_READ=\
    ALLOW_WRITE=\
    UNSTABLE=\
    FILE=\
    TASK=\
    LD_LIBRARY_PATH="/usr/local/lib:/lib:/lib64"

COPY --from=cc --chown=root:root --chmod=755 /lib/*-linux-gnu/* /usr/local/lib/
COPY --from=sym --chown=root:root --chmod=755 /tmp/lib /lib
COPY --from=sym --chown=root:root --chmod=755 /tmp/lib /lib64

RUN set -eux; \
  apk --update --no-cache add curl; \
  case "${TARGETPLATFORM}" in \
  "linux/amd64"|"linux/x86_64") export DENO_ARCH="x86_64-unknown-linux-gnu" ;; \
  "linux/arm64"|"linux/arm/v8") export DENO_ARCH="aarch64-unknown-linux-gnu" ;; \
  "linux/arm/v7") echo "ERROR: Deno does not provide pre-built binaries for 32-bit ARM (armv7). Only x86_64 and arm64 are supported." && exit 1 ;; \
  *) echo "Unsupported platform: ${TARGETPLATFORM}" ; exit 1 ;; \
  esac; \
  curl -Ls https://github.com/denoland/deno/releases/download/v${DENO_VERSION}/deno-${DENO_ARCH}.zip \
    | unzip -q -d /tmp - 'deno'; \
  mv /tmp/deno /bin/; \
  mkdir -p ${DENO_DIR}; \
  chmod 0755 /bin/deno; \
  setgroup /bin/deno ${DENO_DIR}; \
  rm -rf /tmp/*;


COPY /rootfs /

# nosemgrep: dockerfile.security.missing-user.missing-user
HEALTHCHECK --interval=60s --timeout=10s --start-period=30s CMD ["/usr/bin/healthcheck.sh"]

WORKDIR /app
