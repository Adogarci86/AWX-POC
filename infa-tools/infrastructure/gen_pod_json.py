#!/bin/python

import sys
import fileinput
from infa_aws_utils import get_vpc_subnets, get_vpc_cidr
import fileinput
import shutil


pod_environment = str(sys.argv[1])
pod_consul = str(sys.argv[2])
pod_name = str(sys.argv[3])
pod_template = str(sys.argv[4])
pod_file = 'pod.json'
path_provision = str(sys.argv[5])
region = str(sys.argv[6])
pod_json = ''

with open(pod_template, 'r') as in_file:
    pod_json = in_file.read()
in_file.close()

def replace(pod_json, pattern, subst):
    return pod_json.replace(pattern,subst)

pod_json = replace(pod_json, '$pod_environment', pod_environment)
pod_json = replace(pod_json, '$pod_consul', pod_consul)
pod_json = replace(pod_json,'$pod_name', pod_name.upper())
pod_json = replace(pod_json, '$pod_name_caps', pod_name.upper())

with open(path_provision + pod_file, 'w') as out_file:
    out_file.write(pod_json)

print('pod.json Created!')
print(vpc_json)
out_file.close()
