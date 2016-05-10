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
   - failed to ssh: try to login to your vm and restart sshd service. You may also want to check the SuSEfirewall2.

3. CoprHD Deployment
  - Note: It will always use the newest master repo.
  - Current Status: Build failure occured in portal:playCompile. Working on it...

  Possible issues:
  - proxy issues: Still working on it.
    Failed tries:
    - set system-wide proxy (set env variables)
    - use redsocks, doesn't compatible with osu proxy server
    - set proxy to gradle -> failed at play:compile; still dependency module missing
    - set gradle to play configuration file -> doesn't work 
    - directly call play deps with proxy -> failed with artifact not found
    - directly install deadbolt -> failed with module not found 
    - store deadbolt in local directory, and configure play to use local repo

    - next step:
      - play plugin configuration
      - ivy configuration 
      - modify play implementation script to debug 
      - figure how gradle, ivy and play work with each other

  Note:

  1. Ansible Zypper module: till version 2.0.1.1, Ansible zypper module doesn't support (force-resolution)
