#!/bin/bash
#
# Copyright 2015-2016 EMC Corporation
# All Rights Reserved
#

function installRepositories
{
  zypper --non-interactive --no-gpg-checks addrepo --no-check --name suse-13.2-oss \
         --no-gpgcheck http://download.opensuse.org/distribution/13.2/repo/oss/suse suse-13.2-oss
  zypper --non-interactive --no-gpg-checks addrepo --no-check --name suse-13.2-oss-update \
         --no-gpgcheck http://download.opensuse.org/repositories/openSUSE:/13.2:/Update/standard suse-13.2-oss-update
  
  zypper --non-interactive --no-gpg-checks addrepo --no-check --name suse-13.2-non-oss \
         --no-gpgcheck http://download.opensuse.org/distribution/13.2/repo/non-oss/suse suse-13.2-non-oss
  
  zypper --non-interactive --no-gpg-checks addrepo --no-check --name suse-13.2-monitoring \
         --no-gpgcheck http://download.opensuse.org/repositories/server:/monitoring/openSUSE_13.2 suse-13.2-monitoring
  zypper --non-interactive --no-gpg-checks addrepo --no-check --name suse-13.2-seife \
         --no-gpgcheck http://download.opensuse.org/repositories/home:/seife:/testing/openSUSE_13.2 suse-13.2-seife
  zypper --non-interactive --no-gpg-checks addrepo --no-check --name suse-13.2-python \
         --no-gpgcheck http://download.opensuse.org/repositories/devel:/languages:/python/openSUSE_13.2 suse-13.2-python
  zypper --non-interactive --no-gpg-checks addrepo --no-check --name suse-13.2-network \
         --no-gpgcheck http://download.opensuse.org/repositories/network:/utilities/openSUSE_13.2 suse-13.2-network
  zypper --non-interactive --no-gpg-checks addrepo --no-check --name suse-13.2-building \
         --no-gpgcheck http://download.opensuse.org/repositories/devel:/tools:/building/openSUSE_13.2 suse-13.2-building
  zypper --non-interactive --no-gpg-checks addrepo --no-check --name suse-13.2-appliances \
         --no-gpgcheck http://download.opensuse.org/repositories/Virtualization:/Appliances/openSUSE_13.2 suse-13.2-appliances
  zypper --non-interactive --no-gpg-checks addrepo --no-check --name suse-13.2-containers \
         --no-gpgcheck http://download.opensuse.org/repositories/Virtualization:/containers/openSUSE_13.2 suse-13.2-containers

  zypper --non-interactive --no-gpg-checks modifyrepo --priority  3 suse-13.2-oss
  zypper --non-interactive --no-gpg-checks modifyrepo --priority  3 suse-13.2-oss-update
  zypper --non-interactive --no-gpg-checks modifyrepo --priority 99 suse-13.2-non-oss
  zypper --non-interactive --no-gpg-checks modifyrepo --priority  1 suse-13.2-monitoring
  zypper --non-interactive --no-gpg-checks modifyrepo --priority  1 suse-13.2-seife
  zypper --non-interactive --no-gpg-checks modifyrepo --priority  4 suse-13.2-python
  zypper --non-interactive --no-gpg-checks modifyrepo --priority  4 suse-13.2-network
  zypper --non-interactive --no-gpg-checks modifyrepo --priority  5 suse-13.2-building
  zypper --non-interactive --no-gpg-checks modifyrepo --priority  1 suse-13.2-appliances
  zypper --non-interactive --no-gpg-checks modifyrepo --priority  1 suse-13.2-containers

  return 0
}

