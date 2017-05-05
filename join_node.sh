CLUSTER_NAME=${CLUSTER_NAME:-test}

echo "Adding new node to existing cluster ..."
docker run -d -p 3306 \
	 -e MYSQL_ROOT_PASSWORD=root \
	 -e CLUSTER_NAME=${CLUSTER_NAME} \
         -e CLUSTER_JOIN=172.17.0.2 \
	 -e XTRABACKUP_PASSWORD=xtrabackup \
	 percona/percona-xtradb-cluster
echo "Added $(docker ps -l -q)"
