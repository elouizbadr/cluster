#!/bin/bash

# Destroy MySQL Shell container instance
docker container rm -f mysql-shell

# Destroy MySQL Server containers instances
docker container rm -f mysql-server1
docker container rm -f mysql-server2
docker container rm -f mysql-server3
