#!/bin/bash

STATUS[0]='OK'
STATUS[1]='Critical'
STATUS[2]='Critical'
CHECKNAME='Dispatcher_Manager'

MESSAGE=$(/usr/lib/nagios/plugins/check_procs -a '/usr/bin/pixelated-dispatcher manager' -c 1:1)
SERVICESTATUS=$?
echo "${SERVICESTATUS} ${CHECKNAME} running=1 ${MESSAGE}"

