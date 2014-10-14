#!/bin/sh

echo "==============================================="
echo "installing virtualbox guest additions"
echo "==============================================="
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -t wheezy-backports install linux-headers-amd64
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -t wheezy-backports install virtualbox-guest-additions

echo "==============================================="
echo "adding ssh-key"
echo "==============================================="
sudo mkdir /home/vagrant/.ssh
sudo sh -c "echo ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key >> /home/vagrant/.ssh/authorized_keys"
sudo chown -R vagrant:vagrant /home/vagrant/.ssh
sudo chmod 700 /home/vagrant/.ssh
sudo chmod 600 /home/vagrant/.ssh/authorized_keys

sudo sh -c "echo vagrant ALL=\(ALL\) NOPASSWD: ALL >> /etc/sudoers.d/vagrant"

echo "==============================================="
echo "setting passwords for vagrant and root"
echo "==============================================="
sudo usermod -p '\$6\$chPyDBu4\$r.9lJnTa5q7yZbX//3khkkKyTpFsWels5D/zMJ1p5qvLz4034Bu8vOIUBt9bkAFkU2aP7ZGxGtHTHuf90NYOI.' vagrant
sudo usermod -p '\$6\$chPyDBu4\$r.9lJnTa5q7yZbX//3khkkKyTpFsWels5D/zMJ1p5qvLz4034Bu8vOIUBt9bkAFkU2aP7ZGxGtHTHuf90NYOI.' root

