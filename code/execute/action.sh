#!/bin/sh
action=$1; keyname=$2; adminuser=$3; admincidr=$4

#stack = file name less the .yaml extension
function modify_stack(){
    action=$1;config=$2;
    declare -a stackarray=("${!3}")
    for (( i = 0 ; i < ${#stackarray[@]} ; i++ ))
    do
        echo "modify_stack: " $action $config "${stackarray[$i]}"
        run_template "$action" "$config" "${stackarray[$i]}"
    done
}

function run_template () {
    local action=$1; local config=$2; local stack=$3
    template="file://resources/firebox-$config/$stack.yaml"
    stackname="firebox-$config-$stack"
    aws cloudformation describe-stacks --stack-name $stackname > $stackname.txt  2>&1  
    exists=$(./execute/get_value.sh $stackname.txt "StackId")
    vaction=$(validate_action "$exists" "$action" "$stackname")
    
    if [ "$vaction" == "noupdates" ]; then echo $vaction; return; fi

    ./execute/run_template.sh "$vaction" "$stackname" "$template"
   
   if [ -f $stackname.txt ]; then

        noupdates="$(cat $stackname.txt | grep 'No updates')"
        if [ "$noupdates" != "" ]; then return; fi

        err="$(cat $stackname.txt | grep 'error\|failed')"
        if [ "$err" != "" ]; then echo $err; exit; fi
        
        wait_to_complete $action $config $stackname
    else
        exit
    fi
}

function validate_action(){
    exists=$1;action=$2;stackname=$3

    if [ "$action" == "delete" ]; then
        if [ "$exists" == "" ]; then action="noupdates"; fi
        echo $action
        return
    fi
    
    if [ "$exists" == "" ] && [ "$action" == "update" ]; then
        action="create"
    fi

    if [ "$exists" != "" ]
    then 
        aws cloudformation describe-stacks --stack-name $stackname > $stackname.txt  2>&1  
        status=$(./execute/get_value.sh $stackname.txt "StackStatus")
        case "$status" in 
            ROLLBACK_COMPLETE|ROLLBACK_FAILED|DELETE_FAILED)
            ./execute/run_template.sh "delete" "$stackname"
            wait_to_complete "delete" $config $stackname
            action="create"
            return
            ;;
          *)
            action="update"
            ;;
          *)
        esac
    fi

    echo $action
}

function log_errors(){
    stackname=$1;action=$2

    aws cloudformation describe-stacks --stack-name $stackname > $stackname.txt  2>&1  
    exists=$(./execute/get_value.sh $stackname.txt "StackId")

    if [ "$exists" != "" ]
    then
        aws cloudformation describe-stacks --stack-name $stackname > $stackname.txt  2>&1  
        status=$(./execute/get_value.sh $stackname.txt "StackStatus")
        echo "$stack status: $status"
        case "$status" in 
            UPDATE_COMPLETE|CREATE_COMPLETE)   
                break
                ;;
            *)
                cat $stackname.txt
                aws cloudformation describe-stack-events --stack-name $stackname | grep "ResourceStatusReason"
                echo "* ---- What's the problem? ---"
                echo "* Stack $action failed."
                echo "* See the details above which can also be found in the CloudFormation console"
                echo "* ----------------------------"
                exit
                ;;
          *)
        esac
    fi
}

function wait_to_complete () {

    action=$1; config=$2; stack=$3
    
    ./execute/wait.sh $action $stack  
    
    log_errors $stack $action
}

#---Start of Script---#
#reverse of create on delete
if [ "$action" == "delete" ] 
then

    ./execute/delete_files.sh

    stack=(     
        "flowlogs"
        "flowlogsrole"
    )

    
    modify_stack $action "flowlogs" stack[@] 

    stack=(
        "lambda"
        "kmskey"
    )

    modify_stack $action "lambda" stack[@] 

    stack=(
        "s3bucketpolicy"
        "clirole"
        "s3bucket"
        "clinetwork"
    )

    modify_stack $action "cli" stack[@] 

    stack=(
        "natroute" 
        "elasticip"
        "firebox"
        "securitygroups"
        "subnets"
        "internetgateway"
        "vpc"
    )

    modify_stack $action "nat" stack[@] 

else 

    stack=(
        "vpc" 
        "internetgateway"
        "subnets"
        "securitygroups"
        "firebox"
        "elasticip"
        "natroute"
    )

    modify_stack $action "nat" stack[@] 
    
    stack=(
        "clinetwork"
        "s3bucket"
        "clirole"
        "s3bucketpolicy"
    )

    modify_stack $action "cli" stack[@] 

    ./execute/upload_files.sh $keyname

    stack=(
        "kmskey"
        "lambda"
    )

    modify_stack $action "lambda" stack[@] 
    
    stack=(
        "flowlogsrole" 
        "flowlogs"
    )

    modify_stack $action "flowlogs" stack[@] 

fi


