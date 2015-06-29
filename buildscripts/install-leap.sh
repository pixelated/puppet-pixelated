#!/bin/sh

# exit on any error
set -e

# verbose, print cmds
set -x

echo "==============================================="
echo "preparing leap"
echo "==============================================="

echo "deb http://httpredir.debian.org/debian/ wheezy-backports main" > /etc/apt/sources.list.d/backports.list
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get -y install puppet rsync ruby-hiera-puppet git ruby1.9.1-dev rake jq
apt-get clean

# update leap package key
apt-key adv --keyserver pool.sks-keyservers.net --recv-keys 1E34A1828E207901


echo "==============================================="
echo "installing leap"
echo "==============================================="
mkdir /home/leap

# use released leap_cli gem instead of building from source
gem install leap_cli

#git clone -b develop https://leap.se/git/leap_cli.git /home/leap/leap_cli
#cd /home/leap/leap_cli
#rake build
#rake install

git clone --recursive https://github.com/pixelated-project/leap_platform.git /home/leap/leap_platform

echo "==============================================="
echo "cleaning up"
echo "==============================================="
apt-get -f install
sync
sleep 10
