(** Module contenant des graphes prédéfinis pour les tests. *)

open Graph


(** [graphe_complet_k5] est un graphe complet à 5 sommets (K5).
    Chaque sommet est connecté à tous les autres. *)
val graphe_complet_k5 : graphe


(** [graphe_biparti_k33] est un graphe biparti complet K3,3.
    Il est composé de deux ensembles de sommets {A, B, C} et {X, Y, Z}, 
    où chaque sommet d'un ensemble est connecté à tous les sommets de l'autre ensemble. *)
val graphe_biparti_k33 : graphe


(** [graphe_cycle_c5] est un graphe formant un cycle impair de 5 sommets (C5).
    Les sommets sont arrangés en une chaîne fermée : 1 → 2 → 3 → 4 → 5 → 1. *)
val graphe_cycle_c5 : graphe


(** [graphe_etoile] est un graphe en étoile.
    Un sommet central est connecté à tous les autres, qui ne sont connectés qu'au sommet central. *)
val graphe_etoile : graphe


(** [graphe_arbre_binaire] est un graphe représentant un arbre binaire parfait.
    Chaque nœud interne a exactement deux enfants, et tous les niveaux sont complets. (de hauteur 2) *)
val graphe_arbre_binaire : graphe
