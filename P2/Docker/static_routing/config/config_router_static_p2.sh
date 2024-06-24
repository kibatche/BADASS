#!/bin/sh

config_router_static(){
  echo "add a bridge"
  brctl addbr br0
  echo "Up the bridge"
  echo "Note : we use /sbin/ip because ip form busybox cannot handle vxlan configuration"
  /sbin/ip link set dev br0 up
  echo "add an ip to eth0"
  /sbin/ip a add 10.42.42.$1/8 dev eth0
  echo "Check if ip address is set"
  /sbin/ip a show eth0
  echo "Creation of the vxlan link with an id of ten."
  /sbin/ip link add name vxlan10 type vxlan id 10 dev eth0 remote 10.42.42.$2 local 10.42.42.$1 dstport 4789
  echo "Attribute an ip for vxlan10"
  /sbin/ip a add 20.42.42.$1/8 dev vxlan10
  echo "Check vxlan10"
  /sbin/ip -d link show vxlan10
  echo "Link the bridge to eth1 and vxlan10"
  brctl addif br0 eth1
  brctl addif br0 vxlan10
  ## Explications sur la partie ci-dessus : via eth1 on a la trame "originale", via le bridge, elle va être encapsulée par le vxlan (vxlan10 ici)
  echo "Up the vxlan"
  /sbin/ip link set dev vxlan10 up
  echo "===END==="
}

HOSTNAME=$(hostname)


if [ "$HOSTNAME" == "router-p2-static_chbadad-1" ]; then
  config_router_static 1 2
elif [ "$HOSTNAME" == "router-p2-static_chbadad-2" ]; then
  config_router_static 2 1
else
  echo "Hard error : Exit"
  exit 1
fi


exec "$@"


