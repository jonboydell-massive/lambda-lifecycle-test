#!/bin/bash -xe

# DO NOT RUN THIS SCRIPT OUTSIDE OF A DOCKER CONTAINER (see ./run.sh)
# script that deploys the lambda and associates it with CF - this is run inside the docker deploy container
#

[ -z "${AWS_ACCESS_KEY_ID}" ] && echo "Need to set AWS_ACCESS_KEY_ID" && exit 1
[ -z "${AWS_SECRET_ACCESS_KEY}" ] && echo "Need to set AWS_SECRET_ACCESS_KEY" && exit 1
[ -z "${AWS_ROLE_ARN}" ] && echo "Need to set AWS_ROLE_ARN" && exit 1
[ -z "${FUNCTION_NAME}" ] && echo "Need to set FUNCTION_NAME" && exit 1

export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
export AWS_SESSION_TOKEN=${AWS_SESSION_TOKEN}

zip -r ${FUNCTION_NAME}.zip -xi ${FUNCTION_NAME}.js node_modules
AWS_LAMBDA_ARN=`python3 /srv/ops/cd/deploy-lambda.py ${FUNCTION_NAME} ${AWS_ROLE_ARN}`

[ -z "${AWS_CLOUDFRONT_ID}" ] && echo "No CloudFront distribution id specified, won't update CloudFront" && exit 0
[ -z "${FUNCTION_ASSOCIATIONS}" ] && echo "No function associations specified, won't update CloudFront" && exit 0
python3 /srv/ops/cd/deploy-cloudfront.py ${AWS_CLOUDFRONT_ID} ${AWS_LAMBDA_ARN} ${FUNCTION_ASSOCIATIONS}