#!/usr/bin/bash
# generated 2023/01/04 22:03:52 UTC by forwardportstoguestgenerator.php v0102
# Gordon Buchan https://gordonbuchan.com

# values
kvmsubnet="192.168.122.0/24"
wanadaptername="eno1"
wanadapterip="162.55.243.109"
kvmadaptername="virbr0"
kvmadapterip="192.168.122.109"

# allow virtual adapter to accept packets from outside the host
#iptables -I FORWARD -i $wanadaptername -o $kvmadaptername -d $kvmsubnet -j ACCEPT
#iptables -I FORWARD -i $kvmadapterip -o $wanadaptername -s $kvmsubnet -j ACCEPT
# forward ports from host to guest
#iptables -t nat -A PREROUTING -i $wanadaptername -d $wanadapterip -p tcp --dport 80 -j  DNAT --to-destination $kvmadapterip:80
#iptables -t nat -A PREROUTING -i $wanadaptername -d $wanadapterip -p tcp --dport 443 -j DNAT --to-destination $kvmadapterip:443
iptables -t nat -A PREROUTING -i $wanadaptername -d $wanadapterip -p tcp --dport 8022 -j DNAT --to-destination $kvmadapterip:22

