#!/bin/bash
set -e
NETWORK=${NETWORK:-172.17.0.0}
CLUSTER_NAME=${CLUSTER_NAME:-percona_cluster}
NUMBER_OF_NODES=${NUMBER_OF_NODES:-3}
MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-root}
XTRABACKUP_PASSWORD=${XTRABACKUP_PASSWORD:-$MYSQL_ROOT_PASSWORD}

# Extract network addresses
IFS=. read octet1 octet2 octet3 octet4 <<< "$NETWORK"

# Launch the first node which is responsible for initializing the Cluster
echo "Initiatlizing Percona cluster ... "
docker run -d -p 3306 --name node1 --hostname node1 \
  -e CLUSTER_NAME=$CLUSTER_NAME \
  -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD \
  -e XTRABACKUP_PASSWORD=$XTRABACKUP_PASSWORD \
  percona/percona-xtradb-cluster
echo "done!"
echo -n "Waiting for first Cluster node to prepare "
sleep 1; echo -n ". ";sleep 1; echo -n ". ";
sleep 1; echo -n ". ";sleep 1; echo ". done!"

# Launch the remaining Cluster nodes
echo "Proceeding to launch remaining Cluster nodes: "
for i in `seq 1 $((NUMBER_OF_NODES-1))`; do
	docker run -d -p 3306 --name node$((i+1)) --hostname node$((i+1)) \
		-e CLUSTER_NAME=$CLUSTER_NAME \
		-e CLUSTER_JOIN="$octet1.$octet2.$octet3.2" \
		-e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD \
		-e XTRABACKUP_PASSWORD=$XTRABACKUP_PASSWORD \
	percona/percona-xtradb-cluster 
        sleep 2
	echo "- Adding node $((i+1)) to the Cluster : done !"
done
echo "Cluster deployed successfully!"

# Configuration for HAProxy
echo -n "Configuring Cluster nodes for HAProxy " ;
for i in `seq 1 10`; do
	sleep 1
	echo -n ". "
done
echo ":"
for i in `seq 1 $((NUMBER_OF_NODES))`; do
	echo "Node #$i :"
	echo "	- configuring MySQL Check script!"
	docker exec node$i /bin/bash -c "echo 'mysqlchk	9200/tcp	# mysqlchk' >> /etc/services " > /dev/null
	echo "	- configuring Cluster Check account!"
	docker exec node$i /bin/bash -c "mysql -u root -proot -e \"grant process on *.* to 'clustercheckuser'@'%' identified by 'clustercheckpassword!';flush privileges;\"" > /dev/null
	echo "	- configuring MySQL Check script!"
	docker exec node$i /bin/bash -c "apt-get update && apt-get install -y --no-install-recommends telnet nano xinetd" > /dev/null
	docker exec node$i /bin/bash -c "service xinetd start" > /dev/null
done
echo "	- checking HAProxy configuration!"
haproxy/check_haproxy_config.sh > /dev/null # Check HAProxy config file for syntax error
echo "	- running HAProxy proxy!"
haproxy/run_haproxy.sh > /dev/null # Run HAProxy Docker container
echo "Cluster configured successfully for HAProxy!"
