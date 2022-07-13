<div align="justify">
  
# Complete GSA Workflow


Comparación entre métodos clásicos (ORA, GSEA) y métodos tipo MEA (elim, weight, weight01 y PC) para el control de la propagación génica.


## Datos
Los datos resultantes del enriquecimiento diferencial se guardan en la carpeta datos en formato .tsv

## Procesamiento

Con el script `1_0_enriquecimiento.Rmd` se eligen los parámetros de selección para escoger los genes diferencialmente expresados y se realiza el análisis de enriquecimiento con las 6 metodologías. Además se obtienen distintas gráficas como los gráfos para cada método o el top 30 términos más significativos.


## Postprocesado con WSC

Este paso es opcional. Con el script `1_5_wsc.R` se pueden procesar los datos para eliminar ciertos términos redundantes. El proceso tiene dos opciones, a) Aplicar únicamente el algoritmo WSC a las 6 metodologias de clusterizado, b) Primero realizar un filtrado, eliminando aquellos términos con > 1.000 genes anotados y posteriormente aplicar WSC (mucho más recomendable)

## Visualización de resultados

Con el scrip `2_0_analisis_resultados.Rmd`, `2_5_1_kernel_y_tabla.R` y `2_5_2_combinacion.R` podemos generar distintas gráficas sobre los datos obtenidos hasta el momento, como los términos con mayor ratio de enriquecimiento en cada método, la tasa de enriquecimiento media o el estimador Kernel de los valores IC para los términos de cada método. (`2_5_2_combinacion.R` no está automatizado jejeje)

## Clusterizado

Finalmente, con el script `3_clusterizado.Rmd` se pueden clusterizar los datos mediante dos herramientas, `simplifyEnrichment` y `REVIGO`. Para estas herramientas se puede seleccionar un umbral entre 0-1 (por defecto es 0.75 y 0.8 respectivamente) y se produce un heatmap para cada clusterizado asdemás de los datasets con los términos agrupado. Para cada clusterizado hay dos parámetros claves, por un lado el parámetro `importance`. Este parámetro permite elegir el representante de cada cluster basandose en el siguente cálculo:

$$
importance = (n/tamaño del cluster) * term_IC^2
$$

Para calcular este parámetro se obtiene para todos los términos del cluster sus ancestros, de forma que `n` mide las veces que un término aparece entre los ancestros de los términos del cluster. Este valor se divide entre el número de términos que conforman el cluster y finalmente se multiplica por su IC al cuadrado. De esta forma se escogerá un término que sea un ancestro frecuente entre los términos del cluster y además cuyo IC sea elevado.

Por otro lado, el parámetro IC del cluster viene dado por el IC del representante de cada cluster, de forma que valores de IC elevados en un cluster nos indicarán que el cluster es interesante biológicamente y que los términos que lo conforman son en general específicos.

## Informe de resultados

Finalmente, dentro de la carpeta resultados tenemos `informe.Rmd` con el que generamos el script final para visualizar todos los resultados y obtenemos las tablas finales comparativas para todos los métodos.
