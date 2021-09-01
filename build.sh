#!/bin/bash

docker run --rm -i \
    -v /go:/go \
    -v ${PWD}:/workspace \
    golang:1.16-alpine \
    sh -c 'cd /workspace && sh publish.sh'
