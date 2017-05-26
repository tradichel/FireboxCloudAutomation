Firebox Cloud Automation

Questions? DM me @TeriRadichel on Twitter.

More info: 
http://websitenotebook.blogspot.com
https://www.secplicity.org/author/teriradichel/

About This Repo:

    Deploy a Firebox Cloud in Your AWS Account.

    Using bash for people familiar with it. 

    Pay As You Go With 30 day trial - supports t2.micro, c4.large and up:
    https://aws.amazon.com/marketplace/pp/B06XJ9YTMF?utm_source=teriradichel&utm_medium=Twitter&utm_campaign=gh

    BYOL - supports c4.large and up: 
    https://aws.amazon.com/marketplace/pp/B06XJ9NQY3?utm_source=teriradichel&utm_medium=Twitter&utm_campaign=gh

Before You Run This Script:

    Create an AWS account:
    https://aws.amazon.com (click the button to create an account)

    More about AWS:
    https://aws.amazon.com/getting-started/

    Enable MFA on your user ID that is used to run this script:
    http://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa_enable_virtual.html

    More about AWS IAM Best Practices (like MFA)
    http://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html

    Install and configure the AWS CLI with your access key ID, secret key and region: 
    http://docs.aws.amazon.com/cli/latest/userguide/installing.html

    Install git:
    https://git-scm.com/

    Clone (download) this repo with this command: 
    git clone https://github.com/tradichel/FireboxCloudAutomation.git

    More about cloning repos:
    https://git-scm.com/docs/git-clone

    If you are using Windows install a bash shell:
    https://www.howtogeek.com/249966/how-to-install-and-use-the-linux-bash-shell-on-windows-10/

    Install Python
    https://www.python.org

    Activate The Firebox AMI In Your Account:
    http://websitenotebook.blogspot.com/2017/05/manually-activating-watchguard-firebox.html

Now Run The Code (in the code directory):

        ./run.sh 

Follow the prompts.


> Select which action you want to take - create, update or delete resources. 

    Please select:
    1) Create
    2) Update
    3) Delete
    4) Cancel
    #? 

> Enter the CIDR that is allowed to upload files to your private S3 bucket or hit enter. (Hint: For a simple test, you can get your IP at whatismyip.com and add /32 at the end, eg 111.111.111.111/32)

    Enter the IP range allowed to access Firebox S3 bucket (default is 0.0.0.0/0)

> Select an AMI. The script will execute a command to produce a list of available AMIs. For example, if I want the Firebox Pay-As-You-Go version 11.12.2 I would enter ami-a844d4c8 at the prompt and hit enter. (If you don't see any then you need to follow the steps above to activate the AMI from the marketplace.)

    Available AMIs:
    ami-3b4ddd5b 
    firebox-cloud-11_12_2-526900-byol
    ami-a844d4c8 
    firebox-cloud-11_12_2-526900-payasyougo
    WatchGuard Marketplace AMI from list above:

> Enter an MFA token. Your session lasts 12 hours once created.

    MFA token (return to use active session):
    
Watch as your resources get created...

Check out what was built and logs in the AWS Console.

To Do:

    Update Lambda Dependencies
    Network Parameters for CIDRS
    Other Sample FB configurations

Details:

    Read the wiki: https://github.com/tradichel/FireboxCloudAutomation/wiki
    I also post notes here: http://websitenotebook.blogspot.com

More about Firebox Cloud:

    Set Up Firebox Cloud:
    https://www.watchguard.com/help/docs/fireware/11/en-US/Content/en-US/firebox_cloud/fb_cloud_help_intro.html

    Latest Firebox Documentation:
    https://www.watchguard.com/wgrd-help/documentation/xtm
    
    Contact a WatchGuard reseller:
    http://www.watchguard.com/wgrd-resource-center/how-to-buy?utm_source=teriradichel&utm_medium=gh&utm_campaign=gh

    Some resellers sell on Amazon:
    https://www.amazon.com/s/ref=nb_sb_noss_1?url=search-alias%3Daps&field-keywords=watchguard&utm_source=teriradichel&&utm_medium=gh&utm_campaign=gh

Notes:

    - eth0 = public, eth1 = managmenet, create other network interfaces for the rest (more soon)
    - One of other possible configurations to be added later (potentially)
    - More secure to use automated deployment system (e.g. Jenkins, AWS CodeDeploy) but this works for now

Questions?

    @teriradichel

Other Cloud Resources:

    Cloud Security:
    https://www.secplicity.org/2017/04/08/cloud-security/?utm_source=teriradichel&utm_medium=Twitter&utm_campaign=gh

    How Can Automation Improve Security?
    https://www.secplicity.org/2017/04/21/how-can-automation-improve-security/?utm_source=teriradichel&utm_medium=gh&utm_campaign=gh
