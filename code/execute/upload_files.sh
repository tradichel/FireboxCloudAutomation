#!/bin/sh
keyname=$1

#TODO: The lambda function does not seem to update if the zip file changes
#Need to change the name of the zip perhaps to get the lambda to update

if [ -f ./resources/firebox-lambda/fireboxconfig.zip ]; then rm ./resources/firebox-lambda/fireboxconfig.zip; fi
if [ -d pyzip ]; then rm -rf pyzip; fi

#make zip folder if it does not exist
mkdir pyzip

#copy python file over to zip folder
cp ./resources/firebox-lambda/python/fireboxconfig.py ./pyzip/fireboxconfig.py

#install dependencies in zip folder 
#requires python 3.x
pip install paramiko -t ./pyzip

#zip up the python code for the lambda function
cd ./pyzip
zip -r ./../resources/firebox-lambda/fireboxconfig.zip ./* --exclude=*__pycache__*
cd ..

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