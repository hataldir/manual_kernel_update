## Репликация postgres

настроить hot_standby репликацию с использованием слотов
настроить правильное резервное копирование
Для сдачи работы присылаем ссылку на репозиторий, в котором должны обязательно быть 

Vagranfile (2 машины)
плейбук Ansible
конфигурационные файлы postgresql.conf, pg_hba.conf и recovery.conf,
конфиг barman, либо скрипт резервного копирования.
Команда "vagrant up" должна поднимать машины с настроенной репликацией и резервным копированием. 
Рекомендуется в README.md файл вложить результаты (текст или скриншоты) проверки работы репликации и резервного копирования.

## Выполнение 

Создаются 3 машины - master, slave, barman. На них ставятся postgres и barman, копируются соответствующие конфиги и ключи, создаются пользователи.
На slave создается файл $PGDATA/standby.signal

Конфиги postgres можно посмотреть в каталоге playbooks/config. Поскольку используется Postgres 14-й версии, файла recovery.conf нет, 
его содержимое начиная с 12-й версии перенесено в postgresql.conf.

# Проверка работы

# Заходим на master, создаем тестовую базу с 1 таблицей.


root@ekb-git2:~/linux/manual_kernel_update/lesson25# vagrant ssh master

Last login: Sun Oct 10 11:19:02 2021 from 10.0.2.2

[vagrant@master ~]$ sudo -s

[root@master vagrant]# su postgres

bash-4.2$ psql

could not change directory to "/home/vagrant": Permission denied

psql (14.0)

Type "help" for help.

postgres=#  CREATE DATABASE "test";

CREATE DATABASE

postgres=#  \c test

You are now connected to database "test" as user "postgres".

test=#  CREATE TABLE test (col1 varchar, col2 integer);

CREATE TABLE

test=# insert into test (col1, col2) values ('abc', 123);

INSERT 0 1

test=#




# Заходим на slave и проверяем что база появилась

[vagrant@slave ~]$ sudo -s

[root@slave vagrant]# su postgres

bash-4.2$ psql

could not change directory to "/home/vagrant": Permission denied

psql (14.0)

Type "help" for help.


postgres=# \l

                                  List of databases

   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges

-----------+----------+----------+-------------+-------------+-----------------------

 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |

 template0 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +

           |          |          |             |             | postgres=CTc/postgres

 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +

           |          |          |             |             | postgres=CTc/postgres

 test      | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |

(4 rows)

postgres=# \c test

You are now connected to database "test" as user "postgres".

test=# \d

        List of relations

 Schema | Name | Type  |  Owner

--------+------+-------+----------

 public | test | table | postgres

(1 row)

test=# select * from test;

 col1 | col2

------+------

 abc  |  123

(1 row)

# Заходим на barman и бекапим


[root@barman .ssh]# barman backup 192.168.1.1

Starting backup using postgres method for server 192.168.1.1 in /var/lib/barman/192.168.1.1/base/20211010T130613

Backup start at LSN: 0/1C0000A0 (00000001000000000000001C, 000000A0)

Starting backup copy via pg_basebackup for 20211010T130613

Copy done (time: 14 seconds)

Finalising the backup.

This is the first backup for server 192.168.1.1

WAL segments preceding the current backup have been found:

        000000010000000000000019 from server 192.168.1.1 has been removed

        00000001000000000000001A from server 192.168.1.1 has been removed

        000000010000000000000001 from server 192.168.1.1 has been removed

        000000010000000000000002 from server 192.168.1.1 has been removed

        000000010000000000000002.00000060.backup from server 192.168.1.1 has been removed

        000000010000000000000003 from server 192.168.1.1 has been removed

        000000010000000000000004 from server 192.168.1.1 has been removed

        000000010000000000000004.00000028.backup from server 192.168.1.1 has been removed

        000000010000000000000005 from server 192.168.1.1 has been removed

        000000010000000000000006 from server 192.168.1.1 has been removed

        000000010000000000000006.00000028.backup from server 192.168.1.1 has been removed

        000000010000000000000007 from server 192.168.1.1 has been removed

        000000010000000000000008 from server 192.168.1.1 has been removed

        000000010000000000000009 from server 192.168.1.1 has been removed

        000000010000000000000009.00000060.backup from server 192.168.1.1 has been removed

        00000001000000000000000A from server 192.168.1.1 has been removed

        00000001000000000000000B from server 192.168.1.1 has been removed

        00000001000000000000000C from server 192.168.1.1 has been removed

        00000001000000000000000C.00000028.backup from server 192.168.1.1 has been removed

        00000001000000000000000D from server 192.168.1.1 has been removed

        00000001000000000000000E from server 192.168.1.1 has been removed

        00000001000000000000000F from server 192.168.1.1 has been removed

        00000001000000000000000F.00000028.backup from server 192.168.1.1 has been removed

        000000010000000000000010 from server 192.168.1.1 has been removed

        000000010000000000000011 from server 192.168.1.1 has been removed

        000000010000000000000012 from server 192.168.1.1 has been removed

        000000010000000000000012.00000028.backup from server 192.168.1.1 has been removed

        000000010000000000000013 from server 192.168.1.1 has been removed

        000000010000000000000014 from server 192.168.1.1 has been removed

        000000010000000000000015 from server 192.168.1.1 has been removed

        000000010000000000000015.00000060.backup from server 192.168.1.1 has been removed

        000000010000000000000016 from server 192.168.1.1 has been removed

        000000010000000000000017 from server 192.168.1.1 has been removed

        000000010000000000000017.00000060.backup from server 192.168.1.1 has been removed

        000000010000000000000018 from server 192.168.1.1 has been removed

        00000001000000000000001A.00000060.backup from server 192.168.1.1 has been removed

        00000001000000000000001B from server 192.168.1.1 has been removed

Backup size: 33.5 MiB

Backup end at LSN: 0/1E000000 (00000001000000000000001D, 00000000)

Backup completed (start time: 2021-10-10 13:06:14.050218, elapsed time: 17 seconds)

Processing xlog segments from streaming for 192.168.1.1

        00000001000000000000001C

        00000001000000000000001D

Processing xlog segments from file archival for 192.168.1.1

        00000001000000000000001C

        00000001000000000000001D

        00000001000000000000001D.00000028.backup
