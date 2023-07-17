# BADASS
Ce projet vise à simuler un réseau de type FAI via GNS3 et Docker.

## Gloassaire

### Structures Réseau

#### AS (Autonomous System)

Un AS, un système autonome, est une entité essentielle dans la construction du réseau internet. Il s'agit d'une collection de machines qui opère sous une même autorité. Cette autorité administrative peut être une université, une FAI, une entreprise etc. Internet est constitué de ces multiples réseaux indépendants, auxquels le IANA (Internet Assigned Numbers Authority) attribue une identification unique.

### Protocoles utilisés aux seins des différentes structures

- OSPF (Open Short Fatest Path)
> OSPF est un protocole interne à un AS. Plus spécifiquement, c'est un Internet Gateway Protocol. C'est un protocole qui sert de communication entre différents routeurs afin de déterminer le chemin le plus court (routage) à la transmission d'une information au sein d'un AS. C'est un IGP qui est similaire au protocole IS-IS (Intermediate-System to Intermediate-System), car basé sur lui. Cependant, ce dernier est dans les faits plus utilisé par les FAI tandis que l'OSPF l'est dans les AS des entreprises.

- IS-IS (Intermediate-System to Intermediate-System)
> IS-IS est un protocole interne à un AS. C'est également un IGP. Il sert donc au routage d'une information. Similaire à l'OSPF dont il est l'inspiration, il est cependant plus utilisé au sein d'AS de type FAI.

- BGP (Border Gateway Protocol)
> BGP est un protocole inter-domaine. C'est donc un EGP, Exterior Gateway Protocol. Il sert à la communication entre les AS, et non pas en leur sein. C'est le protocol standard pour internet. La nécessité d'un protocole différent pour la communication entre les AS tient du fait que des stratégies (des politiques) de communication peuvent intervenir. Au sein d'une même unité administrative, l'idée est de "simplement" transmettre l'information le plus rapidement possible (via OSPF, IS-IS...). Par contre, un AS peut vouloir que certaines informations soient contraintes.
> Exemples :
- Pas de trafic commercial dans un réseau éducatif
- Pas de trafic militaire américain passant par la Russie
En somme, BGP permet l'utilisation de règles que les AS peuvent mettre en place afin de convenir à leur politique interne, et notamment des politiques commerciales pour le routage d'un trafic donné entre différents AS.
