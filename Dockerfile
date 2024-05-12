ARG ALPINE_VERSION=latest\
    DENO_VERSION

FROM gcr.io/distroless/cc as cc

FROM tundrasoft/alpine:${ALPINE_VERSION}
LABEL maintainer="Abhinav A V <36784+abhai2k@users.noreply.github.com>"

ARG DENO_VERSION \
    TARGETPLATFORM \
    TARGETARCH \
    TARGETVARIANT

ENV DENO_DIR=/deno-dir\
    ALLOW_ALL=\
    ALLOW_HRTIME=\
    ALLOW_SYS=\
    ALLOW_ENV=\
    ALLOW_NET=1\
    UNSTABLE=\
    READ_PATHS=/app\
    WRITE_PATHS=/app\
    ALLOW_RUN=\
    FILE=\
    LANG=C.UTF-8\
    LD_LIBRARY_PATH="/usr/local/lib"

COPY --from=cc --chown=root:root --chmod=755 /lib/*-linux-gnu/* /usr/local/lib/
COPY --from=cc --chown=root:root --chmod=755 /lib/ld-linux-* /lib/

RUN set -eux; \
  mkdir /lib64; \
  ln -s /usr/local/lib/ld-linux-* /lib64/; \
  mkdir -p ${DENO_DIR}; \
  case "${TARGETPLATFORM}" in \
  "linux/amd64"|"linux/x86_64") export DENO_ARCH="x86_64-unknown-linux-gnu" ;; \
  "linux/arm64"|"linux/arm/v8") export DENO_ARCH="aarch64-unknown-linux-gnu" ;; \
  *) echo "Unsupported platform: ${TARGETPLATFORM}" ; exit 1 ;; \
  esac; \
  wget https://github.com/denoland/deno/releases/download/v${DENO_VERSION}/deno-${DENO_ARCH}.zip -O /tmp/deno.zip; \
  unzip /tmp/deno.zip; \
  mv deno /bin/deno;  \
  setgroup /bin/deno ${DENO_DIR}; \
  chmod 0755 /bin/deno; \
  rm /tmp/*;

COPY /rootfs /

HEALTHCHECK --interval=60s --timeout=10s --start-period=30s CMD /usr/bin/healthcheck.sh

WORKDIR /app
