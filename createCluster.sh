#!/bin/bash
set -e

# Create a MySQL Shell container to administer the Cluster
docker run --name mysql-shell -d -it albodor/mysql-shell:latest

# Create three MySQL Server containers
docker run --name mysql-server1 -e MYSQL_ROOT_PASSWORD=p@ssw0rd -p 3333:3306 -d mysql:5.7
docker run --name mysql-server2 -e MYSQL_ROOT_PASSWORD=p@ssw0rd -p 4444:3306 -d mysql:5.7
docker run --name mysql-server3 -e MYSQL_ROOT_PASSWORD=p@ssw0rd -p 5555:3306 -d mysql:5.7
