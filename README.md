# BADASS

Création d'un réseau avec les protcoles BGP/VXLAN/EVPN à l'aide de GNS3.

Les informations dans ce README sont issues de "Les Réseaux" de Guy Pujolle, ainsi que "Computer Networks" de Andrew S. Tanenbaum, Nick Feamster, David J. Wetherall.

## Les Systèmes Autonomes (AS)

Un AS, un système autonome, est une entité essentielle dans la construction du réseau internet. Il s'agit d'une collection de machines qui opèrent sous une même autorité. Cette autorité administrative peut être une université, un FAI, une entreprise etc. Internet est constitué de ces multiples réseaux indépendants, auxquels le IANA (Internet Assigned Numbers Authority) attribue une identification unique. Chacun de ces AS communiquent entre eux, il faut donc, pour diverses raisons, router ces informations selon des procédés particuliers à ce type de réseaux externes.

Dans ce projet, nous allons utiliser différents protocoles, aussi bien à usage interne que externe. De nombreuses couches du modèles OSI sont en jeu, ainsi que des imbrications parfois un peu complexes de protocoles.

## Algorithmes de routage

Le routage sert à transmettre des informations au travers des noeuds d'un réseau. Chaque type possède ses avantages et inconvénients, mais l'idée principale reste d'établir une table de routage pour chaque noeud et de transmettre cette informations sans qu'un noeud intervienne deux fois lors de la transmission d'un paquet.

Il y a trois types principaux d'algo de routage :

- À vecteur de distance
- À état des liens
- À vecteur de chemin

### À vecteur de distance

Les algorithmes de routage à vecteur de distance requièrent que chaque nœud s’échange des informations entre voisins, c’est-à‑­dire entre nœuds directement connectés. De ce fait, chaque nœud peut maintenir à jour une table en y ajoutant des informations sur tous ses voisins. Cette table donne la distance à laquelle se trouvent chaque nœud et chaque réseau à atteindre. Première à avoir été mise en œuvre dans le réseau ARPAnet, cette technique devient vite lourde lorsque le nombre de nœuds augmente puisqu’il faut transporter beaucoup d’informations de nœud en nœud. RIP (Routing Information Protocol) est le meilleur exemple de protocole utilisant un vecteur de distance.

Dans ce type d’algorithme, chaque routeur diffuse à ses voisins un vecteur listant chaque réseau qu’il peut atteindre avec la métrique associée, c’est-à‑­dire le nombre de sauts. Chaque routeur peut donc bâtir une table de routage avec les informations reçues de ses voisins, mais n’a aucune idée de l’identité des routeurs qui se trouvent sur la route sélectionnée. De ce fait, l’utilisation de cette solution pose de nombreux problèmes pour les protocoles de routage
extérieurs. Il est en effet supposé que tous les routeurs utilisent la même métrique, ce qui peut ne pas être le cas entre systèmes autonomes. De plus, un système autonome peut avoir des raisons particulières de se comporter différemment d’un autre système autonome. En particulier, si un système autonome a besoin de déterminer par quel autre système autonome vont passer ses messages, pour des raisons de sécurité par exemple, il ne peut pas le savoir.

### À état des liens

Les algorithmes à état des liens avaient au départ pour objectif de pallier les défauts du routage par vecteur de distance. Quand un routeur est initialisé, il doit définir le coût de chacun de ses liens connectés à un autre nœud. Le nœud diffuse ensuite l’information à l’ensemble des nœuds du système autonome, et donc pas seulement à ses voisins. À partir de l’ensemble de ces informations, les nœuds peuvent effectuer un calcul leur permettant d’obtenir une table de routage indiquant le coût nécessaire pour atteindre chaque destination. Lorsqu’un routeur reçoit des informations qui modifient sa table de routage, il en avertit tous les routeurs intervenant dans sa configuration. Comme chaque nœud possède la topologie du réseau et les coûts de chaque lien, le routage peut être vu comme centralisé dans chaque
nœud.

Le protocole **OSPF** (Open Shortest Path First) met en œuvre cette technique, qui correspond à la deuxième génération de protocoles Internet.

