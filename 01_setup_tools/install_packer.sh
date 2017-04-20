# !/bin/bash

echo 'Downloading packer vers 1.0.0'
wget -O packer_1.0.0_linux_amd64.zip https://releases.hashicorp.com/packer/1.0.0/packer_1.0.0_linux_amd64.zip?_ga=1.227949789.1592093870.1491297717

echo 'Installing unzip'
sudo apt-get install unzip

echo 'Installing packer'
unzip packer_1.0.0_linux_amd64.zip
rm packer_1.0.0_linux_amd64.zip
sudo mv packer /usr/local/bin


