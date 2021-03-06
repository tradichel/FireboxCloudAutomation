from __future__ import print_function
import boto3
import os
import subprocess
import paramiko
import cryptography
import time
import logging
import paramiko

logging.getLogger("paramiko").setLevel(logging.DEBUG) 

#referencing this AWS blog post which recommends paramiko for SSH:
#https://aws.amazon.com/blogs/compute/scheduling-ssh-jobs-using-aws-lambda/

def configure_firebox(event, context):
    
    bucket=os.environ['Bucket']
    fireboxip=os.environ['FireboxIp']
    managementsubnetcidr=os.environ['ManagementCidr']
    key="firebox-cli-ec2-key.pem"
    localkeyfile="/tmp/fb.pem"
    s3=boto3.client('s3')
    
    ###
    #turn on detailed request logging to troubleshoot
    #S3 endpoint connection errors
    ###
    #boto3.set_stream_logger(name='botocore')
    
    #####
    #save key to lambda to use for CLI connection
    #####
    print ('Get SSH key from S3 bucket')
    s3.download_file(bucket, key, localkeyfile)

    #####
    # Connect to Firebox via CLI
    ###
    k = paramiko.RSAKey.from_private_key_file(localkeyfile)
    c = paramiko.SSHClient()

    try:

        #override check in known hosts file
        #https://github.com/paramiko/paramiko/issues/340
        c.set_missing_host_key_policy(paramiko.AutoAddPolicy())

        print("connecting to " + fireboxip)
        c.connect( hostname = fireboxip, port = 4118, username = "admin", key_filename = localkeyfile)
        print("connected to " + fireboxip)

        channel = c.invoke_shell()

        command="configure\n"
        channel.send(command)
        time.sleep(3)

        output=channel.recv(2024)
        print(output)

        command="global-setting report-data enable\n"
        channel.send(command)
        time.sleep(3)
        
        output=channel.recv(2024)
        print(output)

        #make Firebox an NTP server
        #http://www.watchguard.com/help/docs/fireware/11/en-US/Content/en-US/basicadmin/NTP_server_enable_add_c.html
        command="ntp enable\n"
        channel.send(command)
        time.sleep(3)

        output=channel.recv(2024)
        print(output)

        command="ntp device-as-server enable\n"
        channel.send(command)
        time.sleep(3)

        output=channel.recv(2024)
        print(output)

        #at this point can configure web servers to use 
        #firebox for NTP server

    finally:
        if channel:
            channel.close()
            print ("channel closed")
        if c:
            c.close()
            print ("connection closed")

    return 'success'
