#!/bin/sh
bucket=$(./execute/get_output_value.sh "firebox-cli-s3bucket" "FireboxPrivateBucket")

if [ "$bucket" == "" ]
then
    echo "bucket name not found"
    exit
fi

echo "delete files from $bucket"
aws s3 rm --recursive s3://$bucket > delfiles.txt  2>&1
error=$(cat delfiles.txt | grep "error\|Unknown\|path")
if [ "$error" != "" ]
then
    echo "Error deleting files from bucket: $error"
    exit
fi
