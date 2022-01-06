
# datadir is mounted in the container /data
export datadir=/var/data/workspace/dockerprojekte/dokuwiki/data

# run interactive
docker run --name ralph -it -p 9000:80 --mount type=bind,source=$datadir,target=/data ralphsdokuwiki /bin/bash

# run detached, the first time the start takes some time, take any port required, here 9000
docker run --name ralph -d -p 9000:80 --mount type=bind,source=$datadir,target=/data ralphsdokuwiki 

# build with
clear; docker build -t ralphsdokuwiki .

# chekc the running process
docker ps

# eof
