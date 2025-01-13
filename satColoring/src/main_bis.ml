open Sat_solver
open Dimacs_to_cnf
open Quine_dpll
open Unix (* Pour mesurer le temps d'exécution *)

(* Fonction pour trouver le plus petit k pour lequel une solution existe *)
let find_smallest_k n m edges =
  let rec aux k =
    Printf.printf "Test avec k = %d\n" k;
    (* Démarrage du chronomètre pour la génération de la formule *)
    let start_gen = Unix.gettimeofday () in
    let sat_n, sat_m, sat_clauses = generate_kcoloring_sat_formula n m edges k in
    let end_gen = Unix.gettimeofday () in
    Printf.printf "Formule CNF générée : %d variables, %d clauses. Temps de génération : %.6f s\n"
      sat_n sat_m (end_gen -. start_gen);

    (* Démarrage du chronomètre pour la résolution *)
    let start_dpll = Unix.gettimeofday () in
    let result = dpll sat_clauses in
    let end_dpll = Unix.gettimeofday () in
    Printf.printf "Résolution DPLL terminée. Temps de résolution : %.6f s\n" (end_dpll -. start_dpll);

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
  let filename = "test/queen6_6.col" in

  (* Mesurer le temps pour analyser le graphe *)
  let start_parse = Unix.gettimeofday () in
  let n, m, edges = parse_graph filename in
  let end_parse = Unix.gettimeofday () in
  Printf.printf "Graphe lu : %d sommets, %d arêtes. Temps d'analyse : %.6f s\n"
    n m (end_parse -. start_parse);

  (* Trouver le plus petit k et afficher le résultat *)
  let start_k = Unix.gettimeofday () in
  let k, solution = find_smallest_k n m edges in
  let end_k = Unix.gettimeofday () in
  Printf.printf "Solution trouvée avec k = %d couleurs. Temps total : %.6f s\n"
    k (end_k -. start_k);

  (* Afficher la solution *)
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

