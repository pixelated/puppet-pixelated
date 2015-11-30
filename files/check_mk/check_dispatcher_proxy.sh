#!/bin/bash

STATUS[0]='OK'
STATUS[1]='Critical'
STATUS[2]='Critical'
CHECKNAME='Dispatcher_Proxy'

MESSAGE=$(/usr/lib/nagios/plugins/check_procs -a '/usr/bin/pixelated-dispatcher proxy' -c 1:1)
SERVICESTATUS=$?
echo "${SERVICESTATUS} ${CHECKNAME} ${MESSAGE}"

