#!/bin/bash
# Addresses CVE-2015-7547
# This checks if the newest glibc is installed

operatingsystem=$(facter operatingsystem)

if [ "$operatingsystem" == "Ubuntu" ]
then
	lsbdistrelease=$(facter lsbdistrelease)
	libcversion=$(dpkg -s libc6 | grep Version | awk '{ print $2 }')
	if [ "$libcversion" == "2.19-0ubuntu6.7" ] && [ "$lsbdistrelease" == "14.04" ]
	then
		exitCode=0
	fi 
	if [ "$libcversion" == "2.15-0ubuntu10.13" ] && [ "$lsbdistrelease" == "12.04" ]
	then
		exitCode=0
	fi 
fi
if [ "$operatingsystem" == "CentOS" ]
then
	operatingsystemmajrelease=$(facter operatingsystemrelease | cut -c 1)
	hardwaremodel=$(facter hardwaremodel)
	libcversion=$(rpm -q glibc | grep $hardwaremodel)
	if [ "$libcversion" == "glibc-2.12-1.166.el6_7.7.$hardwaremodel" ] && [ "$operatingsystemmajrelease" == "6" ]
	then
		exitCode=0
	fi 
	if [ "$libcversion" == "glibc-2.17-106.el7_2.4.$hardwaremodel" ] && [ "$operatingsystemmajrelease" == "7" ]
	then
		exitCode=0
	fi 
fi
if [ "$operatingsystem" == "SLES" ]
then
	libcversion=$(rpm -q glibc)	
	if [ "$libcversion" == "glibc-2.11.3-17.95.2" ]
	then
		exitCode=0
	fi
fi

if [ "$exitCode" == "0" ]
then
	echo '0 Glibc_DNS - Patched against CVE-2015-7547'
else
	echo '2 Glibc_DNS - Vulnerable to CVE-2015-7547 - Update now!'
fi
