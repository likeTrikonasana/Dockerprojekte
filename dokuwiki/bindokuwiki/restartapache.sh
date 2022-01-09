#!/bin/bash

RUNDIR=/var/run/apache2/
ENVVARS=/etc/apache2/envvars
APACHE=/usr/sbin/apache2

# /bin/bash $RUNDIR/initcontainer.sh

# required to start apache in foreground mode
. $ENVVARS
$APACHE -k restart

# eof
