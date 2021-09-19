# Сбор и анализ логов

Задание:

Настраиваем центральный сервер для сбора логов

в вагранте поднимаем 2 машины web и log

на web поднимаем nginx

на log настраиваем центральный лог сервер на любой системе на выбор

journald;

rsyslog;

elk.

настраиваем аудит, следящий за изменением конфигов нжинкса

Все критичные логи с web должны собираться и локально и удаленно. Все логи с nginx должны уходить на удаленный сервер (локально только критичные). Логи аудита должны также уходить на удаленную систему.




# Решение

Все настройки выполняются плейбками web.yml и log.yml.

На сервере log разрешаем демону rsyslog слушать порт 514 udp. В rsyslog.conf:

$ModLoad imudp

$UDPServerRun 514



На сервере web:

Перенаправляем логи nginx на сервер log. В nginx.conf в разделе server:

        error_log syslog:server=192.168.1.2:514,facility=local7,tag=nginx,severity=info;

        access_log syslog:server=192.168.1.2:514,facility=local7,tag=nginx,severity=info main;

        error_log /var/log/error.log crit;

Включаем мониторинг каталога /etc/nginx демоном auditd. Создаем файл /etc/audit/rules.d/nginx.rules:

-w /etc/nginx -p rwxa -k test_watch

Включаем логирование событий audit в syslog (facility local6). В файле /etc/audisp/plugins.d/syslog.conf:

active = yes

args = LOG_INFO LOG_LOCAL6

Включаем перенаправление событий от facility local6 и всех событий с приоритетом crit и выше на сервер log. В файле /etc/rsyslog.conf:

local6.* @192.168.1.2:514

*.crit @192.168.1.2:514
