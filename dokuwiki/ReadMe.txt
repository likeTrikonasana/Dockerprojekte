
ä Development ********************************************

gitworkspace=/var/data/workspace/dockerprojekte/

# your gitworksppace (there .git  is located)
export workspace=/var/data/workspace/dockerprojekte/dokuwiki
# datadir is mounted in the container /data - Wikedata using bind
export datadir=/var/data/workspace/dockerprojekte/dokuwiki/data

# condir is mounted via volume for config, plugins
docker volume create ralphdevwiki

# run interactive dev
docker run --name ralphdev -it -p 9000:80 -v ralphdevwiki:/conf --mount type=bind,source=$datadir,target=/data ralphsdokuwiki /bin/bash

# run detached, the first time the start takes some time, take any port required, here 9000
docker run --name ralphdev -d -p 9000:80 -v ralphdevwiki:/conf --mount type=bind,source=$datadir,target=/data ralphsdokuwiki 

# build with
clear; docker build -t ralphsdokuwiki .

# chekc the running process
docker ps

ä Production ********************************************

# condir is mounted via volume for config, plugins
docker volume create ralphprodwiki

# run interactive prod
# target should be NFS in version 1
docker run --name ralphprod -it -p 8085:80 --mount type=bind,source=$datadir,target=/data ralphsdokuwiki /bin/bash

# run detached, the first time the start takes some time, take any port required, here 9000
docker run --name ralphprod -d -p 8085:80 --mount type=bind,source=$datadir,target=/data ralphsdokuwiki 

# condir is mounted via volume for config, plugins
create volume ralphprodwiki


# git checkout /depends on git server
# example connect to ssh git server - a simple workflow

. $gitworkspace/dokuwiki/bin/sshagent.sh

git add *
git commit -m"message"
git push "dockerprojekte"

# ToBeDone add github repo

# eof
