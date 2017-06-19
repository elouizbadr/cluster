#!/bin/bash

# Removing MongoDB
echo "Stopping MongoDB Service ..."
sudo service mongod stop

echo "Purging MongoDB Installation ..."
sudo apt-get purge -y mongodb-org*

echo "Deleting MongoDB Data ..."
sudo rm -r /var/log/mongodb
sudo rm -r /var/lib/mongodb

echo "MongoDB was removed successfully!"

# Removing Redis
echo "Stopping Redis Service ..."
sudo service redis-server stop

echo "Purging Redis Installation ..."
sudo apt-get purge -y redis-server

echo "Redis was removed successfully!"

# Removing Node.js
echo "Removing All Node.js Global Packages ..."
sudo npm -g ls | grep -v 'npm@' | awk '/@/ {print }' | awk -F@ '{print }' | sudo xargs npm -g rm

echo "Removing Node.js ..."
sudo apt-get purge -y nodejs

echo "Node.js was removed successfully!"

# Cleaning Up

echo "Cleaning up ..."
sudo apt-get autoremove -y
sudo apt-get autoclean -y
sudo rm -f /etc/apt/sources.list.d/node*
sudo rm -f /etc/apt/sources.list.d/mongo*
sudo apt-get update

echo "MEAN Stack was removed successfully!"
