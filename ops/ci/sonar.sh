#!/bin/bash

docker build -t cloudfront-lambda-build . -f ops/ci/Dockerfile.ci
docker run -v `pwd`/coverage:/srv/coverage --rm -i cloudfront-lambda-build
docker run -v `pwd`/coverage:/srv/coverage --rm -i cloudfront-lambda-build sonar-scanner -Dsonar.host.url=http://sonarqube.tools.livesport-massive.com