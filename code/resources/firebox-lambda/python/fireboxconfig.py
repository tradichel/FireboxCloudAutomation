from __future__ import print_function
import boto3
import os
import subprocess

def configure_firebox(event, context):
    
    #####
    # Get SSH Key for Firebox over S3 Endpoint
    #####
    s3=boto3.client('s3')
    
    print("environment variable: " + os.environ['Bucket'])

    bucket="firebox-private-cli-bucket-876833387914-us-west-2"
    key="firebox-cli-ec2-key.pem"

    response = s3.get_object(Bucket=bucket, Key=key) 
    keycontent = response['Body'].read().decode('utf-8')
    print("key:")
    print(keycontent)
    
    #save key to lambda to use for CLI connection

    #####
    # TODO: Connect to Firebox via CLI
    ###

    #####
    # Turn on WatchGuard feedback data used for troubleshooting 
    # and security report https://www.watchguard.com/wgrd-resource-center/security-report
    # This data helps us report on security trends.
    # More importantly, it allows us to find security threats faster and provide
    # better security to all our customers world wide.
    # http://www.watchguard.com/help/docs/fireware/11/en-US/Content/en-US/basicadmin/global_setting_define_c.html?cshid=1020
    #####   
  
    #command = ["global-setting","report-data","enable"]
    #print(subprocess.check_output(command, stderr=subprocess.STDOUT))


    #random testing...if we got here our code didn't croak
    what_to_print = "testing..."
    how_many_times = 3

    # make sure what_to_print and how_many_times values exist
    if what_to_print and how_many_times > 0:
        for i in range(0, how_many_times):
            # formatted string literals are new in Python 3.6
            print(f"what_to_print: {what_to_print}.")
    
    return "success"