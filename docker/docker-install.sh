#!/bin/bash

#Uninstall old versions
echo "🚫 Removing old versions of Docker..."
sudo apt-get remove docker docker-engine docker.io containerd runc

# Install using the repository
echo "🔍 Setting up repository..."
sudo apt-get update
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker’s official GPG key
echo "🔑 Adding Docker's official GPG key..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Use the following command to set up the repository
echo "🔗 Adding Docker repository..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
echo "🚀 Installing Docker..."
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

#Verify Docker Engine installation
echo "🤖 Verifying Docker Engine installation..."
sudo docker run hello-world

# Manage Docker as a non-root user
read -p "Do you want to Manage Docker as a non-root user? (y/n) " manage
if [ $manage == "y" ]; then
  echo "👥 Adding user to docker group..."
  sudo groupadd docker
  sudo usermod -aG docker $USER

  echo "🔑 Changing ownership and permissions for .docker directory..."
  sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
  sudo chmod g+rwx "$HOME/.docker" -R
fi

# Configure Docker to start on boot with systemd
read -p "Do you want to Configure Docker to start on boot with systemd? (y/n) " start
if [ $start == "y" ]; then
  echo "🚀 Enabling Docker service on boot..."
  sudo systemctl enable docker.service
  sudo systemctl enable containerd.service
fi

echo "🎉 Done! Docker is now installed on your system."
