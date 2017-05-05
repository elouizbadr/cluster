#!/bin/bash
set -e

# Create three Percona Server containers
docker run --name node1 --hostname node1 -d elouizbadr/percona-cluster:test
docker run --name node2 --hostname node2 -d elouizbadr/percona-cluster:test
docker run --name node3 --hostname node3 -d elouizbadr/percona-cluster:test
