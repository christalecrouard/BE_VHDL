# BE VHDL | Controleur Ethernet

Reception, transmission et gestion de collisions par un contrôleur Ethernet programmé en VHDL.


## Installation

Lancer le fichier Ethernet.xpr sous [vivado](https://www.xilinx.com/products/design-tools/vivado.html) pour démarrer.

## Usage

### Réception
La réception commence bien lorsque RESETN et RENABP sont à 1.

Le passage de RESETN à zéro arrête bien la réception et passe RDATA0 à 0.

Si l'adresse du destinataire ne correspond pas à l'adresse MAC, la réception est annulée.

Si toutes les conditions sont respectées, la réception abouti.

### Transmission
La transmission démarre bien si TAVAILP est à 1.

La passage de TABORTP interrompt la transmission.

### Collision
Lorsque qu'une réception est détectée, si une transmission est en cours, le bit de collision (TSOCOLP) passe à 1 et la transmission est interrompue.


## Problèmes rencontrés

Synthèse problématique avec Adresse MAC NOADDRI(47 downto 0), fonctionne en simulation mais pas en synthèse. On a dû séparé l'adresse MAC en 6 constantes pour passer à la synthèse.

## License
[MIT](https://choosealicense.com/licenses/mit/)
