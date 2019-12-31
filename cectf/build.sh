#!/bin/bash

if [[ `lscpu | grep armv7l` != "" ]]; then
  echo "Detected armv7l architecture"
  image="arm32v6/alpine:latest"
else
  echo "Detected non-armv7l architecture"
  image="alpine"
fi

echo "Using base image $image..."

cat Dockerfile.template \
  | sed -r "s!%%image%%!$image!g" \
  > Dockerfile

echo "Building image..."
docker build -t 127.0.0.1:5000/cectf-server:latest . $1

if [[ $? != 0 ]]; then
  echo "Build failed, aborting"
  echo "APK installation can be flaky on Raspberry PI, perhaps retrying will get it past the problematic build stage"
  exit 1
fi

echo "Uploading image to private registry..."
docker push 127.0.0.1:5000/cectf-server:latest
