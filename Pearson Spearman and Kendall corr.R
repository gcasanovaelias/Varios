# Link --------------------------------------------------------------------


# https://ademos.people.uic.edu/Chapter22.html#:~:text=we%20can%20see%20pearson%20and,they%20correlate%20normally%20distributed%20data.

# https://statistics.laerd.com/spss-tutorials/pearsons-product-moment-correlation-using-spss-statistics.php

# http://www.statstutor.ac.uk/resources/uploaded/spearmans.pdf

# (Al final entrega mucha bibliografía)
# https://www.statisticssolutions.com/free-resources/directory-of-statistical-analyses/correlation-pearson-kendall-spearman/


# Packages ----------------------------------------------------------------

library(tidyverse)

# Apuntes -----------------------------------------------------------------

# Correlación es un análisis bivariado que mide el grado y dirección de la asociación entre dos variables. Existen tres tipos comunes de correlación: Pearson, Spearman y Kendall.

# PEARSON
# Una de las correlaciones más empleadas en estaística. Es una medida del grado y la dirección entre una relación linear entre dos variables. Para emplear el coeficiente de correlación Lineal de Pearson se tiene que cumplir:

#* (1) Ambas variables son del tipo cuantitativo continuo
#* (2) A pesar de que se puede emplear el coeficiente de Pearson en datos que presenten linealidad lo apropiado es emplear esta técnica cuando la relación entre variables sea del tipo rectilineal ya que existen otros tests más apropiados para variables que presenten relaciones curvilineales.
#* (3) Eliminación de los outliers ya que estos pueden presentar un elevado impacto en el coeficiente de correlación obtenido.
#* (4) Los datos deben presentar distribución normal y homocedasticidad de la varianza.

# SPEARMAN
# Es similar al coeficiente de correlación de Pearson en cuanto a los supuestos que debe cumplir excepto por (1) no requerir que los datos presenten distribución normal y (2) los datos pueden ser del tipo categórico ordinal. Producto de que no se requiere de la distribución normal el coeficiente de correlación de Spearman es un test no paramétrico* que indica la medida estadística del grado de asociación monotónica entre pares de variables.

# *¿Qué es un test no paramétrico? Es un test que no asume que se cumplen los supuestos de normalidad u homocedasticidad. Producto de esto, cuando los datos no cumplen alguno de estos puntos es más apropiado emplear técnicas estadísticas no parámetricas.

# ¿Qué es una relación monotónica? Una variable nunca crece o decrese a medida que otra incrementa, es decir, o siempre incrementa o siempre decrece. Si una variable crece y a la vez decrece según la otra vaya cambiando esto significa que no es una relación monotónica.

# KENDALL
# Al igual que con Spearman, el coeficiente de correlación de Kendall es una técnica de estadística no-paramétrica (no requiere de distribución normal en los datos) y puede ser empleada para datos ordinales o continuos. Mientras Pearson y Spearman determinan la correlación, Kendall calcula la dependencia entre dos variables



# Exercises ---------------------------------------------------------------



data("iris")

attach(iris)

map(
  .x = c("pearson", "spearman", "kendall"),
  .f = ~ cor.test(
    x = Sepal.Length, 
    y = Petal.Length, 
    method = .x)
  ) %>% 
  map(
    .f = ~ .x$estimate
    ) %>% 
  reduce(
    .f = c
    ) %>% 
  as_tibble() %>% 
  mutate(
    Metric = c("cor", "rho", "tau"),
    Corr = c("Pearson", "Spearman", "Kendall")
    ) %>% 
  rename(
    Value = value
  )

# El análisis de Pearson y Spearman arroja valores de correlación muy similares mientras que el de Kendall difiere en mayor medida. Esto es producto de que el test de Kendall corresponde a la medición del grado de dependencia mientras que Pearson y Spearman determinan el grado de asociación. Esto demuestra que, mientras pearson y spearman observan a los datos desde un punto de vista el análisis de kendall observa los mismos datos de otra manera.

# Una mejor situación para el análisis de correlación para spearman o kendall (pero no para pearson) sería si los datos presentarán una variable categórica ordinal (clases tienen un orden)



