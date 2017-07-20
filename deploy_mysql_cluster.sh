#!/bin/bash
set -e

# Read configuration file
source percona_cluster.cfg

# Extract network addresses
IFS=. read octet1 octet2 octet3 octet4 <<< "$CLUSTER_NETWORK"

# Launch the first node which is responsible for initializing the Cluster
echo "Initiatlizing Percona cluster ... "
number=1

docker run -d \
	--name "$CLUSTER_NODES_NAME$number" \
	--hostname "$CLUSTER_NODES_HOSTNAME$number" \
	-e CLUSTER_NAME=$CLUSTER_NAME \
	-e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD \
	-e XTRABACKUP_PASSWORD=$XTRABACKUP_PASSWORD \
	albodor/percona-cluster-haproxy
rm -f haproxy/haproxy.cfg
cp haproxy/haproxy.cfg.sample haproxy/haproxy.cfg
echo "	server $CLUSTER_NODES_NAME$number 172.17.0.2:3306 check port 9200 inter 12000 rise 3 fall 3" >> ~/cluster/haproxy/haproxy.cfg
echo "done!"
echo -n "Waiting for first Cluster node to prepare "
for i in `seq 1 10`; do
	echo -n ". "
	sleep 1
done
echo "done!"

# Launch the remaining Cluster nodes
echo "Proceeding to launch remaining Cluster nodes: "
for j in `seq 2 $((CLUSTER_NODES_SIZE))`; do
	docker run -d \
		--name $CLUSTER_NODES_NAME$j \
		--hostname $CLUSTER_NODES_HOSTNAME$j \
		-e CLUSTER_NAME=$CLUSTER_NAME \
		-e CLUSTER_JOIN="$octet1.$octet2.$octet3.2" \
		-e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD \
		-e XTRABACKUP_PASSWORD=$XTRABACKUP_PASSWORD \
	albodor/percona-cluster-haproxy
	echo "	server $CLUSTER_NODES_NAME$j $octet1.$octet2.$octet3.$((j+1)):3306 check port 9200 inter 12000 rise 3 fall 3" >> ~/cluster/haproxy/haproxy.cfg
        sleep 2
	echo "- Adding node $j to the Cluster : done !"
done
echo "Cluster nodes are deployed successfully!"

# Configuration for HAProxy

# First, build HAProxy Docker image
echo "Configuring HAProxy . . . "
echo "	- Building HAProxy Docker image!"
docker build -t "haproxy:latest" haproxy/

# Second, verify configuration file for HAProxy
echo "	- Verifying HAProxy configuration file!"
docker run -t --rm \
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
