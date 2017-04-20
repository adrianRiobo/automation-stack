# !/bin/bash

TERRAFORM_VERSION=0.9.3
TERRAFORM_DOWNLOAD_URL=https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/terraform_$TERRAFORM_VERSION_linux_amd64.zip

echo "Downloading terraform vers $TERRAFORM_VERSION"
wget -O $TERRAFORM_DOWNLOAD_URL

echo 'Installing unzip'
sudo apt-get install unzip

echo 'Installing terraform'
unzip terraform_$TERRAFORM_VERSION_linux_amd64.zip
rm packer_$TERRAFORM_VERSION_linux_amd64.zip
sudo mv terraform /usr/local/bin


