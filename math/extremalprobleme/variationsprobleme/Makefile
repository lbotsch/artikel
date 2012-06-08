
# Set the main document name
MAIN_DOC = $(shell basename `pwd`)
BUILD_DIR = build


PLOTS_pdf = $(patsubst %.plot, %.pdf, $(shell find figures -name '*.plot' -a -print))
PLOTS_eps = $(patsubst %.plot, %.eps, $(shell find figures -name '*.plot' -a -print))
PLOTS = $(patsubst %.plot, %.plot, $(shell find figures -name '*.plot' -a -print))

all: $(MAIN_DOC).pdf

clean:
	rm -rf build/

$(BUILD_DIR):
	mkdir -p $@

$(PLOTS_eps): $(PLOTS) $(BUILD_DIR)
	cd build; gnuplot $(patsubst figures/%.eps, ../figures/%.plot, $@); cd ..

$(PLOTS_pdf): $(PLOTS_eps) $(BUILD_DIR)
	cd build; epstopdf --nocompress $(patsubst figures/%.pdf, %.eps, $@); cd ..

build/main.pdf: main.tex header.tex $(PLOTS_pdf) $(BUILD_DIR)
	pdflatex -output-directory build -interaction nonstopmode main.tex; \
		pdflatex -output-directory build -interaction nonstopmode main.tex; # Run twice

$(MAIN_DOC).pdf: build/main.pdf
	cp build/main.pdf $@

.PHONY: clean all
.SUFFIXES: .pdf .eps .plot .tex
