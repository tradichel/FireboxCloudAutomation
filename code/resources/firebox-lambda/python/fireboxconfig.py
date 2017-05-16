import subprocess

def configure_firebox(event, context):
    print 'This is just a test'  

#####
# Using the WatchGuard CLI to automate configuration of WatchGuard Firebox Cloud
# The latest version of the CLI can be found here
# At the time of this writing all WatchGuard products use the same OS and have
# the mody of the same features
# https://www.watchguard.com/wgrd-help/documentation/xtm
#####

#####
#
# Connect to Firebox
#
#####


#####
# Turn on WatchGuard feedback data used for troubleshooting 
# and security report https://www.watchguard.com/wgrd-resource-center/security-report
# This data helps us report on security trends.
# More importantly, it allows us to find security threats faster and provide
# better security to all our customers world wide.
# http://www.watchguard.com/help/docs/fireware/11/en-US/Content/en-US/basicadmin/global_setting_define_c.html?cshid=1020
#####

#change Firebox global settigns to enable feedback
command = ["global-setting","report-data","enable"]
print(subprocess.check_output(command, stderr=subprocess.STDOUT))

return 'This is just a test'

