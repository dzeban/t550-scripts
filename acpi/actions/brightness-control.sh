#!/bin/bash -eu

LOGGER="logger -t $0"
export DISPLAY=:0

case $1 in
	*BRTUP*)
		$LOGGER -t $0 "Incresing brightness"
		# SELINUX IS BLOCKING THIS
		/bin/xbacklight -inc 5
		;;
	*BRTDN*)
		$LOGGER "Decreasing brightness"
		# SELINUX IS BLOCKING THIS
		/bin/xbacklight -dec 5
		;;
	*)
		$LOGGER "Unknown event $1"
esac

