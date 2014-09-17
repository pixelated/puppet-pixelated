
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
# use bigcouch instead of couchdb, so we DON'T provide couch.master=true here
#jq '.["couch.master"]="true"' nodes/pixelated.json > nodes/pixelated.json.tmp
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


