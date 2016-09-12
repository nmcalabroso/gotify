#!/bin/bash
APP_PATH=`pwd -P`

# Build and Create Containers
docker build -t gotify .
docker run --name gotify \
           -v $APP_PATH:/mnt/gotify \
           -d -P \
           gotify

# Start Containers
docker start gotify
