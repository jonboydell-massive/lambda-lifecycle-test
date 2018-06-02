import boto3
import sys
from string import Template

aws_region = 'us-east-1'
function_name = sys.argv[1]
role_arn = sys.argv[2]

session = boto3.session.Session(region_name=aws_region)

with open(function_name + '.zip', 'rb') as z:
  zipfile_bytes = z.read()
  lam = session.client('lambda', region_name=aws_region)
  try:
    response = lam.update_function_code(
        FunctionName=function_name,
        ZipFile=zipfile_bytes,
        Publish=True
    )
  except:
    handler = function_name + '.handler'
    response = lam.create_function(
        FunctionName=function_name,
        Runtime='nodejs6.10',
        Role=role_arn,
        Handler=handler,
        Code={
            'ZipFile':zipfile_bytes
        },
        Publish=True
    )
  print(response['FunctionArn'])
