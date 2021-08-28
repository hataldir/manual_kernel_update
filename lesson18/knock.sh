#!/bin/bash
HOST=192.168.255.1
PORTS="8881 7777 9991"
for ARG in $PORTS
do
        sudo nmap -Pn --max-retries 0 -p $ARG $HOST
done

ssh -l vagrant $HOST
