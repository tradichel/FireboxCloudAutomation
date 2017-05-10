#!/bin/sh
action=$1; stack=$2; template=$3; 
capabilities="--capabilities CAPABILITY_NAMED_IAM"

if [ "$stack" == "" ] 
then
	echo "* Error: Stack name is required."
	exit
fi 

if [ "$action" == "" ]  
then
	echo "* Error: Action is required."
	exit
fi

#There is a better long term way to do this but just for example purposes:
if [ "$stack" == "firebox" ]
then
    parameters="--parameters ParameterKey=ParamKeyName,ParameterValue=$keyname"
else
    if [ "$stack" == "s3bucketpolicy" ]
    then
        parameters="--parameters ParameterKey=ParamAdminCidr,ParameterValue=$admincidr ParameterKey=ParamAdminUser,ParameterValue=$adminuser"
    fi
fi


echo "***RUN TEMPLATE***"
echo "* $action stack name: $stack $capabilities $parameters"

if [ "$action" == "delete" ] 
then
	aws cloudformation delete-stack --stack-name $stack > $stack.txt  2>&1
else
	if [ "$template" == "" ] 
	then
		echo "* Error: Stack template is required in parameter template in form file://filename"
		exit
	fi
	aws cloudformation $action-stack --stack-name $stack --template-body $template $capabilities $parameters > $stack.txt 2>&1
fi
