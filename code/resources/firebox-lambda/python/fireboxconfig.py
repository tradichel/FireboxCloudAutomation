import os
import subprocess

def configure_firebox(event, context):
    what_to_print = "testing..."
    how_many_times = 3

    # make sure what_to_print and how_many_times values exist
    if what_to_print and how_many_times > 0:
        for i in range(0, how_many_times):
            # formatted string literals are new in Python 3.6
            print(f"what_to_print: {what_to_print}.")
        return what_to_print

    #####
    # TODO: Connect to Firebox via CLI
    ###

    #####
    # Turn on WatchGuard feedback data used for troubleshooting 
    # and security report https://www.watchguard.com/wgrd-resource-center/security-report
    # This data helps us report on security trends.
    # More importantly, it allows us to find security threats faster and provide
    # better security to all our customers world wide.
    # http://www.watchguard.com/help/docs/fireware/11/en-US/Content/en-US/basicadmin/global_setting_define_c.html?cshid=1020
    #####   
    #TODO: currently this is going to break as not conn. to fb.
    command = ["global-setting","report-data","enable"]
    print(subprocess.check_output(command, stderr=subprocess.STDOUT))

    return None

