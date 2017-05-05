#!/bin/bash
set -e

# Install dependencies
echo "Installing dependencies ... "
sudo apt-get install -y \
 apt-transport-https ca-certificates curl gnupg2 software-properties-common

# Add Docker's official GPG key
echo "Adding Docker's official GPG key ... "
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

# Add Docker's APT repository
sudo add-apt-repository \
"deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
echo "Adding Docker repository to APT ... done!"

# Install Docker-CE
echo "Updating APT repositories ... "
sudo apt-get update
echo "Installing latest Docker-CE ... "
sudo apt-get install -y docker-ce

# Verify Docker-CE Installation
echo "Verifying Docker-CE installation ... "
sudo docker run hello-world

# To use Docker-CE without "sudo"
sudo usermod -aG docker $USER
echo "Running postinstallation configuration ... done! "
echo "Docker-CE installed Successfully!"
echo "Please log out and log back to be able to run docker commands without 'sudo'."
