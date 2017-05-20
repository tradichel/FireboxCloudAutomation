#The lambda function to run the CLI requires an SSH library 
#since ssh is not available on lambda

#We'll use the paramiko library which in turn requires a crypto library
#The crypto lib

#1 run yum update to get all the latest packates
sudo yum update
sudo yum install python35 -y
sudo pip install virtualenv --upgrade
cd /tmp
virtualenv -p /usr/bin/python3.5 python35

#Looks like this:

#[ec2-user@ip-10-0-0-192 tmp]$ source python35/bin/activate
#(python35) [ec2-user@ip-10-0-0-192 tmp]$ 

sudo yum install gcc


#python3.4-devel probably (and libffi-devel and libssl-devel 

pip install paramiko

build/temp.linux-x86_64-3.5/_openssl.c:12:24: fatal error: pyconfig.h: No such file or directory
     #  include <pyconfig.h>
                            ^
    compilation terminated.
    error: command 'gcc' failed with exit status 1



https://aws.amazon.com/premiumsupport/knowledge-center/python-boto3-virtualenv/

#this already exists by default on ec2 instance so don't need this but if 
#not available would need to install virtual env.
#pip install virtualenv

#to install a different python version (35 is currently supported):
#sudo yum install python35

#virtual env has one command:
#virtualenv ENV
#ENV is the path where you want the virtual environment
#https://virtualenv.pypa.io/en/stable/userguide/

#sudo yum install python35

#had to create venv without pip to avoid error:
#python3 -m venv /tmp/firebox --without-pip

#paramiko already exists on EC2 instance
#presumably this means all requirements also exist

#activate the new environment we just created
#source  /tmp/firebox/bin/activate

#pip install paramiko says requirements are already satisfied
#pip install cryptography gets updates
#cannot execute since gcc does not exist...

##install pip
wget https://pypi.python.org/packages/source/s/setuptools/setuptools-3.4.4.tar.gz
tar -vzxf setuptools-3.4.4.tar.gz
cd setuptools-3.4.4
python setup.py install
cd ..
wget https://pypi.python.org/packages/source/p/pip/pip-1.5.6.tar.gz
tar -vzxf pip-1.5.6.tar.gz
cd pip-1.5.6
python setup.py install
cd ..
deactivate
source ./myvenv/bin/activate

#install gcc
sudo yum install gcc



#install dev tools
sudo yum install python35-devel.x86_64

 build/temp.linux-x86_64-3.5/_openssl.c:434:30: fatal error: openssl/opensslv.h: No such file or directory
     #include <openssl/opensslv.h>
                                  ^
    compilation terminated.
    error: command 'gcc' failed with exit status 1



source /tmp/firebox/bin/activate
sudo yum update python35


