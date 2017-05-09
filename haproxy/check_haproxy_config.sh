#!/bin/bash
set -e

# First, build HAProxy Docker image
docker build -t my-haproxy .

# Then, verify configuration file for HAProxy
docker run -it --rm --name haproxy-syntax-check my-haproxy haproxy -c -f /usr/local/etc/haproxy/haproxy.cfg
