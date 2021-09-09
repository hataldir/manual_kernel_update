# OSPF

Поднять три виртуалки, Объединить их разными vlan, поднять OSPF между машинами на базе Quagga;

Изобразить ассиметричный роутинг;

Сделать один из линков "дорогим", но что бы при этом роутинг был симметричным.


Созданы три виртуалки Router1, Router2, Router3 и три подсети 192.168.1.0/24, 192.168.2.0/24, 192.168.3.0/24

Router1 имеет адреса:

eth1 - 192.168.1.1

eth2 - 192.168.2.1

Router2 имеет адреса:

eth1 - 192.168.1.2

eth2 - 192.168.3.2

Router3 имеет адреса:

eth1 - 192.168.2.3

eth2 - 192.168.3.3

На всех машинах установлена quagga, все перечисленные интерфейсы добавлены в area 0. Асимметричный роутинг включен.

Запускаю с Router3 пинг до 192.168.1.2. Результат tcpdump на Router2:

[root@Router2 vagrant]# tcpdump -n -i eth1 icmp

tcpdump: verbose output suppressed, use -v or -vv for full protocol decode

listening on eth1, link-type EN10MB (Ethernet), capture size 262144 bytes

06:20:05.635408 IP 192.168.2.3 > 192.168.1.2: ICMP echo request, id 1161, seq 536, length 64

06:20:06.638898 IP 192.168.2.3 > 192.168.1.2: ICMP echo request, id 1161, seq 537, length 64

06:20:07.639929 IP 192.168.2.3 > 192.168.1.2: ICMP echo request, id 1161, seq 538, length 64

06:20:08.640651 IP 192.168.2.3 > 192.168.1.2: ICMP echo request, id 1161, seq 539, length 64

06:20:09.643010 IP 192.168.2.3 > 192.168.1.2: ICMP echo request, id 1161, seq 540, length 64

^C

5 packets captured

5 packets received by filter

0 packets dropped by kernel

[root@Router2 vagrant]# tcpdump -n -i eth2 icmp

tcpdump: verbose output suppressed, use -v or -vv for full protocol decode

listening on eth2, link-type EN10MB (Ethernet), capture size 262144 bytes

06:20:13.650890 IP 192.168.1.2 > 192.168.2.3: ICMP echo reply, id 1161, seq 544, length 64

06:20:14.654386 IP 192.168.1.2 > 192.168.2.3: ICMP echo reply, id 1161, seq 545, length 64

06:20:15.654884 IP 192.168.1.2 > 192.168.2.3: ICMP echo reply, id 1161, seq 546, length 64

06:20:16.657303 IP 192.168.1.2 > 192.168.2.3: ICMP echo reply, id 1161, seq 547, length 64

06:20:17.659137 IP 192.168.1.2 > 192.168.2.3: ICMP echo reply, id 1161, seq 548, length 64

06:20:18.660909 IP 192.168.1.2 > 192.168.2.3: ICMP echo reply, id 1161, seq 549, length 64

^C

6 packets captured

6 packets received by filter

0 packets dropped by kernel

Пакеты приходят на интерфейс eth1, а ответы уходят через интерфейс eth2.
 

Теперь меняем стоимость линка между Router2 и Router3

[root@Router2 vagrant]# telnet localhost 2604

Trying ::1...

telnet: connect to address ::1: Connection refused

Trying 127.0.0.1...

Connected to localhost.

Escape character is '^]'.

Hello, this is Quagga (version 0.99.22.4).

Copyright 1996-2005 Kunihiro Ishiguro, et al.


User Access Verification

Password:

Router2> en

Password:

Router2# conf t

Router2(config)# int eth2

Router2(config-if)# ip ospf cost 1000

Router2(config-if)# exit

Router2(config)# exit

Router2# exit

Connection closed by foreign host.

И результат tcpdump. Пакеты перестали ходить через этот линк и идут через Router1

[root@Router2 vagrant]#  tcpdump -n -i eth1 icmp

tcpdump: verbose output suppressed, use -v or -vv for full protocol decode

listening on eth1, link-type EN10MB (Ethernet), capture size 262144 bytes

10:58:53.073914 IP 192.168.2.3 > 192.168.1.2: ICMP echo request, id 2640, seq 148, length 64

10:58:53.073954 IP 192.168.1.2 > 192.168.2.3: ICMP echo reply, id 2640, seq 148, length 64

10:58:54.074583 IP 192.168.2.3 > 192.168.1.2: ICMP echo request, id 2640, seq 149, length 64

10:58:54.074632 IP 192.168.1.2 > 192.168.2.3: ICMP echo reply, id 2640, seq 149, length 64

10:58:55.078040 IP 192.168.2.3 > 192.168.1.2: ICMP echo request, id 2640, seq 150, length 64

10:58:55.078088 IP 192.168.1.2 > 192.168.2.3: ICMP echo reply, id 2640, seq 150, length 64

10:58:56.081153 IP 192.168.2.3 > 192.168.1.2: ICMP echo request, id 2640, seq 151, length 64

10:58:56.081193 IP 192.168.1.2 > 192.168.2.3: ICMP echo reply, id 2640, seq 151, length 64

^C

8 packets captured

9 packets received by filter

0 packets dropped by kernel
