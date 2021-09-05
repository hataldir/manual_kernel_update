# DNS- настройка и обслуживание

Взят стенд https://github.com/erlong15/vagrant-bind

Добавлена еще одна машина client2 (аналогичная машине client) с адресом 192.168.50.16

В зоне dns.lab добавлены два хоста - web1 с адресом 192.168.50.15 и web2 с адресом 192.168.50.16. 

Создана еще одна зона newdns.lab (файл named.newdns.lab)

В ней создан один хост www с двумя адресами 192.168.50.15 и 192.168.50.16.

# Split-dns

В named.conf добавлены отдельные ACL для каждого клиента и три view - client1, client2 и all.

В первом view, доступном только для client1, содержится зона newdns.lab и и модицифированная зона dns.lab - без хоста web2 (файл namd.dns1.lab)

Во втором view, доступном только для client2, содержится только зона dns.lab.

В третьем view, доступном для всех остальных, содержатся все остальные зоны.


# Результат выполнения dig

Приводятся только ANSWER SECTION.

[vagrant@client ~]$  dig @192.168.50.10 web1.dns.lab

;; ANSWER SECTION:
web1.dns.lab.           3600    IN      A       192.168.50.15

[vagrant@client ~]$  dig @192.168.50.10 web2.dns.lab

[vagrant@client ~]$ dig @192.168.50.10 www.newdns.lab

;; ANSWER SECTION:
www.newdns.lab.         3600    IN      A       192.168.50.16
www.newdns.lab.         3600    IN      A       192.168.50.15


[vagrant@client2 ~]$ dig @192.168.50.10 web1.dns.lab

;; ANSWER SECTION:
web1.dns.lab.           3600    IN      A       192.168.50.15

[vagrant@client2 ~]$ dig @192.168.50.10 web2.dns.lab

;; ANSWER SECTION:
web2.dns.lab.           3600    IN      A       192.168.50.16

[vagrant@client2 ~]$ dig @192.168.50.10 www.newdns.lab

