type sommet = {
  mutable dsat : int;
  degre : int;
  numero : int;
}

type tas = {
  mutable data : sommet array;
  mutable size : int;
}

let creer_tas (capacite : int) : tas = {
  data = Array.make capacite { dsat = 0; degre = 0; numero = -1 };
  size = 0;
}

let parent i = (i - 1) / 2
let gauche i = 2 * i + 1
let droite i = 2 * i + 2

let echanger tas i j =
  let temp = tas.data.(i) in
  tas.data.(i) <- tas.data.(j);
  tas.data.(j) <- temp

let comparer s1 s2 =
  if s1.dsat <> s2.dsat then s1.dsat - s2.dsat
  else s1.degre - s2.degre

let remonter tas i =
  let rec aux i =
    if i > 0 then
      let p = parent i in
      if comparer tas.data.(i) tas.data.(p) > 0 then begin
        echanger tas i p;
        aux p
      end
  in
  aux i

let descendre tas i =
  let rec aux i =
    let g = gauche i in
    let d = droite i in
    let max_i =
      if g < tas.size && comparer tas.data.(g) tas.data.(i) > 0 then g else i
    in
    let max_i =
      if d < tas.size && comparer tas.data.(d) tas.data.(max_i) > 0 then d else max_i
    in
    if max_i <> i then begin
      echanger tas i max_i;
      aux max_i
    end
  in
  aux i

let inserer tas sommet =
  if tas.size >= Array.length tas.data then failwith "Tas plein";
  tas.data.(tas.size) <- sommet;
  tas.size <- tas.size + 1;
  remonter tas (tas.size - 1)

let extraire_max tas =
  if tas.size <= 0 then failwith "Tas vide";
  let max_sommet = tas.data.(0) in
  tas.data.(0) <- tas.data.(tas.size - 1);
  tas.size <- tas.size - 1;
  descendre tas 0;
  max_sommet


let index_of predicate arr =
  let rec aux i =
    if i >= Array.length arr then raise Not_found
    else if predicate arr.(i) then i
    else aux (i + 1)
  in
  aux 0

let augmenter_cle tas sommet nouvelle_dsat =
  try
    let i = index_of (fun x -> x.numero = sommet) tas.data in
    tas.data.(i).dsat <- nouvelle_dsat;
    remonter tas i; (* Réorganise le tas après mise à jour *)
  with Not_found ->
    failwith ("Sommet non trouvé dans le tas : " ^ string_of_int sommet)


let taille tas = tas.size

let obtenir_donnees tas = tas.data
