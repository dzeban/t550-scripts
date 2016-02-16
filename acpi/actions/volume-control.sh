#!/bin/bash -u

LOGGER="logger -t $0"
SINK=$(pactl info | awk -F ':' '$1 == "Default Sink" {print $2}')
PAINFO=$(pactl info 2>&1)

$LOGGER "Sink is '$SINK'"
$LOGGER "PAINFO is '$PAINFO'"

case $1 in
	*MUTE*)
		$LOGGER -t $0 "Muting $SINK sink"
		pactl set-sink-mute $SINK toggle		
		;;
	*VOLDN*)
		$LOGGER "Decreasing volume for sink $SINK"
		pactl set-sink-volume $SINK -5%
		;;
	*VOLUP*)
		$LOGGER "Increasing volume for sink $SINK"
		pactl set-sink-volume $SINK +5%
		;;
	*)
		$LOGGER "Unknown event $1"
esac

