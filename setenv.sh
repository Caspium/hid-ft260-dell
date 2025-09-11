#!/bin/bash
# SPDX-License-Identifier: MIT
#
# Copyright (C) 2024 Michael Zaidman <michael.zaidman@gmail.com>
#
# The script sets the environment variables pointing to the sysfs attribute
# directories of all active ft260 devices.
#
# Usage:
#   . ./setenv.sh

# Example with Hub, Fan, and Air Temperature cards:
: '
$ . setenv.sh
sysfs_i2c_15
sysfs_ttyFT0
sysfs_ttyFT1
sysfs_fan_ttyFT1
sysfs_i2c_16
sysfs_fan_i2c_16
sysfs_i2c_17

# Access hub and air temp by I2C bus number
$ echo $sysfs_i2c_15   # Hub I2C
/sys/bus/hid/drivers/ft260/0003:413C:D100.0001

$ echo $sysfs_i2c_17   # Air Temperature Card I2C  
/sys/bus/hid/drivers/ft260/0003:413C:D104.0015

# Access fan cards by device type (supports multiple fan cards)
$ echo $sysfs_fan_i2c_16   # Fan Card I2C
/sys/bus/hid/drivers/ft260/0003:413C:D101.0017
'

# Hub
PVID='*413C:D100*'
SYSFS_FT260=/sys/bus/hid/drivers/ft260/

a=$(find $SYSFS_FT260 -name $PVID | xargs -I % sh -c 'find %/ -maxdepth 1 -name i2c-* -o -name tty*')
for w in $a; do
	b=$(basename "$w")
	[ "$b" = "tty" ] && e=$(find $w/ -name ttyF*) && b=$(basename "$e")
	c=$(dirname "$w")
	d=sysfs_${b/-/_}
	echo $d
	declare $d=$c
done

# Fan Cards (supports multiple cards)
PVID='*413C:D101*'
SYSFS_FT260=/sys/bus/hid/drivers/ft260/

a=$(find $SYSFS_FT260 -name $PVID | xargs -I % sh -c 'find %/ -maxdepth 1 -name i2c-* -o -name tty*')
for w in $a; do
	b=$(basename "$w")
	[ "$b" = "tty" ] && e=$(find $w/ -name ttyF*) && b=$(basename "$e")
	c=$(dirname "$w")
	
	# Create standard variable name
	d=sysfs_${b/-/_}
	echo $d
	declare $d=$c
	
	# Also create fan-specific variable for easier identification
	if [[ "$b" =~ ^i2c ]]; then
		fan_var="sysfs_fan_${b/-/_}"
		echo $fan_var
		declare $fan_var=$c
	elif [[ "$b" =~ ^ttyFT ]]; then
		fan_var="sysfs_fan_${b}"
		echo $fan_var
		declare $fan_var=$c
	fi
done

# Air Temperature Card
PVID='*413C:D104*'
SYSFS_FT260=/sys/bus/hid/drivers/ft260/

a=$(find $SYSFS_FT260 -name $PVID | xargs -I % sh -c 'find %/ -maxdepth 1 -name i2c-* -o -name tty*')
for w in $a; do
	b=$(basename "$w")
	[ "$b" = "tty" ] && e=$(find $w/ -name ttyF*) && b=$(basename "$e")
	c=$(dirname "$w")
	d=sysfs_${b/-/_}
	echo $d
	declare $d=$c
done