#!/bin/bash
# Written for Upstream to run get the time of the sunset
# then parse it into %H:%M and create and run the at scheduling
# command 30 minutes before sunrise.
#
# Written by: Je'aime Powell
# Contact: jhpowell@tacc.utexas.edu
# Date: 1/19/21
# Revision 1

# Check things in the at queue using atq
# Remove things from the queue with atrm <atq_job_number>

# This variable can be altered to use any time wanted
SUNSET_TIME=`grep $(date +"%m/%d/%Y") /home/pi/upstream/sunrise-sunset-times.txt |awk '{print $4,$5,$1}'`
if [[ $SUNSET_TIME == *"AM"* ]]; then
	SUNSET_TIME=`grep $(date --date="tomorrow" +"%m/%d/%Y") /home/pi/upstream/sunrise-sunset-times.txt |awk '{print $4,$5,$1}'`
fi
##Debug - remove comment to run immediately
#SUNSET_TIME="now"

# Time before sunrise to run the command
TIME_BEFORE="- 30 minute"

# Stdin variable. Remember to enclose in quotes " " 
COMMAND=$1

#checks if a stdin command line arguement was given and outputs error if it is not
if [ -z "$1" ]; then
    echo -e "Invalid input, You need to add your command that you want to run at sunset!"
    echo -e "Example: at-sunset.bash \"/path/command [options]\" "
    exit
fi

# Actual command to be run against echo and outputs to system mail /var/spool/mail
echo $COMMAND|at -m $SUNSET_TIME $TIME_BEFORE
##Debug
#echo $COMMAND|at -m now


