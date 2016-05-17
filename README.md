# ansible-coprhd-deployment

## Description: 
  This repository aims to deploy CoprHD on the remote host(hosting on vmware in my case), and deploy ScaleIO driver onto it after that. Please refer to https://coprhd.github.io/ for more information.
  Two nodes:
    Local: Mac OSX
    Remote: OpenSuse 13.2 

## Prerequisites:
 - Remote CorpHD Host: OpenSuse 13.2
 - Make sure you are able to ssh onto your coprHD host using root as username
 
## Usage:

### Ansible Set Up
  + Run `./mac-mgmt-node.sh` to install ansible and generate keygen in your mac; for ubuntu, run `./ubuntu-mgmt-node.sh `
  
  + Edit `hosts` file to specify your remote hosts; all playbooks in this repo works with hosts under group - [coprhd]
  
  + Run `./add-note.sh` to allow ansible ssh access
  
  + Run `ansible all -m ping -i hosts`
   --> The output will be:
	coprhd-ingestion | SUCCESS => {
    	"changed": false,
    	"ping": "pong"
	}

```bash
./mac-mgmt-node.sh 
vi hosts 
./add-note.sh
ansible all -m ping -i hosts 
```

### CoprHD Deployment

+ Run playbooks as below:

```bash
ansible-playbook playbook/coprhd-env-detail.yml -i hosts
ansible-playbook playbook/coprhd-deploy.yml -i hosts
```

### Playbooks Quick Look
  + `coprhd-env.yml`: use scripts provided in the coprHD repo to set up environment for coprHD host.
    * modify `ovfenv.properties` file with your own network setting
  
  + `coprhd-env-local-script.yml`: modified srcipt provided by coprHD, removing some packages: docker, virtualBox. (which cause problem in my environment)
   
  + `coprhd-env-detail.yml`: use ansible modules to set up coprHD host environment
    * need modification on ovfenv.properties beforehand
    
  + `coprhd-deploy.yml`: coprHD deployment
    - coprHD version: master branch - commit: de6886429da0d9c523fbd551952a4bf933ee5eed
      + Note: if you git clone the most updated repo, it might not work!
    - enable root ssh after deployment
      + Note: login password changed to coprHD password
      
  + `redeploy-cleanup.yml`: clean up coprhd host before performing redeployment

  + `proxy-resolve.yml`: Resolve proxy problem if you deploy coprhd behind a proxy. [On progress]

### Issues and Solutions 
  + Fail to ssh
    * solution: Login into your host, restart the ssh service

### Current issues

#### proxy issue

If you build coprHD behind the proxy, there are a couple of solutions you can try, but not guarantee work. (Unfortunetely, it didn't work for me. /:)

+ Set global environment variables
  * Option 1: edit to "hosts" file, add env variables under "[coprhd:vars]"
    - Note: Since it didn't work for me, it's not tested!
  * Option 2: Do it directly in remote host:
  
```bash 
export http_proxy=http://[Proxy Address]:[Proxy Port];
export https_proxy=http://[Proxy Address]:[Proxy Port]
export JAVA_TOOL_OPTIONS="-Dhttp.proxyHost=http://[Proxy Address] -Dhttp.proxyPort=[Proxy Port] -Dhttps.proxyHost=http://[Proxy Address] -Dhttps.proxyPort=[Proxy Port]”
```

+ Setup a Transparent Proxy using redsocks
    - Please refer to: https://coprhd.atlassian.net/wiki/display/COP/How+to+Download+and+Build+CoprHD

+ Modify the proxy in `proxy-resolve.yml`, then run the playbook
    
### Note 
  + Ansible Zypper module: till version 2.0.1.1, Ansible zypper module doesn't support (force-resolution), considering to modify ansible zypper module later.

 
