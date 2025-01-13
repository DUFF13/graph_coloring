open Sat_solver

(* Algorithme Quine *)
let rec quine (f : cnf) : bool * clause =
  match f with
  | [] -> (true, [])  (* La formule est satisfaite si elle est vide *)
  | _ when empty_clause_in f -> (false, [])  (* La formule contient une clause vide, donc insatisfiable *)
  | (x :: _) :: q ->
      (* Suppression de x et de ¬x dans la formule *)
      let (sat, c) = quine (cnf_without_clause_x (cnf_without_negx f x) x) in
      if sat then (sat, x :: c)
      else
        (* Si x ne marche pas, essayer ¬x *)
        let (sat, c) = quine (cnf_without_clause_x (cnf_without_negx f (neg_of_litteral x)) (neg_of_litteral x)) in
        if not sat then (false, [])
        else (sat, neg_of_litteral x :: c)
  | [] :: _ -> (false, [])  (* Cas explicite pour une clause vide *)


(* Algorithme DPLL (optimisation de Quine) *)
let rec dpll (f : cnf) : bool * clause =
  match f with
  | [] -> (true, [])  (* La formule est satisfaite si elle est vide *)
  | _ when empty_clause_in f -> (false, [])  (* La formule contient une clause vide, donc insatisfiable *)
  | _ ->
      (* Étape 1 : Chercher une clause unitaire *)
      let (one, lit) = one_var_clause f in
      if one then
        (* Appliquer la propagation unitaire *)
        let (sat, c) = dpll (cnf_without_clause_x (cnf_without_negx f lit) lit) in
        if sat then (sat, lit :: c)
        else
          (* Sinon essayer le littéral opposé *)
          let (sat, c) = dpll (cnf_without_clause_x (cnf_without_negx f (neg_of_litteral lit)) (neg_of_litteral lit)) in
          if not sat then (false, []) else (sat, neg_of_litteral lit :: c)
      else
        (* Étape 2 : Chercher une variable pure *)
        let (pure, lit) = pur_var_cnf f in
        if pure then
          (* Appliquer la propagation de la variable pure *)
          let (sat, c) = dpll (cnf_without_clause_x (cnf_without_negx f lit) lit) in
          if sat then (sat, lit :: c)
          else
            (* Sinon essayer le littéral opposé *)
            let (sat, c) = dpll (cnf_without_clause_x (cnf_without_negx f (neg_of_litteral lit)) (neg_of_litteral lit)) in
            if not sat then (false, []) else (sat, neg_of_litteral lit :: c)
        else
          (* Étape 3 : Choisir un littéral arbitrairement *)
          match f with
          | (x :: _) :: _ ->
              let (sat, c) = dpll (cnf_without_clause_x (cnf_without_negx f x) x) in
              if sat then (sat, x :: c)
              else
                (* Sinon essayer le littéral opposé *)
                let (sat, c) = dpll (cnf_without_clause_x (cnf_without_negx f (neg_of_litteral x)) (neg_of_litteral x)) in
                if not sat then (false, []) else (sat, neg_of_litteral x :: c)
          | _ -> failwith "Unexpected case in DPLL"
