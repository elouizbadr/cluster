#!/bin/bash

###
# Requirments: "sudo" package must be already installed and configured.
# Recommended: Run this script with a non-priveleged user account.
###

set -e
OSNAME=${OSNAME:-debian}
DockerComposeVersion=${DockerComposeVersion:-1.13.0}

# Install dependencies
echo "Installing dependencies ... "
sudo apt-get update && sudo apt-get install -y --no-install-recommends \
 apt-transport-https ca-certificates curl gnupg2 \
 software-properties-common lsb-release

# Add Docker's official GPG key
echo "Adding Docker's official GPG key ... "
curl -fsSL https://download.docker.com/linux/$OSNAME/gpg | sudo apt-key add -

# Add Docker's APT repository
sudo add-apt-repository \
"deb [arch=amd64] https://download.docker.com/linux/$OSNAME $(lsb_release -cs) stable"
echo "Adding Docker repository to APT ... done!"

# Install Docker-CE
echo "Updating APT repositories ... "
sudo apt-get update
echo "Installing latest Docker-CE ... "
sudo apt-get install -y docker-ce
echo "Installing Docker Compose v$DockerComposeVersion ... "
curl -L https://github.com/docker/compose/releases/download/$DockerComposeVersion/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Verify Docker-CE Installation
echo "Verifying Docker-CE installation ... "
sudo docker run hello-world

# Enable Docker-CE to start with OS
echo "Enabling Docker with SystemD ... "
sudo systemctl enable docker

# To use Docker-CE without "sudo"
if [ "$EUID" -ne 0 ]
  then sudo usermod -aG docker $USER
  echo "Running postinstallation configuration ... done! "
  echo "Please log out and log back to be able to run docker commands without 'sudo'."
fi

echo "Docker-CE installed Successfully!"
