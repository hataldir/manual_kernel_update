sudo useradd user1 && \
sudo useradd user2 && \
sudo useradd useradm
echo "12345"|sudo passwd --stdin user1 &&\
echo "12345" | sudo passwd --stdin user2 &&\
echo "12345" | sudo passwd --stdin useradm
groupadd admin
usermod -G admin useradm
usermod -G admin root
#echo "*;*;!admin;Wd0000-24000">>/etc/security/time.conf
#sed -i "/account    required     pam_nologin.so/a account required pam_time.so" /etc/pam.d/sshd
#account required pam_time.so

sed -i "/account    required     pam_nologin.so/a account required pam_exec.so /usr/local/bin/test_login.sh" /etc/pam.d/sshd

mv /tmp/test_login.sh /usr/local/bin/test_login.sh
mv /tmp/51-docker.rules /etc/polkit-1/rules.d/51-docker.rules
chmod +x /usr/local/bin/test_login.sh

yum install -y epel-release
yum install -y docker
systemctl enable docker
systemctl start docker
groupadd docker
usermod -G docker useradm
setenforce 0
