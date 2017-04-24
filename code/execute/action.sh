#!/bin/sh
action=$1; config=$2 name=$3

function check_exit_code () { 
    exitcode=$1;stack=$2;
    if [ -f $stack.txt ]; then rm $stack.txt; fi
    if (( $exitcode==3 )); then exit; fi 
    if (( $exitcode==2 )); then delete_rollback_stack $stack; fi
}

function delete_rollback_stack () {
    stack = $1;action="delete"
    ./execute/run_template.sh $action $stack
    exitcode=$?
    check_exit_code $exitcode $stack
    action="create"
    run_template $action $stack $template
}

function run_template () {

    action=$1;stack=$2;template=$3
    aws cloudformation describe-stacks --stack-name $1 > $1.txt  2>&1      
    exists=$(./execute/get_value.sh $1.txt "StackId")

    if [ "$exists" != "" ] && [ "$action" == "create" ]
      then action="update"
    fi

    if [ "$exists" == "" ] && [ "$action" == "update" ] 
        then action="create"
    fi

    if [ "$exists" == "" ] && [ "$action" == "delete" ] 
        then echo "* $stack does not exist. Nothing to delete."
        break
    fi
    
    echo "$action $stack $template" >> log.txt
    echo "$action $stack complete"
    ./execute/run_template.sh $action $stack $template
    exitcode=$?
    check_exit_code $exitcode $stack
    wait_to_complete $exitcode $action $stack
}

function wait_to_complete () {
    exitcode=$1; action=$2; stack=$3
    if (( $exitcode==0 ))
    then 
        ./execute/wait.sh $action $stack 
        check_exit_code $?
        echo $action $3 "complete" >> log.txt
    fi
}

echo "***"
echo "* Deploying the NAT configuration of Firebox as explained here: "
echo "* https://www.watchguard.com/help/docs/fireware/11/en-US/Content/en-US/firebox_cloud/fb_cloud_help_intro.html"
echo "***"

#templates
vpc="file://./resources/firebox-nat/vpc.yaml"
internetgateway="file://./resources/firebox-nat/internetgateway.yaml"
subnets="file://./resources/firebox-nat/subnets.yaml"
securitygroups="file://./resources/firebox-nat/securitygroups.yaml"
firebox="file://resources/firebox-nat/firebox.yaml"
#config="file://resources/firebox-nat/config.xml"

#cloudformation stack names
vpcstack="vpc-$name"
subnetstack="subnets-$name"
sgstack="securitygroups-$name"
igstack="internetgateway-$name"
fireboxstack="firebox-$name"

if [ "$action" != "create" ] && [ "$action" != "delete" ] && [ "$action" != "update" ]
then
    echo "* Nothing was run because action is not 'create', 'update', or 'delete'"
    exit
fi

if [ "$action" == "create" ] || [ "$action" == "update" ]
then

    run_template $action $vpcstack $vpc
    run_template $action $igstack $internetgateway
    run_template $action $subnetstack $subnets
    run_template $action $sgstack $securitygroups
    run_template $action $fireboxstack $firebox

else #reverse on delete

    run_template $action $fireboxstack 
    run_template $action $subnetstack
    run_template $action $sgstack 
    run_template $action $igstack
    run_template $action $vpcstack    
fi

