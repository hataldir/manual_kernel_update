yum install -y epel-release 
yum install -y spawn-fcgi php php-cli httpd mod_fcgid 
mv /tmp/spawn-fcgi /etc/sysconfig/spawn-fcgi
mv /tmp/spawn-fcgi.service /etc/systemd/system/spawn-fcgi.service
systemctl enable spawn-fcgi.service
systemctl start spawn-fcgi.service

