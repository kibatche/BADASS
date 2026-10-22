# Part 1

The first part of the project is an **introduction to GNS3 simulator**. It details how to set up a work environment in a virtual machine.

**Docker** containers are used as ligth virtual machines. This is **not a production-ready** use case.

What will be covered is how to import Docker images into the software and how to configure the *FRRouting* daemons file (located at `/etc/frr/daemons`) to run the services required by the assignment.

## Table of Content

- [Requirements](#requirements)
- [Walkthrough](#walkthrough)
    1. [Create Docker images](#1-create-docker-images)
    2. [Set up GNS3](#2-set-up-gns3)
    3. [Create the network](#3-create-the-network)
    4. [Save the project](#4-save-the-project)
- [Defense](#defense)
- [Resources](#resources)

## Requirements

The project run inside a Linux virtual machine in which must be installed:

- GNS3
- Docker

Follow this guide: [GNS3 Linux Install](https://docs.gns3.com/docs/getting-started/installation/linux/).

## Walkthrough

### 1. Create Docker templates

1. Pull the router image:

   ```sh
   $ docker pull frrouting/frr:v8.4.0
   ```

   FRRouting is an open-source network project including everything needed to complete the assignment.

2. Pull the host Docker image:

   ```sh
   $ docker pull alpine:3.21.3
   ```

### 2. Set up GNS3

1. Start GNS3.

2. Create a new project named `P1` as required by the assignment.

3. Now, time to add container templates to GNS3. In the menu bar, click on `Edit` > `Preferences`. A new window will open. In the left menu, select `Docker containers`.

   <img src="../assets/p1/gns3_settings_preferences.png" alt="GNS3 preferences" height="400"/>

4. Click on `New` and select the Alpine image from the list.

   <img src="../assets/p1/gns3_new_docker_container.png" alt="Create new Docker container in GNS3" height="400"/>

   Configure the template. Name it with your 42 username as follows: `host_<username>`. Since it will be used as a host, this machine only needs one network adapter. However, let's set the default number of adapter to 2.

5. Repeat this operation with the router image built earlier. Name it with your 42 username as follows: `router_<username>`.

6. Now let's continue configuring the templates. Display the available devices by clicking the corresponding icons in the left menu:

   <img src="../assets/p1/gns3_device_menu.png" alt="GNS3 device list" height="400"/>

7. The router doesn't look like one. Right-click on it and select `Configure template`. Find the `Symbol` field and select the icon required in the assignment.

   <img src="../assets/p1/gns3_icon_list.png" alt="Icon list for devices" height="400"/>

### 3. Create the network

1. From the device list, drag and drop the Alpine host and the router. Right-click on the router, choose `Configure` and remove the `-<N>` suffix to meet the assignment requirements.

2. Start the router in the topology and open a new auxiliary console window by right-clicking on the router icon and `Auxiliary console`. The assignment requires:
    - The service BGPD active and configured.
    - The service OSPFD active and configured.
    - An IS-IS routing engine service.
  To meet these requirements, we must explicitely enable the daemons in the configuration file named `/etc/frr/daemons`. FRR's official documentation explains all of it [here](https://docs.frrouting.org/en/latest/setup.html).  
  Open the file with a text editor such as `vi`. Enable the `bgpd`, `ospfd` and `isisd` daemons by changing the value from `no` to `yes`.
  `vtysh_enable` can be set to `yes` too in order to `vtysh` to apply configuration when starting the daemons.

3. Start the host in the topology.

4. Open both devices auxiliary console and run `ps` to check the output matches the assignment's one.

### 4. Save the project

Since the changes won't persist after the devices stop, save the `/etc/frr/daemons` file.

The project must be saved as a ZIP archive. In the menu bar, click `File` > `Export portable project`. Don't forget to include the base images to match the requirements.

## Defense

The [`docker` directory](/docker/) contains a Dockerfile for the router based on FRR's with the configured daemons file.

Assuming you are at the directory's root:

```sh
$ docker build -t router_mboivin docker
```

## Resources

- [🎥 GNS3: FRRouting Using Docker Platform](https://www.youtube.com/watch?v=D4nk5VSUelg)
- [GNS3: Docker support in GNS3](https://docs.gns3.com/docs/emulators/docker-support-in-gns3/)
- [FRR: VTYSH](https://docs.frrouting.org/projects/dev-guide/en/latest/vtysh.html)
- [FRR: Basic Setup](https://docs.frrouting.org/en/latest/setup.html)