function installPackages
{
  # distribution packages
  mkdir -p /tmp/coprhd.d
  cp -f /etc/zypp/repos.d/suse-13.2-oss.repo /tmp/coprhd.d/
  cp -f /etc/zypp/repos.d/suse-13.2-monitoring.repo /tmp/coprhd.d/
  cp -f /etc/zypp/repos.d/suse-13.2-python.repo /tmp/coprhd.d/
  cp -f /etc/zypp/repos.d/suse-13.2-network.repo /tmp/coprhd.d/
  cp -f /etc/zypp/repos.d/suse-13.2-seife.repo /tmp/coprhd.d/
  cp -f /etc/zypp/repos.d/suse-13.2-containers.repo /tmp/coprhd.d/

  ISO=$(mount | grep openSUSE-13.2-DVD-x86_64.iso | cut -d ' ' -f 3)
  if [ ! -z "${ISO}" ]; then
    zypper --reposd-dir=/tmp/coprhd.d --non-interactive --no-gpg-checks addrepo --no-check --name suse-13.2-iso \
           --no-gpgcheck ${ISO} suse-13.2-iso
    zypper --reposd-dir=/tmp/coprhd.d --non-interactive --no-gpg-checks modifyrepo --priority 2 suse-13.2-iso
  fi

  zypper --reposd-dir=/tmp/coprhd.d --non-interactive --no-gpg-checks refresh
  zypper --reposd-dir=/tmp/coprhd.d --non-interactive --no-gpg-checks install --details --no-recommends --force-resolution ant apache2-mod_perl apache2-prefork atop bind-libs bind-utils ca-certificates-cacert ca-certificates-mozilla curl createrepo dhcpcd expect fontconfig fonts-config gcc-c++ GeoIP GeoIP-data git git-core glib2-devel gpgme grub2 ifplugd inst-source-utils iproute2 iputils java-1_7_0-openjdk java-1_7_0-openjdk-devel java-1_8_0-openjdk java-1_8_0-openjdk-devel keepalived kernel-default kernel-default-devel kernel-source kiwi kiwi-desc-isoboot kiwi-desc-oemboot kiwi-desc-vmxboot kiwi-templates libaudiofile1 libesd0 libgcrypt-devel libGeoIP1 libgpg-error-devel libmng2 libopenssl-devel libpcrecpp0 libpcreposix0 libqt4 libqt4-sql libqt4-x11 libSDL-1_2-0 libserf-devel libtool libuuid-devel libvpx1 libxml2-devel libXmu6 lvm2 make mkfontdir mkfontscale mozilla-nss-certs netcfg net-tools ndisc6 nfs-client openssh openssh-fips p7zip pam-devel parted pcre-devel perl-Config-General perl-Error perl-Tk plymouth python-cjson python-devel python-gpgme python-iniparse python-libxml2 python-py python-requests python-setools qemu qemu-tools readline-devel regexp rpm-build setools-libs sipcalc sshpass strongswan strongswan-ipsec strongswan-libs0 subversion sudo SuSEfirewall2 sysconfig sysconfig-netconfig syslinux sysstat systemd-logger tar telnet unixODBC vim wget xbitmaps xfsprogs xml-commons-jaxp-1.3-apis xmlstarlet xorg-x11-essentials xorg-x11-fonts xorg-x11-server xz-devel yum zlib-devel
  rm -fr /tmp/coprhd.d

  # distribution updates and security fixes
  mkdir -p /tmp/coprhd.d
  cp -f /etc/zypp/repos.d/suse-13.2-oss-update.repo /tmp/coprhd.d/

  zypper --reposd-dir=/tmp/coprhd.d --non-interactive --no-gpg-checks refresh
  zypper --reposd-dir=/tmp/coprhd.d --non-interactive --no-gpg-checks install --oldpackage lvm2=2.02.98-43.24.1 udev=210.1448627060.53ee915-25.27.1 libudev1=210.1448627060.53ee915-25.27.1
  rm -fr /tmp/coprhd.d

  zypper --non-interactive clean
}

function installJava
{
  java=$2
  [ ! -z "${java}" ] || java=8

  update-alternatives --set java /usr/lib64/jvm/jre-1.${java}.0-openjdk/bin/java
  update-alternatives --set javac /usr/lib64/jvm/java-1.${java}.0-openjdk/bin/javac
}

function installNginx
{
  mkdir -p /tmp/nginx
  wget --continue --output-document=/tmp/nginx/nginx-1.6.2.tar.gz http://nginx.org/download/nginx-1.6.2.tar.gz
  wget --continue --output-document=/tmp/nginx/v0.3.0.tar.gz https://github.com/yaoweibin/nginx_upstream_check_module/archive/v0.3.0.tar.gz
  wget --continue --output-document=/tmp/nginx/v0.25.tar.gz https://github.com/openresty/headers-more-nginx-module/archive/v0.25.tar.gz
  tar --directory=/tmp/nginx -xzf /tmp/nginx/nginx-1.6.2.tar.gz
  tar --directory=/tmp/nginx -xzf /tmp/nginx/v0.3.0.tar.gz
  tar --directory=/tmp/nginx -xzf /tmp/nginx/v0.25.tar.gz
  patch --directory=/tmp/nginx/nginx-1.6.2 -p1 < /tmp/nginx/nginx_upstream_check_module-0.3.0/check_1.5.12+.patch
  bash -c "cd /tmp/nginx/nginx-1.6.2; ./configure --add-module=/tmp/nginx/nginx_upstream_check_module-0.3.0 --add-module=/tmp/nginx/headerXs-more-nginx-module-0.25 --with-http_ssl_module --prefix=/usr --conf-path=/etc/nginx/nginx.conf"
  make --directory=/tmp/nginx/nginx-1.6.2
  make --directory=/tmp/nginx/nginx-1.6.2 install
  rm -fr /tmp/nginx
}

