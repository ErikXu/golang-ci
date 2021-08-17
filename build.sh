#!/bin/bash

rm -rf ./publish
mkdir -p ./publish

export GOPROXY=https://goproxy.cn
go mod tidy

GOOS=linux GOARCH=amd64 GO111MODULE=on CGO_ENABLED=0 go build --ldflags="-s" -v -o ./publish/app