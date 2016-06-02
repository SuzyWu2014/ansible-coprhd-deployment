# ansible-coprhd-deployment

## Description: 
  Please refer to https://coprhd.github.io/ for CoprHD.

  Two nodes:
    Local: Mac OSX
    Remote: OpenSuse 13.2 

## Prerequisites:
 - Remote CorpHD Host: OpenSuse 13.2
 - Make sure you are able to ssh into your coprHD host using root as username
 
## Usage:

### Ansible Set Up
  + Run `./mac-mgmt-node.sh` to install ansible and generate keygen in your mac; for ubuntu, run `./ubuntu-mgmt-node.sh `
  
  + Edit `hosts` file to specify your remote hosts; all playbooks in this repo works with hosts under group - [coprhd]
  
  + Run `./add-note.sh` to allow ansible ssh access
  
  + Run `ansible all -m ping -i hosts`
   --> Varify output:
	coprhd-public | SUCCESS => {
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

+ Modify user name in `add-user.yml`
+ Modify network setting in `ovfenv.properties`
+ Run playbooks: `ansible-playbook playbook/[playbook] -i hosts`

```bash
ansible-playbook playbook/coprhd-env-detail.yml -i hosts
ansible-playbook playbook/add-user.yml -i hosts
ssh root@XX.XX.XX.XX
sudo passwd [newUser]
exit
ansible-playbook playbook/coprhd-deploy.yml -i hosts
```

### ScaleIO driver deployment

``` bash 
ansible-playbook playbook/retrieve-driver-configuration-files.yml -i hosts
ansible-playbook playbook/scaleio-driver-deployment.yml -i hosts
```

#### Configurations
+ controller-conf.xml 
  * line 403: add the following bean or uncomment it's if already there.
``` xml
<!-- Driver class for scaleio block storage driver -->
<bean id="scaleioStorageDriver" class="com.emc.storageos.driver.scaleio.ScaleIOStorageDriver">
</bean>
```
  
  * line 396: add scaleiosystem entry
```xml 
  <bean id="externalBlockStorageDevice" class="com.emc.storageos.volumecontroller.impl.externaldevice.ExternalBlockStorageDevice">
      <property name="dbClient" ref="dbclient"/>
      <property name="locker" ref="locker"/>
      <property name="exportMaskOperationsHelper" ref="externalDeviceExportMaskOperationsHelper"/>
      <!-- Block storage drivers -->
      <property name="drivers">
          <map>
              
              <entry key="scaleiosystem" value-ref="scaleioStorageDriver"/>
              
              <entry key="driversystem" value-ref="storageDriverSimulator"/>
          </map>
      </property>
  </bean>
```

+ discovery-externaldevice-context.xml 
  * line 8: add following bean 
```xml 
 <bean id="scaleioDriver" class="com.emc.storageos.driver.scaleio.ScaleIOStorageDriver">
 </bean>
```
  
  * line 17: add scaleiosystem entry
```xml 
     <bean id="externaldevice" class="com.emc.storageos.volumecontroller.impl.plugins.ExternalDeviceCommunicationInterface">
         <!-- Discovery storage drivers -->
         <property name="drivers">
             <map>
                <entry key="scaleiosystem" value-ref="scaleioDriver"/>
                <entry key="driversystem" value-ref="storageDriverSimulator"/>
            </map>
        </property>
    </bean>

```

+ storagesystem.py 
  * line 91: add "scaleiosystem" to the list
```python 
    CREATE_SYSTEM_TYPE_LIST = [
        'scaleiosystem',
        'isilon',
        'vnxblock',
        'vmax',
        'vnxfile',
        'netapp',
        'hds',
        'openstack',
        'ibmxiv',
        'netappc',
        'ecs' , 
        'vnxe']
```

+ controllersvc-debug
  * add `:${LIB_DIR}/scaleiodriver.jar"` to the end of classpath

### Playbooks Quick Look
  + `coprhd-env.yml`: use the script provided in the coprHD repo to set up environment for coprHD host.
    * modify `ovfenv.properties` file with your own network setting
  
  + `coprhd-env-local-script.yml`: use modified script provided by CoprHD, removing some packages: docker, virtualBox, etc. (which caused issues in my environment)
   
  + `coprhd-env-detail.yml`: use ansible modules to set up coprHD host environment
    * need modification on ovfenv.properties beforehand
    
  + `coprhd-deploy.yml`: coprHD deployment
    - coprHD version: master branch - commit: de6886429da0d9c523fbd551952a4bf933ee5eed
      + Note: if you git clone the most updated repo, it might not work!
    - enable root ssh after deployment
      + Note: login password changed to coprHD password
      
  + `redeploy-cleanup.yml`: clean up coprhd host before performing re-deployment

  + `proxy-resolve.yml`: Resolve proxy problem if you deploy coprhd behind a proxy.

  + `add-user.yml`: add an extra user to the system for ssh.
    * Note: after coprHD deployment, system will be set to not allow root ssh.
    * after running this playbook, make sure login into system as root, to update the password for the new user.
    
### Issues and Solutions 

#### import error: No module named ****
+ zypper install python-setuptools

#### Fail to ssh
+ solution: Login into your host, restart the ssh service
+ check /etc/ssh/sshd_config to allow root and password
+ check your firewall
+ restart the host

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

 
