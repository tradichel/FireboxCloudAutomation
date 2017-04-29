#!/bin/sh
##############################################################
# 
# Automated Firebox Cloud Deployment
#
# Follow instructions in readme: 
# https://github.com/tradichel/FireboxCloudAutomation
#
###############################################################

dt=$(date)
region=$(aws configure get region)
action=$1; config=$2; name=$3
rm *.txt

echo "***"
echo "* Begin: $dt" 
echo "* Your CLI is configured to create resources in this region: " $region
echo "* http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html"

if [ "$action" == "" ] || [ "$config" == "" ] || [ "$name" == "" ]
then

    echo "****"
    echo "* Oops..."
    echo "* Looks like you are missing a command line argument:"
    echo "* - action: create, delete, update"
    echo "* - configuration: nat, test"
    echo "* - name: [anything lowercase, no spaces or special caharacters]"
    echo "* Run the script like this: "
    echo "* ./run.sh create nat fireboxtrial"
    echo "* Then test like this:"
    echo "* ./run.sh create test fireboxtest"
    echo "****"
    exit

else

    echo "Executing..."
    echo "action: $action"
    echo "config: $config"
    echo "name: $name"
    . ./execute/action.sh $action $config $name

fi
dt=$(date)
echo "Done: $dt"