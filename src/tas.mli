(** Module pour gérer un tas binaire adapté à l'algorithme DSATUR. *)


(** Type représentant un sommet dans le tas. *)
type sommet = {
  mutable dsat : int; (** Degré de saturation du sommet. *)
  degre : int;        (** Degré initial du sommet dans le graphe. *)
  numero : int;       (** Numéro du sommet (identifiant unique). *)
}

(** Type représentant un tas binaire. *)
type tas


(** [creer_tas capacite] crée un tas vide avec une capacité donnée.
    @param capacite La capacité initiale du tas.
    @return Un tas vide prêt à l'emploi. *)
val creer_tas : int -> tas


(** [inserer t sommet] insère un sommet dans le tas.
    @param t Le tas dans lequel insérer le sommet.
    @param sommet Le sommet à insérer.
    @raise Invalid_argument Si le tas est plein. *)
val inserer : tas -> sommet -> unit


(** [extraire_max t] extrait le sommet ayant la clé maximale du tas.
    Les clés sont comparées en priorité par DSAT, puis par degré en cas d'égalité.
    @param t Le tas d'où extraire le sommet.
    @return Le sommet avec la clé maximale.
    @raise Invalid_argument Si le tas est vide. *)
val extraire_max : tas -> sommet


(** [augmenter_cle t numero nouvelle_dsat] augmente la clé d'un sommet dans le tas.
    @param t Le tas contenant le sommet.
    @param numero Le numéro du sommet dont on veut augmenter la clé.
    @param nouvelle_dsat La nouvelle valeur de DSAT pour ce sommet.
    @raise Not_found Si le sommet n'existe pas dans le tas. *)
val augmenter_cle : tas -> int -> int -> unit


(** [taille t] retourne la taille actuelle du tas, c'est-à-dire le nombre de sommets qu'il contient.
    @param t Le tas concerné.
    @return La taille du tas. *)
val taille : tas -> int


(** [obtenir_donnees t] retourne les données du tas sous forme d'un tableau.
    @param t Le tas concerné.
    @return Un tableau contenant tous les sommets dans le tas. *)
val obtenir_donnees : tas -> sommet array
