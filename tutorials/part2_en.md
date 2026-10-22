# Part 2

The goal of this section is to introduce VXLAN, which is widely used today to meet evolving technological demands and integrates better into modern architectures (virtualized, distributed, and cloud-native). **What are VXLAN benefits?**

Improved scalability through larger addressing space:

- **A VLAN ID = 12 bits** -> **4,096 VLANs** maximum. But 4,096 VLANs are not enough for large data centers.
- **A VXLAN ID = 24 bits** -> **16 million possible networks**.

Layer 3 overlay capabilities and improved isolation:

- **VLAN operates at Layer 2** of the OSI model (Data Link Layer), which means a single broadcast domain.
- **VXLAN extends the network over Layer 3** (IP). It encapsulates Ethernet frames in **UDP**. This enables interconnection of VMs across geographically distributed IP networks. There is one broadcast domain per VNI.

The [first part](#3-unicast) shows how to manually configure a VXLAN tunnel with two peers. But because this approach would be tedious if we wanted more than one tunnel, the [second part](#4-multicast) asks to use a multicast group to avoid setting every VTEP pairs.

## Table of Content

- [Requirements](#requirements)
- [Conventions and Best Practices](#conventions-and-best-practices)
- [Walkthrough](#walkthrough)
    1. [Set up GNS3](#1-set-up-gns3)
    2. [Create the network](#2-create-the-network)
    3. [Unicast](#3-unicast)
    4. [Multicast](#4-multicast)
    5. [Save the project](#5-save-the-project)
- [Defense](#defense)
- [Resources](#resources)

## 💡 Conventions and Best Practices

Before getting started, here are a few best practices to follow.

### Replace deprecated commands

Numerous online examples feature `brctl` from `bridge-utils` but this tool is old and deprecated. Prefer `ip` and `bridge` from `iproute2`.

### VXLAN UDP Port

> *Destination Port: IANA has assigned the value 4789 for the VXLAN UDP port, and this value SHOULD be used by default as the destination UDP port. [(source: RFC 7348)](https://datatracker.ietf.org/doc/html/rfc7348)*

### Choosing IDs

This is more of an informal convention that helps with easier debugging:

- **VLAN 10**: Users (workstations)
- **VLAN 20**: Servers
- **VLAN 30**: Infrastructure (routers, switches, management)
- **VLAN 40**: VoIP (phones)
- **VLAN 50**: Wi-Fi

This logic allows space for adding more VLANs later if needed (e.g., VLAN 11, 12... within the user range).

In some architectures, a VLAN ID is mapped to a VXLAN (via a VNI), so the naming is preserved:

- VLAN `10` -> VXLAN `10` -> VNI `1010` -> `br10`
- VLAN `20` -> VXLAN `20` -> VNI `1020` -> `br20`

> ⚠️ The assignment explicitly requires a bridge named `br0`.  
> I think it should be `br10` so it makes it clear the bridge is used in VXLAN `10`. You can see in [this post](https://vincent.bernat.ch/en/blog/2017-vxlan-bgp-evpn) the VNI are used for naming the bridges.

### IP Addressing conventions

| **Network Plan** | **Purpose**                                       | **Examples**                              |
| :--------------- | ------------------------------------------------- | ----------------------------------------- |
| **Underlay**     | Transport IP network (between VTEPs)              | `192.0.2.0/24`, `10.100.0.0/16`           |
| **Overlay**      | Logical VXLAN network (between VMs, containers)   | `20.1.1.0/24`, `172.16.0.0/12`            |
| **Loopbacks**    | Logical ID for VTEPs, router ID                   | `10.0.0.0/32` – one unique IP per router  |

> 💡 A loopback interface will be set in part 3. I know because I tried very hard to set one for this part before realizing it is not needed yet!

## Requirements

The project run inside a Linux virtual machine in which must be installed:

- GNS3
- Docker

Follow this guide: [GNS3 Linux Install](https://docs.gns3.com/docs/getting-started/installation/linux/).

## Walkthrough

### 1. Set up GNS3

1. Start GNS3.

2. Create a new project named `P2` as required by the assignment.

### 2. Create the network

1. From the device list, drag and drop the two routers, the two hosts and the ethernet switch to match the assignment schema.

2. To link the devices, click on the corresponding icon in the left toolbar:

   <img src="../assets/p2/gns3_link_icon.png" alt="Icon list to create link" height="400"/>

   You have to select the network interfaces as required in the assignment. Set the hosts number of network adaptaters to match the schema.

   <img src="../assets/p2/gns3_create_link.png" alt="Linking devices" height="400"/>

   For more clarity, you can show the interface labels from the top toolbar (the icon with "ABC" on it).

3. Choose the IP addresses to use:

   | **Device**  | **Interface** | **IP address** |
   | :---------- | :------------ | :------------- |
   | Router-1    | `eth0`        | 192.168.2.2/24 |
   | Router-2    | `eth0`        | 192.168.2.2/24 |
   | Host-1      | `eth1`        | 30.1.1.1/24    |
   | Host-2      | `eth1`        | 30.1.1.2/24    |

### 3. Unicast

In order to discover what a VXLAN is, let's manually create one. The assignment requires a VXLAN with VNI `10` and a bridge called `br0`. The two routers will be the two tunnel endpoints, aka the VTEPs.

1. **Configure first router**:

   Configure IP address on `eth0`:

   ```sh
   /sbin/ip addr add 192.168.2.1/24 dev eth0
   ```

   Create the VXLAN tunnel with ID `10`:

   ```sh
   /sbin/ip link add name vxlan10 type vxlan id 10 dstport 4789 local 192.168.2.1 remote 192.168.2.2 dev eth0
   ```

   `remote <IP>` is the remote router IP address and `local <IP>` is the router IP address. `dev <interface>` specifies the interface to use for the UDP packets. The peer's destination port for UDP is always `4789` ([RFC 7348](https://datatracker.ietf.org/doc/html/rfc7348)).

   Up the tunnel:

   ```sh
   /sbin/ip link set dev vxlan10 up
   ```

   Here is our first VTEP!

   Since the project run in a Linux virtual machine, a bridge is required to replace the VLAN. It links the hosts' `eth1` interfaces and the VXLAN tunnel together in a Layer 2 network like an Ethernet switch.

   Create and up bridge named `br0`:

   ```sh
   /sbin/ip link add br0 type bridge
   /sbin/ip link set dev br0 up
   ```

   Attach interfaces to bridge so the hosts connect to the VXLAN tunnel:

   ```sh
   /sbin/ip link set vxlan10 master br0
   /sbin/ip link set eth1 master br0
   ```

2. **Same for second router:**

   Configure IP address on `eth0`:

   ```sh
   /sbin/ip addr add 192.168.2.2/24 dev eth0
   ```

   Create and up VXLAN tunnel with ID `10` so we have our second VTEP:

   ```sh
   /sbin/ip link add name vxlan10 type vxlan id 10 dstport 4789 local 192.168.2.2 remote 192.168.2.1 dev eth0
   /sbin/ip link set dev vxlan10 up
   ```

   Create and up bridge named `br0`:

   ```sh
   /sbin/ip link add br0 type bridge
   /sbin/ip link set dev br0 up
   ```

   Attach interfaces to bridge:

   ```sh
   /sbin/ip link set vxlan10 master br0
   /sbin/ip link set eth1 master br0
   ```

3. **Configure first host:**

   ```sh
   /sbin/ip addr add 30.1.1.1/24 dev eth1
   ```

4. **Configure second host:**

   ```sh
   /sbin/ip addr add 30.1.1.2/24 dev eth1
   ```

5. Hosts should be able to ping each other.

💡 **Notes**

Even if this [tutorial video](https://www.youtube.com/watch?v=u1ka-S6F9UI) shows we have to configure an IP address on the VXLAN tunnel, it does not need one since it is attached to the bridge and operates at Layer 2 (it carries Ethernet frames, not packets). See it as a virtual Ethernet cable between two switches.

The bridge does not need an IP address too since it operates on Layer 2.

### 4. Multicast

In this topology, there is only one tunnel. What if there were many tunnels? Manually setting every remote peer for each VTEP would be so time-consuming! That's why it is time to discover **multicast**. An **IP multicast group** is associated to a VNI in order to link the VTEPs.

When creating the VXLAN tunnel, instead of setting the peer IP address (`remote <IP>`), a group with an IP address is specified (`group <IP>`). When a frame must be delivered to VNI members, the VTEPs send it to the group address. All VTEPs that subscribed to it will receive the frame. No need to configure every tunnel between peers.

The multicast IP address can be named with the VNI as last byte for clarity: VNI `10` -> `239.1.1.10`

Even if some commands must be updated (prefer `iproute2` utilities), this [article](https://vincent.bernat.ch/en/blog/2017-vxlan-linux) details the procedure with great explanations.

1. **Configure first router**:

   Configure IP address on `eth0`:

   ```sh
   /sbin/ip addr add 192.168.2.1/24 dev eth0
   ```

   Create and up the VXLAN tunnel. The only thing that changes here is the **group IP address** replacing the remote IP address.

   ```sh
   /sbin/ip link add name vxlan10 type vxlan id 10 dstport 4789 local 192.168.2.1 group 239.1.1.10 dev eth0
   /sbin/ip link set dev vxlan10 up
   ```

   Same as for unicast part, create and up bridge named `br0`. Attach the interfaces to it.

   ```sh
   /sbin/ip link add br0 type bridge
   /sbin/ip link set dev br0 up
   /sbin/ip link set vxlan10 master br0
   /sbin/ip link set eth1 master br0
   ```

2. **Same for second router:**

   Configure IP address on `eth0`:

   ```sh
   /sbin/ip addr add 192.168.2.2/24 dev eth0
   ```

   Then everything is the same as first router (except for the local IP address of course):

   ```sh
   /sbin/ip link add name vxlan10 type vxlan id 10 dstport 4789 local 192.168.2.2 group 239.1.1.10 dev eth0
   /sbin/ip link set dev vxlan10 up
   /sbin/ip link add br0 type bridge
   /sbin/ip link set dev br0 up
   /sbin/ip link set vxlan10 master br0
   /sbin/ip link set eth1 master br0
   ```

3. **Configure first host:**

   ```sh
   /sbin/ip addr add 30.1.1.1/24 dev eth1
   ```

4. **Configure second host:**

   ```sh
   /sbin/ip addr add 30.1.1.2/24 dev eth1
   ```

5. Hosts should be able to ping each other.

### 5. Save the project

Since the changes won't persist after the devices stop, create Shell scripts for configuring routers.

The project must be saved as a ZIP archive. In the menu bar, click `File` > `Export portable project`. Don't forget to include the base images to match the requirements.

## Defense

The [`docker` directory](/docker/) contains a Dockerfile for the routers based on FRR's with the configuration scripts.

If you didn't already build the router's Docker image, assuming you are at the directory's root:

```sh
$ docker build -t router_mboivin docker
```

## Resources

- [🇫🇷 VXLAN : des VLANs dynamiques et routables pour les clouds](https://blog.bluetrusty.com/2020/09/25/vxlan-des-vlans-dynamiques-et-routables-pour-les-clouds/)
- [VXLAN Bridge](https://docs.opnsense.org/manual/how-tos/vxlan_bridge.html)
- [VXLAN & Linux](https://vincent.bernat.ch/en/blog/2017-vxlan-linux)
- [VXLAN Flood and Learn Multicast Data Plane](https://networklessons.com/vxlan/vxlan-flood-and-learn-multicast-data-plane)
- Step-by-step tutorial but I don't agree with everything: [🎥 GNS3: FRRouting Using Docker Platform - VXLANs](https://www.youtube.com/watch?v=u1ka-S6F9UI)
- Not the software we use here, but clear explanations: [Création d'un pont réseau avec un VXLAN attaché](https://docs.redhat.com/fr/documentation/red_hat_enterprise_linux/9/html/configuring_and_managing_networking/proc_creating-a-network-bridge-with-a-vxlan-attached_assembly_using-a-vxlan-to-create-a-virtual-layer-2-domain-for-vms#proc_creating-a-network-bridge-with-a-vxlan-attached_assembly_using-a-vxlan-to-create-a-virtual-layer-2-domain-for-vms)
