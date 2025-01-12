# Projet de Coloration de Graphes

Ce projet est une implémentation de l'algorithme DSATUR pour la coloration de graphes. Il inclut divers modules pour manipuler les graphes, gérer les fichiers, et effectuer des tests. L'objectif est de fournir un moyen modulaire et efficace de colorer des graphes et de les tester avec différents scénarios d'entrée.

## Fonctionnalités

- **Représentation des Graphes** : Utilisation de listes d'adjacence pour représenter les graphes.
- **Algorithme DSATUR** : Implémentation efficace pour la coloration de graphes.
- **Gestion de Fichiers** : Capacité à lire des données de graphes depuis des fichiers `.col`.

## Structure du projet

```
.
├── src
│   ├── dsatur.ml
│   ├── dsatur.mli
│   ├── fileMenu.ml
│   ├── fileMenu.mli
│   ├── graph.ml
│   ├── graph.mli
│   ├── tas.ml
│   ├── tas.mli
│   ├── testGraph.ml
│   ├── testGraph.mli
├── test
│   ├── XXX.col
├── version_intermediaire
│   ├── dsatur_glouton.ml
├── .gitignore
├── Makefile
├── README.md
└── graphes_utilises.txt


```

 
## Installation

1. Clonez le dépôt :
   ```bash
   git clone git@github.com:DUFF13/graph_coloring.git
   ```

2. Compilez le projet avec `make` :
   ```bash
   make
   ```

## Utilisation

1. Exécutez l'exécutable compilé :
   ```bash
   ./graph_coloring
   ```

2. Suivez les options du menu pour :
   - Tester des graphes prédéfinis.
   - Tester des graphes à partir des fichiers `.col` situés dans le répertoire `test`.

## Ajouter de Nouveaux Graphes

- Pour tester de nouveaux graphes, placez les fichiers `.col` dans le répertoire `test`.
- Assurez-vous que le format des fichiers respecte la norme DIMACS `.col`.

## Détails sur le Makefile

Le fichier `Makefile` est conçu pour simplifier la compilation et l'exécution du projet. Voici un résumé des règles incluses :

- **all** : Compile tous les fichiers sources et génère l'exécutable principal `graph_coloring`.
- **clean** : Supprime les fichiers objets intermédiaires (`.cmo` et `.cmi`) générés lors de la compilation.
- **mrproper** : Effectue un nettoyage complet en supprimant également l'exécutable final.

### Exemple d'utilisation :

- Pour compiler le projet :
  ```bash
  make
  ```

- Pour nettoyer les fichiers intermédiaires :
  ```bash
  make clean
  ```

- Pour supprimer tous les fichiers générés (y compris l'exécutable) :
  ```bash
  make mrproper
  ```

Les dépendances dans le `Makefile` garantissent que les fichiers sont compilés dans le bon ordre, en fonction des relations entre modules (par exemple, `graph.ml` avant `dsatur.ml`).

## Fichier `graphes_utilises.txt`

Les graphes utilisés pour ce projet ont été récupérés à partir du site suivant : [Graph Coloring Instances](https://mat.tepper.cmu.edu/COLOR/instances.html#XXLAT%3ELAT%3C/A%3E%20(Caution:%203%20MB!)%3Cli%3E%3CA%20HREF=).

Un fichier intitulé `graphes_utilises.txt` a été ajouté pour répertorier les graphes utilisés dans ce projet. Voici un exemple des informations qu'il contient :

```
fpsol2.i.1.col (496,11654), 65, REG
fpsol2.i.2.col (451,8691), 30, REG
fpsol2.i.3.col (425,8688), 30, REG
inithx.i.1.col (864,18707), 54, REG
...
```

Ce fichier liste le nom des graphes, leurs dimensions (nœuds, arêtes), leurs caractéristiques (comme le nombre de couleurs minimal), et leur origine. Vous pouvez le consulter pour plus de détails sur les données de test.

