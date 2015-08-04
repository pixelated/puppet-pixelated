#!/bin/bash
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

# This is a simple install script that you can execute on a plain debian image, wait for some time and end up with a running leap installation

export LC_ALL="en_US.UTF-8"
GIT_RAW_BASE_URL="https://raw.githubusercontent.com/pixelated/pixelated-platform/master"
PIXELATED_INSTALLER_PATH="/usr/local/pixelated-installer"
LOG_PATH="$PIXELATED_INSTALLER_PATH/logs"

INSTALL_LEAP="$PIXELATED_INSTALLER_PATH/install-leap.sh"
CONFIGURE_LEAP="$PIXELATED_INSTALLER_PATH/configure-leap.sh"
INSTALL_DISPATCHER="$PIXELATED_INSTALLER_PATH/install-dispatcher.sh"

set -e

# Fetch all the scripts we need for the setup
mkdir -p "$PIXELATED_INSTALLER_PATH"
mkdir -p "$LOG_PATH"
curl "$GIT_RAW_BASE_URL/buildscripts/install-leap.sh" > "$INSTALL_LEAP"
curl "$GIT_RAW_BASE_URL/buildscripts/configure-leap.sh" > "$CONFIGURE_LEAP"
curl "$GIT_RAW_BASE_URL/buildscripts/install-dispatcher.sh" > "$INSTALL_DISPATCHER"
chmod a+x $PIXELATED_INSTALLER_PATH/*.sh

perl -i -pe 's/^frontend=.*$/frontend=text/' /etc/apt/listchanges.conf

# update debian packages to latest version
apt-get update
DEBIAN_FRONTEND=noninteractive aptitude -y safe-upgrade

apt-get -y install ruby1.9.1 ruby1.9.3

# install the basic dependencies that are necessary to bootstrap leap
$INSTALL_LEAP 2>&1 | tee $LOG_PATH/install-leap.log

# clean up resolv.conf
perl -i -pe 's/^(domain|search).*$//' /etc/resolv.conf

# now lets configure our leap provider
$CONFIGURE_LEAP 2>&1 | tee $LOG_PATH/configure-leap.log

echo "Reboot into new kernel version so that docker support is enabled"
reboot
