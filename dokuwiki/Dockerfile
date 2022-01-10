
FROM ubuntu

ARG BUILD_DATE
ARG VERSION
ARG DOKUWIKI_RELEASE
LABEL build_version="ralphs version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="rwetri"

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Berlin

COPY conf/sources.list /etc/apt/sources.list
COPY conf/envvars /etc/apache2/envvars.new
COPY conf/apache2.conf /etc/apache2/apache2.conf.new
COPY bindokuwiki/startapache.sh /var/run/apache2/startapache.sh
COPY bindokuwiki/stopapache.sh /var/run/apache2/stopapache.sh
COPY bindokuwiki/restartapache.sh /var/run/apache2/restartapache.sh
COPY bindokuwiki/initcontainer.sh /var/run/apache2/initcontainer.sh
COPY conf/apache2-dokuwiki.conf /etc/apache2/sites-enabled/apache2-dokuwiki.conf.new
COPY src/dokuwiki-stable.tgz /run/apache2/dokuwiki-stable.tgz
COPY src/farmer.tgz /run/apache2/farmer.tgz
COPY src/data.tgz /run/apache2/data.tgz

RUN \
  echo "==== Installing Dokuwiki  $DOKUWIKI_RELEASE ====" && \
  echo "==== Actualize packagemanagement ====" && \
  apt-get update && \
  echo "==== Install required base packages ====" && \
  apt-get -y install tzdata && \
  apt-get -y install xmlstarlet && \
  apt-get -y install curl && \
  apt-get -y install wget && \
  echo "==== Install apache2 ====" && \
  apt install -y apache2 && \
  echo "==== Install php7.4 ====" && \
  apt-get -y install php7.4  && \
  apt-get -y install php-mbstring && \
  apt-get -y install php-xml && \
  echo "==== activate apache mods ====" && \
  a2enmod rewrite 

  CMD /var/run/apache2/startapache.sh

VOLUME /data
