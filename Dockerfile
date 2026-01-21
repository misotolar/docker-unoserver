FROM misotolar/alpine:3.23.2

LABEL org.opencontainers.image.url="https://github.com/misotolar/docker-unoserver"
LABEL org.opencontainers.image.description="Unoserver Alpine Linux image"
LABEL org.opencontainers.image.authors="Michal Sotolar <michal@sotolar.com>"

ENV UNOSERVER_VERSION=3.6

ENV INTERFACE=127.0.0.1
ENV PORT=2003
ENV UNO_INTERFACE=127.0.0.1
ENV UNO_PORT=2002

ENV PIP_ROOT_USER_ACTION=ignore
ENV PIP_BREAK_SYSTEM_PACKAGES=1

RUN set -ex; \
    apk add --no-cache \
        fontconfig \
        icu-data-full \
        libreoffice-calc \
        libreoffice-writer \
    ; \
    apk add --no-cache --virtual .build-deps \
        py3-pip \
    ; \
    pip install -U unoserver==${UNOSERVER_VERSION}; \
    apk del --no-network .build-deps; \
    rm -rf \
        /var/cache/apk/* \
        /var/tmp/* \
        /tmp/*

COPY resources/javasettings.xml /usr/lib/libreoffice/share/config/javasettings_Linux_X86_64.xml
COPY resources/entrypoint.sh /usr/local/bin/entrypoint.sh

STOPSIGNAL SIGKILL
ENTRYPOINT ["entrypoint.sh"]
CMD unoserver --interface $INTERFACE --uno-interface $UNO_INTERFACE --port $PORT --uno-port $UNO_PORT
