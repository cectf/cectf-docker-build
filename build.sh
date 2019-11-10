#!/bin/bash

bash build-dockerfile.sh ubuntu
DOCKER_BUILDKIT=1 docker build -t cectf-server:latest .
