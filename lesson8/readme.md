## Домашнее задание 9

1. Написать service, который будет раз в 30 секунд мониторить лог на предмет наличия ключевого слова (файл лога и ключевое слово должны задаваться в /etc/sysconfig).

Сервис watchlog, находится в /opt/watchlog.sh, наблюдает за логом /var/log/watchlog.log, запускается раз в 30 секунд (timer). Параметры в файле /etc/sysconfig/watchlog.
Вагрант копирует файлы watchlog.sh, watchlog.service, watchlog.timer, watchlog, затем скриптом script1.sh раскладывает их в нужные места, создает лог и запускает сервис.

2. Из репозитория epel установить spawn-fcgi и переписать init-скрипт на unit-файл (имя service должно называться так же: spawn-fcgi).

Установлен epel, пакет spawn-fcgi с зависимостями, создан для него юнит.
Вагрант копирует файлы spwan-fcgi и spawn-fcgi.service, затем скриптом script2.sh раскладывает их в нужные места и запускает сервис.

3. Дополнить unit-файл httpd (он же apache) возможностью запустить несколько инстансов сервера с разными конфигурационными файлами.

Юнит находится в /usr/lib/systemd/system/httpd@.service. В файлах /etc/httpd/httpd-first и httpd-second указаны параметры для него - пути к разным конфигам httpd-first.conf и httpd-second.conf.
В конфиге httpd.conf изменен пот на 8080 и добавлен параметр PidFile, указывающий на нестандартный путь.
Вагрант копирует файлы httpd.service, httpd-first, httpd-second, скриптом script3.sh раскладывает их в нужные места, затем копирует конфиг httpd.conf в два новых и правит конфиг httpd-second.conf.
Потом запускает два инстанса сервиса - httpd@first и httpd@second
