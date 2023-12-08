#!/bin/bash
RECORDTIME=$1
HWDEVICE=`echo "$(arecord -l |grep 'card.*USB' | sed 's/.*card //' | cut -d " " -f 1|cut -c 1),$(arecord -l |grep 'card.*USB' | sed 's/.*device //' | cut -d " " -f 1|cut -c 1)"`
if [ -z "$RECORDTIME" ]
then
	echo "Recording with default 10 seconds\n"
	echo "USAGE: upstream-sound.bash <time in seconds>"
	#/usr/bin/arecord --duration=10 --channels=2 --format=S16_LE --rate 44100 --device=hw:$HWDEVICE /home/pi/upstream/sound/`(date +%s)`.wav
	/usr/bin/arecord --duration=10 --format=cd --file-type=wav --device=hw:$HWDEVICE /home/pi/upstream/sound/$HOSTNAME-`(date +%s)`.wav


	echo "Recorded sound @ $(date)"
else
	/usr/bin/arecord --duration=$RECORDTIME --channels=2 --format=cd --rate 44100 --device=hw:$HWDEVICE /home/pi/upstream/sound/$HOSTNAME-`(date +%s)`.wav
	echo "Recorded sound @ $(date) for $RECORDTIME seconds"
fi
