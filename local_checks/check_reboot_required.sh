#!/bin/bash
STATUS_OK=0
STATUS_WARNING=1
STATUS_CRITICAL=2
STATUS_TEXT_OK=OK
STATUS_TEXT_WARNING=WARNING
STATUS_TEXT_CRITICAL=CRITICAL
MESSAGE_OK="no reboot required"
MESSAGE_CRITICAL="reboot required due to kernel update"
status=3

check_name="reboot_required"

if [ "$(facter operatingsystem)" == "Ubuntu" ]
then
	if test -f /var/run/reboot-required
	then
		status=$STATUS_CRITICAL
		status_text=$STATUS_TEXT_CRITICAL
		message=$MESSAGE_CRITICAL
	else
		status=$STATUS_OK
		status_text=$STATUS_TEXT_OK
		message=$MESSAGE_OK		
	fi
fi

if [ "$(facter operatingsystem)" == "CentOS" ]
then
	LAST_KERNEL=$(rpm -q --last kernel | perl -pe 's/^kernel-(\S+).*/$1/' | head -1)
	CURRENT_KERNEL=$(uname -r)
	if test $LAST_KERNEL = $CURRENT_KERNEL; then
		status=$STATUS_OK
		status_text=$STATUS_TEXT_OK
		message=$MESSAGE_OK
	else
		status=$STATUS_CRITICAL
		status_text=$STATUS_TEXT_CRITICAL
		message=$MESSAGE_CRITICAL
	fi
fi


echo "$status $check_name - $status_text - $message"
