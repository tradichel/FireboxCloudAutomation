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
action=$1;

#change these to match your environment, if different
keyname="firebox-cloud-ec2-key"
adminuser="tradichel"

#this IP range will let any IP access your S3 bucket - change if you like
adminips="0.0.0.0/0" 

#adminips="50.198.7.166/32"
#adminips="208.145.43.0/24"

rm *.txt

echo "***"
echo "* Begin: $dt" 
echo "* Your CLI is configured to create resources in this region: " $region

if [ "$action" == "" ] 
then

    echo "****"
    echo "* Oops...Looks like you are missing a command line argument."
    echo "* action: [create, delete, update]"
    echo "* Follow the instruction in the readme"
    echo "****"
    exit

else

    echo "Executing: $action"
    . ./execute/action.sh $action $keyname $adminuser $adminips
    #upload key into bucket and then can create a lambda function to configure firebox

fi
dt=$(date)
echo "Done: $dt"