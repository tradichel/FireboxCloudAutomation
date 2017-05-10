Firebox Cloud Automation

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
    http://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html

    Install and configure the AWS CLI with your access key ID, secret key and region: 
    http://docs.aws.amazon.com/cli/latest/userguide/installing.html

    Install git:
    https://git-scm.com/

    Clone (download) this repo with this command: 
    git clone https://github.com/tradichel/FireboxCloudAutomation.git

    More about cloning repos:
    https://git-scm.com/docs/git-clone

    Create an EC2 Key (SSH Key) so you can automate configuration of your firebox 
    http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html

    If you are using Windows install a bash shell:
    https://www.howtogeek.com/249966/how-to-install-and-use-the-linux-bash-shell-on-windows-10/

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

> Enter the CIDR that is allowed to upload files to your private S3 bucket or hit enter.

    Enter the IP range allowed to access Firebox S3 bucket (default is 0.0.0.0/0)

> Enter an MFA token. Your session lasts 12 hours once created.

    MFA token (return to use active session):
    
Watch as your resources get created...

Check out what was built and logs in the AWS Console.

To Do:

    Lambda function not yet complete
    Upload EC2 Key Pair to Bucket - in progress.

Details:

    Read the wiki: https://github.com/tradichel/FireboxCloudAutomation/wiki

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

    - You might want tighter networking rules but this will get you started...
    - Still need to auto-deploy configuration
    - One of other possible configurations to be added later
    - More secure to deploy through automated build system ~ more on that later

Questions?

    @teriradichel

Other Cloud Resources:

    Cloud Security:
    https://www.secplicity.org/2017/04/08/cloud-security/?utm_source=teriradichel&utm_medium=Twitter&utm_campaign=gh

    How Can Automation Improve Security?
    https://www.secplicity.org/2017/04/21/how-can-automation-improve-security/?utm_source=teriradichel&utm_medium=gh&utm_campaign=gh
