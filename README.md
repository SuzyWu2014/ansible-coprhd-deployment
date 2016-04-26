# ansible-coprhd-deployment

Description: 
  This repository aims to deploy CoprHD on the remote host(hosting on vmware in my case), and deploy ScaleIO driver onto it after that.
  Two nodes:
    Local: Mac OSX
    Remote: OpenSuse on Vmware

Prerequisites:
 - CorpHD Host: OpenSuse 13.2
 - Make sure you are able to ssh onto your coprHD host using root as username
 
Usage:

1. Installation
 - Modify coprHD remote host ip on mac-mgmt-node.sh
 - Run sudo ./mac-mgmt-node.sh (need to modify /etc/hosts file), and don't miss to enter the SSH password in the end
 - Run ansible all -m ping -i hosts
   --> The output will be:
	coprhd-ingestion | SUCCESS => {
    	"changed": false,
    	"ping": "pong"
	}

 - If it fails, check your ssh setting, and run it again.
 
2. Configure OpenSuse environment for CoprHD
 - Run ansible-playbook playbook/coprhd-env.yml -i hosts

 - Possible issues:
   - failed to ssh: try to restart sshd service.
