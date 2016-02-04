#!/bin/bash
#
# Issues:
# - homebrew version of git does not work nicely with submodules

hash vagrant 2>/dev/null || { echo >&2 "Vagrant is not installed.  Aborting."; exit 1; }

vagrant_ssh (){
  vagrant ssh -c "export LANG=en_US.UTF-8; export LANGUAGE=en_US.UTF-8; export LC_ALL=en_US.UTF-8; cd /home/vagrant/leap/configuration/; $1"
}

if [ -d ./leap_platform ]
then
  cd leap_platform
  /usr/bin/git pull
  /usr/bin/git submodule update --init
else
  /usr/bin/git clone --branch develop --recursive https://leap.se/git/leap_platform.git
  cd leap_platform
fi

vagrant up
vagrant_ssh 'mkdir -p files/puppet/modules'
vagrant_ssh 'git submodule add https://github.com/pixelated/puppet-pixelated.git files/puppet/modules/pixelated'
vagrant_ssh 'mkdir -p files/puppet/modules/custom/manifests'
vagrant_ssh 'echo '{}' > services/pixelated.json'
vagrant_ssh "echo 'class custom { include ::pixelated}' > files/puppet/modules/custom/manifests/init.pp"
vagrant_ssh 'leap deploy'

# at last, check if everything is working
vagrant_ssh 'leap test'