Les algorithmes à état des liens règlent les problèmes évoqués précédemment pour le routage extérieur, mais en soulèvent d’autres. Les divers systèmes autonomes peuvent avoir des métriques différentes ainsi que des restrictions spécifiques, de telle sorte qu’il ne soit pas possible d’obtenir un routage cohérent. La diffusion de l’ensemble des informations nécessaires à l’ensemble des systèmes autonomes peut par ailleurs devenir rapidement
ingérable.

### À vecteur de chemin

L’objectif des algorithmes à vecteur de chemin est de pallier les insuffisances des deux premières catégories en se dispensant des métriques et en cherchant à savoir quel réseau peut être atteint par quel nœud et quels systèmes autonomes doivent être traversés pour cela. Cette approche est très différente de celle par vecteur de distance puisque les vecteurs de chemin ne prennent pas en compte les distances ni les coûts. De plus, du fait que chaque information de routage liste tous les systèmes autonomes qui doivent être traversés pour arriver au routeur destinataire, l’approche par vecteur de chemin est beaucoup plus dirigée vers les systèmes de routage extérieurs. Le protocole BGP (Border Gateway Protocol) appartient à cette catégorie.

## Les protocoles

### IS-IS

L’algorithme IS-­IS a été principalement développé par l’ISO (ISO 10589). Il décrit un routage hiérarchique fondé sur la décomposition des réseaux de communication en domaines. Dans un domaine, les différents nœuds indiquent leur état aux routeurs IS-­IS afférents. Les communications interdomaines sont effectuées par un routage vers un point d’accès au domaine déterminé par les routeurs chargés des communications externes au domaine.

### OSPF

OSPF fait partie de la deuxième génération de protocoles de routage. Beaucoup plus complexe que RIP, mais au prix de performances supérieures, il utilise une base de données distribuée, qui garde en mémoire l’état des liens. Ces informations forment une description de la topologie du réseau et de l’état des nœuds, qui permet de définir l’algorithme de routage par un calcul des chemins les plus courts.

L’algorithme OSPF permet, à partir d’un nœud, de calculer le chemin le plus court, avec les contraintes indiquées dans les contenus associés à chaque lien. Les routeurs OSPF communiquent entre eux par l’intermédiaire du protocole OSPF, placé au-­dessus d’IP. Regardons maintenant ce protocole de façon un peu plus détaillée.

L’hypothèse de départ pour les protocoles à état des liens est que chaque nœud est capable de détecter l’état du lien avec ses voisins (marche ou arrêt) et le coût de ce lien. Il faut donner à chaque nœud suffisamment d’informations pour lui permettre de trouver la route la moins chère vers toutes les destinations. Chaque nœud doit donc avoir la connaissance de ses voisins. Si chaque nœud à la connaissance des autres nœuds, une carte complète du réseau peut être dressée. Un algorithme se fondant sur l’état des voisins nécessite deux mécanismes : la dissémination fiable des informations sur l’état des liens et le calcul des routes par sommation des connaissances accumulées sur l’état des liens.

(...)

Il y a plusieurs types de messages OSPF, mais ils utilisent tous le même en-­tête, qui est illustré à la figure 10.11.

La version en cours est la 2. Cinq types ont été définis avec des valeurs de 1 à 5. L’adresse source indique l’émetteur du message. L’identification de l’ère indique l’ère dans laquelle se trouve le nœud émetteur. Le type d’authentification porte la valeur 0 s’il n’y a pas d’authentification, 1 en cas d’authentification par mot de passe et 2 si une technique d’authentification est mise en œuvre et décrite dans les 4 octets suivants.

