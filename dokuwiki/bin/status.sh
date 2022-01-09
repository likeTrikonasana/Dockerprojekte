#!/bin/bash
rwelog()
(
echo $1
)

# ---------------------------------------

WORKSPACE=/var/data/workspace/dockerprojekte/dokuwiki
ENVVARS=$WORKSPACE/bin/envvars.sh

# must be in same dir
if [ ! -f $ENVVARS ]; then
  rwelog "ERROR $ENVVAR missing"
fi

. $ENVVARS

rwelog "INFO Results:"
rwelog "=============================== ps"
docker ps
rwelog "=============================== ps -a"
docker ps -a
rwelog "=============================== images"
docker images
rwelog "=============================== volumes"
docker volume ls
rwelog "=============================== DATADIR"
ls $DATADIR
rwelog "=============================== dokuwiki execute is it makes sense"
echo docker exec ralphdev ls -al /var/www/
echo ls -al /var/www/
echo docker exec ralphdev ls -al /var/www/dokuwiki
echo ls -al /var/www/dokuwiki
echo docker exec ralphdev ls -al /var/run/apache2
echo ls -al /var/run/apache2
echo docker exec ralphdev cat /var/www/dokuwiki/conf/farm.ini | more
echo cat /var/www/dokuwiki/conf/farm.ini | more

# eof
