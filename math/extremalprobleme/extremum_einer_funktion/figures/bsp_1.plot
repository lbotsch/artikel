# ATTENTION: Your gnuplot files must end in .plot for the build system to find them!!!

# This sets the terminal to latex and sets the size
set term epslatex size 8.89cm,6.65cm color colortext
set output "bsp_1.tex"

# Line width of the axes
set border linewidth 1.5

# Define line styles
set style line 1 linecolor rgb '#0060ad' linetype 1 linewidth 2

# Position the legend
#set key at 6cm,0.6cm

# Define Axes labels
#set xlabel '$x$'
#set ylabel '$y$'
set format '$%g$'

# Define Axes ranges
set xrange [-2:2]
set yrange [-1:4]

# Axes tics
set xtics ('-1' -1, '0' 0, '1' 1) nomirror
set ytics ('0' 0, '1' 1, '2' 2) nomirror
#set tics scale 0.5

# Define Functions
f(x) = x**2
min_f(x) = (x == 0 ? 0 : 1/0)
# Plot
plot f(x) notitle with lines linestyle 1, "< echo '0 0'" notitle with points pt 2 ps 4 
