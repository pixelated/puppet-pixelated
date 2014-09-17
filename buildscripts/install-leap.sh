#!/bin/sh

echo "==============================================="
echo "installing leap"
echo "==============================================="
#gem install leap_cli
cd /tmp
git clone -b develop https://leap.se/git/leap_cli.git
cd leap_cli
rake build
rake install
mkdir /home/leap
cd /home/leap
git clone -b develop https://leap.se/git/leap_platform.git
cd /home/leap/leap_platform
git submodule sync
git submodule update --init
