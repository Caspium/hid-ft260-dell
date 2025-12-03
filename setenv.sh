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
Hub:
  sysfs_i2c_15
  sysfs_ttyFT0
Fan:
  sysfs_i2c_16
  sysfs_ttyFT1
Air Temperature:
  sysfs_i2c_17

# Access devices by I2C bus number
$ echo $sysfs_i2c_15   # Hub I2C
/sys/bus/hid/drivers/ft260/0003:413C:D100.0001

$ echo $sysfs_i2c_16   # Fan Card I2C
/sys/bus/hid/drivers/ft260/0003:413C:D101.0017

$ echo $sysfs_i2c_17   # Air Temperature Card I2C  
/sys/bus/hid/drivers/ft260/0003:413C:D104.0015
'

# Hub Cards
PVID='*413C:D100*'
SYSFS_FT260=/sys/bus/hid/drivers/ft260/

a=$(find $SYSFS_FT260 -name $PVID | xargs -I % sh -c 'find %/ -maxdepth 1 -name i2c-* -o -name tty*')
if [ -n "$a" ]; then
	echo "Hub:"
	for w in $a; do
		b=$(basename "$w")
		[ "$b" = "tty" ] && e=$(find $w/ -name ttyF*) && b=$(basename "$e")
		c=$(dirname "$w")
		d=sysfs_${b/-/_}
		echo "  $d"
		declare $d=$c
	done
fi

# Fan Cards
PVID='*413C:D101*'
SYSFS_FT260=/sys/bus/hid/drivers/ft260/

a=$(find $SYSFS_FT260 -name $PVID | xargs -I % sh -c 'find %/ -maxdepth 1 -name i2c-* -o -name tty*')
if [ -n "$a" ]; then
	echo "Fan:"
	for w in $a; do
		b=$(basename "$w")
		[ "$b" = "tty" ] && e=$(find $w/ -name ttyF*) && b=$(basename "$e")
		c=$(dirname "$w")
		d=sysfs_${b/-/_}
		echo "  $d"
		declare $d=$c
	done
fi

# Air Temperature Cards
PVID='*413C:D104*'
SYSFS_FT260=/sys/bus/hid/drivers/ft260/

a=$(find $SYSFS_FT260 -name $PVID | xargs -I % sh -c 'find %/ -maxdepth 1 -name i2c-* -o -name tty*')
if [ -n "$a" ]; then
	echo "Air Temperature:"
	for w in $a; do
		b=$(basename "$w")
		[ "$b" = "tty" ] && e=$(find $w/ -name ttyF*) && b=$(basename "$e")
		c=$(dirname "$w")
		d=sysfs_${b/-/_}
		echo "  $d"
		declare $d=$c
	done
fi