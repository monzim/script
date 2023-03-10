#!/bin/bash

# Docker Installation Script for Ubuntu
# Original Author: https://docs.docker.com/engine/install/ubuntu/ and ChatGPT
# Modified by: Azraf Al Monzim @Monzim
#   -

#Uninstall old versions
echo "π« Removing old versions of Docker..."
sudo apt-get remove docker docker-engine docker.io containerd runc;

# Install using the repository
echo "π Setting up repository..."
sudo apt-get update;
sudo apt-get install -y ca-certificates curl gnupg lsb-release;

# Add Dockerβs official GPG key
echo "π Adding Docker's official GPG key..."
sudo mkdir -p /etc/apt/keyrings;
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg;

# Use the following command to set up the repository
echo "π Adding Docker repository..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
echo "π Installing Docker..."
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

#Verify Docker Engine installation
echo "π€ Verifying Docker Engine installation..."
sudo docker run hello-world

# Install Docker Compose
echo "π Installing Docker Compose..."
sudo apt-get install -y docker-compose


# Manage Docker as a non-root user
read -p "Do you want to Manage Docker as a non-root user? (Y/n) " manage
if [ $manage == "Y" ]; then
  echo "π₯ Adding user to docker group..."
  sudo groupadd docker
  sudo usermod -aG docker $USER

  echo "π Changing ownership and permissions for .docker directory..."
  sudo mkdir -p /home/"$USER"/.docker
  sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
  sudo chmod g+rwx "$HOME/.docker" -R
fi

# Configure Docker to start on boot with systemd
read -p "Do you want to Configure Docker to start on boot with systemd? (Y/n) " start
if [ $start == "Y" ]; then
  echo "π Enabling Docker service on boot..."
  sudo systemctl enable docker.service
  sudo systemctl enable containerd.service
fi

echo "π Done! Docker is now installed on your system."
echo "π For more information, visit https://docs.docker.com/engine/install/ubuntu/"


