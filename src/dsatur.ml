open Graph
open Tas

module IntSet = Set.Make(struct
  type t = int
  let compare = compare
end)

let array_find f arr =
  let rec aux i =
    if i >= Array.length arr then raise Not_found
    else if f arr.(i) then arr.(i)
    else aux (i + 1)
  in
  aux 0

let dsatur_with_tas (g1 : graphe) : int =
  let g = desorienter_graphe g1 in
  let n = Array.length g in
  let c = Array.make n (-1) in (* Tableau pour stocker les couleurs *)
  let tas = Tas.creer_tas n in

  (* Initialisation du tas avec DSAT = 0 et degré calculé *)
  Array.iteri (fun i voisins ->
    let sommet = { Tas.dsat = 0; degre = List.length voisins; numero = i } in
    Tas.inserer tas sommet
  ) g;

  let max_color = ref 0 in
  let dsat_actuel = Array.make n 0 in (* Suivi local des DSAT *)

  while Tas.taille tas > 0 do
    (* Extraire le sommet avec DSAT maximal *)
    let s = Tas.extraire_max tas in

    (* Calculer les couleurs interdites pour ce sommet *)
    let couleurs_interdites = List.fold_left (fun acc voisin ->
      if c.(voisin) <> -1 then IntSet.add c.(voisin) acc else acc
    ) IntSet.empty g.(s.numero) in

    (* Trouver une couleur disponible *)
    let rec trouver_couleur i =
      if IntSet.mem i couleurs_interdites then trouver_couleur (i + 1) else i
    in
    let couleur = trouver_couleur 0 in

    (* Assigner la couleur et mettre à jour la DSAT *)
    c.(s.numero) <- couleur;
    max_color := max !max_color (couleur + 1);

    (* Mise à jour des voisins *)
    List.iter (fun voisin ->
      if c.(voisin) = -1 then
        let voisin_dans_tas =
          Array.exists (fun (x : Tas.sommet) -> x.numero = voisin) (Tas.obtenir_donnees tas) 
        in
        if voisin_dans_tas then
          let sommet_voisin = array_find (fun (x : Tas.sommet) -> x.numero = voisin) (Tas.obtenir_donnees tas) in

          (* Calcul dynamique des nouvelles couleurs voisines *)
          let nouvelles_couleurs_voisines = 
            List.fold_left (fun acc v ->
              if c.(v) <> -1 then IntSet.add c.(v) acc else acc
            ) IntSet.empty g.(voisin) in
          let nouvelle_dsat = IntSet.cardinal nouvelles_couleurs_voisines in

          (* Mise à jour DSAT si nécessaire *)
          if nouvelle_dsat > sommet_voisin.dsat then
            Tas.augmenter_cle tas sommet_voisin.numero nouvelle_dsat;
          dsat_actuel.(voisin) <- nouvelle_dsat
      ) g.(s.numero)
  done;

  !max_color 
