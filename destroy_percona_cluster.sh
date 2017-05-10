#!/bin/bash
source ./percona_cluster.cfg

# Stopping Cluster nodes
echo "Proceeding to stop Cluster nodes: "
for i in `seq 1 $((CLUSTER_NODES_SIZE))`; do
	echo "- Stopping $CLUSTER_NODES_NAME$i ! ... ";
	docker container stop $CLUSTER_NODES_NAME$i
done

# Removing Cluster nodes
echo "Proceeding to remove Cluster nodes: "
for i in `seq 1 $((CLUSTER_NODES_SIZE))`; do
	echo "- Removing $CLUSTER_NODES_NAME$i ! ... ";
	docker container rm $CLUSTER_NODES_NAME$i
done

# Removing HAProxy
echo "Proceeding to remove HAProxy node: "
docker container rm -f $HAPROXY_NODE_NAME

echo "Cluster destroyed successfully!"
