# VPN

Между двумя виртуалками поднять vpn в режимах
tun;
tap; Прочуствовать разницу.
Поднять RAS на базе OpenVPN с клиентскими сертификатами, подключиться с локальной машины на виртуалку.


# Туннель tun

Туннель создается скриптом /opt/tun, скрипт запускает systemd после запуска сети при старте машины

Скрипт такой:

ip tunnel add tun2 mode ipip remote 192.168.1.1 local 192.168.1.2 dev eth1

ip address add 192.168.2.2/24 dev tun2

ip link set tun2 up


Результат:

5: tun2@eth1: <POINTOPOINT,NOARP,UP,LOWER_UP> mtu 1480 qdisc noqueue state UNKNOWN group default qlen 1000

    link/ipip 192.168.1.2 peer 192.168.1.1

    inet 192.168.2.2/24 scope global tun2

       valid_lft forever preferred_lft forever

    inet6 fe80::5efe:c0a8:102/64 scope link

       valid_lft forever preferred_lft forever

[root@Client vagrant]# ping 192.168.2.1

PING 192.168.2.1 (192.168.2.1) 56(84) bytes of data.

64 bytes from 192.168.2.1: icmp_seq=1 ttl=64 time=3.71 ms

64 bytes from 192.168.2.1: icmp_seq=2 ttl=64 time=2.64 ms

^C

--- 192.168.2.1 ping statistics ---

2 packets transmitted, 2 received, 0% packet loss, time 1002ms

rtt min/avg/max/mdev = 2.642/3.176/3.710/0.534 ms




# Туннель tap

Вариантов создания простого туннеля tap не нашел. Только через openvpn.

# Openvpn

Openvpn устанавливается на машине Server, подключаемся к нему с машины Client, команда сохранена в скрипте /home/vagrant/start.sh 

(openvpn --config /etc/openvpn/client.ovpn)
 
Лог запуска:

[root@Client vagrant]# ./start.sh

Fri Oct  8 09:50:21 2021 WARNING: file '/etc/openvpn/client.key' is group or others accessible

Fri Oct  8 09:50:21 2021 OpenVPN 2.4.11 x86_64-redhat-linux-gnu [Fedora EPEL patched] [SSL (OpenSSL)] [LZO] [LZ4] [EPOLL] [PKCS11] [MH/PKTINFO] [AEAD] built on Apr 21 2021

Fri Oct  8 09:50:21 2021 library versions: OpenSSL 1.0.2k-fips  26 Jan 2017, LZO 2.06

Fri Oct  8 09:50:21 2021 WARNING: No server certificate verification method has been enabled.  See http://openvpn.net/howto.html#mitm for more info.

Fri Oct  8 09:50:21 2021 TCP/UDP: Preserving recently used remote address: [AF_INET]192.168.1.1:1194

Fri Oct  8 09:50:21 2021 Socket Buffers: R=[212992->212992] S=[212992->212992]

Fri Oct  8 09:50:21 2021 UDP link local: (not bound)

Fri Oct  8 09:50:21 2021 UDP link remote: [AF_INET]192.168.1.1:1194

Fri Oct  8 09:50:21 2021 TLS: Initial packet from [AF_INET]192.168.1.1:1194, sid=7798ba55 c2c6c1cb

Fri Oct  8 09:50:21 2021 VERIFY OK: depth=1, CN=Server

Fri Oct  8 09:50:21 2021 VERIFY OK: depth=0, CN=1.1.1.1

Fri Oct  8 09:50:21 2021 Control Channel: TLSv1.2, cipher TLSv1/SSLv3 ECDHE-RSA-AES256-GCM-SHA384, 2048 bit RSA

Fri Oct  8 09:50:21 2021 [1.1.1.1] Peer Connection Initiated with [AF_INET]192.168.1.1:1194

Fri Oct  8 09:50:22 2021 SENT CONTROL [1.1.1.1]: 'PUSH_REQUEST' (status=1)

Fri Oct  8 09:50:22 2021 PUSH: Received control message: 'PUSH_REPLY,route 172.16.1.0 255.255.255.0,route 172.16.0.1,topology net30,ping 10,ping-restart 120,ifconfig 172.16.0.6 172.16.0.5,peer-id 1,cipher AES-256-GCM'

Fri Oct  8 09:50:22 2021 OPTIONS IMPORT: timers and/or timeouts modified

Fri Oct  8 09:50:22 2021 OPTIONS IMPORT: --ifconfig/up options modified

Fri Oct  8 09:50:22 2021 OPTIONS IMPORT: route options modified

Fri Oct  8 09:50:22 2021 OPTIONS IMPORT: peer-id set

Fri Oct  8 09:50:22 2021 OPTIONS IMPORT: adjusting link_mtu to 1625

Fri Oct  8 09:50:22 2021 OPTIONS IMPORT: data channel crypto options modified

Fri Oct  8 09:50:22 2021 Data Channel: using negotiated cipher 'AES-256-GCM'

Fri Oct  8 09:50:22 2021 Outgoing Data Channel: Cipher 'AES-256-GCM' initialized with 256 bit key

Fri Oct  8 09:50:22 2021 Incoming Data Channel: Cipher 'AES-256-GCM' initialized with 256 bit key

Fri Oct  8 09:50:22 2021 ROUTE_GATEWAY 10.0.2.2/255.255.255.0 IFACE=eth0 HWADDR=52:54:00:4d:77:d3

Fri Oct  8 09:50:22 2021 TUN/TAP device tun0 opened

Fri Oct  8 09:50:22 2021 TUN/TAP TX queue length set to 100

Fri Oct  8 09:50:22 2021 /sbin/ip link set dev tun0 up mtu 1500

Fri Oct  8 09:50:23 2021 /sbin/ip addr add dev tun0 local 172.16.0.6 peer 172.16.0.5

Fri Oct  8 09:50:23 2021 /sbin/ip route add 172.16.1.0/24 via 172.16.0.5

Fri Oct  8 09:50:23 2021 /sbin/ip route add 172.16.0.1/32 via 172.16.0.5

Fri Oct  8 09:50:23 2021 WARNING: this configuration may cache passwords in memory -- use the auth-nocache option to prevent this

Fri Oct  8 09:50:23 2021 Initialization Sequence Completed


Результат:

7: tun0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UNKNOWN group default qlen 100

    link/none

    inet 172.16.0.6 peer 172.16.0.5/32 scope global tun0

       valid_lft forever preferred_lft forever

    inet6 fe80::c0f5:29fd:a8bb:fec3/64 scope link flags 800

       valid_lft forever preferred_lft forever
