#!/bin/sh
keyname=$1

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
aws s3 cp $keyname.pem s3://$bucket/$keyname.pem --sse AES256 > upload.txt  2>&1  

error=$(cat upload.txt | grep "error\|Unknown\|path")

if [ "$error" != "" ]
then
    echo "Error uploading $keyname.pem: $error"
    exit
fi