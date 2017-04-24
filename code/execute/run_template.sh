#!/bin/sh
action=$1; stack=$2; template=$3

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

echo "***"

echo "* $action stack name: $stack"

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
cat $stack.txt >> log.txt
noupdates="$(cat $stack.txt | grep 'No updates')"
rollback="$(cat $stack.txt | grep 'ROLLBACK_COMPLETE state and can not be updated')"
err="$(cat $stack.txt | grep 'error')"
if [ "$noupdates" != "" ]; then exit 1; fi
cat $stack.txt 
if [ "$rollback" != "" ]; then exit 2; fi
if [ "$err" != "" ]; then exit 3; fi
exit 0