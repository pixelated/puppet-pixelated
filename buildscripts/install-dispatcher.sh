#!/bin/sh

# exit on any error
set -e

# verbose, print cmds
set -x

DEBIAN_FRONTEND=noninteractive apt-get -t wheezy-backports -y install pixelated-dispatcher linux-image-amd64 lxc-docker

echo "==============================================="
echo "Pinning SSL Fingerprint"
echo "==============================================="
FINGERPRINT=$(openssl x509 -in /etc/ssl/certs/ssl-cert-snakeoil.pem -noout -fingerprint -sha1 | cut -d'=' -f 2)
echo "PIXELATED_MANAGER_FINGERPRINT=$FINGERPRINT" >> /etc/default/pixelated-dispatcher-proxy
cat /etc/default/pixelated-dispatcher-proxy

echo "==============================================="
echo "cleaning up"
echo "==============================================="
rm /etc/apt/apt.conf.d/01-apt-cacher
apt-get update
apt-get -f install
sync
sleep 10
