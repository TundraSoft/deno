ARG ALPINE_VERSION=latest\
    DENO_VERSION

FROM gcr.io/distroless/cc-debian12:latest AS cc

FROM tundrasoft/alpine:new-build-${ALPINE_VERSION} AS sym

COPY --from=cc --chown=root:root --chmod=755 /lib/*-linux-gnu/ld-linux-* /usr/local/lib/

RUN mkdir -p /tmp/lib \
    && ln -s /usr/local/lib/ld-linux-* /tmp/lib/

FROM tundrasoft/alpine:new-build-${ALPINE_VERSION}

LABEL maintainer="Abhinav A V <36784+abhai2k@users.noreply.github.com>"

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
    UNSTABLES=\
    READ_PATHS=/app\
    WRITE_PATHS=/app\
    FILE=\
    TASK=\
    LD_LIBRARY_PATH="/usr/local/lib"

COPY --from=cc --chown=root:root --chmod=755 /lib/*-linux-gnu/* /usr/local/lib/
COPY --from=sym --chown=root:root --chmod=755 /tmp/lib /lib
COPY --from=sym --chown=root:root --chmod=755 /tmp/lib /lib64

RUN set -eux; \
  apk --update --no-cache add curl; \
  case "${TARGETPLATFORM}" in \
  "linux/amd64"|"linux/x86_64") export DENO_ARCH="x86_64-unknown-linux-gnu" ;; \
  "linux/arm64"|"linux/arm/v8") export DENO_ARCH="aarch64-unknown-linux-gnu" ;; \
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

HEALTHCHECK --interval=60s --timeout=10s --start-period=30s CMD ["/usr/bin/healthcheck.sh"]

WORKDIR /app
