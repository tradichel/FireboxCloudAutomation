#!/bin/sh
action=$1; keyname=$2; adminuser=$3; admincidr=$4

#stack = file name less the .yaml extension
function modify_stack(){
    local action=$1;local config=$2;
    declare -a stackarray=("${!3}")
    for (( i = 0 ; i < ${#stackarray[@]} ; i++ ))
    do
        echo "modify_stack: " $action $config "${stackarray[$i]}"
        run_template "$action" "$config" "${stackarray[$i]}"
    done
}

function run_template () {
    local action=$1; local config=$2; local stack=$3;local parameters=""

    template="file://resources/firebox-$config/$stack.yaml"
    stackname="firebox-$config-$stack"
    aws cloudformation describe-stacks --stack-name $stackname > $stackname.txt  2>&1  
    exists=$(./execute/get_value.sh $stackname.txt "StackId")
    vaction=$(validate_action "$exists" "$action" "$stackname" "$config")
    
    if [ "$vaction" == "noupdates" ]; then echo "$vaction"; return; fi

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

    ./execute/run_template.sh "$vaction" "$stackname" "$template" "$parameters"
   
   if [ -f $stackname.txt ]; then

        noupdates="$(cat $stackname.txt | grep 'No updates')"
        if [ "$noupdates" != "" ]; then echo "noupdates to stack"; return; fi

        err="$(cat $stackname.txt | grep 'error\|failed')"
        if [ "$err" != "" ]; then echo "$err"; exit; fi
        
        wait_to_complete $action $config $stackname

    else
        echo "stack output file does not exist: $stackname.txt"
    fi
}

function validate_action(){
    local exists=$1;local action=$2;local stackname=$3;local config=$4;

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
    local stackname=$1;local action=$2

    aws cloudformation describe-stacks --stack-name $stackname > $stackname.txt  2>&1  
    exists=$(./execute/get_value.sh $stackname.txt "StackId")

    if [ "$exists" != "" ]
    then
        aws cloudformation describe-stacks --stack-name $stackname > $stackname.txt  2>&1  
        status=$(./execute/get_value.sh $stackname.txt "StackStatus")
        echo "$stack status: $status"
        case "$status" in 
            UPDATE_COMPLETE|CREATE_COMPLETE)   
                return
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
    local action=$1; local config=$2; local stack=$3
    
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
        #"lambda"
    )

    modify_stack $action "lambda" stack[@] 
    
    stack=(
        "flowlogsrole" 
        "flowlogs"
    )

    modify_stack $action "flowlogs" stack[@] 

fi


