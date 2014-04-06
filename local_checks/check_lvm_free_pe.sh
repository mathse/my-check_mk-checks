#!/bin/bash
STATUS_OK=0
STATUS_WARNING=1
STATUS_CRITICAL=2
STATUS_TEXT_OK=OK
STATUS_TEXT_WARNING=WARNING
STATUS_TEXT_CRITICAL=CRITICAL

check_name="lvm_free_pe"

PESIZE=$(vgdisplay -c | cut -f13 -d":")
PEFREE=$(vgdisplay -c | cut -f16 -d":")

FREESIZE=$(expr $PESIZE \* $PEFREE / 1024)

message="unallocated free PE's for LVM: $FREESIZE MB"

status=$STATUS_OK
status_text=$STATUS_TEXT_OK


echo "$status $check_name - $status_text - $message"