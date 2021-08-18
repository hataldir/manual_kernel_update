# Теоретическая часть
- Найти свободные подсети

Свободные подсети в 192.168.0.0/16:

192.168.0.16/28

192.168.0.48/28

192.168.0.128/25

Все подсети /24 с 192.168.3.0 до 192.168.254.0

Все подсети /30 с 192.168.255.4 до 192.168.255.252, две из них возьмем для связи Office 1 и Office 2 с центральным.


- Посчитать сколько узлов в каждой подсети, включая свободные
- Указать broadcast адрес для каждой подсети

Узлы и броадкасты:

192.168.2.0/26  - 62 узла, броадкаст 192.168.2.63

192.168.2.64/26  - 62 узла, броадкаст 192.168.2.127

192.168.2.128/26  - 62 узла, броадкаст 192.168.2.191

192.168.2.192/26  - 62 узла, броадкаст 192.168.2.255

192.168.1.0/25   - 126 узлов, броадкаст 192.168.1.127

192.168.1.128/26  - 62 узла, броадкаст 192.168.1.191

192.168.1.192/26  - 62 узла, броадкаст 192.168.1.255

192.168.0.0/28   - 14 узлов, броадкаст 192.168.0.15

192.168.0.32/28  - 14 узлов, броадкаст 192.168.0.47

192.168.0.64/26  - 62 узла, броадкаст 192.168.0.127

192.168.0.16/28   - 14 узлов, броадкаст 192.168.0.31

192.168.0.48/28   - 14 узлов, броадкаст 192.168.0.63

192.168.0.128/25 - 126 узлов, броадкаст 192.168.0.255

192.168.x.0/24 - 254 узла, броадкаст 192.168.x.255

Подсети /30 из 192.168.255.x - в каждой сети 2 узла, броадкаст 192.168.255.3+n*4, n=0..63


- Проверить нет ли ошибок при разбиении

Ошибок при разбиении нет

# Практическая часть
- Соединить офисы в сеть согласно схеме и настроить роутинг
- Все сервера и роутеры должны ходить в инет черз inetRouter
- Все сервера должны видеть друг друга
- у всех новых серверов отключить дефолт на нат (eth0), который вагрант поднимает для связи
- при нехватке сетевых интервейсов добавить по несколько адресов на интерфейс

Все сделано в Vagrantfile. По окончании provisioning -а каждый сервер перезагружается - нужно немного подождать пока они все загрузятся

Адреса серверов:
office1Server - 192.168.2.66
office2Server - 192.168.1.130
centralServer - 192.168.0.2


- Результаты:

>[vagrant@office1Server ~]$ ping -c 2 192.168.1.130
>PING 192.168.1.130 (192.168.1.130) 56(84) bytes of data.
>64 bytes from 192.168.1.130: icmp_seq=1 ttl=61 time=10.5 ms
>64 bytes from 192.168.1.130: icmp_seq=2 ttl=61 time=13.1 ms
>
>--- 192.168.1.130 ping statistics ---
>2 packets transmitted, 2 received, 0% packet loss, time 1002ms
>rtt min/avg/max/mdev = 10.538/11.833/13.129/1.300 ms
>[vagrant@office1Server ~]$ ping -c 2 192.168.0.2
>PING 192.168.0.2 (192.168.0.2) 56(84) bytes of data.
>64 bytes from 192.168.0.2: icmp_seq=1 ttl=62 time=9.25 ms
>64 bytes from 192.168.0.2: icmp_seq=2 ttl=62 time=7.97 ms
>
>--- 192.168.0.2 ping statistics ---
>2 packets transmitted, 2 received, 0% packet loss, time 1002ms
>rtt min/avg/max/mdev = 7.976/8.613/9.251/0.644 ms
>[vagrant@office1Server ~]$ ping -c 2 8.8.8.8
>PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
>64 bytes from 8.8.8.8: icmp_seq=1 ttl=57 time=55.1 ms
>64 bytes from 8.8.8.8: icmp_seq=2 ttl=57 time=53.2 ms
>
>--- 8.8.8.8 ping statistics ---
>2 packets transmitted, 2 received, 0% packet loss, time 1002ms
>rtt min/avg/max/mdev = 53.225/54.174/55.124/0.977 ms
>
>
>
>
>[vagrant@office2Server ~]$  ping -c 2 192.168.2.66
>PING 192.168.2.66 (192.168.2.66) 56(84) bytes of data.
>64 bytes from 192.168.2.66: icmp_seq=1 ttl=61 time=10.9 ms
>64 bytes from 192.168.2.66: icmp_seq=2 ttl=61 time=8.47 ms
>
>--- 192.168.2.66 ping statistics ---
>2 packets transmitted, 2 received, 0% packet loss, time 1002ms
>rtt min/avg/max/mdev = 8.474/9.730/10.986/1.256 ms
>[vagrant@office2Server ~]$ ping -c 2 192.168.0.2
>PING 192.168.0.2 (192.168.0.2) 56(84) bytes of data.
>64 bytes from 192.168.0.2: icmp_seq=1 ttl=62 time=8.58 ms
>64 bytes from 192.168.0.2: icmp_seq=2 ttl=62 time=3.13 ms
>
>--- 192.168.0.2 ping statistics ---
>2 packets transmitted, 2 received, 0% packet loss, time 1001ms
>rtt min/avg/max/mdev = 3.132/5.856/8.580/2.724 ms
>[vagrant@office2Server ~]$  ping -c 2 8.8.8.8
>PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
>64 bytes from 8.8.8.8: icmp_seq=1 ttl=57 time=55.3 ms
>64 bytes from 8.8.8.8: icmp_seq=2 ttl=57 time=54.0 ms
>
>--- 8.8.8.8 ping statistics ---
>2 packets transmitted, 2 received, 0% packet loss, time 1002ms
>rtt min/avg/max/mdev = 54.015/54.660/55.305/0.645 ms
>
>
>
>
>[vagrant@centralServer ~]$ ping -c 2 192.168.2.66
>PING 192.168.2.66 (192.168.2.66) 56(84) bytes of data.
>64 bytes from 192.168.2.66: icmp_seq=1 ttl=62 time=8.65 ms
>64 bytes from 192.168.2.66: icmp_seq=2 ttl=62 time=4.38 ms
>
>--- 192.168.2.66 ping statistics ---
>2 packets transmitted, 2 received, 0% packet loss, time 1001ms
>rtt min/avg/max/mdev = 4.386/6.522/8.658/2.136 ms
>[vagrant@centralServer ~]$ ping -c 2 192.168.1.130
>PING 192.168.1.130 (192.168.1.130) 56(84) bytes of data.
>64 bytes from 192.168.1.130: icmp_seq=1 ttl=62 time=8.52 ms
>64 bytes from 192.168.1.130: icmp_seq=2 ttl=62 time=7.74 ms
>
>--- 192.168.1.130 ping statistics ---
>2 packets transmitted, 2 received, 0% packet loss, time 1001ms
>rtt min/avg/max/mdev = 7.744/8.135/8.527/0.401 ms
>[vagrant@centralServer ~]$ ping -c 2 8.8.8.8
>PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
>64 bytes from 8.8.8.8: icmp_seq=1 ttl=59 time=53.9 ms
>64 bytes from 8.8.8.8: icmp_seq=2 ttl=59 time=48.6 ms
>
>--- 8.8.8.8 ping statistics ---
>2 packets transmitted, 2 received, 0% packet loss, time 1001ms
>rtt min/avg/max/mdev = 48.643/51.284/53.925/2.641 ms
>