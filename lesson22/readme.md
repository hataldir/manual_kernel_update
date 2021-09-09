# Vlan

Целиком взята инфраструктура из домашней работы "Архитектура сетей". Добавлены еще 4 машины:
testClient1, testClient2 с одинаковыми адресами 10.10.10.254; testServer1, testServer2 с адресами 10.10.10.1.
Ансиблом в них создаются дополнительные интерфейсы eth1.2 (vlan 2) для testClient1 и testServer1 и eth1.3 для testClient2 и testServer2.

Результаты выполения пинга и arp таблицы на обоих клиентах:

[vagrant@testClient1 ~]$ ping 10.10.10.1
PING 10.10.10.1 (10.10.10.1) 56(84) bytes of data.
64 bytes from 10.10.10.1: icmp_seq=1 ttl=64 time=1.46 ms
64 bytes from 10.10.10.1: icmp_seq=2 ttl=64 time=2.40 ms
64 bytes from 10.10.10.1: icmp_seq=3 ttl=64 time=3.17 ms
^C
--- 10.10.10.1 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2004ms
rtt min/avg/max/mdev = 1.461/2.346/3.171/0.700 ms
[vagrant@testClient1 ~]$ ip neig
10.0.2.3 dev eth0 lladdr 52:54:00:12:35:03 STALE
10.0.2.2 dev eth0 lladdr 52:54:00:12:35:02 REACHABLE
10.10.10.1 dev eth1.2 lladdr 08:00:27:82:4f:ff DELAY
[vagrant@testClient1 ~]$


vagrant@testClient2 ~]$ ping 10.10.10.1
PING 10.10.10.1 (10.10.10.1) 56(84) bytes of data.
64 bytes from 10.10.10.1: icmp_seq=1 ttl=64 time=2.28 ms
64 bytes from 10.10.10.1: icmp_seq=2 ttl=64 time=2.56 ms
^C
--- 10.10.10.1 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1002ms
rtt min/avg/max/mdev = 2.283/2.422/2.562/0.147 ms
[vagrant@testClient2 ~]$ ip neig
10.0.2.2 dev eth0 lladdr 52:54:00:12:35:02 REACHABLE
10.0.2.3 dev eth0 lladdr 52:54:00:12:35:03 STALE
10.10.10.1 dev eth1.3 lladdr 08:00:27:b8:61:b2 DELAY

Тестовые серверы доступны и они разные в разных вланах.


# Bonding

Вагрантом созданы по два дополнительных интерфейса на inetRouter и centralRouter. Для них ансиблом выкладываются конфиги ifcfg-eth* и также создается конфиг
ifcfg-bond0.
Адреса: inetRouter - 10.10.20.1, centralRouter - 10.10.20.2.

Проверка отключения интерфейса на inetRouter:

[root@inetRouter vagrant]# ip a
[skipped]
4: eth2: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast master bond0 state UP group default qlen 1000
    link/ether 08:00:27:75:e1:35 brd ff:ff:ff:ff:ff:ff
5: eth3: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast master bond0 state UP group default qlen 1000
    link/ether 08:00:27:03:27:41 brd ff:ff:ff:ff:ff:ff
6: bond0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:03:27:41 brd ff:ff:ff:ff:ff:ff
    inet 10.10.20.1/24 brd 10.10.20.255 scope global bond0
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe75:e135/64 scope link
       valid_lft forever preferred_lft forever
[root@inetRouter vagrant]# cat /sys/class/net/bond0/bonding/active_slave
eth3
[root@inetRouter vagrant]# ip link set eth3 down


В это время на centralRouter:

[root@centralRouter vagrant]# ping 10.10.20.1
PING 10.10.20.1 (10.10.20.1) 56(84) bytes of data.
[skipped]
--- 10.10.20.1 ping statistics ---
38 packets transmitted, 38 received, 0% packet loss, time 37075ms
rtt min/avg/max/mdev = 1.125/2.081/4.270/0.598 ms
