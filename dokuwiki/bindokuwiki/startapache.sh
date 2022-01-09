#!/bin/bash

RUNDIR=/var/run/apache2/
ENVVARS=/etc/apache2/envvars
APACHE=/usr/sbin/apache2

devfunction ()
(
if [ -f /data/apache2-dokuwiki.conf ]; then
  cp /data/apache2-dokuwiki.conf /etc/apache2/sites-enabled/
fi
)
if [ -f /data/apache2.conf ]; then
  cp /data/apache2.conf $APACHE_CONFDIR/
fi

/bin/bash $RUNDIR/initcontainer.sh

devfunction

# required to start apache in foreground mode
. $ENVVARS
$APACHE -D FOREGROUND 
