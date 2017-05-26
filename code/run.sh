#!/bin/sh
##############################################################
# 
# Automated Firebox Cloud Deployment
#
# Follow instructions in readme: 
# https://github.com/tradichel/FireboxCloudAutomation
#
###############################################################
echo "Please select action:"
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
rm -f *.txt
echo "***"
echo "* Begin: $dt" 
echo "* ---- NOTE --------------------------------------------"
echo "* Your CLI is configured for region: " $region
echo "* Resources will be created in this region."
echo "* Switch to this region in console when you login."
echo "* ------------------------------------------------------"

if [ "$action" != "delete" ]
then
    #todo: add this back to bucket policy
    echo "Enter the Admin IP range (default is 0.0.0.0/0 < the whole Internet! Please limit to your network. Hint: whatismyip.com + /32)"
    read adminips
    if [ "$adminips" = "" ]; then adminips="0.0.0.0/0"; fi

    
    echo "* ------------------------------------------------------"
    echo "Please wait for a list of available Firebox Cloud AMIs..."
    aws ec2 describe-images --filters "Name=description,Values=firebox*" | grep 'ImageId\|Description' 
    echo "* ------------------------------------------------------"
    echo "Choose AMI ID from list above (see readme if no AMIs listed):"
    read ami

    echo "Instance Type (default c4.large. Can use t2.micro on pay as you go but only has two ENIs):"
    read instancetype
    if [ "$instancetype" = "" ]; then instancetype="c4.large"; fi

fi

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

#if no errors create the stack
echo "Executing: $action with $user as admin user with ips: $adminips ami: $ami instancetype: $instancetype" 
. ./execute/action.sh $action $user $adminips $userarn $ami $instancetype

rm -f *.txt
#dt=$(date)
echo "Done"