![OSPF header](https://github.com/kibatche/BADASS/assets/61985948/517f296e-4dd7-42d2-a5e1-baaed1c75fde)

Les cinq types de messages comportent le message Hello comme type 1. Ce message est envoyé par un nœud à ses voisins pour leur indiquer qu’il est toujours présent et non en panne. Les quatre autres types servent à envoyer des informations telles que des requêtes, des envois ou des acquittements des messages LSP (Link-­State Packet, des paquets de mise à jour présents en chacun des noeuds). Ces messages transportent principalement des LSA (Link-­State Advertisement), c’est-à‑­dire des informations sur l’état des liens. Un message OSPF peut contenir plusieurs LSA.

La figure 10.12 illustre un message OSPF de type 1 portant un LSA.

![OSPF with LSA](https://github.com/kibatche/BADASS/assets/61985948/ffca27a5-8452-4cfd-817b-ef3bfdd30d2d)

Ce type indique le coût des liens entre les routeurs. Le type 2 est utilisé pour indiquer les réseaux auxquels l’émetteur est connecté. Les types 3 et 4 se préoccupent de l’indication des ères. À la figure 10.12, le champ LS Age est l’équivalent du temporisateur TTL (Time To Live), si ce n’est que le compteur augmente jusqu’à une certaine valeur prédéfinie, alors que le TTL descend jusqu’à 0.

Le type est ici le type 1. Les deux champs Link State ID et LS sequence number sont identiques et transportent l’identificateur du routeur qui émet le message. La raison de ce double champ est de vérifier l’identité du routeur par deux moyens différents. Le numéro de séquence permet de reséquencer les messages reçus. Le LS Checksum permet de vérifier la correction du message. Il prend en compte les informations à partir du champ Option. Le champ longueur indique la longueur totale du message. Ce sont ensuite des informations sur le LSA qui sont transportées : Link ID identifiant chaque lien, informations à propos du lien (Link Data) et métrique.

### BGP (Border Gateway Protocol)

Pour répondre aux faiblesses d’EGP, un nouvel algorithme a été mis en chantier par l’IETF sous le nom de BGP. Une première version, BGP-1, a été implémentée en 1990, suivie de près par BGP-2 puis BGP-3. Au bout de quelques années a été déployé BGP-4, qui permet de gérer beaucoup plus efficacement les tables de routage de grande dimension en rassemblant en une seule ligne plusieurs sous-­réseaux.

BGP apporte de nouvelles propriétés par rapport à EGP, en particulier celle de gérer les boucles, qui devenaient courantes dans EGP puisque ce protocole ne s’occupe que des couples de voisins, sans prendre en compte les rebouclages possibles par un troisième réseau autonome.

Les messages échangés par le biais de BGP-4 sont les suivants :

- **open** : pour ouvrir une relation avec un nœud voisin.
- **update** : pour transmettre des informations au sujet d’une seule route ou demander la destruction de routes qui ne sont plus disponibles.
- **keepalive** : pour acquitter les messages open et confirmer que la relation de voisinage est toujours vivante.
- **notification** : pour envoyer un message d’erreur.

Les trois grandes procédures fonctionnelles suivantes sont définies dans BGP :

- acquisition des nœuds voisins ;
- possibilité d’atteindre le voisin ;
- possibilité d’atteindre des réseaux.

Deux routeurs sont considérés comme voisins s’ils sont dans le même réseau. Si les deux routeurs sontdans des domaines autonomes distincts, ils peuvent avoir besoin d’échanger des informations de routage. Pour cela, il faut d’abord réaliser une acquisition des voisins, c’est-à‑­dire permettre à deux nœuds qui nesont pas dans le même système autonome d’échanger des informations de routage. L’acquisition doit être faite par une procédure formelle puisqu’un des deux nœuds peut ne pas avoir envie d’échanger de l’information de routage. Pour réaliser l’acquisition, un nœud émet le message open. Si le routeur distant accepte la relation, il renvoie un keepalive. Une fois la relation établie, pour maintenir la relation active les nœuds s’échangent des keepalive. Chaque nœud maintient une base de données des réseaux qu’il peut atteindre et de la route permettant d’arriver à ces différents réseaux. Quand un changement intervient, le routeur diffuse un message update vers les autres routeurs, ce qui permet à ceux-­ci de se mettre à jour.

La figure 10.13 illustre le format du paquet de mise à jour BGP.

![image](https://github.com/kibatche/BADASS/assets/61985948/12ce2191-ce45-4c49-8a8c-90640a29471f)

Le champ Marker est réservé à l’authentification. L’émetteur peut mettre un texte chiffré qui ne peut être déchiffré que par le récepteur possédant la clé de chiffrement. Length donne la longueur du message en octet. Les types de message sont open, update, keepalive et notification.

Pour mettre en place une relation de voisinage, le routeur de départ initie une connexion TCP puis envoie un message open. Ce message indique le système autonome dans lequel l’émetteur se trouve ainsi que l’adresse IP du routeur. Il inclut également un paramètre hold time parameter, qui indique le nombre de secondes proposées pour le temporisateur Hold Timer afin de déterminer le temps maximal entre deux messages provenant de l’émetteur (keepalive, update). Si le distant accepte la relation, il calcule le minimum de son propre temporisateur Hold Timer et de celui de l’émetteur et l’envoie à l’émetteur.

![Open packet BGP](https://github.com/kibatche/BADASS/assets/61985948/adaab91a-e036-4d41-8a4b-027c16bfe60d)

(...)

### VXLAN

VXLAN (Virtual eXtensible LAN) est une solution permettant de réaliser des communications dans des grands Clouds entre datacenters. La technologie est assez similaire à celle des VLAN et des extensions Ethernet Carrier Grade. Elle a été proposée au départ par Cisco et VMware. L’inconvénient de la solution de base de VLAN IEEE 802.1Q est la limitation à 4 096 VLAN. VXLAN permet d’étendre la technologie de base en parallèle des Ethernet Carrier Grade.

À la trame Ethernet de base, on ajoute une zone VXLAN d’identification de 24 bits permettant d’atteindre plus de seize millions de VLAN puis un champ UDP de 64 bits, lequel est ensuite encapsulé dans une trame Ethernet avec des champs adresse source, destination et VLAN associés à XVLAN. La trame Ethernet de base est donc la partie « données » du message UDP, lui-­même transporté dans une trame Ethernet. Cette propriété permet de réaliser des VLAN au-­delà d’un domaine Ethernet. Ces encapsulations sont représentées à la figure 9.17.

![trame vxlan](https://github.com/kibatche/BADASS/assets/61985948/019b5fcd-4354-43c8-9c57-6423718272b2)

Les composants d'un VXLAN :

- **Segment VXLAN** : chaque réseau superposé VXLAN est appelé segment VXLAN. Hôtes (par exemple, les machines virtuelles) qui font partie du même segment VXLAN (même domaine de diffusion(_broadcast domain_)) peuvent communiquer entre eux. Une passerelle de couche 3 est nécessaire pour les communications inter-VNI.
- **Identifiant de réseau VXLAN (VNI)** : chaque segment VXLAN est identifié par un identifiant de 24 bits appelé VNI. Cela permet une segmentation à grande échelle du réseau en autorisant la coexistence de jusqu'à 16M de segments VXLAN de coexister dans le même domaine administratif. Le VNI permet d'isoler le trafic pour chaque segment VXLAN. Un hôte est identifié par la combinaison unique de son adresse MAC et de son VNI. Cela permet le chevauchement d'adresses qui se chevauchent entre les segments puisque le VNI définit la portée de la trame de couche 2 interne créée par l'hôte final. Par conséquent, des VNI différents se traduisent par des domaines différents et le trafic ne passe pas d'un domaine à l'autre.
- **VXLAN Tunnel Endpoint (VTEP)** : La trame de couche 2 émise par l'hôte final est encapsulée dans un en-tête VXLAN qui comprend le VNI utilisé pour identifier le tunnel VXLAN. Les tunnels sont également utilisés pour ajouter un en-tête extérieur d'encapsulation externe comprenant des en-têtes UDP, IP et Ethernet pour transporter le trafic de l'hôte final sur le réseau physique sous-jacent. Ce sont points d'extrémité de tunnel ou _Network Virtualization Edges_ (NVE) qui sont responsables de la mise en correspondance des hôtes finaux avec les segments VXLAN appropriés. L'encapsulation et la décapsulation des tunnels liés au VXLAN sont appelées VTEP. Les VTEP peuvent exister sur sur n'importe quel dispositif de réseau (environnement multifournisseur) ou élément de calcul (par exemple, serveur, hyperviseur). Chaque VTEP est identifié par une adresse IP unique (adresse lo0). Le réseau physique sous-jacent est chargé de fournir la joignabilité IP entre les VTEP pour assurer la livraison du trafic de bout en bout. Les VTEP remplissent **deux fonctions** importantes à savoir **1)** la découverte de VTEP à distance pour créer une correspondance entre les adresses MAC de l'hôte final et les VTEP correspondants pour les segments VXLAN dont il est responsable; et **2)** l'encapsulation VXLAN des adresses MAC des hôtes finaux pour le transporter de manière transparente sur le réseau sous-jacent et la décapsulation ultérieure des paquets reçus pour la livraison aux bons hôtes finaux. Les VTEP peuvent commuter des paquets dans le même VNID ou dans le même domaine de diffusion (passerelles L2, _L2 Gateway_) ou peuvent acheminer des paquets à travers différents VNID ou différents sous-réseaux (passerelles L3, _L3 Gateway_).
- **Encapsulation VXLAN** : L'encapsulation VXLAN ajoute 50-54B de surcharge du fait de l'ajout d'en-têtes UDP, IP et Ethernet à la trame générée par l'hôte final. Par conséquent, il est important que le réseau de sous-couche IP prenne en charge les trames Jumbo afin de tenir compte de cette surcharge, ce qui signifie que les valeurs MTU doivent refléter la même chose sur l'ensemble du chemin traversé par le paquet encapsulé. L'en-tête UDP ajoute sa valeur de port source en calculant un hachage du contenu de la trame interne d'origine (en-têtes L2/L3/L4). Cela permet l'entropie de flux pour assurer l'équilibrage efficace de la charge du trafic VXLAN sur les chemins ECMP offerts par la sous-couche physique. La somme de contrôle UDP est fixée à 0x0000. Si la somme de contrôle n'est pas réglée sur 0x0000 par le VTEP source, le VTEP récepteur doit vérifier la somme de contrôle. Si elle est incorrecte, la trame doit être abandonnée et non décapsulée. L'en-tête IP externe se compose des adresses IP du VTEP source et de destination et ces valeurs sont utilisées pour l'acheminement du paquet par le VTEP. Ces valeurs sont utilisées pour que le paquet soit acheminé par le réseau sous-jacent. Les équipements du réseau sous-couche ne regardent pas l'en-tête VXLAN, ils ne maintiennent pas non plus d'état de tunnel et sont donc découplés de la couche supérieure.

![vxlan](https://github.com/kibatche/BADASS/assets/61985948/82b21031-9067-47fb-81dd-397ad2da056c)

---

Le projet
---------

# P1

La P1 est très simple : il s'agit juste de configurer notre vm et gns3, ainsi que deux images docker afin d'avoir :

1) un routeur
2) un hôte

Pour le routeur, afin de garder une configuration constante (c'est à dire qui ne s'efface pas à chaque création de conteneur à partir d'une image), on va faire notre propre Dockerfile. Il est présent dans le dossier `Docker` de chaque partie. Un script est présent pour construire le conteneur (c'est à lancer si jamais on n'a pas l'image sur la vm).

Les services à démarrer (sous forme de daemons, c'est à dire en arrière-plan) sont :

- `bgpd`, pour le protocole bgp (voir plus haut)
- `ospfd`, pour le protocole ospf (voir plus haut)
- `isisd`, pour le protocole is-is (voir plus haut)

Pour ce faire, c'est ultra simple, il suffit de changer dans le fichier /etc/frr/daemons les `no` par des `yes` pour les services voulus.

Concernant l'hôte, on a juste à importer l'image alpine.

Afin d'importer ces images dans gns3 : `edit/preferences/docker` et ajouter les images.

Ensuite on peut les retrouver dans l'onglet `browse all devices` et les glisser déposer.

Pour terminer, il nous suffit juste de démarrer ces conteneurs, et à l'aide de la commande `ps` on est en mesure de voir que tout est bien configuré.

# P2

La P2 est beaucoup plus difficile. Il s'agit ici de créer un VXLAN (voir ci-dessus ce que c'est), afin de faire communiquer deux machines entre-elles.
En réalité, les VXLAN sont surtout utilisés dans les datacenters, afin de faire communiquer par exemple deux datacenters entre eux.

Nos prétentions et nos finances étant limitées, on se contentera donc de le faire entre deux hôtes alpine linux de 5mb chacun. :)

Comme expliqué dans la partie correspondante de ce document, les VXLAN permettent de largement étendre le nombre de réseau virtuels (VLAN) possibles, en faisant passer de 4096 VLAN possibles à plusieurs millions, grâce notamment à l'encapsulation des trames ethernet dans une partie VXLAN à l'aide d'un identifiant (le VNI). On notera que Ethernet est un protocole **physique** et que les vlan visent d'abord à segmenter le réseau physique en réseau virtuel et ainsi augmenter leur efficience.

Ethernet utilise principalement les adresses macs, nous aurons donc besoin de switches. Dans notre cas particulier, topologiquement ce sont des **spine** pour faire la communication entre deux baies par exemple, et des **leaf switches** concernant la trame ethernet au niveau de la baie elle-même. Nos deux routeurs quant à eux sont des **LEAFS**, mais dans la mesure où ce sont eux qui sont responsables de l'encapsulation et de la désencapsulation des trames, elles sont appellées VTEP : _Vxlan Tunnel Endpoints_.

Pour terminer, le projet demande explicitement deux façons de faire communiquer les machines et d'établir une table de routage :

- Statique, c'est un lien direct
- Multicast, c'est une sorte de flood, via   une option de souscription pour chacun des routeurs (on verra cela plus loin)

Un fichier de script est executé afin de déployer la configuration.

Pour le côté statique et multicast, au départ, voyons ce qu'il en est :

1) Nous devons connecter notre routeur avec le switch. Pour ce faire, on utilise un bridge.

> Note : on utilise /sbin/ip car ip de busybox ne prend pas en charge le protocole vxlan...

```bash
brctl addbr br0
/sbin/ip link set dev br0 up
```

2) Ensuite nous devons attribuer une adresse IP à l'interface eth0 (la couche ip sera en connexion avec le switch) :

