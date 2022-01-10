#!/bin/bash


rwelog()
(
echo $1
)

# ---------------------------------------

ENVVARS=/var/data/workspace/dockerprojekte/dokuwiki/bin/envvars.sh

# must be in same dir
if [ ! -f $ENVVARS ]; then
  rwelog "ERROR $ENVVARS missing"
fi

. $ENVVARS

VOLC=`docker volume ls | grep -c $VOLUME`
if [ X$VOLC = X0 ]; then 
  rwelog "INFO docker volume not found, volume create $VOLUME"
  docker volume create $VOLUME
else
  rwelog "INFO docker volume $VOLUME found"
fi
echo "docker build -t $IMAGE ."

# eof
