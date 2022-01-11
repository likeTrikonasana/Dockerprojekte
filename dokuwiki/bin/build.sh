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

VOLC=`docker volume ls | grep -c $VOLUMEDEV`
if [ X$VOLC = X0 ]; then 
  rwelog "INFO docker volume not found, volume create $VOLUME"
  docker volume create $VOLUMEDEV
else
  rwelog "INFO docker volume $VOLUMEDEV found"
fi
rwelog "Build dev"
echo "docker build -t $IMAGEDEV ."

rwelog "Build prod"
echo "docker build -t $IMAGEPROD ."

# eof
