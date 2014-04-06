#!/bin/bash
STATUS_OK=0
STATUS_WARNING=1
STATUS_CRITICAL=2
STATUS_TEXT_OK=OK
STATUS_TEXT_WARNING=WARNING
STATUS_TEXT_CRITICAL=CRITICAL
status=3

check_name="security_updates"

if [ "$(facter operatingsystem)" == "Ubuntu" ]
then
	MISSING_UPDATES=$(/usr/lib/update-notifier/apt-check 2>&1 | cut -f2 -d";")
fi

if [ "$(facter operatingsystem)" == "CentOS" ]
then
	MISSING_UPDATES=$(yum list-security -q | cut -f3 -d" ")
fi

if [ "$(facter operatingsystem)" == "SLES" ]
then
	MISSING_UPDATES=$(zypper -q lp --issue=security | tail -n+4 | cut -f1 -d"|" | sed ':a;N;$!ba;s/\n/ /g')
fi

if [ "$MISSING_UPDATES" == "" ]; then
	status=$STATUS_OK
	status_text=$STATUS_TEXT_OK
	message="no security updates pending"
else
	status=$STATUS_CRITICAL
	status_text=$STATUS_TEXT_CRITICAL
	message="missing: $MISSING_UPDATES"
fi

echo "$status $check_name - $status_text - $message"