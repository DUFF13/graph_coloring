
type litteral =
  |Var of int
  |NVar of int
;;

type graph = int list array;;

type clause = litteral list;;
type cnf = clause list;;


(* Basic function *)

let int_of_litteral (l : litteral) : int = 
  match l with
  | Var n -> n
  | NVar n -> -n;;

let litteral_of_int (n : int): litteral = 
  if n < 0 then NVar(-n) else Var(n);;

let neg_of_litteral (l : litteral) : litteral = 
  match l with
  | Var x -> NVar x
  | NVar x -> Var x;;


let rec empty_clause_in (f : cnf) : bool = List.mem [] f

let int_list_to_litteral_list (l : int list) = List.map litteral_of_int l;;


let rec cnf_without_clause_x (f : cnf)(x : litteral) : cnf =
  match f with
  | [] -> []
  | t :: q when not(List.mem x t) -> t ::  cnf_without_clause_x q x
  | _ :: q -> cnf_without_clause_x q x;;

let rec clause_without_negx (c : clause)(x : litteral) : clause =
  match c with
  | [] -> []
  | t :: q when t <> neg_of_litteral x -> t :: clause_without_negx q x
  | _ :: q -> clause_without_negx q x;;

let rec cnf_without_negx (f : cnf)(x : litteral) : cnf =
  match f with
  | [] -> []
  | t :: q -> clause_without_negx t x :: cnf_without_negx q x;;

let rec one_var_clause (f : cnf) : bool * litteral =
  match f with
  | [] -> false, Var 0
  | t :: q -> match t with  
              | [] -> false, Var 0  (* with dpll or quine t cannot be empty but compiler not happy non-exhaustiv pattern-matching *)
              | a :: [] -> (true, a)
              | _ :: b -> one_var_clause q;;

let rec clause_without_x (f : clause)(x : litteral) : clause =
  match f with
  | [] -> []
  | t :: q -> if (t = x || t = neg_of_litteral x) then clause_without_x q x
              else t :: clause_without_x q x;;


let pur_var_cnf (f : cnf): bool * litteral =
  let rec aux (g : clause) : bool * litteral =
    match g with
    | [] -> false, Var 0 (* with dpll or quine t cannot be empty*)
    | t :: q when not (List.mem (neg_of_litteral t) q) -> (true, t)
    | t :: q -> aux (clause_without_x q t)
  in aux (List.flatten f);;
