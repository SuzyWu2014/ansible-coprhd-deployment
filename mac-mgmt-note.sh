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

echo "[coprhd]
coprhd-ingestion" > inventory.ini

ssh-keygen -t rsa -b 2048

ansible-playbook playbook/ssh-addkey.yml -u root --ask-pass

echo "[coprhd]
coprhd-ingestion ansible_connection=ssh ansible_user=root" > inventory.ini
