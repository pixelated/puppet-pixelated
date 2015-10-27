#!/bin/sh

# This script should run regularly to update the docker image
# and remove all outdated user-agents. All users will be logged out
# and will use the latest docker image on the next login.

DOCKER=/usr/bin/docker
IMAGE='pixelated/pixelated-user-agent:latest'
COMMAND='/usr/bin/pixelated-user-agent'

$DOCKER pull $IMAGE

#kill running user-agents
KILLLIST=$($DOCKER ps --no-trunc | grep $COMMAND | cut -d' ' -f 1)
if [ -n "$KILLLIST" ]; then
    $DOCKER kill $KILLLIST
  fi

  #remove all user-agent images
  RMLIST=$($DOCKER ps -a --no-trunc | grep $COMMAND | cut -d' ' -f 1)
  if [ -n "$RMLIST" ]; then
      $DOCKER rm  $RMLIST
    fi

