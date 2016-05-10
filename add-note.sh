#!/usr/bin/env bash

#####################################################################################
#
# Add an remote host and configure ssh access.
#
#####################################################################################

ansible-playbook playbook/ssh-addkey.yml -u root -i hosts --ask-pass

