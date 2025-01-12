(* Types exposés *)
type litteral =
  | Var of int
  | NVar of int

type graph = int list array

type clause = litteral list
type cnf = clause list

(* Fonctions utilitaires *)
val int_of_litteral : litteral -> int
(** Convertit un littéral en entier. *)

val litteral_of_int : int -> litteral
(** Convertit un entier en littéral. *)

val neg_of_litteral : litteral -> litteral
(** Retourne le littéral opposé. *)

val empty_clause_in : cnf -> bool
(** Vérifie si une clause vide est présente dans une formule CNF. *)

val int_list_to_litteral_list : int list -> litteral list
(** Convertit une liste d'entiers en une liste de littéraux. *)

val cnf_without_clause_x : cnf -> litteral -> cnf
(** Supprime les clauses contenant un littéral donné dans une formule CNF. *)

val clause_without_negx : clause -> litteral -> clause
(** Supprime les occurrences du littéral opposé dans une clause. *)

val cnf_without_negx : cnf -> litteral -> cnf
(** Supprime les occurrences du littéral opposé dans toutes les clauses d'une formule CNF. *)

val one_var_clause : cnf -> bool * litteral
(** Recherche une clause unitaire dans une formule CNF. *)

val clause_without_x : clause -> litteral -> clause
(** Supprime un littéral spécifique et son opposé dans une clause. *)

val pur_var_cnf : cnf -> bool * litteral
(** Recherche une variable pure dans une formule CNF. *)
