# !/bin/bash

echo 'Install dependencies'
sudo apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

echo 'Adding repository'
sudo add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) \
       stable"

echo 'Install docker'
sudo apt-get update
sudo apt-get -y install docker-ce

echo 'Users'
sudo groupadd docker
sudo usermod -aG docker $USER

echo 'Start on boot'
sudo systemctl enable docker

echo 'Reboot to apply changes'
sudo reboot

