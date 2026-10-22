# Glossaire

## A

- **AFNIC (Association française pour le nommage Internet en coopération)** : Gère les TLD de la France (`.fr`, `.re`, `.tf`, `.yt`, `.pm`, `.wf`).
- **ARP (*Address Resolution Protocol*)** : Protocole qui associe adresses IP et addresses MAC. Il se situe à l'interface entre les couche 2 et 3 du modèle OSI.
- **AS (*Autonomous System*)** : Internet étant un réseau de réseaux, les AS sont les plus grands réseaux qui le composent. Un AS a une politique de routage cohérente. Chaque ordinateur ou appareil qui se connecte à Internet est relié à un AS. (Source : [CloudFlare](https://www.cloudflare.com/fr-fr/learning/network-layer/what-is-an-autonomous-system/))
- **ASN (*Autonomous System Number*)** : Numéro de 16 bits (ou 32 depuis 2007, selon la RFC 4893) permettant d'identifier un AS.

## B

- **BGP (*Border Gateway Protocol*)** : Principal protocole supportant l'internet, synchronise les informations de routage entre les périphériques du réseau. Il utilise TCP comme protocole de transport. Il se situe dans la couche 7 du modèle OSI car c'est un protocole applicatif (il échange des messages structurés entre pairs pour établir des sessions, négocier des routes, échanger des mises à jour), il ne s'occupe ni du routage IP ni du transport (c'est TCP qui s'en charge) et possède sa propre logique métier (politique, choix de routes, filtrage, etc.). En résumé, BGP est un protocole de contrôle qui gère la logique de routage.
- **Broadcast (adresse de)** : Cette adresse IP est utilisée pour envoyer des paquets à tous les appareils d'un réseau. Elle est obtenue en mettant tous les bits du HOST ID à 1. Par exemple, si nous avons un réseau `10.0.0.0/24`, alors tout paquet envoyé à `10.0.0.255` sera reçu par toutes les machines du réseau.
- **BUM (*Broadcast, Unknown Unicast, Multicast*)**: Acronyme désignant trois types de trafics.
  - **Broadcast** : Trafic destiné à tous les nœuds d'un réseau (ARP, DHCP).
  - **Unknown Unicast** : Trafic destiné à un nœud spécifique dont l'adresse MAC n'est pas encore dans la table MAC du switch.
  - **Multicast** : Trafic destiné à un groupe de nœuds.

## C

- **Convergence réseau** : Processus d'intégration de différents services de communication qui élimine le besoin de réseaux distincts pour chaque type de services et permet donc de réduire les coûts et le nombre d'opérations.

## D

- **DBD (*Data Base Description*)** : Paquet OSPF résumant tous les liens que le routeur connaît. S'il un routeur ne reconnaît pas un voisin, il demande un LSR.
- **DNS (*Domain Name System*)**

## E

- **EBGP (*Exterior Border Gateway Protocol*)**
- **EIGRP (*Enhanced Interior Gateway Routing Protocol*)** : IGP propriétaire développé par Cisco. Protocole de routage IP hybride (présente des caractéristiques des protocoles à état de liens et de ceux à vecteur de distance).
- **EVPN (*Ethernet Virtual Private Network*)** : Plan de contrôle (VXLAN étant le [plan de données](https://www.cloudflare.com/fr-fr/learning/network-layer/what-is-the-control-plane/)), responsable de la propagation des mappages et des localisations IP/MAC, permettant de créer des réseaux plus évolutifs et agiles, de les superposer, segmenter et connecter plus facilement, notamment grâce à des tunnels. Il se situe dans la couche 2 du modèle OSI.

## F

- **FAI (Fournisseur d'Accès Internet)**
- **FRRouting or FRR (*Free Range Routing*)** : Suite de logiciels de routage, fork de Quagga, implémentant les protocoles BGP, OSPF, RIP, IS-IS, PIM, LDP, BFD, Babel, PBR, OpenFabric et VRRP pour les plates-formes de type Unix.

## I

- **IANA (*Internet Assigned Numbers Authority*)** : Société états-unienne à but non lucratif qui supervise l'allocation globale des adresses IP, des ASN et la gestion de la zone racine dans les DNS.
- **IBGP (*Interior Border Gateway Protocol*)**
- **ICANN (*Internet Corporation for Assigned Names and Numbers*)** : Société états-unienne à but non lucratif de régulation d'Internet. Coordonne et administre les ressourecs numériques (adressage IP, TLD) et les acteurs techniques.
- **ICMP (*Internet Control Message Protocol*)** : Protocole permettant de contrôler les erreurs de transmission puisque le protocole IP ne le peut pas (Exemple : débug avec la commande `ping`). Il se situe dans la couche 3 du modèle OSI.
- **IETF (*Internet Engineering Task Force*)** : Organisme de bénévoles qui élabore et promeut des standards internet en rédigeant des documents de spécification appelés RFC.
- **IGP (*Interior Gateway Protocol*)** : Protocole de routage permettant aux routeurs d'un système autonome de communiquer entre eux pour établir des sessions iBGP. Exemples : RIP, OSPF, IS-IS, EIGRP.
- **IP (*Internet Protocol*)**
- **IS-IS (*Intermediate system to intermediate system*)** : Protocole de routage à état de lien qui gère le routage entre les routeurs d'un même système autonome (AS) et utilisé pour les réseaux de grande taille. Il n'a pas besoin des adresses IP mais des NET IDs. Il se situe dans la couche 2 du modèle OSI.

## L

- **LIR (*Local Internet Registry*)** : Un RIR régional (Exemple : un FAI).
- **Loopback** : Interface virtuelle permettant à un équipement de s'envoyer des données à lui-même sans que ces données ne sortent sur le réseau physique. Conventionnellement, l'adresse IP de loopback est `127.0.0.1` en IPv4 et `::1` en IPv6. Le nom de domaine réservé `localhost` résout automatiquement en adresse IP de loopback sans requête DNS externe.
- **Loopback routable** : On ne parle pas de l'adresse `127.0.0.1` mais d'une interface loopback configurée avec une adresse IP routable souvent privée. Une interface virtuelle reste toujours disponible tant que l'équipement fonctionne. Elle est donc plus fiable qu'une interface physique. Elles sont routables via un IGP (IS-IS, OSPF, RIP, EIGRP) pour établir les sessions iBGP entre routeurs.
- **LSA (*Link-State Advertisement*)** : Paquet OSPF utilisé pour diffuser des informations sur un ou plusieurs liens d'un routeur OSPF.
- **LSR (*Link-State Request*)** Paquet OSPF permettant de demander des informations sur un voisin non connu. La réponse sera un paquet LSA.
- **LSU (*Link-State Update*)** : Paquet OSPF contenant plusieurs LSA.

## M

- **MAC (*Media Access Control*)**
- **MAC - LAA (*Locally Administered Addresses*)** : Ou adresse MAC locale/privée. Cela permet d'attribuer des adresses spécifiques au sein d'un réseau ou dans des simulateurs comme GNS3.
- **MAC - UAA (*Universally Administered Addresses*)** : Adresse MAC unique assignée à un équipement par son constructeur.
- **MPLS (*Multiprotocol Label Switching*)** : Technique de routage se basant sur des étiquettes pour acheminer des paquets de manière optimisée.

## O

- **OSI (*Open Systems Interconnection*)**
- **OSPF (*Open Shortest Path First*)** : Protocole de routage à état de lien. Il se situe dans la couche 3 du modèle OSI.
- **OUI (*Organizationally Unique Identifier*)** : Nombre de 24 bits permettant d'identifier un constructeur, par exemple dans les adresses MAC.

## Q

- **Quagga** : Logiciel de routage open-source basé dur le routeur Zebra. Il supporte les principaux protocoles de routage standardisés comme RIP, OSPF et BGP.

## R

- **RFC (*Request For Comments*)** : Documents rédigés par l'IETF décrivant les spécifications techniques d'Internet.
- **RIP (*Routing Information Protocol*)** : Protocole de routage IP à vecteur de distances.
- **RIR (*Regional Internet Registry*)** : Organisme qui alloue les blocs d'adresses IP. Ils sont 5 dans le monde : **RIPE NCC** (Europe, Moyen-Orient, Asie centrale), **ARIN** (Amérique du Nord), **LACNIC** (Amérique latine et Caraïbes), **AFRINIC** (Afrique), **APNIC** (Asie-Pacifique).
- **Routeur** : Équipement réseau assurant le routage des paquets en cherchant à déterminer la meilleure route. Il se situe dans la couche 3 du modèle OSI.

## S

- **Source Address Learning** : Mécanisme par lequel un switch (physique ou virtuel) apprend dynamiquement les adresses MAC des hôtes en observant les adresses source des trames Ethernet entrantes. Quand un paquet arrive sur un port, le switch lit l’adresse MAC source puis il associe cette MAC au port d’entrée dans sa table de commutation (*MAC table*).
- **Switch ou commutateur** : Équipement réseau permettant de connecter des périphériques en utilisant leurs adresses MAC. Il se situe dans la couche 2 du modèle OSI. Il construit et utilise une table qui associe numéro de port et adresses MAC. Lorsqu'il reçoit une trame, il la renvoie par le port correspondant à l'adresse MAC présente dans celle-ci.

## T

- **TCP (*Transmission Control Protocol*)**
- **TLS (*Transport Layer Security*)**

## U

- **UDP (*User Datagram Protocol*)** : Protocole de transmission de données ne garantissant ni la livraison, ni l'ordre, ni l'unicité des paquets. Il se situe dans la couche 4 du modèle OSI.

## V

- **VNI (*VXLAN Network Identifier*)** : Identifiant sur 24 bits du réseau virtuel auquel appartient un paquet et placé dans l'en-tête VXLAN.
- **VTEP (*VXLAN Tunnel End Point*)** : Points de terminaison de tunnel VXLAN qui encapsulent et désencapsulent les trames Ethernet.
- **vtysh (*Virtual TeletYpe SHell*)** : Shell en ligne de commande fourni par FRRouting. Il permet aux utilisateurs d'interagir de manière unifiée avec les différents daemons du système FRR, tels que : `bgpd`, `ospfd` ou `zebra` pour la table de routage. Il communique avec ces daemons par des sockets UNIX, plus précisément des VTY sockets (Virtual Teletype interfaces). Ainsi, lorsqu'on tape une commande dans `vtysh`, elle est transmise au démon concerné via la socket, le démon exécute l'action, puis retourne la réponse à `vtysh`.
- **VXLAN (*Virtual Extensible LAN*)** : Technologie de virtualisation des réseaux qui permet de partager un même réseau physique entre plusieurs organisations différentes sans qu'aucun ne soit en mesure de voir le trafic réseau des autres (Source : [Juniper Networks](https://www.juniper.net/fr/fr/research-topics/what-is-vxlan.html)). Il encapsule des trames Ethernet de couche 2 dans des datagrammes UDP de couche 4.

## Z

- **Zebra** : Gestionnaire de routage créé dans les années 90 et arrêté en 2003. Quagga en est un fork. Attention, le zebra de FRRouting n'est pas une reprise de ce projet.
- **zebra** : Le daemon gérant le routage des paquets (*IP routing manager*) dans FRRouting ([Documentation FRR](https://docs.frrouting.org/en/latest/zebra.html)). Ce n'est pas le Zebra original.
