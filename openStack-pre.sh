# set root passwd
passwd
# allow root login with password
vi /etc/ssh/sshd_config

#PermitRootLogin yes
# PasswordAuthentication yes

service sshd restart
