## Домашнее задание 1

Установлены Vagrant, Packer и VirtualBox

Сделан форк репозитория dmitry-lyutenko/manual_kernel_update и затем склонирован на рабочую машину.

Заапущена виртуалка из содержащегося в репозитории Vagrantfile.

Внутри виртуалки: подключен репозитория elrepo, скачано и установлено последнее ядро kernel-ml.

В конфиг образа Packer centos.json внесена строка "headless" : "true", затем создан образ centos 7.7 с ядром 5.12.0. Этот образ импортирован в Vagrant и запущен.

Заведен аккаунт на Vagrant Cloud, загружен полученный образ centos.

Все изменения запушены в github.

Адрес образа в Vagrant Cloud - https://app.vagrantup.com/hataldir/boxes/centos-7-5

Vagrantfile - https://github.com/hataldir/manual_kernel_update/blob/master/packer/cloud-box/Vagrantfile

## Домашнее задание 2

Скачан Vagrantfile для машины с 6 дисками, запущена машина. Установлена утилита mdadm.

Создан рейд RAID6 из 5 дисков. Создан конфиг mdadm.conf.

"Сломан" и "заменен" диск в рейде.

На рейде создана GPT и пять разделов - /dev/md0p[1-5]. Разделы отформатированы и смонтированы.

Файлы находятся в каталоге https://github.com/hataldir/manual_kernel_update/tree/master/lesson2 

Дополнительное задание:

Написан скрипт provision.sh, создающий рейд и разделы на нем, В Vagrantfile добавлена строка  server.vm.provision 'shell', path: 'provision.sh'.


## Домашнее задание 3

Скачан Vagrantfile для машины с LVM. 

Раздел для / уменьшен с 40 Gb до 8 Gb с помощью временного раздела /dev/vg_root/lv_root

Для /var создан новый раздел, зеркало.

Для /home создан раздел и снапшот, протестировано восстановление со снапшота


## Домашнее задание 4

Скачан Vagrantfile для машины с ZFS.

Логи выполнения всех команд в файле https://github.com/hataldir/manual_kernel_update/tree/master/lesson4/result.txt

1. Определить алгоритм с наилучшим сжатием

Созданы 4 файловые системы disk1..disk4, им назначены типы сжатия gzip, zle, lzjb, lz4. Скачан текстовый файл размером 3.4 Мб, скопирован на каждый из разделов и определен лучший тип сжатия - gzip (disk1):

Filesystem      Size  Used Avail Use% Mounted on

pool1/disk1     4.6G  1.3M  4.6G   1% /pool1/disk1

pool1/disk2     4.6G  3.3M  4.6G   1% /pool1/disk2

pool1/disk3     4.6G  2.5M  4.6G   1% /pool1/disk3

pool1/disk4     4.6G  2.0M  4.6G   1% /pool1/disk4

2.  Определить настройки pool’a

Скачан архив с дисками, импортирован. Определены настройки:

Hазмер хранилища - 480М

Тип pool - mirror

Значение recordsize - 128К

Какое сжатие используется - zle

Какая контрольная сумма используется - sha256

3. Найти сообщение от преподавателей 

Скачан снапшот, импортирован. Текст сообщения: https://github.com/sindresorhus/awesome

## Домашнее задание 5

Скачан Vagrantfile для создания двух машин.

К нему написаны два скрипта provision:

Машина-сервер - установка nfs-utils, создание каталогов /share и /share/upload, назначение прав, прописывание их в /etc/exports,
включение и запуск сервиса nfs.

Машина-клиент - создание каталога /share, прописывание в /fstab строки для подключения к серверу с использованием NFSv3 и UDP, подключение.

Результат df -h|grep share на клиенте:

    nfsc: 192.168.50.10:/share   40G  3.1G   37G   8% /share

Скрипты nfss.sh и nfsc.sh - на https://github.com/hataldir/manual_kernel_update/tree/master/lesson5

## Домашнее задание 6

Создана виртуалка Centos, установлены указанные в методичке пакеты и неуказанный gcc. Скачаны openssl и исходники nginx.

Изменен nginx.spec, создан новый пакет nginx с помощью rpmbuild

Из полученного пакета установнен nginx, затем создан репозиторий, в который выложены два пакета.

Репозиторий добавлен в yum.repos.d, из него установлен пакет percona.

Пакет находится в каталоге lesson6.

 
