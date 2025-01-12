
type voisin = int list

type graphe = voisin array


let lire_graphe (filename : string) : graphe =
  let x = open_in filename in
  let n = ref 0 in
  let edges = ref [] in
  try
    while true do
      let line = input_line x in
      match line.[0] with
      | 'c' -> () (* Ligne de commentaire, ignorée *)
      | 'p' -> 
        let line_list = List.filter (fun s -> s <> "") (String.split_on_char ' ' line) in
        n := int_of_string (List.nth line_list 2) (* Nombre de sommets *)
      | 'e' -> 
        let line_list = List.filter (fun s -> s <> "") (String.split_on_char ' ' line) in
        let u = int_of_string (List.nth line_list 1) - 1 in (* Convertir en base 0 *)
        let v = int_of_string (List.nth line_list 2) - 1 in
        edges := (u, v) :: !edges
      | _ -> ()
    done;
    [||] (* Jamais atteint, sauf si la boucle est interrompue *)
  with
  | End_of_file -> 
    close_in x;
    (* Construire le graphe *)
    let g = Array.make !n [] in
    List.iter (fun (u, v) ->
        g.(u) <- v :: g.(u); (* Ajouter l’arête u -> v *)
      (* g.(v) <- u :: g.(v); (* Ajouter l’arête v -> u, car non orienté *)*)
    ) !edges;
    g 
   

let desorienter_graphe (g : graphe) : graphe =
  let n = Array.length g in
  let g_non_oriente = Array.make n [] in
  for i = 0 to n - 1 do
    List.iter (fun voisin -> (* jouter l'arrete i -> voisin *)
      if not (List.exists (fun x -> x = voisin) g_non_oriente.(i)) then
        g_non_oriente.(i) <- voisin :: g_non_oriente.(i); (* Ajouter l'arrete voisin -> i *)
      if not (List.exists (fun x -> x = i) g_non_oriente.(voisin)) then
        g_non_oriente.(voisin) <- i :: g_non_oriente.(voisin)
    ) g.(i)
  done;
  g_non_oriente;;