```bash
/sbin/ip a add 10.42.42.$1/8 dev eth0
```

> Note : selon qu'on soit sur le routeur 1 ou 2, on change le dernier numéro pour l'adresse IP.

3) On peut checker si l'interface est up avec la bonne adresse ip :

```bash
/sbin/ip a show eth0
```

À cette étape, le mode statique ou dynamique de découverte des routes change la façon de mettre en place l'interface vxlan.

### Statique

4) On va créer l'interface vxlan. Voyons la commande en entier, avant de la segmenter afin de mieux la comprendre :

```bash
/sbin/ip link add name vxlan10 type vxlan id 10 dev eth0 remote 10.42.42.$2 local 10.42.42.$1 dstport 4789
```

- `/sbin/ip link add name vxlan10` : on attribue un nom à l'interface
- `type vxlan` : on attribue un type, ici on veut une interface vxlan
- `id 10` : c'est le VNI (voir plus haut), le sujet nous commande d'utiliser le nombre 10.
- `dev eth0` : l'interface utilisée pour le trafic sortant, donc eth0 (qu'on a configurée plus haut)
- `remote 10.42.42.$2` : c'est le lien de connexion direct avec l'autre routeur qui se chargera de désencapsuler le paquet (et bien sûr encapsuler le paquet également)
- `local 10.42.42.$1` : c'est l'adresse ip attribuée à l'interface eth0 .
-  `dstport 4789` : le port de destination, c'est ce qui est recommandé par la RFC.

