#!/bin/sh
stack="firebox-$name"
cfwait="true"
#./execute/run_firebox.sh
#if [ "$err" != "" ]
#then
#   return
#fi

#create network stack
stack="network-$name"
cfwait="true"
./execute/run_template.sh $action $stack $network $cfwait
if [ "$err" != "" ]
then
    exit
fi



