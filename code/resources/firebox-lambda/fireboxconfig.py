from __future__ import print_function
import boto3
import os
import subprocess
import paramiko
import cryptography

import logging
import paramiko

logging.getLogger("paramiko").setLevel(logging.DEBUG) 

#referencing this AWS blog post which recommends paramiko for SSH:
#https://aws.amazon.com/blogs/compute/scheduling-ssh-jobs-using-aws-lambda/

def configure_firebox(event, context):
    
    bucket=os.environ['Bucket']
    fireboxip=os.environ['FireboxIp']
    key="firebox-cli-ec2-key.pem"
    localkeyfile="/tmp/fb.pem"
    s3=boto3.client('s3')

    #####
    #save key to lambda to use for CLI connection
    #####
    print ('Get SSH key from S3 bucket')
    s3.download_file(bucket, key, localkeyfile)

    #####
    # Change permissions on the key file (more restrictive)
    ###
    #print('change permissions on key')
    #command = ["chmod","400",localkeyfile]
    result=subprocess.check_output(command, stderr=subprocess.STDOUT)
    result=result.decode('ascii')
    if (len(result)>0):
        print(result)
    
    #####
    # Connect to Firebox via CLI
    ###
    k = paramiko.RSAKey.from_private_key_file(localkeyfile)
    c = paramiko.SSHClient()
    #override check in known hosts file
    #https://github.com/paramiko/paramiko/issues/340
    c.set_missing_host_key_policy(paramiko.AutoAddPolicy())

    #This will fail until the private interface is set up to accept
    #these connections. Otherwise need to open up public network
    #connections and prefer not to do that. More on that later...
    print("connecting to " + fireboxip)
    c.connect( hostname = fireboxip, port = 4118, username = "admin", key_filename = localkeyfile)
    print("connected to " + fireboxip)

    #####
    # Turn on WatchGuard feedback data used for troubleshooting 
    # and security report https://www.watchguard.com/wgrd-resource-center/security-report
    # This data helps us report on security trends.
    # More importantly, it allows us to find security threats faster and provide
    # better security to all our customers world wide.
    # http://www.watchguard.com/help/docs/fireware/11/en-US/Content/en-US/basicadmin/global_setting_define_c.html?cshid=1020
    #####   
    
    commands = [
        "global-setting report-data enable"
    ]

    for command in commands:
        print ("Executing {}".format(command))
        stdin , stdout, stderr = c.exec_command(command)
        print (stdout.read())
        print (stderr.read())

    return 'success'