# Nom de l'exécutable principal
EXEC = sat_coloring

# Répertoires des sources
SRC_DIR = src

# Fichiers source
SRC_MLI = $(wildcard $(SRC_DIR)/*.mli)
SRC_ML = $(wildcard $(SRC_DIR)/*.ml)

# Fichiers objets générés
CMI = $(SRC_MLI:.mli=.cmi)
CMO = $(SRC_ML:.ml=.cmo)

# Compilateur OCaml
OCAMLC = ocamlc
LIBS = -I +str -I +unix str.cma unix.cma

# Options de compilation
INCLUDES = -I $(SRC_DIR)

# Règle par défaut : compilation et lien
all: $(EXEC)

# Lier les fichiers objets pour produire l'exécutable
$(EXEC): $(CMO)
	$(OCAMLC) -o $(EXEC) $(LIBS) $(INCLUDES) \
		src/sat_solver.cmo src/quine_dpll.cmo src/dimacs_to_cnf.cmo src/main_bis.cmo

# Dépendances explicites pour garantir l'ordre de compilation
src/sat_solver.cmi: src/sat_solver.mli
	$(OCAMLC) $(INCLUDES) -I +unix -c $<

src/sat_solver.cmo: src/sat_solver.ml src/sat_solver.cmi
	$(OCAMLC) $(INCLUDES) -I +unix -c $<

src/quine_dpll.cmi: src/quine_dpll.mli src/sat_solver.cmi
	$(OCAMLC) $(INCLUDES) -I +unix -c $<

src/quine_dpll.cmo: src/quine_dpll.ml src/quine_dpll.cmi src/sat_solver.cmo
	$(OCAMLC) $(INCLUDES) -I +unix -c $<

src/dimacs_to_cnf.cmi: src/dimacs_to_cnf.mli src/sat_solver.cmi
	$(OCAMLC) $(INCLUDES) -I +unix -c $<

src/dimacs_to_cnf.cmo: src/dimacs_to_cnf.ml src/dimacs_to_cnf.cmi src/sat_solver.cmo
	$(OCAMLC) $(INCLUDES) -I +unix -c $<

src/main_bis.cmo: src/main_bis.ml src/dimacs_to_cnf.cmo src/sat_solver.cmo src/quine_dpll.cmo
	$(OCAMLC) $(INCLUDES) -I +unix -c $<

# Nettoyer les fichiers compilés
clean:
	rm -f $(SRC_DIR)/*.cmo $(SRC_DIR)/*.cmi

# Supprimer tous les fichiers compilés, y compris les exécutables
mrproper: clean
	rm -f $(EXEC)
