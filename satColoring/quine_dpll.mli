open Sat_solver

(* Algorithmes pour résoudre les formules CNF *)

val quine : cnf -> bool * clause
(** [quine f] applique l'algorithme de Quine pour vérifier si la formule CNF [f] est satisfiable.
    Retourne un couple :
    - [true, solution] si [f] est satisfiable, où [solution] est une liste de littéraux assignés,
    - [false, []] si [f] est insatisfiable. *)

val dpll : cnf -> bool * clause
(** [dpll f] applique l'algorithme DPLL (optimisation de Quine) pour vérifier si la formule CNF [f] est satisfiable.
    Retourne un couple :
    - [true, solution] si [f] est satisfiable, où [solution] est une liste de littéraux assignés,
    - [false, []] si [f] est insatisfiable. *)
