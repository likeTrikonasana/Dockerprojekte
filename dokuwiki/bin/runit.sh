#!/bin/bash

rwelog()
(
echo $1
)

# ---------------------------------------

# Volumes:
# bind: source=$DATADIR,target=/data (i.e. ./data -> /data
# prepares 
# /var/www/dokuwiki/data -> /data/data 
# /var/www/farm -> /data/farm
# 
# Volume: $VOLUME -> /var/www

WORKSPACE=/var/data/workspace/dockerprojekte/dokuwiki/
ENVVARS=$WORKSPACE/bin/envvars.sh

# must be in same dir
if [ ! -f$ENVVARS ]; then
  echo " $ENVVARS missing"
else

. $ENVVARS

rwelog "INFO All dev runs"
echo "docker run --name $CONATINERDEV -it -p $PORTDEV:80 -v $VOLUMEDEV:/var/www --mount type=bind,source=$DATADIR,target=/data $IMAGEDEV /bin/bash"
echo "docker run --name $CONATINERDEV -d -p $PORTDEV:80 -v $VOLUMEDEV:/var/www --mount type=bind,source=$DATADIR,target=/data $IMAGEDEV "
echo docker start ralphdev

rwelog "INFO All prod runs"
echo "docker run --name $CONATINERPROD -it -p $PORTPROD:80 -v $VOLUMEPROD:/var/www -v $VOLUMENFS:/data $IMAGEPROD /bin/bash"
echo "docker run --name $CONATINERPROD -d -p $PORTPROD:80 -v $VOLUMEPROD:/var/www -v $VOLUMENFS:/data $IMAGEPROD"

fi
