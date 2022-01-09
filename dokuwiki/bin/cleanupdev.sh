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
else

. $ENVVARS

rwelog "INFO stop running processes $NAME"
PIDC=`docker ps | grep -c $NAME`
if [ X$PIDC != X0 ]; then
  docker stop `docker ps | grep $NAME | cut -f1 -d\  `
fi

rwelog "INFO stop containers $NAME"
PIDC=`docker ps -a | grep -c $NAME`
if [ X$PIDC != X0 ]; then
  for i in `docker ps -a | grep $NAME | cut -f1 -d\ `; do docker rm $i; done
fi

rwelog "INFO delete images $IMAGE $NAME"
PIDC=`docker images | grep -c $IMAGE`
if [ X$PIDC != X0 ]; then
  PID=`docker images | grep $IMAGE | cut -f3 -d\t | sed -e "s%^ *%%g" | cut -f1 -d\ `
  docker rmi $PID
fi

if [ X$1 = Xall ]; then
  rwelog "INFO Deleting volume $1"
  docker volume rm $VOLUME
  if [ -d $DATADIR ] ; then
  rm -rf $DATADIR/data
  rm -rf $DATADIR/conf
  rm -rf $DATADIR/farm
  rm $DATADIR/*.tar  $DATADIR/*.log
fi
else
  rwelog 'INFO user Option "all" to include volumes'
fi

CHECK=`echo $DATADIR | grep -c $WORKSPACE`

if [ -d $DATADIR ] && [ X$CHECK = X1 ]; then
  echo rm -rf $DATADIR/data
  echo rm -rf $DATADIR/conf
  echo rm $DATADIR/*
fi

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

fi
# eof
