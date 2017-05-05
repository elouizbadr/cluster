#!/bin/bash
set -e
NUMBER_OF_NODES=${NUMBER_OF_NODES:-3}

# Stopping Cluster nodes
echo "Proceeding to stop Cluster nodes: "
for i in `seq 1 $((NUMBER_OF_NODES))`; do
	echo "- Stopping node$i ! ... ";
	docker container stop node$i
done

# Removing Cluster nodes
echo "Proceeding to remove Cluster nodes: "
for i in `seq 1 $((NUMBER_OF_NODES))`; do
	echo "- Removing node$i ! ... ";
	docker container rm node$i
done
echo "Cluster destroyed successfully!"
