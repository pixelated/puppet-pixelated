#!/bin/sh

echo "deb http://debian.mirror.iphh.net/debian wheezy-backports main" > /etc/apt/sources.list.d/backports.list
apt-get update
apt-get -y install puppet rsync ruby-hiera-puppet git ruby1.9.1-dev rake jq
apt-get clean

