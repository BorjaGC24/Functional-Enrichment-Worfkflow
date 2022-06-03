# Esto esta hecho manalmente, pero he cargado la variable "fila" del final del script anterior
# para cada dataser (astrocitos up y down y neuronas up y down)
load("fila_a_down.rda")
a_down = unlist(fila)
load("fila_a_up.rda")
a_up = unlist(fila)
load("fila_n_down.rda")
n_down = unlist(fila)
load("fila_n_up.rda")
n_up = unlist(fila)

patata = as.data.frame(rbind(a_down, a_up, n_down, n_up))
patata = round(patata, digits = 2)

filas = apply(X = patata, MARGIN = 1, FUN = mean)
columnas = apply(X = patata, MARGIN = 2, FUN = mean)
patata = cbind(patata, filas)
patata = rbind(patata, columnas)

colnames(patata) = c("ORA", "GSEA", "elim", "weight", "PC", "weight01", "Mean")
rownames(patata) = c("Ast down", "Ast up", "Neur down", "Neur up", "Mean")
patata[5,7] = NA
