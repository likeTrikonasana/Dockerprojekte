#!/bin/bash

backuprwe()
(
# $1 - WIKIDIR
# $2 - BACKUPFILE

# create tar to $2 from $1, $1 must not be a link, $2 must not be existent

logrwe "==== backuprwe tar: $1 backup file: $2"
if [ ! -L $1 ] && [ ! -f $2 ]; then
# keep existing backup, may be generated externally, do not backup in case target is allready a link
  logrwe "INFO tar -cvf $2 -C $1 ."
  tar -cvf $2 -C $1 . 
  rwelog "INFO create bakckup in $MOUNTCONF"
  cp $2 $MOUNTCONF/
else
  logrwe "INFO backup not required tar $2 or link $1 exists, $1 exists as link"
fi
if [ -f $2 ]; then 
  logrwe "INFO, backup file $2 exists"
else
  logrwe "ERROR, backup file $2 missing"
  logrwe "INFO try to recover from $MOUNTCONF"
  filename="${2##*/}"
  cp $MOUNTCONF/$filename $RUNDIR/
  if [ -f $2 ]; then
    rwelog "INFO Recover successfull $2"
  else
    rwelog "ERROR recover failed $MOUNTCONF/$filename"
  fi
fi
if [ -L $1 ]; then 
  logrwe "INFO, link $1 exists"
else
  logrwe "WARN, link $1 missing, should be created in internal step"
fi
logrwe ""
)

checkexternal()
(
# $1 - DATADIR
# $2 - BACKUPFILE
# $3 - MOUNT
# checkexternal $DIRDATA $DATABACKUP $MOUNTDATA

logrwe "==== checkexternal source $1 backupfile $2 target for tar $3"
if [ ! -d $1 ]; then 
# if external structure $1 exists, keep this
  logrwe "INFO creating dir mkdir -p $1"
  mkdir -p $1
  chown -R www-data $1
  chgrp -R www-data $1
  if [ -f $2 ]; then 
    logrwe "INFO restore tar -xvf $2 -C $1"
    tar -xvf $2 -C $1
    logrwe "INFO chown to www-data $1"
    chown -R www-data $1
    chgrp -R www-data $1
  else
    if [ X$2 != XNOBACKUP ]; then
      logrwe "ERROR Backupfile $2 not found"
    fi
  fi
else
  logrwe "INFO: external dir $1 found"
fi
logrwe ""
)

checkinternal()
(
# $1 - ext. dir
# $2 - link in wiki
logrwe "==== checkinternal external dir $1 linkfile in wiki $2"
if [ -d $1 ]; then
# $1 the external structure $1 must exist
  echo "INFO creating link rm -rf $2; ln -s $1 $2"
  rm -rf $2; ln -s $1 $2
else
  logrwe "ERREO external dir $1 does not exist"
fi
if [ -L $2 ]; then
  logrwe "INFO Link $2 exist"
else
  logrwe "ERROR Link $2 does not exist"
fi
logrwe ""
)

logrwe ()
(
  echo $1 | tee -a $LOGFILE
)

# ----------------------------------------------------
echo "================ Starting container ini ================" 

# installationdirs
WIKIROOT=/var/www
WIKIDIR=/var/www/dokuwiki
WIKIFARM=/var/www/farm
WIKIDATA=$WIKIDIR/data
WIKICONF=$WIKIDIR/conf
WIKIPLUGIN=$WIKIDIR/lib/plugins
WIKIINC=$WIKIDIR/inc

# externaldirs
# conf, plugins -> /conf
# data -> /data

MOUNTCONF=/conf
DIRCONF=$MOUNTCONF/conf
DIRPLUGIN=$MOUNTCONF/plugins
DIRINC=$MOUNTCONF/inc

MOUNTDATA=/data
DIRDATA=$MOUNTDATA/data
DIRFARMER=$MOUNTDATA/farm

RUNDIR=/var/run/apache2
ETCDIR=/etc/apache2
DATABACKUP=$RUNDIR/databackup.tar
CONFBACKUP=$RUNDIR/confbackup.tar
PLUGINBACKUP=$RUNDIR/pluginorighbackup.tar
PLUGINFARMERBACKUP=$RUNDIR/pluginbackup.tar
INCBACKUP=$RUNDIR/incbackup.tar

LOGFILE=$RUNDIR/install.log

if [ ! -d $RUNDIR ]; then
# should exist
  rwelog "WARNING expect the rundir $RUNDIR should allready exist, please check this"
  mkdir $RUNDIR
fi

backuprwe $WIKIDATA $DATABACKUP
backuprwe $WIKICONF $CONFBACKUP
backuprwe $WIKIPLUGIN $PLUGINBACKUP
backuprwe $WIKIINC $INCBACKUP

# check external structur
checkexternal $DIRDATA $DATABACKUP $MOUNTDATA
checkexternal $DIRCONF $CONFBACKUP $MOUNTCONF
checkexternal $DIRPLUGIN $PLUGINBACKUP $MOUNTCONF
checkexternal $DIRFARMER NOBACKUP $MOUNTDATA
checkexternal $DIRINC $INCBACKUP $MOUNTCONF

# check internal structur
checkinternal $DIRDATA $WIKIDATA
checkinternal $DIRCONF $WIKICONF
checkinternal $DIRPLUGIN $WIKIPLUGIN
checkinternal $DIRFARMER $WIKIFARM
checkinternal $DIRINC $WIKIINC

logrwe "INFO copy /etc/apache2/sites-available/apache2-dokuwiki.conf"
cp $ETCDIR/sites-enabled/apache2-dokuwiki.conf.new /etc/apache2/sites-available/apache2-dokuwiki.conf
logrwe "INFO copy $ETCDIR/apache2.conf"
cp $ETCDIR/apache2.conf.new $ETCDIR/apache2.conf
logrwe "INFO copy /etc/apache2/envvars"
cp $ETCDIR/envvars.new $ETCDIR/envvars
# logrwe "INFO copy $RUNDIR/preload.php $WIKIINC/"

cp $RUNDIR/preload.php $WIKIINC/
chown -R www-data $WIKIINC/preload.php
chgrp -R www-data $WIKIINC/preload.php

if [ ! -d $WIKIPLUGIN/farmer ]; then
  rwelog "INFO Farmer plugin not found, installing!"
  mkdir -p $WIKIPLUGIN/farmer
  tar -xvf $PLUGINFARMERBACKUP -C $WIKIPLUGIN/farmer .
  chown -R www-data $WIKIPLUGIN/farmer
  chgrp -R www-data $WIKIPLUGIN/farmer
else
  rwelog "INFO Farmer plugin found"
fi

# in case there is an external configuration delivered
if [ -d $MOUNTDATA/conf ]; then
# required, as MOUNTDATA/conf/ is accessable from outside, as MOUNTCONF/ is not
  logrwe "INFO Default config found, restore cp $MOUNTDATA/conf/\* $DIRCONF/"
  cp $MOUNTDATA/conf/* $DIRCONF/
  chown -R www-data $DIRCONF/*
  chgrp -R www-data $DIRCONF/*
fi
if [ -f $DIRCONF/install.php ]; then 
  logrwe "INFO remove $DIRCONF/install.php to $DIRCONF/install.php.old"
  mv $DIRCONF/install.php $DIRCONF/install.php.old
fi

# connect conf, plugins to docker volume

logrwe "INFO disable apache default site 000-default "
a2dissite 000-default 
logrwe "INFO activate apache wikisite apache2-dokuwiki "
a2ensite apache2-dokuwiki

logrwe "============ Finished container init ============"

# eof
