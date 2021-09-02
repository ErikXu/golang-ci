#!/bin/bash

docker run --rm -i -v ${PWD}/test/api:/etc/newman \
    --entrypoint sh postman/newman:alpine -c \
    'npm i -g newman-reporter-html; \
    newman run collection.json \
    --suppress-exit-code 1 \
    --color off \
    --reporters cli,html\
    --reporter-html-export api_report.html \
    --environment=environment.json'
