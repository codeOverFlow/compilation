EXEC = projet

CAMLC = ocamlc
CAMLDEP = ocamldep
CAMLLEX = ocamllex
CAMLYACC = ocamlyacc

all:
	$(CAMLLEX) scanner.mll
	$(CAMLYACC) parser.mly
	$(CAMLC) -c definitions.ml
	$(CAMLC) -c errors.ml
	$(CAMLC) -c parser.mli
	$(CAMLC) -c scanner.ml
	$(CAMLC) -c parser.ml
	$(CAMLC) definitions.cmo errors.cmo scanner.cmo parser.cmo projet.ml -o $(EXEC)

clean:
	rm -f *.cm[iox] *.mli *~ .*~ #*#
	rm -f $(EXEC).opt
	rm -rf scanner.ml parser.ml
