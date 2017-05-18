from __future__ import print_function
import boto3
import os
import subprocess

def configure_firebox(event, context):
    
    #####
    # Get SSH Key for Firebox over S3 Endpoint
    #####
    s3=boto3.client('s3')
    bucket=os.environ['Bucket']
    fireboxip=os.environ['FireboxIp']
    key="firebox-cli-ec2-key.pem"

    #####
    #save key to lambda to use for CLI connection
    #####
    s3.download_file(bucket, key, "/tmp/fb.pem")

    #####
    # Change permissions on the key file (more restrictive)
    ###
    command = ["chmod","700","/tmp/fb.pem"]
    result=subprocess.check_output(command, stderr=subprocess.STDOUT)
    result=result.decode('ascii')
    if (len(result)>0):
        print(result)
    
    #####
    # Connect to Firebox via CLI
    ###
    command = ["ssh","-i","/tmp/fb.pem",fireboxip]
    result=subprocess.check_output(command, stderr=subprocess.STDOUT)
    result=result.decode('ascii')
    if (len(result)>0):
        print(result) 

    #####
    # Turn on WatchGuard feedback data used for troubleshooting 
    # and security report https://www.watchguard.com/wgrd-resource-center/security-report
    # This data helps us report on security trends.
    # More importantly, it allows us to find security threats faster and provide
    # better security to all our customers world wide.
    # http://www.watchguard.com/help/docs/fireware/11/en-US/Content/en-US/basicadmin/global_setting_define_c.html?cshid=1020
    #####   
  
    command = ["global-setting","report-data","enable"]
    print(subprocess.check_output(command, stderr=subprocess.STDOUT))

    return "success"