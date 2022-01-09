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

# rwelog 'INFO copy dokuwiki confîg to data cp $DOCKERFILEPATH/conf/dokuwiki/* $DOCKERFILEPATH/data/conf/'
# mkdir -p $DOCKERFILEPATH/data/conf/
# cp $DOCKERFILEPATH/conf/dokuwiki/* $DOCKERFILEPATH/data/conf/


# rwelog 'INFO copy farmers confîg to data cp $DOCKERFILEPATH/conf/farmer/* $DOCKERFILEPATH/data/farmerconf/'
# mkdir -p $DOCKERFILEPATH/data/farmerconf/
# cp -r $DOCKERFILEPATH/conf/farmer/* $DOCKERFILEPATH/data/farmerconf/

# files which will be copied in Dokufile
rwelog "INFO tar -cvf $DOCKERFILEPATH/data/dokuwiki.conf.tar -C $DOCKERFILEPATH/conf/dokuwiki/ ."
tar -cvf $DOCKERFILEPATH/data/confbackup.tar -C $DOCKERFILEPATH/conf/dokuwiki/ .
rwelog "INFO tar -cvf $DOCKERFILEPATH/data/farmer.plugin.tar -C $DOCKERFILEPATH/conf/plugins/farmer/ ."
tar -cvf $DOCKERFILEPATH/data/pluginbackup.tar -C $DOCKERFILEPATH/conf/plugins/farmer/ .

# echo docker build -f $DOCKERFILEPATH -t $IMAGE .
echo docker volume create $VOLUME

rwelog "INFO buils.sh"
echo "docker build -t $IMAGE ."

# eof
