#/bin/bash

PIDFILE=/tmp/rwe.ssh.txt
KEYFILE=$HOME/.ssh/media03

if [ -f $PIDFILE ]; then
  echo Pidfile $PIDFILE found
  PID=`grep "echo Agent pid" $PIDFILE | cut -f4 -d\  | sed -e "s%;%%g"`
  PIDEXIST=`ls /proc | grep -c $PID`
  if [ X$PIDEXIST = X0 ]; then
    echo PIDEXIST $PIDEXIST PID $PID not found, creating new one
    ssh-agent | tee $PIDFILE
    ssh-add $KEYFILE
  else
    echo $PIDEXIST PID $PID found, running setting env
. $PIDFILE
  fi
else
    echo PIDFILE $PIDFILE not found creating new one
    echo Pidfile $PIDFILE found
    ssh-agent | tee $PIDFILE
    ssh-add $KEYFILE
fi

# eof
