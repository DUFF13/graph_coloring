(** Module Dsatur : Implémentation de l'algorithme DSATUR pour la coloration de graphes *)

open Graph
open Tas

(** 
  [dsatur_with_tas g] applique l'algorithme DSATUR pour colorier un graphe [g].
  Il utilise un tas binaire pour gérer efficacement le calcul de DSAT (degree of saturation).
  
  @param g Le graphe à colorier, représenté par un type [graphe].
  @return Le nombre minimal de couleurs nécessaires pour colorier le graphe [g].
  
  @raise Failure Si une erreur se produit pendant la coloration, comme un problème avec le tas.
 *)

val dsatur_with_tas : graphe -> int
