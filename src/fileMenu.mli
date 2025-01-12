(** 
  Module FileMenu : Gestion des graphes à partir de fichiers 
  Ce module permet de lister, sélectionner et colorier des graphes stockés dans des fichiers au format `.col`.
*)


(** 
  [lister_fichiers repertoire] renvoie la liste des fichiers `.col` dans le répertoire donné.
  
  @param repertoire Le chemin du répertoire où chercher les fichiers.
  @return Une liste contenant les noms des fichiers avec l'extension `.col` trouvés dans le répertoire.
  
  @raise Sys_error Si le répertoire n'existe pas ou s'il y a une erreur d'accès.
*)
val lister_fichiers : string -> string list


(** 
  [tester_fichier fichier] lit le graphe depuis un fichier et applique l'algorithme de coloration.
  
  @param fichier Le chemin complet du fichier `.col` contenant le graphe à tester.
  @return Affiche dans la console le nombre de couleurs utilisées pour colorier le graphe.
  
  @raise Failure Si une erreur de lecture ou de traitement se produit.
*)
val tester_fichier : string -> unit


(** 
  [tester_fichiers repertoire] permet à l'utilisateur d'interagir avec une liste de fichiers dans un répertoire
  et de tester les graphes qu'ils contiennent.
  
  @param repertoire Le chemin du répertoire contenant les fichiers `.col`.
  @return Affiche un menu interactif permettant à l'utilisateur de choisir un fichier à tester.
  
  @raise Sys_error Si le répertoire n'existe pas ou s'il y a une erreur d'accès.
*)
val tester_fichiers : string -> unit

