# Project           : Informatica
# Program name      : mysql-query
# Author            : Adolfo Garcia
# Date created      : 02/20/2019
# Purpose           : Run mysql queries, multiple applications script.
# Revision History  :
#

#!/usr/bin/python

import MySQLdb
import boto3
import configparser
import sys

pod_name = str(sys.argv[1])
query_file = str(sys.argv[2])

config = configparser.ConfigParser()
config.read('/opt/apps/infa-tools/config.' + pod_name)

with open('/opt/apps/infa-tools/' + query_file, 'r') as myfile:
    query=myfile.read().replace('\n', '')

db = MySQLdb.connect(config['DEFAULT']['hostname'], config['DEFAULT']['user'], config['DEFAULT']['password'], config['DEFAULT']['databases'])
cursor = db.cursor()
result = cursor.execute(query)
data = cursor.fetchone()
if data:
    for row in cursor.fetchone():
        print("Rows produced by statement '{}':".format(row))
else:
    print("Number of rows affected by statement '{}'".format(int(result)))

db.commit()
db.close()

