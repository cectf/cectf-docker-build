#!/bin/bash

bash build-dockerfile.sh ubuntu
docker build -t cectf-server:latest .
