#!/bin/bash
set -e
source ~/cluster/percona_cluster.cfg

##
# Create a specific user for Benchmarking
#	- username : sysadmin
#	- password : sysadmin
##
#echo "Creating a MySQL user account specifically for Benchmarking . . . "
#echo " GRANT ALL ON *.* TO 'sysadmin'@'%' IDENTIFIED BY 'sysadmin'; " | mysql -h 172.17.0.2 -u root -P 3306 -p$MYSQL_ROOT_PASSWORD
#echo "OK!"

##
# Disabling PXC Strict Mode
##
#echo "Disabling 'pxc_strict_mode' on all Cluster nodes . . . "
#for i in `seq 1 $CLUSTER_NODES_SIZE`; do
#	docker exec $CLUSTER_NODES_NAME$i /bin/bash -c "mysql -u root -proot -e \" SET GLOBAL pxc_strict_mode=DISABLED ;\" "
#done 
#echo "OK!"

##
# Loading "EMPLOYEES" test database to the Cluster
##
( cd employees_db && mysql -h 172.17.0.2 -u sysadmin -P 3306 -psysadmin -t < employees.sql)
