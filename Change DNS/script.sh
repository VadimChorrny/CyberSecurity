#! /bin/bash

read -r -p "Enter ip adress: " ip

# /etc/sysconfig/network-script/ifcfg-*

sed -i "s/dhcp/static/g" /home/net

read -r -p "Enter netmask: " netmask
if[[ $netmask == "" ]]; then
    netmask=255.255.255.0

fi
echo "$netmask"


if cat /home/net | grep "IPADDR="
    then
        echo "IPADDR ONM"

else 
    echo "IPADDR OFF"
    echo "IPADDR=$ip" >> /home/net
fi

name=$((cat /homr/net | grep NAME=))
echo "$name"
