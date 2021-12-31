# BE VHDL | Controleur Ethernet

Reception, transmission et gestion de collisions par un contrôleur Ethernet programmé en VHDL.


## Installation

Lancer le fichier Ethernet.xpr sous [vivado](https://www.xilinx.com/products/design-tools/vivado.html) pour démarrer.

## Usage

### Réception
La réception commence bien lorsque RESETN et RENABP sont à 1.

![Début de la réception](https://github.com/christalecrouard/BE_VHDL/blob/main/images/renabp.png)

Le passage de RESETN à zéro arrête bien la réception et passe RDATA0 à 0.

![RESET passe à zéro et arrête la reception](https://github.com/christalecrouard/BE_VHDL/blob/main/images/resetn.png)

Si l'adresse du destinataire ne correspond pas à l'adresse MAC, la réception est annulée.

![Adresse incorrecte : pas de reception](https://github.com/christalecrouard/BE_VHDL/blob/main/images/addrincorrecte.png)

Si toutes les conditions sont respectées, la réception abouti.

![Reception complète si tout est respecté](https://github.com/christalecrouard/BE_VHDL/blob/main/images/receptionnormale.png)

### Transmission
La transmission démarre bien si TAVAILP est à 1 et abouti si rien ne l'empêche.

![Transmission complète](https://github.com/christalecrouard/BE_VHDL/blob/main/images/transmission%20ok.png)

La passage de TABORTP interrompt la transmission.

![TABORT interrompt le transmission](https://github.com/christalecrouard/BE_VHDL/blob/main/images/abort.png)

### Collision
Lorsque qu'une réception est détectée, si une transmission est en cours, le bit de collision (TSOCOLP) passe à 1 et la transmission est interrompue.

![Un collision interrompt la transmission](https://github.com/christalecrouard/BE_VHDL/blob/main/images/collision.png)


## Problèmes rencontrés

Synthèse non réalisée avec l'adresse MAC sur 48 bits ( NOADDRI(47 downto 0) ). La simulation fonctionne mais pas en synthèse. On a dû séparé l'adresse MAC en 6 constantes pour réaliser la synthèse.

## Analyse

### Synthèse
- Nombre de portes : 41600
- Nombre de bascules : 151

![Synthèse du circuit](https://github.com/christalecrouard/BE_VHDL/blob/main/images/synth%C3%A8se.png)

## Fréquence maximale
Chemin critique : 2.155 ns (Fréquence maximale : 464 MHz)

![Fréquence max du circuit](https://github.com/christalecrouard/BE_VHDL/blob/main/images/fr%C3%A9quence.png)

### Puissance consommée
Puissance consommée de la chip : 74 mW (95 % statique et 5% dynamique)

![Puissance consommée](https://github.com/christalecrouard/BE_VHDL/blob/main/images/consommation.png)


## License
[MIT](https://choosealicense.com/licenses/mit/)
