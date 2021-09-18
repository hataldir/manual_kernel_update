## Задание 1. Запустить nginx на нестандартном порту 3-мя разными способами

Устанавливаем epel-release, nginx , setools, policycoreutils-python


В конфиге nginx меняем порт на нестандартный

[root@localhost nginx]# cat nginx.conf|grep listen
        listen       8090;
        listen       [::]:8090;

Пытаемся запустить

[root@localhost nginx]# systemctl start nginx

Job for nginx.service failed because the control process exited with error code. See "systemctl status nginx.service" and "journalctl -xe" for details.

[root@localhost nginx]# systemctl status nginx

[skipped]

Sep 18 11:28:26 localhost.localdomain nginx[2169]: nginx: [emerg] bind() to 0.0.0.0:8090 failed (13: Permission denied)


# 1 способ - переключатели setsebool

Включаем переключатель nis_enabled

[root@localhost nginx]# setsebool -P nis_enabled 1

[root@localhost nginx]# systemctl start nginx

[root@localhost nginx]# telnet localhost 8090

Trying ::1...

Connected to localhost.

Escape character is '^]'.

Выключаем

[root@localhost nginx]# setsebool -P nis_enabled 0

[root@localhost nginx]# systemctl stop nginx


# 2 способ  - добавление нестандартного порта в имеющийся тип

Добавляем порт 8090 в тип http_port_t.

[root@localhost nginx]# semanage port -a -t http_port_t  -p tcp 8090

[root@localhost nginx]# systemctl start nginx

[root@localhost nginx]# telnet localhost 8090

Trying ::1...

Connected to localhost.

Escape character is '^]'.

Удаляем

[root@localhost nginx]# semanage port -d -t http_port_t  -p tcp 8090

[root@localhost nginx]# systemctl stop nginx

# 3 способ - формирование и установка модуля SELinux 

Смотрим лог аудита, генерируем из найденных в нем ошибок модуль и запускаем его

[root@localhost audit]# cd /var/log/audit

[root@localhost audit]# audit2allow -a -M nginx

******************** IMPORTANT ***********************

To make this policy package active, execute:

semodule -i nginx.pp

[root@localhost audit]# semodule -i nginx.pp

[root@localhost nginx]# systemctl start nginx

[root@localhost nginx]# telnet localhost 8090

Trying ::1...

Connected to localhost.

Escape character is '^]'.


## Задание 2. Обеспечить работоспособность приложения при включенном selinux.

развернуть приложенный стенд https://github.com/mbfx/otus-linux-adm/tree/master/selinux_dns_problems;

выяснить причину неработоспособности механизма обновления зоны;

предложить решение (или решения) для данной проблемы;

выбрать одно из решений для реализации, предварительно обосновав выбор;

реализовать выбранное решение и продемонстрировать его работоспособность.


Скачиваем и запускаем стенд.

Заходим на машину client, выполняем описанные в readme действия, получаем ошибку.

[vagrant@client ~]$ nsupdate -k /etc/named.zonetransfer.key

>  server 192.168.50.10

>  zone ddns.lab

>   update add www.ddns.lab. 60 A 192.168.50.15

>     send

update failed: SERVFAIL

>

После этого идем на машину ns01 и смотрим лог:

[root@ns01 audit]# audit2why < audit.log

type=AVC msg=audit(1631968894.728:1915): avc:  denied  { create } for  pid=5046 comm="isc-worker0000" name="named.ddns.lab.view1.jnl" scontext=system_u:system_r:named_t:s0 tcontext=system_u:object_r:etc_t:s0 tclass=file permissive=0

        Was caused by:
                Missing type enforcement (TE) allow rule.

                You can use audit2allow to generate a loadable module to allow this access.

Ищем упомянутый файл

[root@ns01 named]# find / -name named.ddns.lab.view1.jnl

/etc/named/dynamic/named.ddns.lab.view1.jnl

Идем туда и смотрим права

[root@ns01 named]# cd /etc/named/dynamic/

[root@ns01 dynamic]# ls -laZ

drw-rwx---. root  named unconfined_u:object_r:etc_t:s0   .

drw-rwx---. root  named system_u:object_r:etc_t:s0       ..

-rw-rw----. named named system_u:object_r:etc_t:s0       named.ddns.lab

-rw-rw----. named named system_u:object_r:etc_t:s0       named.ddns.lab.view1

-rw-r--r--. named named system_u:object_r:etc_t:s0       named.ddns.lab.view1.jnl

Меняем контекст в каталоге

[root@ns01 named]# chcon -u system_u dynamic

Снова выполняем команды на клиенте:

[vagrant@client ~]$ nsupdate -k /etc/named.zonetransfer.key

>   server 192.168.50.10

>  zone ddns.lab

>  update add www.ddns.lab. 60 A 192.168.50.15

>   send

>

Ошибок нет.

Пинг на добавленную запись идет:

[vagrant@client ~]$ ping www.ddns.lab

PING www.ddns.lab (192.168.50.15) 56(84) bytes of data.

64 bytes from web1.dns.lab (192.168.50.15): icmp_seq=1 ttl=64 time=0.056 ms

64 bytes from web1.dns.lab (192.168.50.15): icmp_seq=2 ttl=64 time=0.071 ms
