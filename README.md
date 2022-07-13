<div align="justify">
  
# Complete GSA Workflow


Comparación entre métodos clásicos (ORA, GSEA) y métodos PT (elim, weight, weight01 y PC) para el control de la propagación génica.


## Datos
Los datos resultantes del análisis de expresión diferencial se guardan en la carpeta datos en formato .tsv

## Procesamiento

Con el script `1_GSA.rmd` se eligen los parámetros de selección para escoger los genes diferencialmente expresados y se realiza el análisis de enriquecimiento con las 6 metodologías. Adicionalmente se genera el grafo GO para cada uno de los métodos.


## Postprocesado con WSC

Con el script `2_WSC.Rmd` se pueden procesar los datos para eliminar ciertos términos redundantes. El proceso tiene dos opciones, a) Aplicar únicamente el algoritmo WSC a las 6 metodologias de clusterizado, b) Primero realizar un filtrado, eliminando aquellos términos con > 1.000 genes anotados y posteriormente aplicar WSC (mucho más recomendable)

## Visualización de resultados

Con el scrip `3_GRAFICOS.Rmd`, y `4_DIST_KERNEL.Rmd` podemos generar distintas gráficas sobre los datos obtenidos hasta el momento, como los términos con mayor ratio de enriquecimiento en cada método, la tasa de enriquecimiento media o el estimador Kernel de los valores IC para los términos de cada método.

## Clusterizado

Finalmente, con el script `5_CLUSTERIZADO.Rmd` se pueden clusterizar los datos mediante dos herramientas, `simplifyEnrichment` y `REVIGO`. Para estas herramientas se puede seleccionar un umbral entre 0-1 (por defecto es 0.75 y 0.8 respectivamente) y se produce un heatmap para cada clusterizado asdemás de los datasets con los términos agrupado. Para cada clusterizado hay dos parámetros claves, por un lado el parámetro `importance`. Este parámetro permite elegir el representante de cada cluster basandose en el siguente cálculo:

$$
importance = (n/tamaño del cluster) * term_IC^2
$$

Para calcular este parámetro se obtiene para todos los términos del cluster sus ancestros, de forma que `n` mide las veces que un término aparece entre los ancestros de los términos del cluster. Este valor se divide entre el número de términos que conforman el cluster y finalmente se multiplica por su IC al cuadrado. De esta forma se escogerá un término que sea un ancestro frecuente entre los términos del cluster y además cuyo IC sea elevado.

Por otro lado, el parámetro IC del cluster viene dado por el IC del representante de cada cluster, de forma que valores de IC elevados en un cluster nos indicarán que el cluster es interesante biológicamente y que los términos que lo conforman son en general específicos.

## Informe de resultados

Finalmente, `6_RESULTADOS` genera un informe final con todos los resultados para la comparación y selección de la mejor metodología en cada dataset.
