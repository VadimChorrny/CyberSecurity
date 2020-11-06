#! /bin/bash 



help(){
    echo -e "You should use paramatres as :\n--ip - ip address of host (example: 192.168.0.111) \n--mask - mask of network (example: 24) \n--gateway - ip address of network gateway (example: 192.168.1.1) \nexample: bash script.sh --ip 192.168.0.25 --mask 24 --gateway 192.168.1.1"
}



os=$(cat /etc/os-release | grep -Eo "ID_LIKE=.*" | cut -c 9-)
check="(1[0-9][0-9]|[1-9][0-9]|[1-9]|2[0-4][0-9]|25[0-5]).(1[0-9][0-9]|[1-9][0-9]|[1-9]|2[0-5][0-9]|25[0-5]).(1[0-9][0-9]|[1-9][0-9]|[1-9]|2[0-5][0-9]|25[0-5]).(1[0-9][0-9]|[1-9][0-9]|[1-9]|2[0-5][0-9]|25[0-5])"
maskformat="[1-9]|[1-2][0-9]|3[0-1]"

 

while [[ $# >1 ]]
    do
        par="$1"
        case $par in
            --ip)
                ip=$2
            shift
            ;;
            --mask)
                mask=$2
            shift
            ;;
            --gateway)
                gateway=$2
            shift
            ;;
            --help)
                help;
            shift
            ;;
            *) echo -e "Bad parametr $1 \nyou have to use: --help"
            exit 1
        esac
        shift
    done

 

if [ -z $ip ];
    then
    echo "You should enter ip"
    help;
    exit 1
fi
if [ -z $mask ];
    then
    echo "You should enter mask"
    help;
    exit 1
fi
if [ -z $gateway ];
    then
    echo "You should enter gateway"
    help;
    exit 1
fi
    if [[ $ip =~ ^((1[0-9][0-9]|[1-9][0-9]|[1-9]|2[0-4][0-9]|25[0-5]).(1[0-9][0-9]|[1-9][0-9]|[1-9]|2[0-5][0-9]|25[0-5]).(1[0-9][0-9]|[1-9][0-9]|[1-9]|2[0-5][0-9]|25[0-5]).(1[0-9][0-9]|[1-9][0-9]|[1-9]|2[0-5][0-9]|25[0-5]))$ ]] ; then
        if [[ $mask =~ ^(([1-9]|[1-2][0-9]|3[0-1]))$ ]] ; then
            if [[ $gateway =~ ^((1[0-9][0-9]|[1-9][0-9]|[1-9]|2[0-4][0-9]|25[0-5]).(1[0-9][0-9]|[1-9][0-9]|[1-9]|2[0-5][0-9]|25[0-5]).(1[0-9][0-9]|[1-9][0-9]|[1-9]|2[0-5][0-9]|25[0-5]).(1[0-9][0-9]|[1-9][0-9]|[1-9]|2[0-5][0-9]|25[0-5]))$ ]] ; then
                if [[ $os == "debian" ]] ; then
                interface=$(ip route | grep default | grep -Eo "en.*.\s\p" | sed 's/.$//')
                sudo sed -i "/network:/,$ d" /etc/netplan/*.yaml
                printf "network:
  ethernets:
    $interface:
      addresses: [$ip/$mask]
      gateway4: $gateway
      nameservers:
        addresses: [8.8.8.8,8.8.4.4]
      dhcp4: false
  version: 2" > /etc/netplan/*.yaml
netplan apply
                else
                    var=$(cat /etc/sysconfig/network-scripts/ifcfg-e* | grep BOOTPROTO)
                    if ! grep "BOOTPROTO" /etc/sysconfig/network-scripts/ifcfg-e* | grep "static" /etc/sysconfig/network-scripts/ifcfg-e* ; then
                        sed -i "s/$var/BOOTPROTO=static/g" /etc/sysconfig/network-scripts/ifcfg-e*
                    fi
                    if grep "IPADDR" /etc/sysconfig/network-scripts/ifcfg-e* ; then
                        var=$(cat /etc/sysconfig/network-scripts/ifcfg-e* | grep IPADDR)
                        sed -i "s/$var/IPADDR=$ip/g" /etc/sysconfig/network-scripts/ifcfg-e*
                    else 
                        echo "IPADDR=$ip" >> /etc/sysconfig/network-scripts/ifcfg-e*
                    fi
                    if grep "NETMASK" /etc/sysconfig/network-scripts/ifcfg-e* ; then
                        var=$(cat /etc/sysconfig/network-scripts/ifcfg-e* | grep NETMASK)
                        sed -i "s/$var/NETMASK=$mask/g" /etc/sysconfig/network-scripts/ifcfg-e*
                    else 
                        echo "NETMASK=$mask" >> /etc/sysconfig/network-scripts/ifcfg-e*
                    fi
                    if grep "GATEWAY" /etc/sysconfig/network-scripts/ifcfg-e* ; then
                        var=$(cat /etc/sysconfig/network-scripts/ifcfg-e* | grep GETWAY)
                        sed -i "s/$var/GETWAY=$getway/g" /etc/sysconfig/network-scripts/ifcfg-e*
                    else 
                        echo "GATEWAY=$getway" >> /etc/sysconfig/network-scripts/ifcfg-e*
                    fi
                    if grep "DNS" /etc/sysconfig/network-scripts/ifcfg-e* ; then
                        var=$(cat /etc/sysconfig/network-scripts/ifcfg-e* | grep DNS)
                        sed -i "s/$var/DNS=8.8.8.8/g" /etc/sysconfig/network-scripts/ifcfg-e*
                    else 
                        echo "DNS=8.8.8.8" >> /etc/sysconfig/network-scripts/ifcfg-e*
                    fi
                    systemctl restart network
                fi
            else
                echo "not correct gateway"
            fi
        else
            echo "not correct mask"
        fi
    else
        echo "not correct ip"
    fi
