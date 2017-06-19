#!/bin/bash
set -e

###
# Requirements : "sudo" package must be already installed and configured.
# Recommended : Launch this script using a non-privileged system user.
###

# Installing Dependencies
sudo apt-get install -y --no-install-recommends \
 curl build-essential

# Installing MongoDB
echo "Receiving MongoDB Repository Public Key ..."
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6

echo "Adding MongoDB Repository to APT List ..."
echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list

echo "Installing MongoDB Community Edition ..."
sudo apt-get update
sudo apt-get install -y mongodb-org

echo "Starting MongoDB Daemon Server ..."
sudo service mongod start

echo "Enabling MongoDB Daemon System Startup ..."
sudo systemctl enable mongod 

echo "MongoDB was installed successfully!"

# Installing Redis
echo "Installing Redis ..."
sudo apt-get install -y --no-install-recommends redis-server

echo "Starting Redis Service ..."
sudo service redis-server start

echo "Enabling Redis System Startup ..."
sudo systemctl enable redis-server

echo "Redis was installed successfully!"

# Installing Node.js
echo "Executing Node.js Installation Preparation Script ..."
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -

echo "Installing Node.js ..."
sudo apt-get install -y nodejs

echo "Node.js was installed successfully"

# Preparing and Configuring MEAN Stack
sudo npm install --global express-generator
sudo npm install --global bower
sudo npm install --global grunt

echo "MEAN Stack was installed successfully!"
