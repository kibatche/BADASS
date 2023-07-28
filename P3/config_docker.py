import docker
import time
import sys

NODE_NB = 7
RR_IP = '1.1.1.1'

def set_router_daemon(container:object, name:str) -> int:
    daemon = ['bgpd', 'ospfd', 'isisd']

    sed_commands = ' '.join([f'-e "s/^{d}=no/{d}=yes/"' for d in daemon])
    command = f'sed -i {sed_commands} /etc/frr/daemons'
    container.exec_run(command)

    try:
        container.restart()
        print(f"[*] node {name} has been restarted.")
    except docker.errors.APIError as e:
        print(f"An error occurred while restarting {name}: {e}")
        return 1
    return 0


def check_nodes_presence() -> int:
    n_try = 0

    while n_try < 10:
        containers_len = len(docker.from_env().containers.list())
        if containers_len == NODE_NB:
            return 0
        if containers_len > NODE_NB:
            print("[x] To many containers: check gns3 and script parameters please")
            return 2
        print(f"[x] try: {n_try}: {NODE_NB - containers_len} node(s) are missing...")
        time.sleep(1)
        n_try += 1
    return 1


def get_dockers() -> dict:
    containers = {}
    client = docker.from_env()
    for container in client.containers.list():
        hostname = container.attrs['Config']['Hostname']
        containers[hostname] = container.id
    return containers


def configure_host(container:object, name:str) -> None:
    command = f"ip addr add 20.1.1.{name[-1]}/24 dev eth{'1' if name[-1] == '1' else '0'}"
    res = container.exec_run(command)
    print(res)
    print(f"[*] {name} as being attributed with ip address: 20.1.1.{name[-1]}/24 on eth{'1' if name[-1] == '1' else '0'}")

def configure_vxlan_bridge(container:object, name:str) -> None:
    commands = [
    'brctl addbr br0',                                   # bridge creation
    'ip link set up dev br0',                            # bridge activation
    'ip link add vxlan10 type vxlan id 10 dstport 4789', #  vlxlan interface creation
    'ip link set up dev vxlan10',                        # vxlan interface activation
    'brctl addif br0 vxlan10',                           # add vlxlan10 interface to the bridge
    f'brctl addif br0 eth{"1" if name[-1] == "2" else "0"}'# ajout interface eth1 au bridge
    ]

    for command in commands:
        print(command)
        container.exec_run(command)
    #container.exec_run(' && '.join(commands))

    
def get_vtysh_configuration(name:str, rr_ip:str, isrr:bool) -> str:
    configuration = []

    configuration.append('config t')                # enter configuration mode
    configuration.append(f'hostname {name}')        # set hostname
    configuration.append('no ipv6 forwarding')      # no forwarding ipv6

    if isrr:
        configuration.append('interface eth0')
        configuration.append('ip address 10.1.1.1/30')
        configuration.append('interface eth1')
        configuration.append('ip address 10.1.1.5/30')
        configuration.append('interface eth2')
        configuration.append('ip address 10.1.1.9/30')
        configuration.append('interface lo')
        configuration.append(f'ip address {rr_ip}/32')
    else:
        ### interface setup
        configuration.append(f'interface eth{int(name[-1]) - 2}')
        configuration.append(f'ip address 10.1.1.{4 * int(name[-1]) - 6}/30')
        configuration.append('ip ospf area 0')
    
        configuration.append('interface lo')
        configuration.append(f'ip address 1.1.1.{name[-1]}/32')
        configuration.append('ip ospf area 0')

    ### bgp setup 
    configuration.append('router bgp 1')
    if isrr:
        configuration.append('neighbor ibgp peer-group')
        configuration.append('neighbor ibgp remote-as 1')
        configuration.append('neighbor ibgp update-source lo')
        configuration.append('bgp listen range 1.1.1.0/29 peer-group ibgp')
    else:
        configuration.append(f'neighbor {rr_ip} remote-as 1')
        configuration.append(f'neighbor {rr_ip} update-source lo')
    
    ### evpn setup
    configuration.append('address-family l2vpn evpn')
    if isrr:
        configuration.append('neighbor ibgp activate')
        configuration.append('neighbor ibgp route-reflector-client')
    else:
        configuration.append(f'neighbor {rr_ip} activate')
        configuration.append('advertise-all-vni')
    configuration.append('exit-address-family')

    configuration.append('router ospf')
    if isrr:
        configuration.append('network 0.0.0.0/0 area 0')
        configuration.append('line vty')

    configuration.append('end')
    configuration.append('write memory') # not sure is usefull
    return '\n'.join(configuration)


def configure_vtep(container:object, name:str, rr_ip:str) -> None:

    configure_vxlan_bridge(container, name)
    vtysh_conf = get_vtysh_configuration(name, rr_ip, False)
    #
    print(vtysh_conf)
    response = container.exec_run(cmd=f"vtysh -c '{vtysh_conf}'")
    print(response.output.decode("utf-8"))


def configure_route_reflector(container:object, name:str, rr_ip:str) -> None:
    vtysh_conf = get_vtysh_configuration(name, rr_ip, True)

    print(vtysh_conf)
    response = container.exec_run(cmd=f"vtysh -c '{vtysh_conf}'")

    pass

def main(argv) -> int:

    # get presence of all the nodes
    if check_nodes_presence():
        print('[x] aborting configuration...\n')
        return 1

    client = docker.from_env()
    nodes = get_dockers()

    # set router daemon and restart them to apply changes
    if len(argv) == 2 and argv[1] == 'set_daemons':
        for n in nodes:
            if n.startswith('router'):
                container = client.containers.get(nodes[n])
                if set_router_daemon(container, n):
                    print('[x] aborting configuration...\n')
                    return 1
        # check that everything still okay
        time.sleep(10)
        if check_nodes_presence():
            print('[x] aborting configuration...\n')
            return 1
        # restart ins't working well with gns3 so end config there and please restart on gns3
        return 0
        # refresh
        #client = docker.from_env()
        #nodes = get_dockers()



    # configure the nodes
    print('[*] Start configuring all nodes...\n')
    for n in nodes:
        container = client.containers.get(nodes[n])
        if n.startswith('host'):
            print(f'[*] configuring (host): {n}')
            configure_host(container, n)
        elif n[-1] == '1':
            print(f'[*] configuring (route reflector): {n}')
            configure_route_reflector(container, n, RR_IP)
        else:
            print(f'[*] configuring (vtep-leaf): {n}')
            configure_vtep(container, n, RR_IP)

        print('\n##################################\n')

    return 0

if __name__ == '__main__':
    sys.exit(main(sys.argv))