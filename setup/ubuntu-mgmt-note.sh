#!/usr/bin/env bash

sudo apt-get update
# install ansible (http://docs.ansible.com/intro_installation.html)
sudo apt-get -y install software-properties-common
sudo apt-add-repository -y ppa:ansible/ansible
sudo apt-get update
sudo apt-get -y install ansible


