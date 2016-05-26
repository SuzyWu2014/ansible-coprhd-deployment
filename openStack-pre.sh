# set root passwd
passwd
# allow root login with password
vi /etc/ssh/sshd_config
#PermitRootLogin yes
# PasswordAuthentication yes
service sshd restart

# turn off docker0 interface
systemctl stop docker
ip link set dev docker0 down
brctl delbr docker0