#!/bin/bash
set -e

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
echo "	- checking HAProxy configuration!"
./haproxy/check_haproxy_config.sh > /dev/null # Check HAProxy config file for syntax error
echo "	- running HAProxy proxy!"
./haproxy/run_haproxy.sh > /dev/null # Run HAProxy Docker container
echo "Cluster configured successfully for HAProxy!"
