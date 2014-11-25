#!/bin/sh

# exit on any error
set -e

echo "==============================================="
echo "preparing leap"
echo "==============================================="

echo "deb http://debian.mirror.iphh.net/debian wheezy-backports main" > /etc/apt/sources.list.d/backports.list
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get -y install puppet rsync ruby-hiera-puppet git ruby1.9.1-dev rake jq
apt-get clean

echo "==============================================="
echo "installing leap"
echo "==============================================="
#gem install leap_cli
git clone -b develop https://leap.se/git/leap_cli.git /tmp/leap_cli
cd /tmp/leap_cli
rake build
rake install

mkdir /home/leap
git clone -b develop --recursive https://github.com/pixelated-project/leap_platform.git /home/leap/leap_platform

echo "==============================================="
echo "cleaning up"
echo "==============================================="
apt-get -f install
sync
sleep 10
