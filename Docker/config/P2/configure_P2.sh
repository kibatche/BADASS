#!/bin/sh

info() {
  echo -e "\e[1;34m[*] $1\e[0m"
}

config_router_static(){
  info "Configuring IP address on eth0"
  /sbin/ip a add 192.168.2.$1/24 dev eth0
  info "Infos about eth0 :"
  /sbin/ip a show eth0
  info "Creating the VXLAN tunnel with ID 10"
  /sbin/ip link add name vxlan10 type vxlan id 10 dstport 4789 local 192.168.2.$1 remote 192.168.2.$2 dev eth0
  info "Upping the VXLAN"
  /sbin/ip link set dev vxlan10 up
  info "Infos about vxlan10 :"
  /sbin/ip -d link show vxlan10
  info "Creating a bridge"
  /sbin/ip link add br0 type bridge
  info "Upping the bridge"
  /sbin/ip link set dev br0 up
  info "Adding vxlan10 and eth1 to the bridge"
  /sbin/ip link set vxlan10 master br0
  /sbin/ip link set eth1 master br0
  info "===END==="
}

config_router_multicast(){
  info "Configure IP address on eth0 :"
  /sbin/ip a add 192.168.2.$1/24 dev eth0
  info "Infos about eth0 :"
  /sbin/ip a show eth0
  info "Create the VXLAN tunnel with ID 10 :"
  /sbin/ip link add name vxlan10 type vxlan id 10 dstport 4789 local 192.168.2.$1 group 239.1.1.10 dev eth0
  info "Up the VXLAN"
  /sbin/ip link set dev vxlan10 up
  info "Infos about vxlan10 :"
  /sbin/ip -d link show vxlan10
  info "Create a bridge :"
  /sbin/ip link add br0 type bridge
  info "Up the bridge"
  /sbin/ip link set dev br0 up
  info "Add vxlan10 and eth1 to the bridge"
  /sbin/ip link set vxlan10 master br0
  /sbin/ip link set eth1 master br0
  info "===END==="
}

HOSTNAME=$(hostname)

if [ "$1" == "static" ]; then
  if [ $HOSTNAME == "router_mboivin-1" ]; then
    config_router_static 1 2
  elif [ $HOSTNAME == "router_mboivin-2" ]; then
    config_router_static 2 1
  else
    info "Usage : ./config_router.sh [static/multicast]"
    exit 1
  fi
elif [ "$1" == "multicast" ]; then
  if [ $HOSTNAME == "router_mboivin-1" ]; then
    config_router_multicast 1
  elif [ $HOSTNAME == "router_mboivin-2" ]; then
    config_router_multicast 2
  else
    info "Usage : ./config_router.sh [static/multicast]"
    exit 1
  fi
else
  info "Usage : ./config_router.sh [static/multicast]"
  exit 1
fi

# exec /usr/lib/frr/docker-starts