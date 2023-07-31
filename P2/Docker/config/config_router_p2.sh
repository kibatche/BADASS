#!/bin/sh

config_router_static(){
  echo "add a bridge"
  brctl addbr br0
  echo "Up the bridge"
  echo "Note : we use the absolute path because /sbin/ip is more updated and diffrent from ip from busybox"
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

config_router_multicast(){
  echo "add a bridge"
  brctl addbr br0
  echo "Up the bridge"
  echo "Note : we use the absolute path because /sbin/ip is more updated and diffrent from ip from busybox"
  /sbin/ip link set dev br0 up
  echo "add an ip to eth0"
  /sbin/ip a add 10.42.42.$1/8 dev eth0
  echo "Check if ip address is set"
  /sbin/ip a show eth0
  echo "Creation of the vxlan link with an id of ten. We suscribe it under 239.42.42.1, the multicast group. Then, when a paquet arrive, it will be diffused for the member of this group."
  echo "To achieve this task, it is mandatory to subscribe to the same group for both router."
  /sbin/ip link add name vxlan10 type vxlan id 10 dev eth0 group 239.42.42.1 dstport 4789
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

if [ "$1" == "static" ]; then
  if [ $HOSTNAME == "router_chbadad-1" ]; then
    config_router_static 1 2
  elif [ $HOSTNAME == "router_chbadad-2" ]; then
    config_router_static 2 1
  else
   echo "Hard error : Exit"
   exit 1
  fi
elif [ "$1" == "multicast" ]; then
  if [ $HOSTNAME == "router_chbadad-1" ]; then
    config_router_multicast 1
  elif [ $HOSTNAME == "router_chbadad-2" ]; then
    config_router_multicast 2
  else
    echo "Hard error. Exit"
    exit 1
  fi
else
  echo "Hard error. Exit."
  exit 1
fi

exec /usr/lib/frr/docker-start


