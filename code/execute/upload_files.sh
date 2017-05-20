#!/bin/sh
#note: If you want to see how the lambda.zip file was craeted, read this:
#http://websitenotebook.blogspot.com/2017/05/creating-paramiko-and-cryptography.html
keyname=$1

if [ -f ./resources/firebox-lambda/fireboxconfig.zip ]; then rm ./resources/firebox-lambda/fireboxconfig.zip; fi

#make a copy of lambda.zip
cp lambda.zip fireboxconfig.zip

#add py file to fireboxconfig.zip
zip -g fireboxconfig.zip fireboxconig.py

#upload the lambda code to the bucket used by lambda cloudformation file
bucket=$(./execute/get_output_value.sh "firebox-cli-s3bucket" "FireboxPrivateBucket")
aws s3 cp resources/firebox-lambda/fireboxconfig.zip s3://$bucket/fireboxconfig.zip --sse AES256 > upload.txt  2>&1  

error=$(cat upload.txt | grep "error\|Unknown")
if [ "$error" != "" ]; then
    echo "Error uploading fireboxconfig.zip: $error"; exit
fi

#upload EC2 Key Pair
aws s3 cp $keyname.pem s3://$bucket/$keyname.pem --sse AES256 > upload.txt  2>&1  

error=$(cat upload.txt | grep "error\|Unknown\|path")
if [ "$error" != "" ]; then
    echo "Error uploading $keyname.pem: $error"; exit
fi