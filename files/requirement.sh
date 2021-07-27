#!/bin/bash
#date: 2021-06-25
#
#apt-get install python

#关闭防火墙
ufw disable &> /dev/null
#关闭selinux
#setenforce 0 ;sed -i 's/enforcing/disabled/' /etc/selinux/config
#关闭swap分区
swapoff -a ; sed -ri 's/.*swap.*/#&/' /etc/fstab
#时间同步
echo "server 172.17.200.188" >> /etc/chrony/chrony.conf
systemctl enable chrony && systemctl start chrony
