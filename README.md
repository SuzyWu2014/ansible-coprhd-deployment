# ansible-coprhd-deployment

## Description:
  Please refer to https://coprhd.github.io/ for CoprHD.

  Two nodes:
    Local: Mac OSX
    Remote: OpenSuse 13.2 (Recommended at least 60GB in root filesystem, 6GB of RAM, otherwise might result in unexpected failure)

## Prerequisites:
 - Remote CorpHD Host: OpenSuse 13.2
 - Make sure you are able to ssh into your coprHD host using username(root) and password

## Usage:

### Configurations

#### Config the remote host you will be used to deploy CoprHD

+ Edit `hosts` file to specify your remote hosts; all playbooks in this repo work with hosts under group - [coprhd]
  * Replace "X.X.X.X" with the ip address of your remote hosts
+ Edit host ip/gateway/netmask in `plays/coprhd-env-setup.yml`
+ replace username "shujin" in `plays/add-user.yml` with the your desired name( default password for the user: p@ssw0rd)

#### Config coprHD repo

+ Replace the commit id "de6886429da0d9c523fbd551952a4bf933ee5eed" with the one you want to deploy. Highly recommend that you deploy with the default one, since it's guaranteed working.

### Ansible Set Up

```bash
.setup/mac-mgmt-node.sh
ansible-playbook plays/ssh-addkey.yml -i hosts --ask-pass # your root password
ansible coprhd -m ping -i hosts
```
   --> Varify output:
  coprhd-public | SUCCESS => {
      "changed": false,
      "ping": "pong"
  }

### CoprHD Deployment

+ Run playbooks: `ansible-playbook plays/[playbook] -i hosts`

```bash
ansible-playbook plays/add-user.yml -i hosts  #just in case you can't ssh into your coprhd host after deployment
ansible-playbook plays/coprhd-env-setup.yml -i hosts
ansible-playbook plays/coprhd-deploy.yml -i hosts --tags master-branch

ansible-playbook plays/coprhd-uninstall.yml -i hosts # run this before re-deploy coprhd
```

### ScaleIO driver deployment

Note: the version of master branch that is  used in this repo doesn't have the fully support of southbound SDK, namely, the scaleIO driver is not fully functioning if deployed to master branch.

``` bash
ansible-playbook plays/coprhd-deploy.yml -i hosts --tags ingestion-branch # the current lastest branch doesn't work
ansible-playbook plays/fetch-driver.confs.yml -i hosts
vi [conf-file]
ansible-playbook plays/scaleio-driver-deployment.yml -i hosts
```

#### Driver Configurations
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

#### discover ScaleIO system: (temporary approach)

Please refer to [coprhd_aio](https://github.com/curtbruns/coprhd_aio) if you need a ScaleIO system for demo.

```bash
ssh root@ip_address
cd /opt/storageos/cli/bin/
./viprcli authenticate -hn coprhd-host-ip -u root -d /tmp
./viprcli storagesystem create -hostname coprhd-host-ip -n pdomain -t scaleiosystem -dip scaleio-cluster-mdm-ip -dp 443 -u admin
```

### Playbooks Quick Look
  + `coprhd-env-org-script.yml`: use the script provided in the coprHD repo to set up environment for coprHD host.
  + `coprhd-env-local-script.yml`: use modified script provided by CoprHD, removing some packages: docker, virtualBox, etc. (which caused issues in my environment)
  + `coprhd-env-setup.yml`: use ansible modules to set up coprHD host environment
    * need modification on ovfenv.properties beforehand

  + `coprhd-deploy.yml`: coprHD deployment
    - coprHD version: master branch - commit: de6886429da0d9c523fbd551952a4bf933ee5eed
      + Note: if you git clone the most updated repo, it might not work!
    - enable root ssh after deployment
      + Note: login password changed to coprHD password

  + `coprhd-uninstall.yml`: clean up coprhd host before performing re-deployment

  + `proxy-resolve.yml`: Resolve proxy problem if you deploy coprhd behind a proxy.

  + `add-user.yml`: add an extra user to the system for ssh. password: p@ssw0rd
    * Note: after coprHD deployment, system will be set to not allow root ssh.
    * after running this playbook, make sure login into system as root, to update the password for the new user.
      - `SHA512_password.sh` you can use this script to generate the encrypted password and replace the one in the playbook

### Issues and Solutions

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


