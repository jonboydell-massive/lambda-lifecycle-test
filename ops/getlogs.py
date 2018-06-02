#!/usr/bin/env python

import boto3
import json
import sys
from string import Template
import time
from pprint import pprint
import json
from botocore.exceptions import ClientError

try:
  aws_profile = sys.argv[1]
  log_group_name = sys.argv[2]

  aws_region = 'us-east-1'
  aws_regions = ['us-west-1', 'us-west-2', 'us-east-1', 'eu-central-1', 'eu-west-2', 'eu-west-1', 'eu-west-3']
  session = boto3.session.Session(profile_name=aws_profile, region_name=aws_region)
  aggregated_events = {}

  curr = ''
  for aws_region in aws_regions:
    logs = session.client('logs', region_name=aws_region)

    try:
      response = logs.describe_log_streams(
          logGroupName=log_group_name,
          orderBy='LastEventTime',
          descending=True
      )

      for target_list in response['logStreams']:
        log_stream_name = target_list['logStreamName']
        response = logs.get_log_events(
          logGroupName=log_group_name,
          logStreamName=log_stream_name
        )
        events = response['events']
        for event in events:
          if event['message'].startswith('2018'):
            event['awsRegion'] = aws_region
            raw_message = event['message']
            [datetime, message_id, json_message] = raw_message.split('\t')
            event['datetime'] = datetime
            event['message_id'] = message_id
            try:
              message = json.loads(json_message)
              print('{},{}'.format(message['source']['uri'], message['target']['uri']))
            except Exception as e:
              x = 10
    except ClientError as xx:
      print(xx)
    except Exception as e:
      print('Problem: ' + str(curr))
      print('nothing found for ' + aws_region)

  #pprint(aggregated_events)
except Exception as x:
  print('Problem: ' + str(x))
  print('Usage python getlogs.py AWS_PROFILE_NAME LOG_GROUP_NAME')