#!/bin/bash

cat >> /etc/mysql/my.cnf << EOL

[mysqld]
wsrep_provider=/usr/lib/libgalera_smm.so

wsrep_cluster_name=pxc-cluster
wsrep_cluster_address=gcomm://172.17.0.1,172.17.0.2,172.17.0.3

wsrep_node_name=pxc1
wsrep_node_address=192.168.70.61

wsrep_sst_method=xtrabackup-v2
wsrep_sst_auth=sstuser:passw0rd

pxc_strict_mode=ENFORCING

binlog_format=ROW
default_storage_engine=InnoDB
innodb_autoinc_lock_mode=2

EOL
