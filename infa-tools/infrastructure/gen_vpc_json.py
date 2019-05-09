#!/bin/python

import sys
import fileinput
from infa_aws_utils import get_vpc_subnets, get_vpc_cidr
import fileinput
import shutil


ma_vpc = str(sys.argv[1])
pod_vpc = str(sys.argv[2])
pod_type = str(sys.argv[3])
vpc_template = str(sys.argv[4])
pod_consul = str(sys.argv[5])
vpc_file = 'vpc.json'
path_provision = str(sys.argv[6])
region = str(sys.argv[7])
vpc_json = ''

with open(vpc_template, 'r') as in_file:
    vpc_json = in_file.read()
in_file.close()

def replace(vpc_json, pattern, subst):
    return vpc_json.replace(pattern,subst)

if 'ma' in pod_type.lower():
    vpc_id = ma_vpc
elif 'pod' in pod_type.lower():
    vpc_id = pod_vpc
else:
    print('Not a valid pod type, only "ma/pod" supported"')
    exit(1)

vpc_json = replace(vpc_json, '$vpc_id', vpc_id)
vpc_json = replace(vpc_json, '$region', region)
vpc_json = replace(vpc_json,'$ma_cidr', get_vpc_cidr(ma_vpc, region))
vpc_json = replace(vpc_json, '$pod_cidr', get_vpc_cidr(pod_vpc, region))
vpc_json = replace(vpc_json, '$pod_consul', pod_consul)

for subnet in get_vpc_subnets(vpc_id, region):
    vpc_subnet = '$subnet_' + subnet['Name'].split('-')[-2] + '_' + subnet['Name'].split('-')[-1]
    vpc_json = replace(vpc_json, vpc_subnet, subnet['SubnetId'])

with open(path_provision + vpc_file, 'w') as out_file:
    out_file.write(vpc_json)

print('vpc.json Created!')
print(vpc_json)
out_file.close()
