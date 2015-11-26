#!/bin/bash

/usr/lib/nagios/plugins/check_procs -a '/usr/bin/pixelated-dispatcher manager' -c 1:1
exit $?
