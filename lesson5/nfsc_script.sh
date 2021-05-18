echo "192.168.50.10:/share /share  nfs vers=3,udp 0 0" >>/etc/fstab
mkdir /share
mount /share
df -h