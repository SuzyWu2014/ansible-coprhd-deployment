# ansible-coprhd-deployment

## Description: 
  This repository aims to deploy CoprHD on the remote host(hosting on vmware in my case), and deploy ScaleIO driver onto it after that.
  Two nodes:
    Local: Mac OSX
    Remote: OpenSuse 13.2 

## Prerequisites:
 - Remote CorpHD Host: OpenSuse 13.2
 - Make sure you are able to ssh onto your coprHD host using root as username
 
## Usage:

### Installation
  + Run ./mac-mgmt-node.sh to install ansible and generate keygen in your mac; for ubuntu, run ./ubuntu-mgmt-node.sh 
  + Edit "hosts" file to specify your remote hosts; all playbooks in this repo works with hosts under group - [coprhd]
  + Run ./add-note.sh to allow ansible ssh access
  + Run ansible all -m ping -i hosts
   --> The output will be:
	coprhd-ingestion | SUCCESS => {
    	"changed": false,
    	"ping": "pong"
	}

### Playbooks Quick Look
  + coprhd-env.yml: use scripts provided in the coprHD repo to set up environment for coprHD host.
    * modify ovfenv.properties file with your own network setting
    
  + coprhd-env-detail.yml: use ansible modules to set up coprHD host environment
    * need modification on ovfenv.properties beforehand
    
  + coprhd-deploy.yml: coprHD deployment
    - add version in git command to specify branch; Default: master
  
  + redeploy-cleanup.yml: clean up coprhd host before performing redeployment

  + proxy-resolve.yml: Resolve proxy problem if you deploy coprhd behind a proxy. [On progress]

### Issues and Solutions 
  + Fail to ssh
    * solution: Login into your host, restart the ssh service

### Current issues

#### proxy issue
+ Failed solutions
  - set system-wide proxy (set env variables)
  - use redsocks, doesn't compatible with osu proxy server
  - set proxy to gradle -> failed at play:compile; still dependency module missing
  - set gradle to play configuration file -> doesn't work 
  - directly call play deps with proxy -> failed with artifact not found
  - directly install deadbolt -> failed with module not found 
  - store deadbolt in local directory, and configure play to use local repo

+ next step:
  - dive in plugin configuration
  - gradle ivy configuration ?
  - dive more in play implementation
  - figure how gradle, ivy and play work with each other
    
### Note 
  + Ansible Zypper module: till version 2.0.1.1, Ansible zypper module doesn't support (force-resolution), will work on modify ansible zypper module later.



 
