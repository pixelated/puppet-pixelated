#!/bin/sh

# exit on any error
set -e

# verbose, print cmds
set -x

echo "==============================================="
echo "preparing leap"
echo "==============================================="

sudo sh -c 'echo "deb http://debian.mirror.iphh.net/debian wheezy-backports main" > /etc/apt/sources.list.d/backports.list'
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install puppet rsync ruby-hiera-puppet git ruby1.9.1-dev rake jq
sudo apt-get clean

# update leap package key
sudo apt-key adv --keyserver pool.sks-keyservers.net --recv-keys 1E34A1828E207901


echo "==============================================="
echo "installing leap"
echo "==============================================="
ME=$USER
sudo mkdir /home/leap
sudo chown $ME /home/leap

# build leap_cli from source so it works together with leap_platform:develop
git clone -b develop https://leap.se/git/leap_cli.git /home/leap/leap_cli
cd /home/leap/leap_cli
rake build
sudo rake install

git clone --recursive --branch develop https://github.com/pixelated/leap_platform.git /home/leap/leap_platform

echo "==============================================="
echo "cleaning up"
echo "==============================================="
sudo apt-get -f install
sudo sync
sleep 10
