ARG ALPINE_VERSION\
    DENO_VERSION

FROM tundrasoft/alpine:${ALPINE_VERSION}

LABEL maintainer="Abhinav A V <36784+abhai2k@users.noreply.github.com>"

ARG DENO_VERSION\
    TARGETPLATFORM\
    TARGETARCH\
    TARGETVARIANT

USER root

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
    LANG=C.UTF-8

RUN set -eux; \
    mkdir -p ${DENO_DIR}; \
    ALPINE_GLIBC_BASE_URL="https://github.com/sgerrand/alpine-pkg-glibc/releases/download"; \
    ALPINE_GLIBC_PACKAGE_VERSION="2.34-r0"; \
    ALPINE_GLIBC_BASE_PACKAGE_FILENAME="glibc-$ALPINE_GLIBC_PACKAGE_VERSION.apk"; \
    ALPINE_GLIBC_BIN_PACKAGE_FILENAME="glibc-bin-$ALPINE_GLIBC_PACKAGE_VERSION.apk"; \
    ALPINE_GLIBC_I18N_PACKAGE_FILENAME="glibc-i18n-$ALPINE_GLIBC_PACKAGE_VERSION.apk"; \
    apk add --no-cache --virtual=.build-dependencies ca-certificates wget unzip; \
    echo \
      "-----BEGIN PUBLIC KEY-----\
      MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApZ2u1KJKUu/fW4A25y9m\
      y70AGEa/J3Wi5ibNVGNn1gT1r0VfgeWd0pUybS4UmcHdiNzxJPgoWQhV2SSW1JYu\
      tOqKZF5QSN6X937PTUpNBjUvLtTQ1ve1fp39uf/lEXPpFpOPL88LKnDBgbh7wkCp\
      m2KzLVGChf83MS0ShL6G9EQIAUxLm99VpgRjwqTQ/KfzGtpke1wqws4au0Ab4qPY\
      KXvMLSPLUp7cfulWvhmZSegr5AdhNw5KNizPqCJT8ZrGvgHypXyiFvvAH5YRtSsc\
      Zvo9GI2e2MaZyo9/lvb+LbLEJZKEQckqRj4P26gmASrZEPStwc+yqy1ShHLA0j6m\
      1QIDAQAB\
      -----END PUBLIC KEY-----" | sed 's/   */\n/g' > "/etc/apk/keys/sgerrand.rsa.pub"; \
    wget \
      "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
      "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
      "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_I18N_PACKAGE_FILENAME"; \
    if [ ! -f /etc/nsswitch.conf ]; \
      then \
      echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf; \
    fi; \
    mv /etc/nsswitch.conf /etc/nsswitch.conf.bak; \
    apk add --no-cache --force-overwrite \
      "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
      "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
      "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME"; \
    mv /etc/nsswitch.conf.bak /etc/nsswitch.conf; \
    rm "/etc/apk/keys/sgerrand.rsa.pub"; \
    (/usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 "$LANG" || true); \
    echo "export LANG=$LANG" > /etc/profile.d/locale.sh; \
    apk del glibc-i18n; \
    rm "/root/.wget-hsts"; \
    rm \
      "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
      "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
      "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME"; \
    apk add --no-cache libgcc; \
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

# EXPOSE 3000

# VOLUME [ "/app" ]
