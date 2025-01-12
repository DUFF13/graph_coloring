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
      let nb_couleurs = dsatur_with_tas graphe in
      Printf.printf "Nombre de couleurs utilisées : %d\n" nb_couleurs;
      Printf.printf "-------------------------------------\n";
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
      FileMenu.tester_fichiers "test"; (* Répertoire des fichiers de test *)
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
