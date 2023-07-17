# BADASS
Ce projet vise à simuler un réseau de type FAI via GNS3 et Docker.

## Gloassaire

### Structures Réseau

#### AS (Autonomous System)

Un AS, un système autonome, est une entité essentielle dans la construction du réseau internet. Il s'agit d'une collection de machines qui opère sous une même autorité. Cette autorité administrative peut être une université, une FAI, une entreprise etc. Internet est constitué de ces multiples réseaux indépendants, auxquels le IANA (Internet Assigned Numbers Authority) attribue une identification unique.

### Protocoles utilisés aux seins des différentes structures

- OSPF (Open Short Fatest Path)
> OSPF est un protocole interne à un AS. Plus spécifiquement, c'est un Internet Gateway Protocol. C'est un protocole qui sert de communication entre différents routeurs afin de déterminer le chemin le plus court (routage) à la transmission d'une information au sein d'un AS. C'est un IGP qui est similaire au protocole IS-IS (Intermediate-System to Intermediate-System), car basé sur lui. Cependant, ce dernier est dans les faits plus utilisé par les FAI tandis que l'OSPF l'est dans les AS des entreprises.
