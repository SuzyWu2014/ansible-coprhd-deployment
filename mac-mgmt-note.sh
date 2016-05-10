#!/usr/bin/env bash
#####################################################################################
#
# This script installs ansible in your mac and generate ssh-key for later note access.
#
#####################################################################################
sudo easy_install pip
sudo pip install --upgrade pip
sudo pip install ansible

#the latest development version:
#pip install git+git://github.com/ansible/ansible.git@devel

ssh-keygen -t rsa -b 2048

