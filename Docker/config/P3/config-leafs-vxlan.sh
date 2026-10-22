#!/bin/bash

/sbin/ip link add br0 type bridge
/sbin/ip link set dev br0 up
/sbin/ip link add vxlan10 type vxlan id 10 dstport 4789
/sbin/ip link set dev vxlan10 up
brctl addif br0 eth0
brctl addif br0 vxlan10