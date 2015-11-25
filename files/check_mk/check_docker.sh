#!/bin/bash

WARN=1
CRIT=5

STATUS[0]='OK'
STATUS[1]='Critical'
STATUS[2]='Critical'
CHECKNAME='Docker'

service docker status >/dev/null
SERVICESTATUS=$?
CONTAINERCOUNT=$(docker ps | tail -n+2 |  wc -l)

echo "${SERVICESTATUS} ${CHECKNAME} containers=${CONTAINERCOUNT} ${STATUS[$SERVICESTATUS]}: ${CONTAINERCOUNT} Containers running"
