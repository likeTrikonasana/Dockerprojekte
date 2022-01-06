#!/bin/bash

RUNDIR=/var/run/apache2/
ENVVARS=/etc/apache2/envvars
APACHE=/usr/sbin/apache2

if [ -f $RUNDIR/initcontainer.sh ]; then
# run once
/bin/bash $RUNDIR/initcontainer.sh
mv $RUNDIR/initcontainer.sh $RUNDIR/initcontainer.sh.run
fi

# required to start apache in foreground mode
. $ENVVARS
$APACHE -D FOREGROUND 
