
reset

unset key
set grid xtics ytics ls 3 lw 1 lc rgb 'gray'

#set xlabel 'x_{n}'
#set ylabel 'y_{n}'
set title "Mapa caotico"
plot filename u ($1) t "Grafica" linetype 7 linecolor -1 pointsize 0.5
#plot filename u ($1) t "Grafica" w l lc -1 lw 1
pause -1
# Ejecutar en terminal de la siguiente manera
# gnuplot -e "filename='salida.txt'" graph.gnu
