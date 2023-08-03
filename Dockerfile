ARG ALPINE_VERSION\
    DENO_VERSION

FROM tundrasoft/alpine-glibc:${ALPINE_VERSION}

LABEL maintainer="Abhinav A V <abhai2k@gmail.com>"

ARG DENO_VERSION

USER root

ENV DENO_DIR=/deno-dir\
    ALLOW_ALL=\
    ALLOW_HRTIME=\
    ALLOW_SYS=\
    ALLOW_ENV=\
    ALLOW_NET=1\
    READ_PATHS=/app\
    WRITE_PATHS=/app\
    ALLOW_RUN=\
    FILE='https://deno.land/std/examples/chat/server.ts'

RUN set -eux; \
    mkdir -p /app ${DENO_DIR}; \
    apk add --no-cache --virtual=.build-dependencies wget unzip; \
    wget https://github.com/denoland/deno/releases/download/v${DENO_VERSION}/deno-x86_64-unknown-linux-gnu.zip -O /tmp/deno.zip; \
    unzip /tmp/deno.zip; \
    mv deno /bin/deno;  \
    setgroup /bin/deno ${DENO_DIR}; \
    chmod 0755 /bin/deno; \
    rm /tmp/*; \
    apk del .build-dependencies;

COPY /rootfs /

HEALTHCHECK --interval=60s --timeout=10s --start-period=30s CMD /usr/bin/healthcheck.sh

WORKDIR /app

# RUN chown -R ${PUID}:${PGID} /app

EXPOSE 3000

VOLUME [ "/app" ]