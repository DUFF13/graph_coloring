open Graph
open Dsatur
open FileMenu
open TestGraph

(** [afficher_menu_principal ()] affiche le menu principal. *)
let afficher_menu_principal () =
  Printf.printf "Menu principal :\n";
  Printf.printf "1. Tester des graphes prédéfinis\n";
  Printf.printf "2. Tester des graphes depuis des fichiers\n";
  Printf.printf "0. Quitter\n";
  Printf.printf "Votre choix : "

(** [test_graphes ()] permet de tester les graphes prédéfinis. *)
let test_graphes () =
  let graphes = [|
    ("Graphe complet K5", graphe_complet_k5);
    ("Graphe biparti K3,3", graphe_biparti_k33);
    ("Cycle impair C5", graphe_cycle_c5);
    ("Graphe en étoile", graphe_etoile);
    ("Graphe arbre binaire", graphe_arbre_binaire)
  |] in

  let rec boucle () =
    Printf.printf "Sélectionnez un graphe à tester :\n";
    Array.iteri (fun i (nom, _) ->
      Printf.printf "%d. %s\n" (i + 1) nom
    ) graphes;
    Printf.printf "0. Quitter\n";
    Printf.printf "Votre choix : ";
    match read_int_opt () with
    | Some 0 -> Printf.printf "Retour au menu principal.\n"
    | Some n when n > 0 && n <= Array.length graphes ->
      let (nom, graphe) = graphes.(n - 1) in
      Printf.printf "Test du graphe : %s\n" nom;
      let start_time = Sys.time () in
      let nb_couleurs = dsatur_with_tas graphe in
      let end_time = Sys.time () in
      Printf.printf "Nombre de couleurs utilisées : %d\n" nb_couleurs;
      Printf.printf "Temps d'exécution : %.6f secondes\n" (end_time -. start_time);
      Printf.printf "-------------------------------------\n";
      boucle ()
    | _ ->
      Printf.printf "Choix invalide. Veuillez réessayer.\n";
      boucle ()
  in
  boucle ()

(** [tester_fichiers_repertoire dir] teste les graphes d'un répertoire. *)
let tester_fichiers_repertoire dir =
  let fichiers = Sys.readdir dir in
  Array.sort String.compare fichiers;
  let rec boucle () =
    Printf.printf "Sélectionnez un fichier à tester :\n";
    Array.iteri (fun i fichier ->
      if Filename.check_suffix fichier ".col" then
        Printf.printf "%d. %s\n" (i + 1) fichier
    ) fichiers;
    Printf.printf "0. Retour au menu principal\n";
    Printf.printf "Votre choix : ";
    match read_int_opt () with
    | Some 0 -> Printf.printf "Retour au menu principal.\n"
    | Some n when n > 0 && n <= Array.length fichiers ->
      let fichier = fichiers.(n - 1) in
      if Filename.check_suffix fichier ".col" then (
        let chemin = Filename.concat dir fichier in
        Printf.printf "Test du fichier : %s\n" chemin;
        let graphe = lire_graphe chemin in
        let start_time = Sys.time () in
        let nb_couleurs = dsatur_with_tas graphe in
        let end_time = Sys.time () in
        Printf.printf "Nombre de couleurs utilisées : %d\n" nb_couleurs;
        Printf.printf "Temps d'exécution : %.6f secondes\n" (end_time -. start_time);
        Printf.printf "-------------------------------------\n";
      ) else (
        Printf.printf "Fichier invalide. Veuillez choisir un fichier .col\n";
      );
      boucle ()
    | _ ->
      Printf.printf "Choix invalide. Veuillez réessayer.\n";
      boucle ()
  in
  boucle ()

(** [menu_principal ()] gère le menu principal. *)
let menu_principal () =
  let rec boucle () =
    afficher_menu_principal ();
    match read_int_opt () with
    | Some 0 -> Printf.printf "Au revoir !\n"
    | Some 1 ->
      test_graphes ();
      boucle ()
    | Some 2 ->
      tester_fichiers_repertoire "test"; (* Répertoire des fichiers de test *)
      boucle ()
    | _ ->
      Printf.printf "Choix invalide. Veuillez réessayer.\n";
      boucle ()
  in
  boucle ()

(** Point d'entrée principal du programme. *)
let () =
  Printf.printf "Début du programme\n";
  menu_principal ();
  Printf.printf "Fin du programme\n"
