#!/bin/sh
##############################################################
# 
# Automated Firebox Cloud Deployment
#
# Before running this script make sure you have set up the
# AWS CLI and verified it is working:
# http://docs.aws.amazon.com/cli/latest/userguide/installing.html
#
# Specifiy the following arguments when you run this script:
#
# Argument #1 - action: create, delete
# Argument #2 - config: nat, ...
#
# For more information see https://www.secplicity.org 
# (specific blog post coming soon) or firebox cloud docs:
#
# https://www.watchguard.com/help/docs/fireware/11/en-US/Content/en-US/firebox_cloud/fb_cloud_help_intro.html
#
# Note this example uses command line scripts but it would be 
# much better to deploy this through an automated build system
# and secure, repeatable build process (article coming soon)
#
###############################################################

echo "----BEGIN----"
date
region=$(aws configure get region)
echo "* Your CLI is configured to create resources in this region: " $region
echo "* http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html"

#mode is the only parameter required on the command line
#./run.sh with no parameter will explain.
action=$1
config=$2
name=$3

#use default name if none provided
if [ "$name" == "" ]
then
    name = "fireboxtrial"
fi

if [ "$action" == "" ] || [ "$config" == "" ] || [ "$name" == "" ]
then
    echo "*"
    echo "* Oops. Looks like you are missing a command line argument:"
    echo "* action: create, delete"
    echo "* configuration: nat"
    echo "* name: [anything lowercase, no spaces or special caharacters]"
    echo ""
    echo "* run the script like this: ./run.sh create nat fireboxtrial"
    exit

else
    echo "action: $action"
    echo "config: $config"
    echo "name: $name"
    
    if [ "$action" == "create" ] || [ "$action" == "delete" ] || [ "$action" == "update" ]
    then
        . ./execute/_$action.sh $action $config $name
    else
        echo "* Nothing was run because action is not 'create', 'update', or 'delete'"
    fi

    echo "done" > log.txt
    rm *.txt
fi

echo "----END----"
date