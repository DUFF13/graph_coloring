open Sat_solver

let parse_graph filename =
  let in_channel = open_in filename in
  let n = ref 0 in
  let m = ref 0 in
  let edges = ref [] in
  try
    while true do
      let line = input_line in_channel in
      match String.trim line with
      | "" -> ()
      | l when String.get l 0 = 'c' -> ()  (* Commentaire *)
      | l when String.get l 0 = 'p' ->  (* Nombre de sommets et arêtes *)
          let parts = String.split_on_char ' ' l in
          begin match parts with
          | [_; _; num_vertices; num_edges] ->
              n := int_of_string num_vertices;
              m := int_of_string num_edges
          | _ -> ()
          end
      | l when String.get l 0 = 'e' ->  (* Arêtes *)
          let parts = String.split_on_char ' ' l in
          begin match parts with
          | [_; u; v] ->
              edges := (int_of_string u - 1, int_of_string v - 1) :: !edges
          | _ -> ()
          end
      | _ -> ()
    done;
    close_in in_channel;
    (!n, !m, !edges)
  with End_of_file ->
    close_in in_channel;
    (!n, !m, !edges);;


let generate_kcoloring_sat_formula n m edges k =
  let clauses = ref [] in
  let sat_vars = Hashtbl.create (n * k) in
  let var_count = ref 1 in

  (* Assigner une variable pour chaque sommet/couleur *)
  for i = 0 to n - 1 do
    for c = 0 to k - 1 do
      Hashtbl.add sat_vars (i, c) !var_count;
      incr var_count;
    done
  done;

  (* Chaque sommet a au moins une couleur *)
  for i = 0 to n - 1 do
    let clause = List.init k (fun c -> Var (Hashtbl.find sat_vars (i, c))) in
    clauses := clause :: !clauses
  done;

  (* Chaque sommet a au plus une couleur *)
  for i = 0 to n - 1 do
    for r = 0 to k - 1 do
      for q = r + 1 to k - 1 do
        let clause = [
          NVar (Hashtbl.find sat_vars (i, r));
          NVar (Hashtbl.find sat_vars (i, q));
        ] in
        clauses := clause :: !clauses
      done
    done
  done;

  (* Pas de conflit entre voisins *)
  List.iter (fun (u, v) ->
    for c = 0 to k - 1 do
      let clause = [
        NVar (Hashtbl.find sat_vars (u, c));
        NVar (Hashtbl.find sat_vars (v, c));
      ] in
      clauses := clause :: !clauses
    done
  ) edges;

  (!var_count - 1, List.length !clauses, !clauses)

let export_dimacs n m clauses filename =
  let out_channel = open_out filename in
  Printf.fprintf out_channel "p cnf %d %d\n" n m;
  List.iter (fun clause ->
    List.iter (fun lit -> Printf.fprintf out_channel "%d " lit) clause;
    Printf.fprintf out_channel "0\n"
  ) clauses;
  close_out out_channel

