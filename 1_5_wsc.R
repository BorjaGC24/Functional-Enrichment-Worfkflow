library(WebGestaltR)
library(Hmisc)

# IMP: Hay dos opciones, A) realizar el WSC con los datos en sucio o B) realizar
#      primero un filtrado eliminando aquellos términos con > 1000 genes
#      anotados. Para el trabajo y el workflok de los scripts se ha utilizado la
#      opción B.


### Cargamos los datos del enriquecimiento
load("resultados_durante_enriquecimiento/procesado/lista_dataframes_resultados.rda")

### Seleccionamos el pvalor con el que se ha realizado el enriquecimiento
pvalor = 0.05

### Cargamos la informacion significativa de cada método
fisher = lista_resultados[[1]][as.numeric(lista_resultados[[1]]$ORA)<=pvalor,]
gsea<-lista_resultados[[2]][as.numeric(lista_resultados[[2]]$GSEA)<=pvalor,]
elim<-lista_resultados[[3]][as.numeric(lista_resultados[[3]]$elim)<=pvalor,]
weight<-lista_resultados[[4]][as.numeric(lista_resultados[[4]]$weight)<=pvalor,]
pa<-lista_resultados[[5]][as.numeric(lista_resultados[[5]]$PC)<=pvalor,]
weight01<-lista_resultados[[6]][(lista_resultados[[6]]$weight01)<=pvalor,]


### Creamos las variables metodos y nueva_lista para automatizar el proceso 
metodos = list(fisher, gsea, elim, weight, pa, weight01)
nueva_lista = list()



# OPCIÓN A
### Aplicamos el algoritmo WSC para nuestro set de términos significativos.
for (numero in 1:length(metodos)){
  a<- metodos[[numero]]
  
  lista<-a$Genes
  names(lista) = a$GO.ID
  cost = as.numeric(a[,length(a)-1])
  
  match<-weightedSetCover(lista, cost, length(lista), nThreads = 8)
  patata <- a[a$GO.ID %in% match$topSets,]
  
  nueva_lista[[numero]] = patata
}

### Guardamos los términos restantes y su pvalor en una lista para facilitar
### futuros pasos
go_term_sig_wsc = list()

for (numero in 1:6){
  a<-nueva_lista[[numero]]
  valores = as.numeric(a[,length(a)-1])
  names(valores) = a$GO.ID
  go_term_sig_wsc[[numero]] = valores
}

save(go_term_sig_wsc, file = "resultados_durante_enriquecimiento/procesado_wsc/terminos_significativos.rda")
save(nueva_lista, file = "resultados_durante_enriquecimiento/procesado_wsc/lista_dataframes_resultados.rda")


# OPCIÓN B
### Aplicamos el algoritmo WSC para nuestro set de términos significativos PERO
### eliminando aquellos términos con >1000 genes anotados, que son muy generales
nueva_lista_filtrado = list()

for (numero in 1:length(metodos)){
  a<- metodos[[numero]]
  
  a = a[a$Annotated < 1000,] 
  lista<-a$Genes
  names(lista) = a$GO.ID
  cost = as.numeric(a[,length(a)-1])
  
  match<-weightedSetCover(lista, cost, length(lista), nThreads = 8)
  patata <- a[a$GO.ID %in% match$topSets,]
  
  nueva_lista_filtrado[[numero]] = patata
}


### Guardamos los términos restantes y su pvalor en una lista para facilitar
### futuros pasos
go_term_sig_wsc_filtrado = list()

for (numero in 1:6){
  a<-nueva_lista_filtrado[[numero]]
  valores = as.numeric(a[,length(a)-1])
  names(valores) = a$GO.ID
  go_term_sig_wsc_filtrado[[numero]] = valores
}


save(go_term_sig_wsc_filtrado, file = "resultados_durante_enriquecimiento/procesado_wsc/terminos_significativos_filtrados.rda")
save(nueva_lista_filtrado, file = "resultados_durante_enriquecimiento/procesado_wsc/filtrado_lista_dataframes_resultados.rda")








