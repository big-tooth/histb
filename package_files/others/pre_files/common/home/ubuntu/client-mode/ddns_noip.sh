#!/bin/bash

user=
password=
hostname=

oldIP=`cat ddns_cur_ip2.dat`
curExIP=`curl http://ip.3322.net | tee ddns_cur_ip2.dat`

if [ "$curExIP" != "$oldIP" ];then
    echo "Refresh IP from $oldIP to: $curExIP"
    noipcom="http://$user:$password@dynupdate.no-ip.com/nic/update?hostname=$hostaname&myip=$curExIP"
    curl $noipcom
else
    echo "No change on external IP - $curExIP"
fi

