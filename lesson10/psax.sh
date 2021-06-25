#!/bin/bash

# Читаем список pid из /proc в массив pids и еще два параметра
declare -a pids
pids=(`find /proc/ -maxdepth 1 -regex '/proc.*[0-9]' |cut -d "/" -f 3`)
hertz=`getconf CLK_TCK`
uptime=`cat /proc/uptime | cut -d " " -f 2 |cut -d "." -f 1`



echo -e "PID\tTTY\tSTAT\tTIME\tCOMMAND"

# Выводим строки таблицы

for i in "${pids[@]}"; do 

# Если провесс еще существует
    if [ -f "/proc/$i/stat" ]; then

# Читаем stat в массив statt
	declare -a statt
	statt=(`cat /proc/$i/stat`) 

# Читаем cmdline, если есть. Если нет - то второй параметр из stat и заключаем его в []
        cmdl=`cat /proc/$i/cmdline  2>/dev/null`
        if [ -z "$cmdl" ]; then
	    cmdl=${statt[1]}
    	    cmdl="${cmdl:1}"
	    cmdl="[${cmdl::-1}]"
        fi
# Читаем tty из fd/0, если есть. Если нет, то "?"
        if [ -L "/proc/$i/fd/0" ]; then
	    ttyn=`readlink -f /proc/$i/fd/0`
	    if [[ "$ttyn" == "/dev/null" ]]; then ttyn="?"; fi 
	    if [[ "${ttyn:0:4}" == "/dev" ]]; then ttyn="${ttyn:5}"; 
	    else
    		ttyn="?"
	    fi
	else	
	    ttyn="?"
	fi

# Читаем state из stat
	state=${statt[2]}

# Считаем cpu usage
	utime=${statt[13]}
        stime=${statt[14]}
        cutime=${statt[15]}
        cstime=${statt[16]}
        starttime=${statt[21]}

        total_time=$(( $utime + $stime + $cstime ))

	elapse=$(( ${statt[22]} / $hertz ))
	seconds=$(( $uptime - $elapse ))
	usage=$(( $total_time / $hertz ))
	usage=` date -d@$usage -u +%H:%M:%S`

# Выводим
        echo -e "$i\t$ttyn\t$state\t$usage\t$cmdl" 2>/dev/null
    fi
done
