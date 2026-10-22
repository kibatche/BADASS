# Les systèmes autonomes

## Qu’est-ce qu’un Système Autonome (AS) ?

Un AS est un groupe de réseaux IP géré par une ou plusieurs entités (comme un FAI ou une grande entreprise) avec une politique de routage commune, identifié de manière unique par un numéro appelé **ASN** (Autonomous System Number).

## Qui crée les systèmes autonomes ?

Les AS sont créés par les organisations qui souhaitent gérer leur propre routage inter-domaine, généralement parce qu'elles veulent avoir une présence sur Internet indépendante (par ex. multi-hébergement ou transit IP avec plusieurs FAI).

- Fournisseurs d'accès à Internet (FAI). *Exemples : Orange, Free, Deutsche Telekom (T-Systems).*
- Grandes entreprises avec des besoins réseaux complexes. *Exemples : Microsoft, Amazon, Google, OVHcloud.*
- Universités, organismes publics. *Exemples : RENATER (réseau académique français), MIT (Massachusetts Institute of Technology), Université de Cambridge.*
- Fournisseurs de contenu. *Exemples : Netflix, Cloudflare.*

En 2019, il y avait 91000 AS alloués (pas forcément utilisés donc) et sur ces 91000 AS, 64000 étaient utilisés.

## Comment obtenir un ASN ?

Les ASN sont attribués par les **RIRs** (Regional Internet Registries). Il en existe cinq dans le monde :

| Région                              | RIR                                 |
| :---------------------------------- | :---------------------------------- |
| Europe, Moyen-Orient, Asie centrale | [RIPE NCC](https://www.ripe.net/)   |
| Amérique du Nord                    | [ARIN](https://www.arin.net/)       |
| Amérique latine et Caraïbes         | [LACNIC](https://www.lacnic.net/)   |
| Afrique                             | [AFRINIC](https://www.afrinic.net/) |
| Asie-Pacifique                      | [APNIC](https://www.apnic.net/)     |

Pour obtenir un ASN, il faut :
- Être souvent membre d’un RIR (ou passer par un Local Internet Registry comme un FAI).
- Justifier d’un besoin légitime (par exemple : avoir au moins deux fournisseurs de transit IP).
- Faire une demande officielle auprès du RIR compétent.
- Payer des frais d’allocation et d’adhésion.

## Qui les réglemente ?

- Les ASN et les plages IP sont gérés globalement par l’**IANA** (Internet Assigned Numbers Authority), qui délègue ensuite aux RIRs.
- Chaque RIR a ses propres politiques, décidées de manière communautaire (bottom-up), souvent transparentes et consultables publiquement.

## Qui peut postuler ?

Toute organisation légitime avec un besoin technique clair peut faire une demande, sous certaines conditions :
- Disposer de blocs IP (souvent aussi alloués par le RIR)
- Justifier du besoin (multi-homing, routage interconnecté, etc.)
- Avoir les ressources techniques et humaines pour maintenir l’AS (ingénieurs réseau, infrastructure BGP, etc.)

## Explorer les connexions BGP

Pour examiner les connexions BGP d'un AS spécifique, on peut utiliser des outils tels que :
- [RIPEstat ASN Neighbours](https://stat.ripe.net/widget/asn-neighbours) : Fournit des informations sur les voisins BGP d'un ASN, y compris les connexions directes et les chemins de routage.​
- [PeeringDB](https://www.peeringdb.com/) : Base de données collaborative offrant des détails sur les points de peering, les politiques de peering et les informations de contact des réseaux.​
- [IPinfo.io](https://ipinfo.io/) : Fournit des informations sur les ASN, y compris les pairs, les préfixes annoncés et les connexions réseau.
