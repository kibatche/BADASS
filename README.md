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

