open Sat_solver

(* Analyse un fichier DIMACS pour extraire les sommets, arêtes, et leur nombre *)
val parse_graph : string -> int * int * (int * int) list
(** [parse_graph filename] lit un graphe au format DIMACS depuis [filename].
    Retourne un triplet contenant :
    - le nombre de sommets,
    - le nombre d'arêtes,
    - la liste des arêtes (paires de sommets).
*)

(* Génère une formule CNF pour le problème de k-coloration *)
val generate_kcoloring_sat_formula : int -> int -> (int * int) list -> int -> int * int * cnf
(** [generate_kcoloring_sat_formula n m edges k] génère une formule CNF pour résoudre
    le problème de k-coloration d'un graphe. Paramètres :
    - [n] : nombre de sommets,
    - [m] : nombre d'arêtes,
    - [edges] : liste des arêtes (paires de sommets),
    - [k] : nombre de couleurs.
    Retourne un triplet contenant :
    - le nombre de variables dans la formule,
    - le nombre de clauses dans la formule,
    - la formule CNF. *)

(* Exporte une formule CNF au format DIMACS *)
val export_dimacs : int -> int -> cnf -> string -> unit
(** [export_dimacs n m clauses filename] écrit la formule CNF [clauses]
    dans un fichier [filename] au format DIMACS. Paramètres :
    - [n] : nombre de variables dans la formule,
    - [m] : nombre de clauses dans la formule,
    - [clauses] : la formule CNF (liste de clauses),
    - [filename] : nom du fichier de sortie. *)
