#!/bin/sh
#define variables
network="file://./resources/firebox-nat/network.yaml"
firebox="file://resources/firebox-nat/firebox.yaml"
config="file://resources/firebox-nat/config.xml"

#create network stack
stack="network-$name"
cfwait="true"

./execute/run_template.sh $action $stack $network $cfwait
if [ "$err" != "" ]
then
    exit
fi

stack="firebox-$name"
#./execute/run_firebox.sh
#if [ "$err" != "" ]
#then
#   return
#fi

