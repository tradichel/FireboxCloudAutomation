#These commands create a virtual environment 
#with paramiko and cryptography for our lambda
#function. For now this is not automated.
#Read this blog post for more:

#http://websitenotebook.blogspot.com/2017/05/creating-paramiko-and-cryptography.html

#update the ec2 isntance
sudo yum update -y

#see what versions of python are available
sudo yum list | grep python3

#install the one we want
sudo yum install python35.x86_64 -y

#switch to temp directory
cd /tmp

#create virtual environment
virtualenv -p /usr/bin/python3.5 python35

#activate virtual environment
source python35/bin/activate

#install dependencies
sudo yum install gcc -y
sudo yum install python35-devel.x86_64 -y
sudo yum install openssl-devel.x86_64 -y
sudo yum install libffi-devel.x86_64 -y

#install paramiko
pip install paramiko
