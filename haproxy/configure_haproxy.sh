#!/bin/bash
set -e
source ~/cluster/percona_cluster.cfg

# Configuration for HAProxy
echo -n "Configuring Cluster nodes for HAProxy " ;
for i in `seq 1 30`; do
	sleep 1
	echo -n ". "
done
echo ":"
for i in `seq 1 $((CLUSTER_NODES_SIZE))`; do
	echo "Node #$i :"
	echo "	- configuring MySQL Check script!"
	docker exec $CLUSTER_NODES_NAME$i /bin/bash -c "echo 'mysqlchk	9200/tcp	# mysqlchk' >> /etc/services "
	echo "	- configuring Cluster Check account!"
	docker exec $CLUSTER_NODES_NAME$i /bin/bash -c "mysql -u root -proot -e \"grant process on *.* to 'clustercheckuser'@'%' identified by 'clustercheckpassword!';flush privileges;\" "
	echo "	- configuring MySQL Check script!"
	docker exec $CLUSTER_NODES_NAME$i /bin/bash -c "apt-get update && apt-get install -y --no-install-recommends telnet nano xinetd" > /dev/null
	docker exec $CLUSTER_NODES_NAME$i /bin/bash -c "service xinetd start" > /dev/null
done

echo "Configuring HAProxy :"
# First, build HAProxy Docker image
echo "	- Building HAProxy Docker image!"
docker build -t "haproxy:latest" ~/cluster/haproxy/

# Second, verify configuration file for HAProxy
echo "	- Verifying HAProxy configuration file!"
docker run -it --rm --name haproxy-syntax-check haproxy haproxy \
	-c -f /usr/local/etc/haproxy/haproxy.cfg

# Last, run HAProxy Docker container
echo "	- Running HAProxy Docker container!"
docker run -d \
	-p $HAPROXY_CLUSTER_PORT:3306 \
	-p $HAPROXY_WEBSTATS_PORT:80 \
	--name $HAPROXY_NODE_NAME \
	haproxy:latest

echo "HAProxy is configured successfully!"
