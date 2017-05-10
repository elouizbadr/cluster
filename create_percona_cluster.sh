#!/bin/bash
set -e

# Read configuration file
source ./percona_cluster.cfg

# Extract network addresses
IFS=. read octet1 octet2 octet3 octet4 <<< "$CLUSTER_NETWORK"

# Launch the first node which is responsible for initializing the Cluster
echo "Initiatlizing Percona cluster ... "
number=1
docker run -d --name "$CLUSTER_NODES_NAME$number" --hostname "$CLUSTER_NODES_HOSTNAME$number" \
  -e CLUSTER_NAME=$CLUSTER_NAME \
  -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD \
  -e XTRABACKUP_PASSWORD=$XTRABACKUP_PASSWORD \
  percona/percona-xtradb-cluster
echo "done!"
echo -n "Waiting for first Cluster node to prepare "
for i in `seq 1 10`; do
	echo -n ". "
	sleep 1
done
echo "done!"

# Launch the remaining Cluster nodes
echo "Proceeding to launch remaining Cluster nodes: "
for i in `seq 1 $((CLUSTER_NODES_SIZE-1))`; do
	docker run -d \
		--name $CLUSTER_NODES_NAME$((i+1)) \
		--hostname $CLUSTER_NODES_HOSTNAME$((i+1)) \
		-e CLUSTER_NAME=$CLUSTER_NAME \
		-e CLUSTER_JOIN="$octet1.$octet2.$octet3.2" \
		-e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD \
		-e XTRABACKUP_PASSWORD=$XTRABACKUP_PASSWORD \
	percona/percona-xtradb-cluster 
        sleep 2
	echo "- Adding node $((i+1)) to the Cluster : done !"
done
echo "Cluster nodes are deployed successfully!"

# Configuration for HAProxy
./haproxy/configure_haproxy.sh
