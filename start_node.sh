CLUSTER_NAME=${CLUSTER_NAME:-test}

echo "Starting new node..."
docker run -d -p 3306 \
	 -e MYSQL_ROOT_PASSWORD=root \
	 -e CLUSTER_NAME=${CLUSTER_NAME} \
	 -e XTRABACKUP_PASSWORD=xtrabackup \
	 percona/percona-xtradb-cluster
echo "Started $(docker ps -l -q)"
