#!/bin/bash

#  ================ Functions ================"

logrwe ()
(
  echo $1 | tee -a $LOGFILE
)

changepermissions()
(
if [ -f $1 ] || [ -d $1 ]; then
  chown -R www-data $1
  chgrp -R www-data $1
fi
)

createdir ()
(
  if [ -d $1 ]; then
    logrwe "INFO Dir $1 found"
  else
    logrwe "INFO creating Dir $1"
    mkdir -p $1
    changepermissions $1
  fi
)

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
# /var/www -> /www
# /var/www/dokuwiki/data -> /data/data
# /var/www/farm -> /data/farm

MOUNTCONF=/var/www
MOUNTWIKI=$MOUNTCONF/dokuwiki

MOUNTPOINT=/data
MOUNTDATA=$MOUNTPOINT/data
MOUNTFARMER=$MOUNTPOINT/farm

RUNDIR=/var/run/apache2
ETCDIR=/etc/apache2

DATABACKUP=$RUNDIR/data.tgz
WIKIBACKUP=$RUNDIR/dokuwiki-stable.tgz
FARMERBACKUP=$RUNDIR/farmer.tgz

LOGFILE=$RUNDIR/install.log

if [ ! -d $RUNDIR ]; then
# should exist
  rwelog "WARNING expect the rundir $RUNDIR should allready exist, please check this"
  mkdir -p $RUNDIR
fi

logrwe "INFO copy /etc/apache2/sites-available/apache2-dokuwiki.conf"
cp $ETCDIR/sites-enabled/apache2-dokuwiki.conf.new /etc/apache2/sites-available/apache2-dokuwiki.conf
logrwe "INFO copy $ETCDIR/apache2.conf"
cp $ETCDIR/apache2.conf.new $ETCDIR/apache2.conf
logrwe "INFO copy /etc/apache2/envvars"
cp $ETCDIR/envvars.new $ETCDIR/envvars

# connect conf, plugins to docker volume

logrwe "INFO disable apache default site 000-default "
a2dissite 000-default 
logrwe "INFO activate apache wikisite apache2-dokuwiki "
a2ensite apache2-dokuwiki

logrwe "============ Install dokuwiki ============"

if [ -d $WIKIDIR ]; then
  logrwe "INFO $WIKIDIR exists, will be kept"
else
  logrwe "INFO Installing $WIKIDIR "
  createdir $WIKIDIR
  tar -xf  $WIKIBACKUP -C $WIKIDIR
  changepermissions $WIKIROOT
fi

logrwe "============ Install farm ============"
if [ -d $MOUNTFARMER ]; then
  logrwe "INFO $MOUNTFARMER exists, will be kept"
else
  if [ -f $FARMERBACKUP ]; then
    logrwe "INFO Installing $MOUNTFARMER "
    createdir $MOUNTFARMER
    tar -xf  $FARMERBACKUP -C $MOUNTFARMER
    changepermissions $MOUNTFARMER
  else
    logrwe "INFO Creating Farmerdir $MOUNTFARMER, no backup $FARMERBACKUP found to be installed"
    createdir $MOUNTFARMER
  fi
fi
if [ -L $WIKIFARM ]; then
  logrwe "INFO Link $WIKIFARM found"
else
  logrwe "INFO Creating link ln -s $MOUNTFARMER $WIKIFARM"
  ln -s $MOUNTFARMER $WIKIFARM
fi

logrwe "============ Install data ============"
if [ ! -d $MOUNTDATA ]; then
  logrwe "INFO Create datadir $MOUNTDATA"
  createdir $MOUNTDATA
  tar -xf $DATABACKUP -C $MOUNTDATA
  changepermissions $MOUNTDATA
else
  logrwe "INFO $MOUNTDATA exists, will be kept"
fi
if [ -L $WIKIDATA ]; then
  logrwe "INFO Link $WIKIDATA found"
else
  if [ -d $WIKIDATA ]; then
    logrwe "INFO Backup installed data dir $WIKIDATA to $MOUNTPOINT/data.backup "
    tar -cf $MOUNTPOINT/data.backup -C $WIKIDATA .
  fi
  logrwe "INFO Creating link ln -s $MOUNTDATA $WIKIDATA"
  rm -rf $WIKIDATA; ln -s $MOUNTDATA $WIKIDATA
fi

logrwe "============ cleanup ============"
if [ -f $WIKICONF/install.php ]; then 
  logrwe "INFO remove $DIRCONF/install.php to $DIRCONF/install.php.old"
  mv $WIKICONF/install.php $DIRCONF/install.php.old
fi


logrwe "============ Finished container init ============"

# eof
