#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Usage: $0 PATH"
    echo "PATH: relative path (e.g. math/calculus/integral)"
    exit 1
fi

BASE_PATH=`dirname $0`
ARTICLE_PATH=$BASE_PATH/$1
FIGURES_PATH=$ARTICLE_PATH/figures

MAKEFILE_PATH=$ARTICLE_PATH/Makefile
HEADER_TEX_PATH=$ARTICLE_PATH/header.tex
MAIN_TEX_PATH=$ARTICLE_PATH/main.tex
EXAMPLE_PLOT_PATH=$FIGURES_PATH/skeleton.plot.example

if [ -d $ARTICLE_PATH ]; then
    echo "The path you specified already exists. Do you want to overwrite it? (yes/no)"
    read ANSWER
    if [ "yes" != "$ANSWER" ]; then
        echo "Aborting."
        exit 0
    fi
fi

mkdir -p $ARTICLE_PATH
mkdir -p $FIGURES_PATH

cat > $MAKEFILE_PATH <<"EOF"
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
EOF

cat > $HEADER_TEX_PATH <<"EOF"

% ***********************************************************
% ******************* PHYSICS HEADER ************************
% ***********************************************************
% Version 2
\documentclass[11pt]{article} 
\parindent0pt % No indentation of paragraphs
\parskip11pt
\usepackage{amsmath} % AMS Math Package
\usepackage{amsthm} % Theorem Formatting
\usepackage{amssymb}	% Math symbols such as \mathbb
\usepackage{graphicx} % Allows for eps images
\usepackage{color}
\usepackage{multicol} % Allows for multiple columns
\usepackage[pdfborder={0 0 0}]{hyperref}
%\usepackage{epstopdf}
\usepackage[utf8]{inputenc}
\usepackage[dvips,a4paper,margin=2.5cm,bottom=2cm]{geometry}
\usepackage[T1]{fontenc}
\usepackage{pslatex}
 % Sets margins and page size
