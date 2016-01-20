#!/bin/bash

vagrant_ssh (){
  vagrant ssh -c "cd /home/vagrant/leap/configuration/; $1"
}

git clone --branch develop --recursive https://github.com/leapcode/leap_platform.git
cd leap_platform
vagrant up
vagrant_ssh 'mkdir -p files/puppet/modules'
vagrant_ssh 'git submodule add https://github.com/pixelated/puppet-pixelated.git files/puppet/modules/pixelated'
vagrant_ssh 'mkdir -p files/puppet/modules/custom/manifests'
vagrant_ssh 'echo '{}' > services/pixelated.json'
vagrant_ssh "echo 'class custom { include ::pixelated::dispatcher }' > files/puppet/modules/custom/manifests/init.pp"
vagrant_ssh 'leap deploy'
