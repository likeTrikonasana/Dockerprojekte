
FROM ubuntu

ARG BUILD_DATE
ARG VERSION
ARG DOKUWIKI_RELEASE
LABEL build_version="ralphs version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="rwetri"

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Berlin

COPY sources.list /etc/apt/sources.list
COPY conf/apache2.conf /etc/apache2/apache2.conf.new
COPY bin/startapache.sh /var/run/apache2/startapache.sh
COPY bin/initcontainer.sh /var/run/apache2/initcontainer.sh
COPY conf/apache2-dokuwiki.conf /etc/apache2/sites-enabled/apache2-dokuwiki.conf.new

RUN \
  echo "*** Installing Dokuwiki  $DOKUWIKI_RELEASE ***" && \
  echo "*** Actualize packagemanagement ***" && \
  apt-get update && \
  echo "*** Install required base packages ***" && \
  apt-get -y install tzdata && \
  apt-get -y install xmlstarlet && \
  apt-get -y install curl && \
  apt-get -y install wget && \
  echo "*** Install apache2 ***" && \
  apt install -y apache2 && \
  echo "*** Install dokuwiki $DOKUWIKI_RELEASE ***" && \
  if [ -z ${DOKUWIKI_RELEASE+x} ]; then \
         DOKUWIKI_RELEASE=$(wget https://download.dokuwiki.org/rss -O - 2>/dev/null | \
                 xmlstarlet sel -T -t -v '/rss/channel/item[1]/link' | \
                 cut -d'-' -f2-4 | cut -d'.' -f1 ); \
  fi && \
  echo "*** Using dokuwiki ${DOKUWIKI_RELEASE} ***" && \
  curl -o \
  /tmp/dokuwiki.tar.gz -L \
         "https://github.com/splitbrain/dokuwiki/archive/release_stable_${DOKUWIKI_RELEASE}.tar.gz" && \
  mkdir -p \
         /var/www/dokuwiki && \
  tar xf \
         /tmp/dokuwiki.tar.gz -C \
         /var/www/dokuwiki --strip-components=1 && \
  echo "*** Install php7.4 ***" && \
  apt-get -y install php7.4  && \
  apt-get -y install php-mbstring && \
  echo "*** activate apache mods ***" && \
  a2enmod rewrite 

  CMD /var/run/apache2/startapache.sh

VOLUME /data
