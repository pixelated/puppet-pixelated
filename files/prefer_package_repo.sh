#!/bin/bash

# Makes sure that all packages that are available from both LEAP and
# Pixelated debian repos are instaled from Pixelated
# Background is that under certain circumstances Pixelated providers end
# up with some of these packages installed from the LEAP debian repo, and
# even we pin all Pixelated packages with '1000' in `/etc/apt/preferences.d/pixelated`
# packages will not downgraded to the Pixelated versions if they are lower than
# the LEAP ones.
# see https://github.com/pixelated/project-issues/issues/415 for more details

# Usage:
#
# Run this script with 'check' as parameter to check if there are
# packages installed from a different repo. In this case, the script will
# exit with an exit code of 1.
#
# Without any parameter it will install all available packages from the
# Pixleated repo.

set -e
set -o pipefail

options="$*"

# For now, default to pixelated as preferred repo
# Could get set via a command line option later
preferred_repo='pixelated'
preferred_repo_url='packages.pixelated-project.org'

get_installed_packages () {
  packages="$(aptitude search "?installed?origin(${preferred_repo})" -F '%p' | tr '\n' ' ' | sed 's/  */ /g' )"
  echo "${packages}"
}

get_installed_packages_from_other_repo () {
  packages="$(get_installed_packages)"

  installed=()
  for deb in $packages
  do
    url=$(apt-cache policy "$deb" | awk '/\*\*\*/{getline; print}' | grep -oP 'http.*? ')
    if [[ ! "$url" =~ $preferred_repo_url ]]
    then
      installed+=(${deb})
    fi
  done
  echo "${installed[@]}"
}

install_packages_from_preferred_repo () {
  packages="$*"
  echo "Installing these packages from ${preferred_repo_url}: $packages"

  debs=()
  # Use "-y --force-yes" to allow downgrading packages with lower versions
  for deb in $packages
  do
    version=$(apt-cache policy "$deb" | grep -B1 "$preferred_repo_url" | head -1 | sed 's/     //g' | cut -d' ' -f1)
    debs+=("${deb}=${version}")
  done
  cmd="apt-get -y --force-yes install ${debs[*]}"
  echo "Using this command to install the packages from ${preferred_repo_url}: ${cmd}"
  $cmd
}

installed_packages_from_other_repo=$(get_installed_packages_from_other_repo)
echo "Found these packages installed from a different repo: ${installed_packages_from_other_repo}"
echo


if [ -n "$installed_packages_from_other_repo" ]
then
  [[ "$options" == "check" ]] && exit 1
  install_packages_from_preferred_repo "$installed_packages_from_other_repo"
else
  echo "Nothing to install - all packages are installed from ${preferred_repo}."
fi
