#!/bin/bash

ip tunnel add tun2 mode ipip remote {{ peer_outer_ip }} local {{ my_outer_ip }} dev eth1
ip address add {{ my_inner_ip }}/24 dev tun2
ip link set tun2 up


