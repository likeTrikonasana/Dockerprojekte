#!/bin/bash

echo "*** Starting container ini ***"

wikidir=/var/www/dokuwiki
targetdir=/data
RUNDIR=/var/run/apache2
ETCDIR=/etc/apache2

for i in data conf
do
if [ ! -d $targetdir/$i ]; then
  if [ ! -d $wikidir/$i ]; then
    echo "*** error ***"
  else
    mv $wikidir/$i $targetdir/
    ln -s $targetdir/$i $wikidir/$i
  fi
else
  rm -rf $wikidir/$i
  ln -s $targetdir/$i  $wikidir/$i
fi
if [ ! -d $RUNDIR ]; then
  mkdir $RUNDIR
fi
chown -R www-data $targetdir/$i
chgrp -R www-data $targetdir/$i
done

chown -R www-data $wikidir 
chgrp -R www-data $wikidir

cp $ETCDIR/sites-enabled/apache2-dokuwiki.conf.new /etc/apache2/sites-available/apache2-dokuwiki.conf
cp $ETCDIR/apache2.conf.new $ETCDIR/apache2.conf

echo "*** run container init ***" && \
echo "*** activate apache wikisite ***" && \
a2dissite 000-default && \
a2ensite apache2-dokuwiki

echo "*** Finished container ini ***"
