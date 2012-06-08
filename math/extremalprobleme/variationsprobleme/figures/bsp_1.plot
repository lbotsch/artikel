set term epslatex size 8.89cm,6.65cm color colortext
set output "bsp_1.tex"

# Define constants
a = 1
b = 3
alpha = 1
beta = 3

# Line width of the axes
set border linewidth 1.5
# Line styles
set style line 1 linecolor rgb '#0060ad' linetype 1 linewidth 2
set style line 2 linecolor rgb '#dd181f' linetype 1 linewidth 2
set style line 3 linecolor rgb '#d02090' linetype 1 linewidth 2

# Legend
#set key at 6cm,0.6cm

# Axes label
#set xlabel '$x$'
#set ylabel '$y$'
set format '$%g$'

# Axes ranges
set xrange [a-0.5:b+0.5]
set yrange [alpha-1:beta+2]

# Axes tics
set xtics ('$a$' a, '$b$' b) nomirror
set ytics ('$\alpha$' alpha, '$\beta$' beta) nomirror
set tics scale 0.5

# Functions

cut(x,x1,x2) = ((x >= x1 && x <= x2) ? 1.0 : 1/0)
f(x) = (beta-alpha)/(b-a) * (x-a) + alpha
g(x) = (a**4*(x-b)+a*(b**4+12*beta-x**4)-b**4*x+b*(x**4-12*alpha)+12*x*(alpha-beta))/(12*(a-b))
h(x) = (5*cos(a)*(b-x)+(x-a)*5*cos(b)+a*beta+a*5*cos(x)-b*alpha-b*5*cos(x)+alpha*x-beta*x)/(a-b)

# Plot
plot [:] [alpha-1:beta+4] \
    f(x)*cut(x, a, b) title '$y_1(x)$' with lines linestyle 1, \
    g(x)*cut(x, a, b) title '$y_2(x)$' with lines linestyle 2, \
    h(x)*cut(x, a, b) title '$y_3(x)$' with lines linestyle 3

