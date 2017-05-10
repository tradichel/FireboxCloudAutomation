#!/bin/sh
action=$1; keyname=$2; adminuser=$3; admincidr=$4

#don't need this for every stack but keeping code simpler
capabilities="--capabilities CAPABILITY_NAMED_IAM"

#stack = file name less the .yaml extension
function modify_stack(){

    action=$1;config=$2;
    declare -a stackarray=("${!3}")
    for (( i = 0 ; i < ${#stackarray[@]} ; i++ ))
    do
        run_template $action $config "${stackarray[$i]}"
    done
    
}

function run_template () {

    action=$1;config=$2;stack=$3

    parameters=""

    if [ "$stack" == "firebox" ]
    then
        parameters="--parameters ParameterKey=ParamKeyName,ParameterValue=$keyname"
    else
        if [ "$stack" == "s3bucketpolicy" ]
        then
            parameters="--parameters ParameterKey=ParamAdminCidr,ParameterValue=$admincidr ParameterKey=ParamAdminUser,ParameterValue=$adminuser"
        fi
    fi

    template="file://resources/firebox-$config/$stack.yaml"
    stackname="firebox-$config-$stack"
    aws cloudformation describe-stacks --stack-name $stackname > $stackname.txt  2>&1  
    exists=$(./execute/get_value.sh $stackname.txt "StackId")
   
    if [ "$exists" != "" ] && [ "$action" == "create" ] 
    then 
        action="update"
    else
        if [ "$exists" == "" ] && [ "$action" == "update" ] 
            then action="create"
        else
            if [ "$exists" == "" ] && [ "$action" == "delete" ] 
                then echo "* $stack does not exist. Nothing to delete."
                break
            fi
        fi
    fi

    if [ $action = "update" ]
    then 
        aws cloudformation describe-stacks --stack-name $stackname > $stackname.txt  2>&1  
        status=$(./execute/get_value.sh $stackname.txt "StackStatus")
        echo "Status of stack $stackname: $status"
        case "$status" in 
            ROLLBACK_COMPLETE|ROLLBACK_FAILED)
             echo "delete stack: $stackname"
            ./execute/run_template.sh "delete" $stackname "$capabilities"
            wait_to_complete 0 "delete" $config $stackname
            action="create"
            ;;
          *)
        esac
    fi
        
    ./execute/run_template.sh $action $stackname $template "$capabilities" "$parameters"
    exitcode=$?
    check_exit_code $exitcode $config $stackname
    wait_to_complete $exitcode $action $config $stackname
    exitcode=$?
    check_exit_code $exitcode $config $stackname
}

function wait_to_complete () {
    exitcode=$1; action=$2; config=$3; stack=$4
    if (( $exitcode==0 ))
    then 
        ./execute/wait.sh $action $stack  
        #check the status of the stack
        if [ "$action" != "delete" ]
        then
            aws cloudformation describe-stacks --stack-name $stackname > $stackname.txt  2>&1  
            status=$(./execute/get_value.sh $stackname.txt "StackStatus")
            echo $action $config $stack $status >> log.txt
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
    fi
}

function check_exit_code () { 
    exitcode=$1;config=$2;stackname=$3;stack=$4;
    if [ -f $stackname.txt ]; then rm $stackname.txt; fi
    if [ $exitcode -gt 1 ]; then echo "Error: $exitcode"; exit; fi 
}

if [ "$action" == "delete" ] 
then

    #reverse on delete
    stack=(     
        "flowlogs"
        "flowlogsrole"
    )

    modify_stack $action "flowlogs" stack[@] 

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
        "s3bucketpolicy"
    )

    modify_stack $action "cli" stack[@] 

    #zip up the python code for the lambda function
    if [ -f ./resources/firebox-lambda/fireboxconfig.zip ]; then rm ./resources/firebox-lambda/fireboxconfig.zip; fi
    zip ./resources/firebox-lambda/fireboxconfig.zip ./resources/firebox-lambda/python/fireboxconfig.py 

    #upload the lambda code to the bucket used by lambda cloudformation file
    bucket=$(./execute/get_output_value.sh "firebox-cli-s3bucket" "FireboxPrivateBucket")
    aws s3 cp resources/firebox-lambda/fireboxconfig.zip s3://$bucket/fireboxconfig.zip --sse AES256 > upload.txt  2>&1  

    error=$(cat upload.txt | grep "error\|Unknown")
 
    if [ "$error" != "" ]
    then
        echo "Error uploading fireboxconfig.zip: $error"
        exit
    fi

    #upload EC2 Key Pair
    aws s3 cp $kename.pem s3://$bucket/$keyname.pem --sse AES256 > upload.txt  2>&1  

    error=$(cat upload.txt | grep "error\|Unknown")
 
    if [ "$error" != "" ]
    then
        echo "Error uploading $kename.pem: $error"
        exit
    fi

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


