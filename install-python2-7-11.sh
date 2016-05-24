zypper remove python
zypper install gcc
zypper install make
wget https://www.python.org/ftp/python/2.7.11/Python-2.7.11.tgz
tar zxf Python-2.7.11.tgz
cd Python-2.7.11/
./configure
make
su root
make install