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

echo "docker run --name $CONATINER -it -p $PORT:80 -v $VOLUME:/var/www --mount type=bind,source=$DATADIR,target=/data $IMAGE /bin/bash"
echo "docker run --name $CONATINER -p $PORT:80 -v $VOLUME:/var/www --mount type=bind,source=$DATADIR,target=/data $IMAGE "
echo docker start ralphdev

fi
