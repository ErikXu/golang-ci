#!/bin/bash

SONAR_HOST_URL=${SONAR_HOST_URL:-http://example:9000}
echo "SONAR_HOST_URL: "$SONAR_HOST_URL

SONAR_LOGIN=${SONAR_LOGIN:-token}
echo "SONAR_LOGIN: "$SONAR_LOGIN

docker run --rm \
    -e SONAR_HOST_URL=${SONAR_HOST_URL} \
    -e SONAR_LOGIN=${SONAR_LOGIN} \
    -v ${PWD}:/usr/src \
    sonarsource/sonar-scanner-cli
