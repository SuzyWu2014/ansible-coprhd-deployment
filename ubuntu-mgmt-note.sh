#!/usr/bin/env bash

sudo apt-get update
# install ansible (http://docs.ansible.com/intro_installation.html)
sudo apt-get -y install software-properties-common
sudo apt-add-repository -y ppa:ansible/ansible
sudo apt-get update
sudo apt-get -y install ansible

# configure hosts file for the associated hosts
cat >> /etc/hosts <<EOL

# vagrant environment nodes
192.168.9.60  ansible-mgmt
192.168.9.61  ansible-lb
192.168.9.62  ansible-host1
192.168.9.63  ansible-host2
192.168.9.64  ansible-host3
EOL
