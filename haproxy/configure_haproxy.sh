#!/bin/bash
set -e
source percona_cluster.cfg

# First, build HAProxy Docker image
echo "Configuring HAProxy . . . "
echo "	- Building HAProxy Docker image!"
docker build -t "haproxy:latest" .

# Second, verify configuration file for HAProxy
echo "	- Verifying HAProxy configuration file!"
docker run -it --rm \
	--name haproxy-syntax-check \
	haproxy haproxy	-c -f /usr/local/etc/haproxy/haproxy.cfg

# Last, run HAProxy Docker container
echo "	- Running HAProxy Docker container!"
docker run -d \
	-p $HAPROXY_CLUSTER_PORT:3306 \
	-p $HAPROXY_WEBSTATS_PORT:80 \
	--name $HAPROXY_NODE_NAME \
	haproxy:latest

echo "HAProxy is configured successfully!"
