
FROM ubuntu

ARG BUILD_DATE
ARG VERSION
ARG DOKUWIKI_RELEASE
LABEL build_version="ralphs version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="rwetri"

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Moscow

COPY sources.list /etc/apt/sources.list

RUN \
  apt-get update && \
  apt-get -y install tzdata && \
  apt install -y apache2 

ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

