mv /tmp/watchlog /etc/sysconfig/watchlog
mv /tmp/watchlog.sh /opt/watchlog.sh
chmod +x /opt/watchlog.sh
mv /tmp/watchlog.service /etc/systemd/system/watchlog.service
mv /tmp/watchlog.timer /etc/systemd/system/watchlog.timer
systemctl start watchlog.timer
cd /var/log
cp secure watchlog.log
echo ALERT>>watchlog.log
cat secure>>watchlog.log

