#!/bin/python
import subprocess
import json
import sys

app_env = str(sys.argv[1])

cmd_azure_vms = 'az vm list-ip-addresses --ids $(az resource list --query "[?type==\'Microsoft.Compute/virtualMachines\' && tags.APPLICATIONENV == ' + app_env + '].id" --output tsv)'

p = subprocess.call([cmd_azure_vms], stdout=subprocess.PIPE)

print p.communicate()
