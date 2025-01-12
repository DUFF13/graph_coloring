(* src/test_graphs.ml *)

open Graph

(* Graphes de test prédéfinis *)
let graphe_complet_k5 = [|
  [1; 2; 3; 4];
  [0; 2; 3; 4];
  [0; 1; 3; 4];
  [0; 1; 2; 4];
  [0; 1; 2; 3]
|]

let graphe_biparti_k33 = [|
  [3; 4; 5];
  [3; 4; 5];
  [3; 4; 5];
  [0; 1; 2];
  [0; 1; 2];
  [0; 1; 2]
|]

let graphe_cycle_c5 = [|
  [1; 4];
  [0; 2];
  [1; 3];
  [2; 4];
  [0; 3]
|]

let graphe_etoile = [|
  [1; 2; 3; 4; 5];
  [0];
  [0];
  [0];
  [0];
  [0]
|]

let graphe_arbre_binaire = [|
  [1; 2];
  [0; 3; 4];
  [0; 5; 6];
  [1];
  [1];
  [2];
  [2]
|]
