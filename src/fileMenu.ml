open Graph
open Dsatur
open Unix

(** [lister_fichiers repertoire] renvoie la liste des fichiers .col dans un répertoire donné. *)
let lister_fichiers repertoire =
  try
    Array.to_list (Sys.readdir repertoire)
    |> List.filter (fun fichier -> Filename.check_suffix fichier ".col")
    |> List.sort String.compare
  with
  | Sys_error err ->
    Printf.printf "Erreur : %s\n" err;
    []

(** [afficher_menu_fichiers fichiers] affiche un menu pour sélectionner un fichier. *)
let afficher_menu_fichiers fichiers =
  Printf.printf "Fichiers disponibles dans le répertoire :\n";
  List.iteri (fun i fichier ->
    Printf.printf "%d. %s\n" (i + 1) fichier
  ) fichiers;
  Printf.printf "0. Retourner au menu principal\n";
  Printf.printf "Votre choix : "

(** [tester_fichier fichier] lit et colore le graphe contenu dans un fichier. *)
let tester_fichier fichier =
  let graphe = lire_graphe fichier in
  Printf.printf "Test du fichier : %s\n" fichier;
  let nb_couleurs = dsatur_with_tas graphe in
  Printf.printf "Nombre de couleurs utilisées : %d\n" nb_couleurs;
  Printf.printf "-------------------------------------\n"

(** [tester_fichiers repertoire] permet à l'utilisateur de tester des graphes depuis des fichiers. *)
let tester_fichiers repertoire =
  let rec boucle () =
    let fichiers = lister_fichiers repertoire in
    if fichiers = [] then
      Printf.printf "Aucun fichier .col trouvé dans le répertoire %s\n" repertoire
    else begin
      afficher_menu_fichiers fichiers;
      match read_int_opt () with
      | Some 0 -> Printf.printf "Retour au menu principal.\n"
      | Some n when n > 0 && n <= List.length fichiers ->
        let fichier = List.nth fichiers (n - 1) in
        tester_fichier (Filename.concat repertoire fichier);
        boucle ()
      | _ ->
        Printf.printf "Choix invalide. Veuillez réessayer.\n";
        boucle ()
    end
  in
  boucle ()
