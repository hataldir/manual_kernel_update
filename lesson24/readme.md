# Репликация mysql

В материалах приложены ссылки на вагрант для репликации и дамп базы bet.dmp

Базу развернуть на мастере и настроить так, чтобы реплицировались таблицы:

| bookmaker          |

| competition        |

| market             |

| odds               |

| outcome



Настроить GTID репликацию x варианты которые принимаются к сдаче

рабочий вагрантафайл

скрины или логи SHOW TABLES

конфиги

пример в логе изменения строки и появления строки на реплике

# Выполнение.

Приложенная ссылка ведет на vagrant box, использующий ubuntu 12.04, который по понятным причинам нормально не работает.

Поэтому стенд создан заново. Поднимаются две машины с адресами 192.168.1.1 (master) и 192.168.1.2 (slave).

На обе ставится percona mysql, копируется дамп bet.dmp, распространяется конфиг /etc/my.cnf.d/my2.cnf, отличающийся для master и slave. 

После запуска mysql меняется пароль пользователя root, создается отдельный пользователь replica и загружается дамп в новую базу bets.

На slave после этого настраивается содеинение с master.




Теперь заходим на slave, проверям репликацию, смотрим содержимое таблицы bookmaker:

[root@slave vagrant]# mysql -uroot -p'Mypass1!'

mysql: [Warning] Using a password on the command line interface can be insecure.

Welcome to the MySQL monitor.  Commands end with ; or \g.

Your MySQL connection id is 5

Server version: 5.7.35-38-log Percona Server (GPL), Release 38, Revision 3692a61

Copyright (c) 2009-2021 Percona LLC and/or its affiliates

Copyright (c) 2000, 2021, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its

affiliates. Other names may be trademarks of their respective

owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show slave status\G;

*************************** 1. row ***************************

               Slave_IO_State: Waiting for master to send event

                  Master_Host: 192.168.1.1

                  Master_User: replica

                  Master_Port: 3306

                Connect_Retry: 60

              Master_Log_File: mysql-bin.000001

          Read_Master_Log_Pos: 154

               Relay_Log_File: slave-relay-bin.000006

                Relay_Log_Pos: 367

        Relay_Master_Log_File: mysql-bin.000001

             Slave_IO_Running: Yes

            Slave_SQL_Running: Yes

              Replicate_Do_DB:

          Replicate_Ignore_DB:

           Replicate_Do_Table:

       Replicate_Ignore_Table: bets.events_on_demand,bets.e_event

      Replicate_Wild_Do_Table:

  Replicate_Wild_Ignore_Table:

                   Last_Errno: 0

                   Last_Error:

                 Skip_Counter: 0

          Exec_Master_Log_Pos: 154

              Relay_Log_Space: 574

              Until_Condition: None

               Until_Log_File:

                Until_Log_Pos: 0

           Master_SSL_Allowed: No

           Master_SSL_CA_File:

           Master_SSL_CA_Path:

              Master_SSL_Cert:

            Master_SSL_Cipher:

               Master_SSL_Key:

        Seconds_Behind_Master: 0

Master_SSL_Verify_Server_Cert: No

                Last_IO_Errno: 0

                Last_IO_Error:

               Last_SQL_Errno: 0

               Last_SQL_Error:

  Replicate_Ignore_Server_Ids:

             Master_Server_Id: 1

                  Master_UUID: fe702af5-284e-11ec-8f67-5254004d77d3

             Master_Info_File: /var/lib/mysql/master.info

                    SQL_Delay: 0

          SQL_Remaining_Delay: NULL

      Slave_SQL_Running_State: Slave has read all relay log; waiting for more updates

           Master_Retry_Count: 86400

                  Master_Bind:

      Last_IO_Error_Timestamp:

     Last_SQL_Error_Timestamp:

               Master_SSL_Crl:

           Master_SSL_Crlpath:

           Retrieved_Gtid_Set:

            Executed_Gtid_Set:

                Auto_Position: 1

         Replicate_Rewrite_DB:

                 Channel_Name:

           Master_TLS_Version:

1 row in set (0.00 sec)

ERROR:

No query specified

mysql> use bets;

Reading table information for completion of table and column names

You can turn off this feature to get a quicker startup with -A

Database changed

mysql> select * from bookmaker;

+----+----------------+

| id | bookmaker_name |

+----+----------------+

|  4 | betway         |

|  5 | bwin           |

|  6 | ladbrokes      |

|  3 | unibet         |

+----+----------------+

4 rows in set (0.00 sec)



Заходим в mysql на master, вставляем строку в таблицу bookmaker:


[root@master my.cnf.d]# mysql -uroot -p'Mypass1!'

mysql: [Warning] Using a password on the command line interface can be insecure.

Welcome to the MySQL monitor.  Commands end with ; or \g.

Your MySQL connection id is 3

Server version: 5.7.35-38-log Percona Server (GPL), Release 38, Revision 3692a61



Copyright (c) 2009-2021 Percona LLC and/or its affiliates

Copyright (c) 2000, 2021, Oracle and/or its affiliates.



Oracle is a registered trademark of Oracle Corporation and/or its

affiliates. Other names may be trademarks of their respective

owners.


Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> use bets;

Reading table information for completion of table and column names

You can turn off this feature to get a quicker startup with -A



Database changed

mysql> show tables;

+------------------+

| Tables_in_bets   |

+------------------+

| bookmaker        |

| competition      |

| events_on_demand |

| market           |

| odds             |

| outcome          |

| v_same_event     |

+------------------+
7 rows in set (0.00 sec)


mysql> select * from bookmaker;

+----+----------------+

| id | bookmaker_name |

+----+----------------+

|  4 | betway         |

|  5 | bwin           |

|  6 | ladbrokes      |

|  3 | unibet         |

+----+----------------+

4 rows in set (0.00 sec)


mysql> insert INTO bookmaker (id,bookmaker_name) VALUES(2,"test");

Query OK, 1 row affected (0.02 sec)

mysql>


Возвращаемся на slave:

mysql> select * from bookmaker;

+----+----------------+

| id | bookmaker_name |

+----+----------------+

|  4 | betway         |

|  5 | bwin           |

|  6 | ladbrokes      |

|  2 | test           |

|  3 | unibet         |

+----+----------------+

5 rows in set (0.00 sec)

mysql>
