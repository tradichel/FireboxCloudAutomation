#!/bin/sh
##############################################################
# 
# Automated Firebox Cloud Deployment
#
# Follow instructions in readme: 
# https://github.com/tradichel/FireboxCloudAutomation
#
###############################################################
echo "Please select:"
select cudl in "Create" "Update" "Delete" "Cancel"; do
    case $cudl in
        Create ) action="create";break;;
        Update ) action="update";break;;
        Delete ) action="delete";break;;
        Cancel ) exit;;
    esac
done

dt=$(date)
region=$(aws configure get region)
rm *.txt
echo "***"
echo "* Begin: $dt" 
echo "* ---- NOTE --------------------------------------------"
echo "* Your CLI is configured for region: " $region
echo "* Resources will be created in this region."
echo "* Switch to this region in console when you login."
echo "* ------------------------------------------------------"

#todo: add this back to bucket policy
echo "Enter the IP range allowed to access Firebox S3 bucket (default is 0.0.0.0/0)"
read adminips
if [ "$adminips" = "" ]; then adminips="0.0.0.0/0"; fi

#get the user information to get an active session with MFA
aws sts  get-caller-identity > "user.txt" 2>&1
userarn=$(./execute/get_value.sh "user.txt" "Arn")
account=$(./execute/get_value.sh "user.txt" "Account")
user=$(cut -d "/" -f 2 <<< $userarn)

#if user has enters MFA token get a new session.
echo "MFA token (return to use active session):"
read mfatoken
if [ "$mfatoken" != "" ]
then

    mfaarn="arn:aws:iam::$account:mfa/$user"
    error=$(./execute/get_credentials.sh $mfaarn $mfatoken | grep "error\|Invalid") 
    if [ "$error" != "" ]; then 
        echo "* ---- What's the problem? ----"
        echo "* Enable MFA on your account and enter MFA token at prompt."
        echo "* For more information about MFA:"
        echo "* http://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa_enable_virtual.html"
        echo "* https://aws.amazon.com/premiumsupport/knowledge-center/authenticate-mfa-cli/"
        echo "* -----------------------------"
        echo $error 
        exit; 
    fi
fi

keyname="firebox-cloud-ec2-key"
echo ""
echo "* ---- NOTE --------------------------------------------"
echo "* Creating EC2 keypair: $keyname"
echo "* Do NOT check in keys to public source control systems."
echo "* Keys are passwords. Protect them!"
echo "* This github repository excludes .pem and .PEM files in the .gitignore file"
echo "* https://git-scm.com/docs/gitignore"
echo "* ------------------------------------------------------"
echo ""
aws ec2 describe-key-pairs --key-name $keyname > ec2key.txt  2>&1  
noexist=$(cat ec2key.txt | grep "does not exist")
if [ "$noexist" != "" ]
then
    aws ec2 create-key-pair --key-name $keyname --query 'KeyMaterial' --output text > $keyname.pem
    chmod 600 $keyname.pem
    ls -al
fi

#if no errors create the stack
echo "Executing: $action with $user as admin user at $adminips"
. ./execute/action.sh $action $keyname $user $adminips

dt=$(date)
echo "Done: $dt"