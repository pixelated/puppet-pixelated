#!/bin/sh
echo "==============================================="
echo "installing pixelated platform"
echo "==============================================="
echo "deb http://packages.pixelated-project.org/debian wheezy-snapshots main" > /etc/apt/sources.list.d/pixelated.list
echo "deb http://packages.pixelated-project.org/debian wheezy main"          >> /etc/apt/sources.list.d/pixelated.list
apt-key adv --keyserver pool.sks-keyservers.net --recv-key 287A1542472DC0E3 # install the pixelated apt key
apt-get update
apt-get -t wheezy-backports -y install pixelated-dispatcher linux-image-amd64 lxc-docker

