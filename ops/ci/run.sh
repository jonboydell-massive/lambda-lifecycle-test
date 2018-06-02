#!/bin/bash -xe

#
# starts the CI process - which is dockerised
#

docker build -t cloudfront-lambda-build . -f ops/ci/Dockerfile.build
docker run --rm -i cloudfront-lambda-build
docker rmi cloudfront-lambda-build