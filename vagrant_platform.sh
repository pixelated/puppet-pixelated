#!/bin/bash
#
# Issues:
# - homebrew version of git does not work nicely with submodules

hash vagrant 2>/dev/null || { echo >&2 "Vagrant is not installed.  Aborting."; exit 1; }

if [ -d ./leap_platform ]
then
  cd leap_platform
  /usr/bin/git pull
else
  /usr/bin/git clone https://leap.se/git/leap_platform.git
  cd leap_platform
fi

cd tests/example-provider
vagrant up pixelated --no-provision  || vagrant reload
vagrant provision
