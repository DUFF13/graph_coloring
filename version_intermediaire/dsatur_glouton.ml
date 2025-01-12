

type voisin = int list;;

type graphe = voisin array;;

type coloration = int array;;




(* Fonction récursive principale pour le Branch-and-Bound *)

let rec taille_liste (l : 'a list) : int = (* O(n) *)
  match l with
  | [] -> 0
  | t :: q -> 1 + taille_liste q;;

let rec pour_tous (f : 'a -> bool)(l : 'a list) : bool =
  match l with
  | [] -> true
  | t :: q -> if f t then pour_tous f q else false;;


let max_array arr =
  let max = ref arr.(0) in
  for i = 1 to Array.length arr - 1 do
    if arr.(i) > !max then
      max := arr.(i)
  done;
  !max;;


let coloration_correcte (g : graphe)(c : coloration) : bool = (* O(|A|
  + |S| *)
  let n = Array.length g in
  let rec aux (i : int) =
    match i with
    | i when i = n -> true
    | i -> if pour_tous (fun x -> c.(x) <> c.(i)) g.(i)
           then aux (i + 1)
           else false
  in aux 0;;



let degres_sommet (g : graphe) (noeud : int) : int =
  (degre_sortant g noeud) + (degre_entrant g noeud)

let noeud_degre_max (g : graphe) : int = 
  let n = Array.length g in
  let max_noeud = ref 0 in
  let max_degre = ref (List.length g.(0)) in
  for i = 1 to n - 1 do
    let degre_i = List.length g.(i) in
    if degre_i > !max_degre then begin
      max_degre := degre_i;
      max_noeud := i
    end
  done;
  !max_noeud;;


let rec exists (f : 'a -> bool)(l : 'a list) : bool =
  match l with
  | [] -> false
  | t :: q -> if f t then true else exists f q;;


let dsat (g : graphe)(c : coloration)(s : int) : int =
  let rec aux (l : int list) =
    match l with
    | [] -> 0
    | t :: q when c.(t) = -1 -> aux q
    | t :: q when exists (fun j -> c.(j) = c.(t)) q -> aux q
    | _ :: q -> 1 + aux q
  in aux g.(s);;


let sommet_saturation_max (g : graphe) (c : coloration) : int = (* considere le cas d'égalité *)
  let n = Array.length g in
  let max_sommet = ref (-1) in
  let max_dsat = ref (-1) in
  let max_degre = ref (-1) in

  for i = 0 to n - 1 do
    if c.(i) = -1 then 
      let dsat_i = dsat g c i in
      let degre_i = degres_sommet g i in
      if dsat_i > !max_dsat || (dsat_i = !max_dsat && degre_i > !max_degre) then begin
        max_sommet := i;
        max_dsat := dsat_i;
        max_degre := degre_i;
      end
  done;

  !max_sommet;;
   
let find_first_available_color (g : graphe) (c : coloration) (s : int) : int =
  let voisins = g.(s) in
  let n = Array.length c in
  let couleurs_voisines = Array.make n false in
  List.iter (fun voisin ->
      if c.(voisin) <> -1 then
        couleurs_voisines.(c.(voisin)) <- true
    ) voisins;
  let couleur = ref 0 in
  while !couleur < n && couleurs_voisines.(!couleur) do
    incr couleur
  done;
  !couleur
;;


let dsatur (g : graphe) : int * coloration =
  let start_time = Unix.gettimeofday () in

  let n = Array.length g in
  let c = Array.make n (-1) in (* Initialisation des couleurs à -1 *)

  for _step = 0 to n - 1 do
    let s = sommet_saturation_max g c in
    let couleur = find_first_available_color g c s in
    c.(s) <- couleur
  done;


  let end_time = Unix.gettimeofday () in
  let execution_time = end_time -. start_time in
  Printf.printf "Temps d'exécution : %.6f secondes\n" execution_time;
  
  max_array c + 1, c;;

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


(* Utilisation du tableau pour mettre à jour les sommets *)

let update_dsat (g : graphe) (c : coloration) (dsat : int array) (voisins_colores : bool array array) (sommet : int) (couleur : int) =
  List.iter (fun voisin ->
    if c.(voisin) = -1 then (* Si le voisin n'est pas encore coloré *)
      if not voisins_colores.(voisin).(couleur) then begin
        voisins_colores.(voisin).(couleur) <- true;
        dsat.(voisin) <- dsat.(voisin) + 1
      end
    ) g.(sommet);;


let sommet_saturation_max_mem (g : graphe) (c : coloration) (dsat : int array) : int =
  let n = Array.length g in
  let max_sommet = ref (-1) in
  let max_dsat = ref (-1) in
  let max_degre = ref (-1) in
  for i = 0 to n - 1 do
    if c.(i) = -1 then (* Considérer uniquement les sommets non colorés *)
      let dsat_i = dsat.(i) in
      let degre_i = List.length g.(i) in
      if dsat_i > !max_dsat || (dsat_i = !max_dsat && degre_i > !max_degre) then begin
        max_sommet := i;
        max_dsat := dsat_i;
        max_degre := degre_i;
      end
  done;
  !max_sommet;;



let dsatur_mem (g : graphe) : int * coloration =
  let start_time = Unix.gettimeofday () in

  let n = Array.length g in
  let c = Array.make n (-1) in (* Initialisation des couleurs à -1 *)
  let dsat = Array.make n 0 in (* Initialisation des saturations à 0 *)
  let voisins_colores = Array.init n (fun _ -> Array.make n false) in (* Tableau des couleurs voisines *)

  for _step = 0 to n - 1 do
    let s = sommet_saturation_max_mem g c dsat in
    let couleur = find_first_available_color g c s in
    c.(s) <- couleur;
    update_dsat g c dsat voisins_colores s couleur
  done;

  let end_time = Unix.gettimeofday () in
  let execution_time = end_time -. start_time in
  Printf.printf "Temps d'exécution : %.6f secondes\n" execution_time;

  max_array c + 1, c;;


