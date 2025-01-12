open Sat_solver
open Dimacs_to_cnf
open Quine_dpll

(* Fonction pour trouver le plus petit k pour lequel une solution existe *)
let find_smallest_k n m edges =
  let rec aux k =
    Printf.printf "Test avec k = %d\n" k;
    (* Générer la formule CNF pour le k courant *)
    let sat_n, sat_m, sat_clauses = generate_kcoloring_sat_formula n m edges k in
    Printf.printf "Formule CNF générée : %d variables, %d clauses.\n" sat_n sat_m;

    (* Résoudre avec DPLL *)
    let result = dpll sat_clauses in
    match result with
    | (true, solution) ->
        (* Si une solution est trouvée, retourner k et la solution *)
        (k, solution)
    | (false, _) ->
        (* Sinon, continuer avec k + 1 *)
        aux (k + 1)
  in
  aux 1

let main () =
  (* Nom du fichier DIMACS contenant le graphe *)
  let filename = "test/myciel4" in

  (* Parse le graphe à partir du fichier *)
  let n, m, edges = parse_graph filename in
  Printf.printf "Graphe lu : %d sommets, %d arêtes.\n" n m;

  (* Trouver le plus petit k et afficher le résultat *)
  let k, solution = find_smallest_k n m edges in
  Printf.printf "Solution trouvée avec k = %d couleurs :\n" k;
  List.iter (fun lit ->
    match lit with
    | Var x ->
        let vertex = (x - 1) / k in
        let color = (x - 1) mod k + 1 in
        Printf.printf "  Sommet %d -> Couleur %d\n" vertex color
    | NVar _ -> ()
  ) solution

(* Lancer le programme principal *)
let () = main ()

