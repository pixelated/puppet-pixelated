#
# Copyright (c) 2014 ThoughtWorks Deutschland GmbH
#
# Pixelated is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Pixelated is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Pixelated. If not, see <http://www.gnu.org/licenses/>.
echo "deb http://debian.mirror.iphh.net/debian wheezy-backports main" > /etc/apt/sources.list.d/backports.list
apt-get update
apt-get -y install puppet rsync ruby-hiera-puppet git ruby1.9.1-dev rake jq
apt-get clean
echo "==============================================="
echo "installing leap"
echo "==============================================="
#gem install leap_cli
cd /tmp
git clone -b master https://leap.se/git/leap_cli.git
cd leap_cli
rake build
rake install
mkdir /home/leap
cd /home/leap
git clone -b master https://leap.se/git/leap_platform.git
cd /home/leap/leap_platform
#git fetch origin
#git checkout develop
git submodule sync
git submodule update --init
echo "==============================================="
echo "installing pixelated platform"
echo "==============================================="
echo "deb http://packages.pixelated-project.org/debian wheezy-snapshots main" > /etc/apt/sources.list.d/pixelated.list
echo "deb http://packages.pixelated-project.org/debian wheezy main" > /etc/apt/sources.list.d/pixelated.list
apt-key adv --keyserver pool.sks-keyservers.net --recv-key 1E34A1828E207901 # install the leap apt key
apt-key adv --keyserver pool.sks-keyservers.net --recv-key 287A1542472DC0E3 # install the pixelated apt key
apt-get update
apt-get install pixelated-dispatcher

echo "==============================================="
echo "configuring leap"
echo "==============================================="
mkdir /home/leap/configuration
cd /home/leap/configuration
leap new --contacts no-reply@wazokazi.is --domain example.wazokazi.is --name LEAP_Example --platform=/home/leap/leap_platform .
ssh-keygen -f /root/.ssh/id_rsa -P ""
cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
leap add-user --self
leap cert ca
leap cert csr
leap node add pixelated ip_address:$(facter ipaddress)  services:webapp,mx,couchdb,soledad tags:production
jq '.["couch.master"]="true"' nodes/pixelated.json > nodes/pixelated.json.tmp
mv nodes/pixelated.json.tmp nodes/pixelated.json
sh -c 'cat /etc/ssh/ssh_host_ecdsa_key.pub | cut -d" " -f1,2 >> /home/leap/configuration/files/nodes/leap/leap_ssh.pub'
echo '{ "webapp": { "admins": ["testadmin"] } }' > services/webapp.json

leap node init pixelated 
if [ $? -eq 1 ]; then
  echo "node init failed"
  exit 1
fi

leap -v 3 deploy
if [ $? -eq 1 ]; then
  echo "deploy failed"
  exit 1
fi

echo "==============================================="
echo "setting node to demo-mode"
echo "==============================================="
postconf -e default_transport="error: in demo mode"
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
# add users: testadmin and testuser with passwords "hallo123"
curl -k https://localhost/1/users.json -d "user%5Blogin%5D=testuser&user%5Bpassword_salt%5D=7d4880237a038e0e&user%5Bpassword_verifier%5D=b98dc393afcd16e5a40fb57ce9cddfa6a978b84be326196627c111d426cada898cdaf3a6427e98b27daf4b0ed61d278bc856515aeceb2312e50c8f816659fcaa4460d839a1e2d7ffb867d32ac869962061368141c7571a53443d58dc84ca1fca34776894414c1090a93e296db6cef12c2cc3f7a991b05d49728ed358fd868286"
curl -k https://localhost/1/users.json -d "user%5Blogin%5D=testadmin&user%5Bpassword_salt%5D=ece1c457014d8282&user%5Bpassword_verifier%5D=9654d93ab409edf4ff1543d07e08f321107c3fd00de05c646c637866a94f28b3eb263ea9129dacebb7291b3374cc6f0bf88eb3d231eb3a76eed330a0e8fd2a5c477ed2693694efc1cc23ae83c2ae351a21139701983dd595b6c3225a1bebd2a4e6122f83df87606f1a41152d9890e5a11ac3749b3bfcf4407fc83ef60b4ced68"


VIRTUAL=$(facter virtual)

if [ $VIRTUAL = 'virtualbox' ]; then
  apt-get -y install virtualbox-guest-utils
fi

echo "==============================================="
echo "done"
echo "==============================================="
sync
