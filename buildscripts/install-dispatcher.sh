#!/bin/sh

# exit on any error
set -e

# verbose, print cmds
set -x

# update leap package key
apt-key adv --keyserver pool.sks-keyservers.net --recv-keys 1E34A1828E207901
apt-get update

DEBIAN_FRONTEND=noninteractive apt-get -t wheezy -y install python-tornado
DEBIAN_FRONTEND=noninteractive apt-get -t wheezy-backports -y install pixelated-dispatcher linux-image-amd64 lxc-docker

echo "==============================================="
echo "Pinning SSL Fingerprint"
echo "==============================================="
FINGERPRINT=$(openssl x509 -in /etc/ssl/certs/ssl-cert-snakeoil.pem -noout -fingerprint -sha1 | cut -d'=' -f 2)
echo "PIXELATED_MANAGER_FINGERPRINT=$FINGERPRINT" >> /etc/default/pixelated-dispatcher-proxy
cat /etc/default/pixelated-dispatcher-proxy

FINGERPRINT=$(openssl x509 -in /etc/x509/certs/leap_commercial.crt -noout -fingerprint -sha1 | cut -d'=' -f 2)
echo "PIXELATED_PROVIDER_FINGERPRINT=$FINGERPRINT" >> /etc/default/pixelated-dispatcher-manager
cat /etc/default/pixelated-dispatcher-manager
echo "==============================================="
echo "cleaning up"
echo "==============================================="
rm -f /etc/apt/apt.conf.d/01-apt-cacher
apt-get update
apt-get -f install
sync
sleep 10
