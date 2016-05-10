#!/usr/bin/env bash

#####################################################################################
#
# Add an remote host and configure ssh access.
#
#####################################################################################
cat >> /etc/hosts <<EOL

#Vmware environment nodes
10.193.19.243  coprhd-ingestion
10.193.17.135  coprhd-master
EOL

# echo "[coprhd]
# coprhd-ingestion
# coprhd-master" > inventory.ini

ansible-playbook playbook/ssh-addkey.yml -u root -i hosts --ask-pass

# echo "[coprhd]
# coprhd-ingestion ansible_connection=ssh ansible_user=root" > inventory.ini
