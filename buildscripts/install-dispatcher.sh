#!/bin/sh

# exit on any error
set -e

# exit
echo "==============================================="
echo "installing pixelated platform"
echo "==============================================="
echo "deb http://packages.pixelated-project.org/debian wheezy-snapshots main" > /etc/apt/sources.list.d/pixelated.list
echo "deb http://packages.pixelated-project.org/debian wheezy main"          >> /etc/apt/sources.list.d/pixelated.list
apt-key adv --keyserver pool.sks-keyservers.net --recv-key 287A1542472DC0E3 # install the pixelated apt key
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get -t wheezy-backports -y install pixelated-dispatcher linux-image-amd64 lxc-docker


echo "==============================================="
echo "Pinning SSL Fingerprint"
echo "==============================================="
FINGERPRINT=$(openssl x509 -in /etc/ssl/certs/ssl-cert-snakeoil.pem -noout -fingerprint -sha1 | cut -d'=' -f 2)
echo "PIXELATED_MANAGER_FINGERPRINT=$FINGERPRINT" >> /etc/default/pixelated-dispatcher-proxy

echo "==============================================="
echo "cleaning up"
echo "==============================================="
apt-get -f install
sync
sleep 10
