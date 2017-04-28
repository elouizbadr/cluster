#!/bin/bash
set -e

# Download MySQL's APT Repository for Debian based OSes
sudo wget https://dev.mysql.com/get/mysql-apt-config_0.8.5-1_all.deb

# Install MySQL's APT Repository
sudo dpkg -i mysql-apt-config_0.8.5-1_all.deb

# Update the APT Packages
sudo apt-get update

# Install MySQL Server (Latest GA version) and MySQL Shell for Administration purposes
sudo apt-get install -y mysql-server mysql-shell
