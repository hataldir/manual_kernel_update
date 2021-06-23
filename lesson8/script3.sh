mv /tmp/httpd.service /usr/lib/systemd/system/httpd@.service
mv /tmp/httpd-first /etc/sysconfig/httpd-first
mv /tmp/httpd-second /etc/sysconfig/httpd-second
systemctl daemon-reload

cd /etc/httpd/conf/
cp httpd.conf httpd-first.conf
cp httpd.conf httpd-second.conf

sed -i 's/Listen 80/Listen 8080/' httpd-second.conf
echo "PidFile /var/run/httpd-second.pid" >>httpd-second.conf

systemctl enable httpd@first
systemctl enable httpd@second
systemctl start httpd@first
systemctl start httpd@second


