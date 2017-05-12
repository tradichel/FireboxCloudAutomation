#!/bin/sh
stack=$1

if [ "stack" == "firebox" ]; then
    $keyname=$2
    echo "--parameters ParameterKey=ParamKeyName,ParameterValue=$keyname"
    return
fi

if [ "$stack" == "s3bucketpolicy" ]; then
    $admincidr=$2;adminuser=$3
    echo "--parameters ParameterKey=ParamAdminCidr,ParameterValue=$admincidr ParameterKey=ParamAdminUser,ParameterValue=$adminuser"
    return
fi
    