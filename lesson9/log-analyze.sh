#!/bin/bash

x=10  # Количество выводимых в отчет IP адресов клиентов
y=10  # Количество выводимых в отчет адресов страниц
email="denis@monetka.ru"
report="report.txt"
logpath="."

# Проверка на повторный запуск
pid_file="log-analyze.pid"
while [ -f $pid_file ]
  do
    echo "Script has already started"
    exit 1
done
touch $pid_file

# Имя файла
log=` find $logpath -name access*.log -printf '%T+ %p\n' | sort -r | head -1 | cut -d ' ' -f2`

# Временной диапазон
start=`head -n 1 $log | cut -d "[" -f2 | cut -d "]" -f1`
end=`tail -n 1 $log | cut -d "[" -f2 | cut -d "]" -f1`


# Чтение лога, выделение адресов клиентов и страниц   
rm ips pages codes errors 2> /dev/nul
#while IFS=" " read -r ip a1 a2 a3 a4 a5 page a6 code a7; do
while  read -r line; do 
    ip="$(echo $line | cut -d' ' -f1)"
    page2="$(echo $line | cut -d' ' -f6)"
    page="$(echo $line | cut -d' ' -f7)"
    code="$(echo $line | cut -d' ' -f9)"
    if [ "$code" == '"-"' ];  then 
    	code=$page
	page=$page2
    fi
    echo "$ip" >> ips
    echo "$page" >>pages
    echo "$code" >>codes
    if [ ${code:0:1} == 4 ]; then
	echo "$line">>errors
    fi
done <$log

# Определение количества, сортировка
sort ips | uniq -c >ips_c
sort pages | uniq -c >pages_c
sort codes | uniq -c >codes_c
sort -nr ips_c > ips_s
sort -nr pages_c > pages_s
sort -nr codes_c > codes_res
head -n $x ips_s > ips_res
head -n $y pages_s > pages_res
rm ips pages ips_c pages_c ips_s pages_s codes codes_c

# Формирование отчета
echo "Отчет за $start - $end" >$report
echo >>$report
echo "Топ $x клиентов:">>$report
cat ips_res >>$report
echo >>$report
echo "Топ $y запрашиваемых страниц:">>$report
cat pages_res >>$report
echo >>$report
echo "Количество кодов возврата:">>$report
cat codes_res >>$report
echo >>$report
echo "Ошибки (запросы с кодом возврата 4xx):">>$report
cat errors >>$report
rm ips_res pages_res codes_res errors


#mail $email<$report
(echo "Subject: Apache log report $start - $end"; cat $report) | /usr/sbin/sendmail $email



rm $pid_file