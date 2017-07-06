# Firebox Cloud Automation
https://www.secplicity.org/2017/07/03/automate-deployment-watchguard-firebox-cloud-aws/?utm_source=teriradichel&utm_medium=gh

Questions? DM me @TeriRadichel on Twitter.

## About This Repo:

    Deploy a Firebox Cloud in Your AWS Account.

    Using bash for people familiar with it. 

    Pay As You Go With 30 day trial - supports t2.micro*, c4.large and up:
    https://aws.amazon.com/marketplace/pp/B06XJ9YTMF?utm_source=teriradichel&utm_medium=gh
    * Use C4.large for more than two network interfaces

    BYOL - supports c4.large and up: 
    https://aws.amazon.com/marketplace/pp/B06XJ9NQY3?utm_source=teriradichel&utm_medium=gh

## Before You Run This Script:

    Create an AWS account:
    https://aws.amazon.com (click the button to create an account)

    Enable MFA on your user ID that is used to run this script:
    http://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa_enable_virtual.html

    Install and configure the AWS CLI with your access key ID, secret key and region: 
    http://docs.aws.amazon.com/cli/latest/userguide/installing.html

    Install git:
    https://git-scm.com/

    Clone (download) this repo with this command: 
    git clone https://github.com/tradichel/PacketCaptureAWS.git
    More info: https://git-scm.com/docs/git-clone

    If you are using Windows install a bash shell:
    https://www.howtogeek.com/249966/how-to-install-and-use-the-linux-bash-shell-on-windows-10/

    Install Python
    https://www.python.org

    Activate The Firebox AMI In Your Account:
    http://websitenotebook.blogspot.com/2017/05/manually-activating-watchguard-firebox.html
    
    Follow AWS IAM Best Practices (like MFA)
    http://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html

## Run the code:

    Log into the console using MFA.

    Navigate to PacketCaptureAWS/code folder

    type ./run.sh

    At the prompt, type 1 and hit enter:

        Please select action:
        1) Create/Update
        2) Delete
        3) Cancel
        #? 

    The code will tell you the region your CLI is configured to use:

        * ---- NOTE --------------------------------------------
        * Your CLI is configured for region:  us-west-2
        * Resources will be created in this region.
        * Switch to this region in console when you login.
        * ------------------------------------------------------

    When it asks if you want to use the default options type y and hit enter:

       * Would you like to use all the default options? (Y)
    
    If you want to change defaults, hit enter above. Read prompts.

    To delete all the resources run the script again and choose delete.


## View The Results:

    Watch the screen for updates.

    Log into the console to see that actions were successful

## More about Firebox Cloud:

Set Up Firebox Cloud:
https://www.watchguard.com/help/docs/fireware/11/en-US/Content/en-US/firebox_cloud/fb_cloud_help_intro.html

Latest Firebox Documentation:
https://www.watchguard.com/wgrd-help/documentation/xtm
    
Contact a WatchGuard reseller:
http://www.watchguard.com/wgrd-resource-center/how-to-buy?utm_source=teriradichel&utm_medium=gh

Some resellers sell on Amazon:
https://www.amazon.com/s/ref=nb_sb_noss_1?url=search-alias%3Daps&field-keywords=watchguard&utm_source=teriradichel&&utm_medium=gh

## More info about author and code: 

@teriradichel
https://twitter.com/teriradichel

Code Blog:
http://websitenotebook.blogspot.com

Secplicity:
https://www.secplicity.org/author/teriradichel/?utm_source=teriradichel&utm_medium=gh

SlideShare:
https://www.slideshare.net/TeriRadichel

AWS Network Security Meet Up Video:
https://youtu.be/DSptV0km1aY