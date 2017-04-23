#!/bin/bash

#This bash script gathers the IPs of each machine on the local network with eth0.
#It proceeds to store potentially exploitable targets in individual target files.

FOLDER=/tmp/.attack-files
SERVER=192.168.50.254
ADAPTER=192.168.50.1
LOCAL=`hostname -I`
TARGNUM=0
COUNT=0
QUIET=0

if [ "$1" == "-q" ]; then
	QUIET=1	
fi

if [ ! -d $FOLDER ]; then
	mkdir $FOLDER
fi

arp-scan -interface=eth0 --localnet | grep 192.168 | cut -f1 > $FOLDER/ip_list.txt

while read line; do
	COUNT=$(($COUNT + 1))
	PROSPECT=`cat $FOLDER/ip_list.txt | cut -d$'\n' -f$COUNT`
	if [ "$PROSPECT" == "$SERVER" ]; then
		if [ $QUIET -eq 0 ]; then
			echo Candidate \#$COUNT is the server \($SERVER\), skipping...
		fi
	elif [ "$PROSPECT" == "$ADAPTER" ]; then
		if [ $QUIET -eq 0 ]; then
			echo Candidate \#$COUNT is the network adapter \($ADAPTER\), skipping...
		fi
	elif [ "$PROSPECT" == "$LOCAL" ]; then
		if [ $QUIET -eq 0 ]; then
			echo Candidate \#$COUNT is this machine \($LOCAL\), skipping...
		fi
	else
		if [ $QUIET -eq 0 ]; then
			echo Candidate \#$COUNT is a confirmed target \($PROSPECT\)
		fi
		TARGNUM=$(($TARGNUM + 1))
		echo $PROSPECT > $FOLDER/target$TARGNUM.txt
	fi		
done < $FOLDER/ip_list.txt


