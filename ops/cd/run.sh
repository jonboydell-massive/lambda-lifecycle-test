#!/bin/bash -xe

#
# starts the CD process - which is dockerised
#

[ -z "${AWS_ACCESS_KEY_ID}" ] && echo "Need to set AWS_ACCESS_KEY_ID" && exit 1
[ -z "${AWS_SECRET_ACCESS_KEY}" ] && echo "Need to set AWS_SECRET_ACCESS_KEY" && exit 1
[ -z "${AWS_ROLE_ARN}" ] && echo "Need to set AWS_ROLE_ARN" && exit 1
[ -z "${FUNCTION_NAME}" ] && echo "Need to set FUNCTION_NAME" && exit 1

rm -rf node_modules

docker build -t cloundfront-lambda-deploy . -f ops/cd/Dockerfile.deploy
docker run --rm -i -e FUNCTION_ASSOCIATIONS=${FUNCTION_ASSOCIATIONS} -e FUNCTION_NAME=${FUNCTION_NAME} -e AWS_SESSION_TOKEN=${AWS_SESSION_TOKEN} -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} -e AWS_CLOUDFRONT_ID=${AWS_CLOUDFRONT_ID} -e AWS_ROLE_ARN=${AWS_ROLE_ARN} cloundfront-lambda-deploy
docker rmi cloundfront-lambda-deploy