\pagestyle{empty} % Removes page numbers
\date{}
\author{}
\makeatletter % Need for anything that contains an @ command 
\renewcommand{\maketitle} % Redefine maketitle to conserve space
{ \begingroup 
    \vskip 10pt \begin{center} \huge {\bf \@title} \end{center}
%    \vskip 10pt \begin{center} \normalsize \@author \hskip 20pt \@date \end{center}
    \vskip 30pt
  \endgroup
  \setcounter{footnote}{0}
}
\makeatother % End of region containing @ commands
\renewcommand{\labelenumi}{(\alph{enumi})} % Use letters for enumerate
% \DeclareMathOperator{\Sample}{Sample}
\let\vaccent=\v % rename builtin command \v{} to \vaccent{}
\renewcommand{\v}[1]{\ensuremath{\mathbf{#1}}} % for vectors
\newcommand{\gv}[1]{\ensuremath{\mbox{\boldmath$ #1 $}}} 
% for vectors of Greek letters
\newcommand{\uv}[1]{\ensuremath{\mathbf{\hat{#1}}}} % for unit vector
\newcommand{\abs}[1]{\left| #1 \right|} % for absolute value
\newcommand{\avg}[1]{\left< #1 \right>} % for average
\let\underdot=\d % rename builtin command \d{} to \underdot{}
\renewcommand{\d}[2]{\frac{d #1}{d #2}} % for derivatives
\newcommand{\dd}[2]{\frac{d^2 #1}{d #2^2}} % for double derivatives
\newcommand{\pd}[2]{\frac{\partial #1}{\partial #2}} 
% for partial derivatives
\newcommand{\pdd}[2]{\frac{\partial^2 #1}{\partial #2^2}} 
% for double partial derivatives
\newcommand{\pdc}[3]{\left( \frac{\partial #1}{\partial #2}
 \right)_{#3}} % for thermodynamic partial derivatives
\newcommand{\ket}[1]{\left| #1 \right>} % for Dirac bras
\newcommand{\bra}[1]{\left< #1 \right|} % for Dirac kets
\newcommand{\braket}[2]{\left< #1 \vphantom{#2} \right|
 \left. #2 \vphantom{#1} \right>} % for Dirac brackets
\newcommand{\matrixel}[3]{\left< #1 \vphantom{#2#3} \right|
 #2 \left| #3 \vphantom{#1#2} \right>} % for Dirac matrix elements
\newcommand{\grad}[1]{\gv{\nabla} #1} % for gradient
\let\divsymb=\div % rename builtin command \div to \divsymb
\renewcommand{\div}[1]{\gv{\nabla} \cdot #1} % for divergence
\newcommand{\curl}[1]{\gv{\nabla} \times #1} % for curl
\let\baraccent=\= % rename builtin command \= to \baraccent
\renewcommand{\=}[1]{\stackrel{#1}{=}} % for putting numbers above =
\newcommand{\integral}[4]{\int_{#1}^{#2} #3 \, \mathrm{d}#4}
\let\oldphi=\phi % rename old phi to oldphi
\renewcommand{\phi}{\varphi}
\newtheorem{prop}{Proposition}
\newtheorem{thm}{Satz}[section]
\newtheorem{lem}[thm]{Lemma}
\theoremstyle{definition}
\newtheorem{dfn}{Definition}
\theoremstyle{remark}
\newtheorem*{rmk}{Bemerkung}
\theoremstyle{proof}
\newtheorem*{beweis}{Beweis}


% Include GnuPlots
\newcommand{\gnuplot}[3]{
    \let\oldincludegraphics=\includegraphics
    \renewcommand{\includegraphics}[1]{\oldincludegraphics{build/#1.pdf}}
    \begin{figure}[htbp]\begin{center}\input{build/#1.tex}\caption{#2}\label{#3}\end{center}\end{figure}
    \let\includegraphics=\oldincludegraphics
}
% ***********************************************************
% ********************** END HEADER *************************
% ***********************************************************
EOF

cat > $MAIN_TEX_PATH <<"EOF"

% File: main.tex
% This is the main file of your article. Begin writing your article after the comment 'Actual content starts here'!

\input{header.tex}
\title{TITLE}
\hypersetup
{
    pdfauthor = {YOUR NAME},
    pdfsubject = {SUBJECT},
    pdftitle = {TITLE},
    pdfkeywords = {KEYWORDS}
}

\begin{document}
\maketitle{}

% Ein paar nützliche Befehle:
%
% \gnuplot{name}{Titel}{label}  Fügt das gnuplot 'figures/[name].plot' mit dem gegebenen title und label als Figur ein
% 
% \begin{align}
%     % Integral
%     \int_a^b f(x) \,\mathrm{d}x\\
%
%     % Ableitung
%     \d{f}{x}
%
%     % Zweite Ableitung
%     \dd{f}{x}
%
%     % Partielle Ableitung
%     \pd{f}{x}
%
%     % Zweite partielle Ableitung
%     \pdd{f}{x}
%
%     % Nabla notation von Gradient, Divergenz und Krümmung
%     \grad{f} \div{f} \curl{f}
% \end{align}
%
% \begin{thm}[Titel]
%     Ein Satz ...
% \end{thm}
% \begin{beweis}
%     Der Beweis zum Satz ...
%     \qed % setzt ein rechteck ans Ende der Zeile
% \end{beweis}

% Actual content starts here



% Actual content ends here

\end{document}
EOF

cat > $EXAMPLE_PLOT_PATH <<"EOF"
# ATTENTION: Your gnuplot files must end in .plot for the build system to find them!!!

# This sets the terminal to latex and sets the size
set term epslatex size 8.89cm,6.65cm color colortext
set output "plot1.tex"

# Line width of the axes
set border linewidth 1.5

# Define line styles
set style line 1 linecolor rgb '#0060ad' linetype 1 linewidth 2
set style line 2 linecolor rgb '#dd181f' linetype 1 linewidth 2
set style line 3 linecolor rgb '#d02090' linetype 1 linewidth 2

# Position the legend
#set key at 6cm,0.6cm

# Define Axes labels
#set xlabel '$x$'
#set ylabel '$y$'
set format '$%g$'

# Define Axes ranges
set xrange [0:5]
set yrange [-2:2]

# Axes tics
#set xtics ('$a$' 1, '$b$' 2) nomirror
#set ytics ('$\alpha$' 1, '$\beta$' 2) nomirror
#set tics scale 0.5

# Define Functions

# Use cut to cut a function to a certain frame (eg. f(x)*cut(x, 1, 4) will cut f(x) to values of x in [1,4]
cut(x,x1,x2) = ((x >= x1 && x <= x2) ? 1.0 : 1/0)

f(x) = x**2
g(x) = cos(x)
h(x) = sin(x)

# Plot
plot \
    f(x) title '$y_1(x) = x^2$' with lines linestyle 1, \
    g(x) title '$y_2(x) = cos(x)$' with lines linestyle 2, \
    h(x) title '$y_3(x) = sin(x)$' with lines linestyle 3
EOF

echo "A skeleton for your new article has been created at '$ARTICLE_PATH'!"
