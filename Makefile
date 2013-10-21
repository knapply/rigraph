
REALVERSION=$(shell ../../tools/getversion.sh)
VERSION=$(shell ./tools/convertversion.sh)
DATAVERSION=0.1
top_srcdir=../..

all: igraph_$(VERSION).tar.gz igraphdata_$(DATAVERSION).tar.gz

YACC=bison -d
LEX=flex

%.c: %.y
	$(YACC) $<
	mv -f y.tab.c $@
	mv -f y.tab.h $(@:.c=.h)

%.c: %.l
	$(LEX) $<
	mv -f lex.yy.c $@

DATAFILES = $(wildcard igraphdata/data/*.rda) igraphdata/DESCRIPTION \
	igraphdata/LICENSE $(wildcard igraphdata/man/*.Rd) \
	$(wildcard igraphdata/inst/*)

igraphdata_$(DATAVERSION).tar.gz: $(DATAFILES)
	R CMD build igraphdata

RFILES = $(wildcard igraph/R/*.R) $(wildcard igraph/man/*.Rd) \
	igraph/src/config.h igraph/src/config.h.in igraph/src/Makevars.in \
	igraph/src/Makevars.win igraph/DESCRIPTION \
	igraph/NAMESPACE igraph/R/auto.R igraph/src/rinterface.c \
	igraph/src/rinterface.h arpack/stamp

igraph/src/config.h: src/config.h
	cp $< $@
igraph/src/Makevars.in: src/Makevars.in
	cp $< $@
igraph/src/rinterface.h: src/rinterface.h
	cp $< $@

arpack/stamp: $(wildcard arpack/*.f) $(wildcard arpack/*.h)
	cp arpack/*.{f,h} igraph/src/ && \
	touch arpack/stamp

# Files generated by stimulus

igraph/src/rinterface.c: ../../interfaces/functions.def ../../interfaces/R/src/rinterface.c.in  ../../interfaces/R/types-C.def ../../tools/stimulus.py
	../../tools/stimulus.py \
           -f ../../interfaces/functions.def \
           -i ../../interfaces/R/src/rinterface.c.in \
           -o igraph/src/rinterface.c \
           -t ../../interfaces/R/types-C.def \
           -l RC

igraph/R/auto.R: ../../interfaces/functions.def auto.R.in ../../interfaces/R/types-R.def ../../tools/stimulus.py
	../../tools/stimulus.py \
           -f ../../interfaces/functions.def \
           -i auto.R.in \
           -o igraph/R/auto.R \
           -t ../../interfaces/R/types-R.def \
           -l RR

igraph/NAMESPACE: ../functions.def NAMESPACE.in ../../tools/stimulus.py
	../../tools/stimulus.py \
            -f ../functions.def \
            -i NAMESPACE.in \
            -o igraph/NAMESPACE \
            -l RNamespace

# Files from the original source

YFILES = $(wildcard $(top_srcdir)/src/*.y)
LFILES = $(wildcard $(top_srcdir)/src/*.l)
SRCFILES_ORIGPLACE = $(wildcard $(top_srcdir)/src/*.c) \
	$(wildcard $(top_srcdir)/src/*.h) \
	$(wildcard $(top_srcdir)/src/*.cc) \
	$(wildcard $(top_srcdir)/src/*.hh) \
	$(wildcard $(top_srcdir)/src/*.cpp) \
	$(wildcard $(top_srcdir)/src/*.pmt) \
	$(YFILES) $(LFILES)

SRCFILES_ORIGPLACE6 =   $(wildcard $(top_srcdir)/include/*.h)

SRCFILES_ORIGPLACE7 = 	$(wildcard $(top_srcdir)/src/cs/*.c)

SRCFILES_ORIGPLACE8 = 	$(wildcard $(top_srcdir)/src/cs/*.h)

SRCFILES_ORIGPLACE9 =   $(wildcard $(top_srcdir)/optional/glpk/*.c)

SRCFILES_ORIGPLACE10 =  $(wildcard $(top_srcdir)/optional/glpk/*.h)

SRCFILES_ORIGPLACE11 =  $(wildcard $(top_srcdir)/optional/glpk/amd/*.c)

SRCFILES_ORIGPLACE12 =  $(wildcard $(top_srcdir)/optional/glpk/amd/*.h)

SRCFILES_ORIGPLACE13 =  $(wildcard $(top_srcdir)/optional/glpk/colamd/*.c)

SRCFILES_ORIGPLACE14 =  $(wildcard $(top_srcdir)/optional/glpk/colamd/*.h)

SRCFILES_ORIGPLACE15 =  $(wildcard $(top_srcdir)/optional/simpleraytracer/*.cpp)

SRCFILES_ORIGPLACE16 =  $(wildcard $(top_srcdir)/optional/simpleraytracer/*.h)

SRCFILES_ORIGPLACE17 =  $(wildcard $(top_srcdir)/src/plfit/*.h)

SRCFILES_ORIGPLACE18 =  $(wildcard $(top_srcdir)/src/plfit/*.c)

SRCFILES = $(patsubst $(top_srcdir)/src/%,igraph/src/%,$(SRCFILES_ORIGPLACE)) \
	$(patsubst $(top_srcdir)/include/%,igraph/src/%,$(SRCFILES_ORIGPLACE6)) \
	$(patsubst $(top_srcdir)/src/cs/%,igraph/src/%,$(SRCFILES_ORIGPLACE7)) \
	$(patsubst $(top_srcdir)/src/cs/%,igraph/src/cs/%,$(SRCFILES_ORIGPLACE8)) \
	$(patsubst $(top_srcdir)/optional/glpk/%,igraph/src/%,$(SRCFILES_ORIGPLACE9)) \
	$(patsubst $(top_srcdir)/optional/glpk/%,igraph/src/glpk/%,$(SRCFILES_ORIGPLACE10)) \
	$(patsubst $(top_srcdir)/optional/glpk/amd/%,igraph/src/%,$(SRCFILES_ORIGPLACE11)) \
	$(patsubst $(top_srcdir)/optional/glpk/amd/%,igraph/src/glpk/amd/%,$(SRCFILES_ORIGPLACE12)) \
	$(patsubst $(top_srcdir)/optional/glpk/colamd/%,igraph/src/%,$(SRCFILES_ORIGPLACE13)) \
	$(patsubst $(top_srcdir)/optional/glpk/colamd/%,igraph/src/glpk/colamd/%,$(SRCFILES_ORIGPLACE14)) \
	$(patsubst $(top_srcdir)/optional/simpleraytracer/%,igraph/src/%,$(SRCFILES_ORIGPLACE15)) \
	$(patsubst $(top_srcdir)/optional/simpleraytracer/%,igraph/src/%,$(SRCFILES_ORIGPLACE16)) \
	$(patsubst $(top_srcdir)/src/plfit/%,igraph/src/plfit/%,$(SRCFILES_ORIGPLACE17)) \
	$(patsubst $(top_srcdir)/src/plfit/%,igraph/src/%,$(SRCFILES_ORIGPLACE18)) \
	$(patsubst $(top_srcdir)/src/%,igraph/src/%,$(YFILES:.y=.c)) \
	$(patsubst $(top_srcdir)/src/%,igraph/src/%,$(YFILES:.y=.h)) \
	$(patsubst $(top_srcdir)/src/%,igraph/src/%,$(LFILES:.l=.c)) \
	igraph/src/igraph_threading.h igraph/src/igraph_version.h

igraph/src/cs/%.h: $(top_srcdir)/src/cs/%.h
	cp $(top_srcdir)/src/cs/$(@F) igraph/src/cs/$(@F)

igraph/src/glpk/amd/%.h: $(top_srcdir)/optional/glpk/amd/%.h
	cp $(top_srcdir)/optional/glpk/amd/$(@F) igraph/src/glpk/amd/$(@F)
igraph/src/glpk/colamd/%.h: $(top_srcdir)/optional/glpk/colamd/%.h
	cp $(top_srcdir)/optional/glpk/colamd/$(@F) igraph/src/glpk/colamd/$(@F)
igraph/src/glpk/%.h: $(top_srcdir)/optional/glpk/%.h
	cp $(top_srcdir)/optional/glpk/$(@F) igraph/src/glpk/$(@F)

igraph/src/%.c: $(top_srcdir)/src/plfit/%.c
	cp $(top_srcdir)/src/plfit/$(@F) igraph/src/$(@F)
igraph/src/plfit/%.h: $(top_srcdir)/src/plfit/%.h
	cp $(top_srcdir)/src/plfit/$(@F) igraph/src/plfit/$(@F)

igraph/src/%.c: $(top_srcdir)/src/%.c
	cp $(top_srcdir)/src/$(@F) $@
igraph/src/%.cc: $(top_srcdir)/src/%.cc
	cp $(top_srcdir)/src/$(@F) $@
igraph/src/%.hh: $(top_srcdir)/src/%.hh
	cp $(top_srcdir)/src/$(@F) $@
igraph/src/%.cpp: $(top_srcdir)/src/%.cpp
	cp $(top_srcdir)/src/$(@F) $@
igraph/src/%.pmt: $(top_srcdir)/src/%.pmt
	cp $(top_srcdir)/src/$(@F) $@
igraph/src/%.h: $(top_srcdir)/src/%.h
	cp $(top_srcdir)/src/$(@F) $@
igraph/src/%.y: $(top_srcdir)/src/%.y
	cp $(top_srcdir)/src/$(@F) $@
igraph/src/%.l: $(top_srcdir)/src/%.l
	cp $(top_srcdir)/src/$(@F) $@

igraph/src/%.c: $(top_srcdir)/src/cs/%.c
	cp $(top_srcdir)/src/cs/$(@F) igraph/src/$(@F)
igraph/src/%.c: $(top_srcdir)/optional/glpk/amd/%.c
	cp $(top_srcdir)/optional/glpk/amd/$(@F) igraph/src/$(@F)
igraph/src/%.c: $(top_srcdir)/optional/glpk/colamd/%.c
	cp $(top_srcdir)/optional/glpk/colamd/$(@F) igraph/src/$(@F)
igraph/src/%.c: $(top_srcdir)/optional/glpk/%.c
	cp $(top_srcdir)/optional/glpk/$(@F) igraph/src/$(@F)

igraph/src/%.cpp: $(top_srcdir)/optional/simpleraytracer/%.cpp
	cp $(top_srcdir)/optional/simpleraytracer/$(@F) igraph/src/$(@F)
igraph/src/%.h: $(top_srcdir)/optional/simpleraytracer/%.h
	cp $(top_srcdir)/optional/simpleraytracer/$(@F) igraph/src/$(@F)

igraph/src/%.h: $(top_srcdir)/include/%.h
	cp $(top_srcdir)/include/$(@F) $@

igraph/src/igraph_threading.h: $(top_srcdir)/include/igraph_threading.h.in
	sed 's/@HAVE_TLS@/0/g' $< >$@

igraph/src/igraph_version.h: $(top_srcdir)/include/igraph_version.h.in
	sed 's/@VERSION@/'$(REALVERSION)'/g' $< >$@

DIRS: 
	mkdir -p igraph/src
	mkdir -p igraph/src/cs
	mkdir -p igraph/src/glpk
	mkdir -p igraph/src/glpk/amd
	mkdir -p igraph/src/glpk/colamd
	mkdir -p igraph/src/plfit

.PHONY: DIRS

igraph/configure igraph/src/config.h.in: igraph/configure.in
	cd igraph; autoheader; autoconf

igraph/src/Makevars.win: src/Makevars.win
	sed 's/@VERSION@/'$(VERSION)'/g' $< >$@

igraph/DESCRIPTION: src/DESCRIPTION ../../VERSION
	sed 's/^Version: .*$$/Version: '$(VERSION)'/' $<     | \
        sed 's/^Date: .*$$/Date: '`date "+%Y-%m-%d"`'/' > $@

igraph_$(VERSION).tar.gz: DIRS $(RFILES) $(SRCFILES) igraph/DESCRIPTION
	rm -f igraph/R/config.R
	rm -f igraph/src/config.h
	touch igraph/src/config.h
	R CMD build igraph

homepagetests:
	$(eval $@_TMP := $(shell mktemp -d -t igraph))
	cp -r ../../doc/homepage/examples $($@_TMP) && \
	cd $($@_TMP)/examples && echo "tools:::.runPackageTestsR()" | \
	R --no-save && echo

.PHONY: tests igraph/DESCRIPTION
