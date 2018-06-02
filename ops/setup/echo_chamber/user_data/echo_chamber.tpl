#!/bin/bash -xe
yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
yum install -y docker
service docker start
usermod -a -G docker ec2-user
docker pull jonboydell/echo-chamber
docker run -dt -p 80:3000 -e REGION=${region} jonboydell/echo-chamber:latest