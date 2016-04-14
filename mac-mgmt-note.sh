#!/usr/bin/env bash
sudo easy_install pip
sudo pip install --upgrade pip
sudo pip install ansible

#the latest development version:
#pip install git+git://github.com/ansible/ansible.git@devel

cat >> /etc/hosts <<EOL

#Vmware environment nodes
10.193.19.243  coprhd-ingestion
EOL
