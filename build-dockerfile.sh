#!/bin/bash

if [[ `lscpu | grep armv7l` != "" ]]; then
  echo "Detected armv7l architecture"
  FROM="FROM hypriot/rpi-alpine-scratch"
else
  echo "Detected non-armv7l architecture"
  FROM="FROM alpine"
fi

echo "Building for target $FROM..."
echo "$FROM" > Dockerfile
cat template.Dockerfile >> Dockerfile