### Dynamique

4) On va créer l'interface vxlan. Voyons la commande en entier, avant de la segmenter afin de mieux la comprendre :


### Commun

5) On attribue une adresse IP à l'interface VXLAN `vxlan10`.

```bash
/sbin/ip a add 20.42.42.$1/8 dev vxlan10
```

6) On regarde si l'interface est bien configurée :

```bash
/sbin/ip -d link show vxlan10
```

7) Ensuite on va ajouter l'interface eth1 et vxlan10  au bridge, afin de pouvoir faire communiquer notre hôte alpine avec le routeur chrgé de l'encapsulation :

```bash
brctl addif br0 eth1 #addif veut dire : add interface
brctl addif br0 vxlan10
```

8) Pour terminer, nous démarrons l'interface vxlan !

```bash
/sbin/ip link set dev vxlan10 up
```

## En résumé

Nous avons vu ici pratiquement comment sont encapsulées les données. On part d'un hôte qui envoit des données, ces données sont encapsulées dans un paquet vxlan, lui-même encapsulé dans un paquet UDP, lui-même encapsulé dans une couche IP. L'inverse est opéré afin que l'hôte 2 puisse recevoir les données de l'hôte 1.

Les interfaces vxlan peuvent être configuré soit de façon statique, en lien direct, soit via multicast, via une souscription à un groupe.

