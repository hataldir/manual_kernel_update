# LDAP

Установить FreeIPA;
Написать Ansible playbook для конфигурации клиента;

# Выполнение

Вагрантом поднимаются две машины, на них устанавливаются ipa-server и ipa-client, настраиваются ансиблом. 
Запускать надо по очереди, чтобы к моменту настройки клиента сервер уже работал:
 vagrant up ipaserver
 vagrant up ipaclient

После окончания настройки заходим на серуер, пробуем создать пользователя:

[root@ipaserver vagrant]# kinit admin

Password for admin@EXAMPLE.LOCAL:

[root@ipaserver vagrant]# klist

Ticket cache: KEYRING:persistent:0:0

Default principal: admin@EXAMPLE.LOCAL


Valid starting     Expires            Service principal

10/12/21 09:09:12  10/13/21 09:09:08  krbtgt/EXAMPLE.LOCAL@EXAMPLE.LOCAL

[root@ipaserver vagrant]# ipa user-add

First name: Test

Last name: Test

User login [ttest]: ttest

------------------

Added user "ttest"

------------------

  User login: ttest

  First name: Test

  Last name: Test

  Full name: Test Test

  Display name: Test Test

  Initials: TT

  Home directory: /home/ttest

  GECOS: Test Test

  Login shell: /bin/sh

  Principal name: ttest@EXAMPLE.LOCAL

  Principal alias: ttest@EXAMPLE.LOCAL

  Email address: ttest@example.local

  UID: 353400001

  GID: 353400001

  Password: False

  Member of groups: ipausers

  Kerberos keys available: False


Потом заходим на клиента и логинимся под созданным пользователем ttest:


[root@ipaclient log]# su - ttest

Creating home directory for ttest.

-sh-4.2$ exit
