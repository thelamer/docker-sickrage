FROM lsiobase/alpine.python:3.8

# set version label
ARG BUILD_DATE
ARG VERSION
ARG SICKRAGE_COMMIT
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="sparklyballs"

# set python to use utf-8 rather than ascii
ENV PYTHONIOENCODING="UTF-8"

RUN \
 echo "**** install packages ****" && \
 apk add --no-cache \
	--repository http://nl.alpinelinux.org/alpine/edge/main \
	jq \
	nodejs && \
 echo "**** install app ****" && \
 if [ -z ${SICKRAGE_COMMIT+x} ]; then \
        SICKRAGE_COMMIT=$(curl -sX GET https://api.github.com/repos/SickChill/SickChill/commits/master \
        | jq -r '. | .sha'); \
 fi && \
 mkdir -p /app/sickrage && \
 curl -o \
 /tmp/sickrage.tar.gz -L \
        "https://github.com/SickChill/SickChill/archive/${SICKRAGE_COMMIT}.tar.gz" && \
 tar xf \
 /tmp/sickrage.tar.gz -C \
        /app/sickrage --strip-components=1 && \
 echo "**** cleanup ****" && \
 rm -f /tmp/*


# copy local files
COPY root/ /

# ports and volumes
EXPOSE 8081
VOLUME /config /downloads /tv
