# Code source des impôts sur les revenus

## Contenu des fichiers sources mis à disposition des usagers

Les fichiers contenus dans l'archive sont l'ensemble des fichiers de paramétrage utilisés par les services informatiques de la Direction Générale des Finances Publiques pour réaliser la taxation des foyers fiscaux (IR, ISF, CSG).

Ces fichiers sont développés sous licence CeCILL 2.1 soumise au droit français et respectant les principes de diffusion des logiciels libres.

La version retenue est la 2.5 qui a servi au cours de l'année 2015 pour produire les avis d'impôt sur les revenus 2014.

Les fichiers contenus dans cette archive sont :

- [`tgvH.m`](src/tgvH.m) : Tableau général des variables qui assure la correspondance entre les codes issus de la 2042 et les variables internes au calcul, les variables de calcul et les variables restituées par la calculette IR
- [`errH.m`](src/errH.m) : Fichier décrivant les différentes anomalies
- `coi[x].m`, `coc[x].m`, [`horizoc.m`](src/horizoc.m), [`horizoi.m`](src/horizoi.m) : Fichiers de gestion des anomalies de la calculette
- `chap-[xxx].m`, [`res-ser1.m`](src/res-ser1.m), [`res-ser2.m`](src/res-ser2.m) : Fichiers comportant les différentes règles de calcul pour un ensemble fonctionnel cohérent.

  Exemples :
  - [`chap-1.m`](src/chap-1.m) contient les règles de calcul du montant net
  - [`chap-isf.m`](src/chap-isf.m) contient les règles de calcul de l'ISF
  - [`chap-perp.m`](src/chap-perp.m) contient les règles de calcul des déductions pour verserment sur un Plan d'Epargne Retraite Populaire

## Variables remarquables

- IINET : montant net à payer
