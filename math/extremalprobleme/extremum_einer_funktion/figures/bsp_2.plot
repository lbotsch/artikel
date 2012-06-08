# ATTENTION: Your gnuplot files must end in .plot for the build system to find them!!!

# This sets the terminal to latex and sets the size
set term epslatex size 8.89cm,6.65cm color colortext
set output "bsp_2.tex"

# Line width of the axes
set border linewidth 1.5

# Define line styles
set style line 1 linecolor rgb '#0060ad' linetype 1 linewidth 2
set style line 2 linecolor rgb '#dd181f' linetype 1 linewidth 2
set style line 3 linecolor rgb '#d02090' linetype 1 linewidth 2

# Position the legend
#set key at 6cm,0.6cm

# Define Axes labels
set xlabel '$x$'
set ylabel '$y$'
set zlabel '$z$'
set format '$%g$'

# Define Axes ranges
set xrange [-2:2]
set yrange [-2:2]
set zrange [0:5]

# Axes tics
set xtics ('$0$' 0) nomirror
set ytics ('$0$' 0) nomirror
set ztics ('$0$' 0) nomirror
#set tics scale 0.5

# Define Functions

# Use cut to cut a function to a certain frame (eg. f(x)*cut(x, 1, 4) will cut f(x) to values of x in [1,4]
cut(x,x1,x2) = ((x >= x1 && x <= x2) ? 1.0 : 1/0)

f(x,y) = exp(x*y) + x**2 + 2*y**2

# Plot
splot f(x,y) notitle #with lines linestyle 1
