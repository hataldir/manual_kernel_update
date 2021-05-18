yum install -y nfs-utils
mkdir /share
mkdir /share/upload
chmod 755 /share
chmod 777 /share/upload
systemctl enable nfs
echo "/share   192.168.50.0/24(all_squash,rw)" >/etc/exports
systemctl start nfs