function installStorageOS
{
  getent group storageos || groupadd -g 444 storageos
  getent passwd storageos || useradd -r -d /opt/storageos -c "StorageOS" -g 444 -u 444 -s /bin/bash storageos
  [ ! -d /opt/storageos ] || chown -R storageos:storageos /opt/storageos
  [ ! -d /data ] || chown -R storageos:storageos /data
}

function installNetwork
{
  echo "BOOTPROTO='dhcp'"  > /etc/sysconfig/network/ifcfg-eth0
  echo "STARTMODE='auto'" >> /etc/sysconfig/network/ifcfg-eth0
  echo "USERCONTROL='no'" >> /etc/sysconfig/network/ifcfg-eth0
  ln -fs /dev/null /etc/udev/rules.d/80-net-name-slot.rules
  ln -fs /dev/null /etc/udev/rules.d/80-net-setup-link.rules
}

function installNetworkConfigurationFile
{
  eth=$2
  gateway=$3
  netmask=$4
  [ ! -z "${eth}" ] || eth=1
  [ ! -z "${gateway}" ] || gateway=$(route -n | grep 'UG[ \t]' | awk '{print $2}')
  [ ! -z "${netmask}" ] || netmask='255.255.255.0'
  ipaddr=$(ifconfig | awk '/inet addr/{print substr($2,6)}' | head -n ${eth} | tail -n 1)
  cat > /etc/ovfenv.properties <<EOF
network_1_ipaddr6=::0
network_1_ipaddr=${ipaddr}
network_gateway6=::0
network_gateway=${gateway}
network_netmask=${netmask}
network_prefix_length=64
network_vip6=::0
network_vip=${ipaddr}
node_count=1
node_id=vipr1
EOF
}

function installXorg
{
  cat > /etc/X11/xorg.conf <<EOF
Section "ServerLayout"
        Identifier     "X.org Configured"
        Screen      0  "Screen0" 0 0
        InputDevice    "Mouse0" "CorePointer"
        InputDevice    "Keyboard0" "CoreKeyboard"
EndSection

Section "Files"
        ModulePath   "/usr/lib64/xorg/modules"
        FontPath     "/usr/share/fonts/misc:unscaled"
        FontPath     "/usr/share/fonts/Type1/"
        FontPath     "/usr/share/fonts/100dpi:unscaled"
        FontPath     "/usr/share/fonts/75dpi:unscaled"
        FontPath     "/usr/share/fonts/ghostscript/"
        FontPath     "/usr/share/fonts/cyrillic:unscaled"
        FontPath     "/usr/share/fonts/misc/sgi:unscaled"
        FontPath     "/usr/share/fonts/truetype/"
        FontPath     "built-ins"
EndSection

Section "Module"
        Load  "glx"
EndSection

Section "InputDevice"
        Identifier  "Keyboard0"
        Driver      "kbd"
EndSection

Section "InputDevice"
        Identifier  "Mouse0"
        Driver      "mouse"
        Option      "Protocol" "auto"
        Option      "Device" "/dev/input/mice"
        Option      "ZAxisMapping" "4 5 6 7"
EndSection

Section "Monitor"
        Identifier   "Monitor0"
        VendorName   "Monitor Vendor"
        ModelName    "Monitor Model"
EndSection

Section "Device"
        Identifier  "Card0"
        Driver      "vmware"
        BusID       "PCI:0:15:0"
EndSection

Section "Screen"
        Identifier "Screen0"
        Device     "Card0"
        Monitor    "Monitor0"
        SubSection "Display"
                Viewport   0 0
                Depth     1
        EndSubSection
        SubSection "Display"
                Viewport   0 0
                Depth     4
        EndSubSection
        SubSection "Display"
                Viewport   0 0
                Depth     8
        EndSubSection
        SubSection "Display"
                Viewport   0 0
                Depth     15
        EndSubSection
        SubSection "Display"
                Viewport   0 0
                Depth     16
        EndSubSection
        SubSection "Display"
                Viewport   0 0
                Depth     24
        EndSubSection
EndSection
EOF
}


$1 "$@"
