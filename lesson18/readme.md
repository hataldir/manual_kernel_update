# Сценарии iptables

1. Реализовать knocking port. centralRouter может попасть на ssh inetrRouter через knock скрипт (пример в материалах).

2. Добавить inetRouter2, который виден(маршрутизируется (host-only тип сети для виртуалки)) с хоста или форвардится порт через локалхост.

3. Запустить nginx на centralServer.

4. Пробросить 80й порт на inetRouter2 8080. Дефолт в инет оставить через inetRouter.

Машины взяты из предыдущего домашего задания - centralServer, centralRouter, inetRouter. Настраиваются плейбуками ansible - server.yml, central.yml, inet.yml.

# 1. Knocking port

Knocking port взят из примера в материалах, порты оставлены те же самые  (8881, 7777, 9991). Адрес inetRouter - 192.168.255.1.
Результат с centralRouter (для удобства на эту машину закидывается скрипт knock.sh, выполняющий три раза nmap, а затем ssh -l vagrant 192.168.255.1):

[vagrant@centralRouter ~]$ ssh -l vagrant 192.168.255.1
^C

[vagrant@centralRouter ~]$ cd /vagrant
[vagrant@centralRouter vagrant]$ bash ./knock.sh

Starting Nmap 6.40 ( http://nmap.org ) at 2021-08-28 12:45 UTC
Warning: 192.168.255.1 giving up on port because retransmission cap hit (0).
Nmap scan report for 192.168.255.1
Host is up (0.0028s latency).
PORT     STATE    SERVICE
8881/tcp filtered unknown
MAC Address: 08:00:27:87:95:3A (Cadmus Computer Systems)

Nmap done: 1 IP address (1 host up) scanned in 8.67 seconds

Starting Nmap 6.40 ( http://nmap.org ) at 2021-08-28 12:46 UTC
Warning: 192.168.255.1 giving up on port because retransmission cap hit (0).
Nmap scan report for 192.168.255.1
Host is up (0.0026s latency).
PORT     STATE    SERVICE
7777/tcp filtered cbt
MAC Address: 08:00:27:87:95:3A (Cadmus Computer Systems)

Nmap done: 1 IP address (1 host up) scanned in 13.40 seconds

Starting Nmap 6.40 ( http://nmap.org ) at 2021-08-28 12:46 UTC
Warning: 192.168.255.1 giving up on port because retransmission cap hit (0).
Nmap scan report for 192.168.255.1
Host is up (0.0018s latency).
PORT     STATE    SERVICE
9991/tcp filtered issa
MAC Address: 08:00:27:87:95:3A (Cadmus Computer Systems)

Nmap done: 1 IP address (1 host up) scanned in 10.96 seconds

The authenticity of host '192.168.255.1 (192.168.255.1)' can't be established.
ECDSA key fingerprint is SHA256:S0chujFnNINIWzObpYSeS/dZ4HRKQa9P9143GpMDzjU.
ECDSA key fingerprint is MD5:82:ae:35:24:ba:4d:fd:b7:5b:24:30:24:5e:92:46:e1.
Are you sure you want to continue connecting (yes/no)?


# 2. inetRouter2

Подсеть 192.168.255.0/30, использовавшаяся в прошлом домашнем задании для связи centralRouter и inetRouter, расширена до 192.168.255.0/29, чтобы добавить в нее машину inetRouter2 с адресом 192.168.255.3.
У машины inetRouter2 наружу, на хостовую машину форвардится порт 8080.

# 3. nginx

Установлен на centralServer, одной задачей в плейбуке server.yml, без каких-либо настроек. 

# 4. Проброс порта

Проброс делается двумя правилами:

iptables -t nat -A PREROUTING --dst 10.0.2.15 -p tcp --dport 8080 -j DNAT --to-destination 192.168.0.2:80

iptables -t nat -A POSTROUTING --dst 192.168.0.2 -p tcp --dport 80 -j SNAT --to-source 192.168.255.3

Правила добавляются в плейбуке inet2.yml.

Проверка с хостовой машины:

root@ekb-git2:~/linux/lesson18# curl http://localhost:8080
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <title>Welcome to CentOS</title>
  <style rel="stylesheet" type="text/css">
[skipped]
