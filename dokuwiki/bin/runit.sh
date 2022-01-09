#!/bin/bash

rwelog()
(
echo $1
)

# ---------------------------------------

WORKSPACE=/var/data/workspace/dockerprojekte/dokuwiki/
ENVVARS=$WORKSPACE/bin/envvars.sh

# must be in same dir
if [ ! -f$ENVVARS ]; then
  echo " $ENVVARS missing"
else

. $ENVVARS

echo "docker run --name $CONATINER -it -p $PORT:80 -v $VOLUME:/conf --mount type=bind,source=$DATADIR,target=/data $IMAGE /bin/bash"
echo "docker run --name $CONATINER -p $PORT:80 -v $VOLUME:/conf --mount type=bind,source=$DATADIR,target=/data $IMAGE "
echo docker start ralphdev

fi
