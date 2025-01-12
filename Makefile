# Nom de l'exécutable principal
EXEC = graph_coloring

# Répertoires des sources et des tests
SRC_DIR = src
TEST_DIR = test

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
		src/graph.cmo src/tas.cmo src/dsatur.cmo src/testGraph.cmo src/fileMenu.cmo src/main.cmo

# Dépendances explicites pour garantir l'ordre de compilation
src/graph.cmi: src/graph.mli
	$(OCAMLC) $(INCLUDES) -I +unix -c $<

src/graph.cmo: src/graph.ml src/graph.cmi
	$(OCAMLC) $(INCLUDES) -I +unix -c $<

src/tas.cmi: src/tas.mli
	$(OCAMLC) $(INCLUDES) -I +unix -c $<

src/tas.cmo: src/tas.ml src/tas.cmi
	$(OCAMLC) $(INCLUDES) -I +unix -c $<

src/dsatur.cmi: src/dsatur.mli src/graph.cmi src/tas.cmi
	$(OCAMLC) $(INCLUDES) -I +unix -c $<

src/dsatur.cmo: src/dsatur.ml src/dsatur.cmi src/graph.cmo src/tas.cmo
	$(OCAMLC) $(INCLUDES) -I +unix -c $<

src/testGraph.cmi: src/testGraph.mli src/graph.cmi
	$(OCAMLC) $(INCLUDES) -I +unix -c $<

src/testGraph.cmo: src/testGraph.ml src/testGraph.cmi src/graph.cmo
	$(OCAMLC) $(INCLUDES) -I +unix -c $<

src/fileMenu.cmi: src/fileMenu.mli src/graph.cmi src/dsatur.cmi
	$(OCAMLC) $(INCLUDES) -c $<

src/fileMenu.cmo: src/fileMenu.ml src/fileMenu.cmi src/graph.cmo src/dsatur.cmo
	$(OCAMLC) $(INCLUDES) -c $<

src/main.cmo: src/main.ml src/graph.cmo src/dsatur.cmo src/tas.cmo src/testGraph.cmo src/fileMenu.cmo
	$(OCAMLC) $(INCLUDES) -I +unix -c $<


# Nettoyer les fichiers compilés
clean:
	rm -f $(SRC_DIR)/*.cmo $(SRC_DIR)/*.cmi

# Supprimer tous les fichiers compilés, y compris les exécutables
mrproper: clean
	rm -f $(EXEC)
