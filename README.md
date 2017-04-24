Firebox Cloud Automation

About This Repo:

    Deploy a Firebox Cloud in Your AWS Account.

    Firebox Cloud: 
    https://aws.amazon.com/marketplace/pp/B06XJ9NQY3?qid=1489541285919&sr=0-3630&ref_=srh_res_product_image
    

Before You Run This Script:

    Create an AWS account:
    https://aws.amazon.com (click the button to create an account).

    More about AWS:
    https://aws.amazon.com/getting-started/

    Install and configure the AWS CLI with your access key ID, secret key and region: 
    http://docs.aws.amazon.com/cli/latest/userguide/installing.html

    Install git:
    https://git-scm.com/

    Clone this repo with this command: 
    git clone https://github.com/tradichel/FireboxCloudAutomation.git

    More about cloning repos:
    https://git-scm.com/docs/git-clone

Now Run The Code (in the code directory):

    Mac, Linux:

        ./run.sh create nat fireboxtrial 

        ./run.sh delete fireboxtrial

        ./run.sh update fireboxtrial

    Windows:
    
        Leave off the ./ in the commands above

More about Firebox Cloud:

    Set Up Firebox Cloud:
    https://www.watchguard.com/help/docs/fireware/11/en-US/Content/en-US/firebox_cloud/fb_cloud_help_intro.html

    Contact a WatchGuard reseller:
    http://www.watchguard.com/wgrd-resource-center/how-to-buy

    Some resellers sell on Amazon:
    https://www.amazon.com/s/ref=nb_sb_noss_1?url=search-alias%3Daps&field-keywords=watchguard

Notes:

    - You might want tighter networking rules but this will get you started...
    - Still need to auto-deploy configuration
    - One of other possible configurations to be added later
    - More secure to deploy through automated build system ~ more on that later

Questions?

    @teriradichel

Other Cloud Resources:

    Cloud Security:
    https://www.secplicity.org/2017/04/08/cloud-security/

    How Can Automation Improve Security?
    https://www.secplicity.org/2017/04/21/how-can-automation-improve-security/