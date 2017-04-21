#!/bin/sh
action=$1
stack=$2
template=$3
cfwait=$4

if [ "$stack" == "" ] 
then
	echo "stack name is required."
	exit
fi

echo "$action stack: $stack"

aws cloudformation describe-stacks --stack-name $stack > $stack1.txt  2>&1		
exists=$(./execute/get_value.sh $stack1.txt "StackId")

if [ "$exists" != "" ] && [ "$action" == "create" ]
then
	echo $stack "exists. Cannot create."
	exit
fi

if [ "$exists" == "" ] && [ "$action" != "create" ]
then
	echo $stack " does not exist. Cannot $action."
	exit
fi	


if [ "$action" == "delete" ] 
then
	aws cloudformation delete-stack --stack-name $stack > $stack.txt  2>&1
else

	if [ "$template" == "" ] 
	then
		echo "stack template is required in parameter template in form file://filename"
		exit
	fi
	aws cloudformation $action-stack --stack-name $stack --template-body $template $capabilities $parameters > $stack.txt 2>&1

fi

cat $stack.txt
err="$(cat $stack.txt | grep 'error')"
rm $stack.txt

if [ "$err" == "" ]
then 
	if [ "$cfwait" == "true" ]
	then
		echo "waiting for stack to $action..."
		aws cloudformation wait stack-$action-complete --stack-name $stack
		echo "network $cfaction complete"
	fi
fi
