(** 
  Module Graph : Représentation et manipulation des graphes.
  
  Ce module fournit des types et des fonctions pour gérer les graphes sous forme de listes d'adjacence.
*)

(** 
  Type [voisin] : représente les voisins d'un sommet sous forme de liste d'entiers. 
  Chaque entier correspond à un sommet.
*)
type voisin = int list

(** 
  Type [graphe] : représente un graphe sous forme d'un tableau de listes d'adjacence.
  L'indice du tableau représente un sommet, et l'élément à cet indice est la liste de ses voisins.
*)
type graphe = voisin array

(** 
  [lire_graphe fichier] lit un graphe depuis un fichier au format DIMACS ou équivalent.
  
  @param fichier Le chemin du fichier contenant la description du graphe.
  @return Un graphe représenté sous forme d'un tableau de listes d'adjacence.
  
  @raise Failure Si le fichier ne peut pas être lu ou si son format est incorrect.
*)
val lire_graphe : string -> graphe

(** 
  [desorienter_graphe g] transforme un graphe orienté en un graphe non orienté. Nécessaire pour le bon fonctionnement de DSATUR
  Nous avons un problème lorsque le fichier dimacs contient les arrêtes (u -> v) et (v -> u) mais n'avons pas réussi à le résoudre.
  @param g Un graphe représenté sous forme de listes d'adjacence.
  @return Un graphe non orienté, où chaque arête est bidirectionnelle (si [u -> v] existe, [v -> u] sera ajouté).
  
*)
val desorienter_graphe : graphe -> graphe
