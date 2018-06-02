import boto3
import sys
import json

def error():
  print('Attaches a L@E lambda to a cloudfront event')
  print('Usage deploy-cloudfront.py CF_DISTRIBUTION_ID LAMBDA_ARN TRIGGER_EVENT[,TRIGGER_EVENT] [PATH_PATTERN[,PATH_PATTERN]')
  print('TRIGGER_EVENT must be one of origin-request, origin-response, viewer-request, viewer-response')
  exit(1)

aws_region = 'us-east-1'
allowed_trigger_events = ['viewer-request', 'viewer-response', 'origin-request', 'origin-response']

if (len(sys.argv) < 3):
  error()

cloudfront_distribution_id = sys.argv[1]
lambda_arn = sys.argv[2]

trigger_events = sys.argv[3].lower().split(',')
if not set(trigger_events).issubset(set(allowed_trigger_events)):
  error()

path_patterns = []
if (len(sys.argv) > 4):
  path_patterns = sys.argv[4].split(',')

session = boto3.session.Session(region_name=aws_region)
cf = session.client('cloudfront')

response = cf.get_distribution_config(Id=cloudfront_distribution_id)
etag = response['ETag']
distribution_config = response['DistributionConfig']

cache_behaviours = []
if len(path_patterns) == 0 or '*' in path_patterns:
    cache_behaviours.append(distribution_config['DefaultCacheBehavior'])

if distribution_config['CacheBehaviors']['Quantity'] > 0:
    for item in distribution_config['CacheBehaviors']['Items']:
        if item['PathPattern'] in path_patterns:
            cache_behaviours.append(item)

for cache_behaviour in cache_behaviours:
    cache_behaviour['LambdaFunctionAssociations']['Quantity'] = len(trigger_events)
    behaviour_items = []
    for trigger_event in trigger_events:
      behaviour_item = {
       'LambdaFunctionARN': lambda_arn,
       'EventType': trigger_event
      }
      behaviour_items.append(behaviour_item)
    cache_behaviour['LambdaFunctionAssociations']['Items'] = behaviour_items

#print(distribution_config)
response = cf.update_distribution(DistributionConfig=distribution_config, Id=cloudfront_distribution_id, IfMatch=etag)
print(response)