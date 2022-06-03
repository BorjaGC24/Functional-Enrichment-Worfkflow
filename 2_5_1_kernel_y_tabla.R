
# Con este script vamos a generar un plot de la densidad kernel para el IC de
# términos detectados por los distintos métodos. Además vamos a generar para 
# cada término una medida del porcentaje de términos con un IC mayor a 5 
# (escogido de forma empirica)

# Cargamos las variables
load("resultados_durante_enriquecimiento/procesado/terminos_significativos.rda")
pacman::p_load(GOSemSim,GO.db, kdensity)
organismo = "org.Hs.eg.db"
GO_semsim = godata(organismo, ont="BP")

# Calculamos el IC para los términos detectados
valores_ic_fisher = na.omit((GO_semsim@IC)[names(go_term_sig[[1]])])
valores_ic_gsea = na.omit((GO_semsim@IC)[names(go_term_sig[[2]])])
valores_ic_elim = na.omit((GO_semsim@IC)[names(go_term_sig[[3]])])
valores_ic_weight = na.omit((GO_semsim@IC)[names(go_term_sig[[4]])])
valores_ic_pc = na.omit((GO_semsim@IC)[names(go_term_sig[[5]])])
valores_ic_weight01 = na.omit((GO_semsim@IC)[names(go_term_sig[[6]])])

# Normalizamos los valores de IC para cada método
valores_ic_fisher <- (valores_ic_fisher - min(valores_ic_fisher)) / (max(valores_ic_fisher) - min(valores_ic_fisher))
valores_ic_gsea <- (valores_ic_gsea - min(valores_ic_gsea)) / (max(valores_ic_gsea) - min(valores_ic_gsea))
valores_ic_elim <- (valores_ic_elim - min(valores_ic_elim)) / (max(valores_ic_elim) - min(valores_ic_elim))
valores_ic_weight <- (valores_ic_weight - min(valores_ic_weight)) / (max(valores_ic_weight) - min(valores_ic_weight))
valores_ic_pc <- (valores_ic_pc - min(valores_ic_pc)) / (max(valores_ic_pc) - min(valores_ic_pc))
valores_ic_weight01 <- (valores_ic_weight01 - min(valores_ic_weight01)) / (max(valores_ic_weight01) - min(valores_ic_weight01))

# Generamos el plot de kernel combinando todos los métodos
svg(paste0("resultados_durante_enriquecimiento/procesado/KDE.svg"), width = 8, height = 6)
plot(kdensity(valores_ic_fisher), ylim = c(0,3.5), main = "",xlab="IC", lwd = 2, lty = 2)
lines(kdensity(valores_ic_gsea), lty = 2, col = "blue", lwd = 2)
lines(kdensity(valores_ic_elim), lty = 1, col = "red", lwd = 2)
lines(kdensity(valores_ic_weight), lty = 1, col = "green", lwd = 2)
lines(kdensity(valores_ic_pc), lty = 1, col = "brown", lwd = 2)
lines(kdensity(valores_ic_weight01), lty = 1, col = "pink", lwd = 2)

legend("topleft",
       legend = c("ORA", "GSEA", "elim", "weight", "PC", "weight01"),
       col = c("black", "blue", "red", "green", "brown", "pink"),
       lty = 1,
       cex=1)
dev.off()

# Finalmente calculamos para cada método el porcentaje de términos con IC 
# superior a 5 (en el siguiente script se combinarán los datos)

f1 = function(x){
  x<-x[!is.na(x)]
  x<-(GO_semsim@IC)[names(x)]
}

a<-lapply(go_term_sig, f1)

f2 = function(x){
  longitud = length(x)
  match = sum(na.omit(x>5))
  resultado = (match/longitud)*100
}

fila <-lapply(a, f2)

save(fila, file ="resultados_durante_enriquecimiento/procesado/fila.rda")

