# Apuntes -----------------------------------------------------------------
# La linealidad en los modelos se refiere a que en la conformación de su ecuación estas presenten una constante o una serie de parámetros únicos acompalando a las variables explicativas. Cuando se cumpla esta condición estaremos hablando de modelos lineales mientras que en cualquier caso que la linealidad no se cumpla se estará frente a modelos no lineales. De esta manera, mientras los modelos lineales son capaces de ser resueltos mediante ecuaciones lineales esto no se cumple para los modelos no lineales.

# Otra gran diferencia es que los modelos lineales SI pueden presentar curvaturas al incorporar comportamientos exponenciales, logaritmicos y cuadráticos, siempre y cuando se siga respetando la linealidad de la ecuación (que una estimación de parámetro este multiplicando una variable). 

# Las regresiones no lineales son mucho más versátiles pero a la vez más complejas de interpretar en comparación a las lineales, siendo mayormente susceptibles a la sobreparametrización. De este modo, el curso de acción debiese ser intentar ajustar el modelo bajo una regresión lineal y, si no se llega a un resultado aceptable o no se cumplen los supuestos de normalidad y homocedasticidad, se procede a ajustar un modelo no-lineal.

# Junto con la complejidad en su interpretación los modelos no-lineales tambien presentan la desventaja de que ciertas métricas como el R2 y el p-value no son aplicables a este tipo de regresiones. R2 supone linealidad en el modelo para calcular el % de variabilidad producto de este pero la relación no es válida (sobrepasa los límites de 0 y 1). En este sentido, la métrica de GOF más adecuada sería la distancia media absoluta (S) entre las observaciones y predichos. Por otro lado, p-value no es aplicable a modelos no-lineales producto de que, mientras que los modelos lineales presentan una estructura tipo y predeterminada(lo que permite que si el valor del parámetro es 0 la influencia de la variable se anula), esto no ocurre en los modelos no-lineales afectando la construcción de las hipótesis respectivas.

# Hace 50 años las regresiones no-lineales podían resolverse mediante las llamadas linealizaciones en donde el modelo y sus variables eran transformados a un modelo lineal para su resolución y definición de parámetros mediante relaciones matemáticas y algebraicas (logaritmos, exponentes, inversos, etc). Actualmente, este curso de acción no resulta óptimo ya que (1) se posee el poder de computo suficiente para resolver estas ecuaciones, (2) esta transformación altera los datos y los parámetros obtenidos (una transformación logaritmica provoica que algunas obsrevaciones presenten mayor peso que otras) y (3) posterior a esta linealización es que se deben re-transformar las variables de interés para la predicción así como para el análisis descriptivo.


# Video 1 -----------------------------------------------------------------
# https://www.youtube.com/watch?v=zTMZc7jooVo


# Paquetes

library(NISTnls)
library(gslnls)

# Ejercicio 1

datos <- tibble(
  x = c(7.6, 8.8, 10, 11, 11.6, 13, 16.5, 17, 18, 21.5, 22.6, 22.8, 23, 23.5, 25, 25, 25.5, 27.2),
  y = c(1.68, 4.2, 1.68, 4.5, 3.8, 8, 5.61, 10, 5.61, 20, 9, 14.5, 11.4, 13.5, 11, 9.5, 12, 13.5)
)

mod1 <- gslnls::gsl_nls(
  fn = y ~ b0 * (x ^ b1),
  data = datos,
  start = c(b0 = 5, b1 = 0.01)
)

# Tambien se puede emplear la función base de R
# mod1 <-
#   nls(
#     formula = y ~ b0 * (x ^ b1),
#     data = datos,
#     # Valores iniciales de los parámetros del modelo (vector o lista)
#     start = c(b0 = 5, b1 = 0.01)
#   )

summary(mod1)

tidy(mod1)

ggplot(data = datos, aes(x = x, y = y)) +
  geom_point() +
  stat_smooth(
    method = "nls",
    formula = y ~ b0 * (x ^ b1),
    # Lista de argumentos adicionales
    method.args = list(start = c(b0 = 5, b1 = 0.01)),
    se = F
  )

# Ejercicio 2

mod2 <- gslnls::gsl_nls(
  fn = y ~ b0 * exp(-exp(b1 - b2 * x)), 
  data = datos,
  start = c(b0 = 500, b1 = 0.01, b2 = 0.1)
)

broom::tidy(mod2)

ggplot(data = datos, aes(x = x, y = y)) +
  geom_point() +
  stat_smooth(
    method = "nls",
    formula = y ~ b0 * exp(-exp(b1 - b2 * x)),
    # Lista de argumentos adicionales.
    method.args = list(start = c(b0 = 500, b1 = 0.01, b2 = 0.1)),
    se = F
  )

# Video 2 -----------------------------------------------------------------

# https://www.youtube.com/watch?v=u-rVXhsFyxo&ab_channel=DataScienceAnalytics

library(tidyverse)
library(ISLR) # Paquete de orientado al aprendizaje estadístico en R

data(Wage)

attach(Wage)

str(Wage)

# Polynomial regression (modelo de regresión lineal múltiple)

fit <- lm(wage ~ poly(x = age, 
                      # Se crea un set de datos desde un 
                      degree = 4, 
                      # Para que sean polinomios ortogonales
                      raw = F))

# Visualización

ggplot(data = Wage, aes(x = age, y = wage)) +
  geom_point(alpha = 0.1) +
  # Agregar línea de tendencia
  stat_smooth(method = "lm",
              # Le estamos agregando un comportamiento cuadrático a "x" sin necesidad de cambiar los valores del eje
              formula = y ~ poly(x,4),
              # Display confidence interval?
              se = T) +
  theme_minimal()

# Polynomial logistic regression (modelo de regresión linear generalizado)

# We distinguish between the "big earners" (<250) as 1, else 0

fit <- glm(
  # "y" ahora es un booleano, es tratado como 1 o 0 según una condición
  I(wage > 250) ~ poly(age, 3),
  data = Wage,
  # Distribución binomial
  family = binomial)

summary(fit)


# Video 3 -----------------------------------------------------------------

# https://www.youtube.com/watch?v=Vps_q3UUDJQ&ab_channel=wildvineyard

library(mosaic)
library(broom)

isotherm <- tibble(
  Cw = c(5, 20, 30, 41, 52, 138, 265, 414),
  Cs = c(15735, 40651, 56071, 65628, 72825, 145089, 247605, 323551)
)

attach(isotherm)

# Exercise 1: Fitting a linear model using nls()

iso.lm <- nls(formula = Cs ~ A * Cw + B) # Los parámetros iniciales son 1 por default

ggplot(data = isotherm, aes(x = Cw, y = Cs)) +
  geom_point() +
  stat_smooth(method = "lm", se = F)

broom::tidy(iso.lm)
broom::glance(iso.lm)

isotherm_augment <- broom::augment(iso.lm) # nls() no permite que se calculen la totalidad de métricas en comparación a las obtenidas en lm()
attach(isotherm_augment)

RMSE(pred = .fitted, obs = Cw)

# Exercise 2: Fitting a (Freundlich) non-linear model using nls()

iso.F <-
  nls(
    formula = Cs ~ KF * (Cw ^ n),
    data = isotherm,
    # Valores iniciales de los parámetros del modelo (vector o lista)
    start = c(KF = 5000, n = 0.7)
  )

broom.mixed::tidy(iso.F)
broom.mixed::glance(iso.F)
iso.F_augment <- broom.mixed::augment(iso.F)

ggplot(data = iso.F_augment, aes(x = Cw, y = Cs)) + 
  geom_point() +
  stat_smooth(method = "nls",
              formula = Cs ~ KF * (Cw ^ n),
              se = F,
              mapping = aes(y = .fitted),
              method.args = list(start = list(KF = 5000, n = 0.7)))
              
              

# Exercise 3: Fitting a Langmuir non-linear model using nls()

iso.L <- nls(
  formula = Cs ~ ((G * KL * Cw) / (1 + KL * Cw)),
  data = isotherm,
  start = list(G = 100000, KL = 0.05)
)

tidy(iso.L)
glance(iso.L)
augment(iso.L)

ggplot(data = isotherm, aes(x = Cw, y = Cs)) +
  geom_point() +
  stat_smooth(method = "nls",
              formula = Cs ~ ((G * KL * Cw) / (1 + KL * Cw)),
              method.args = list(start = list(G = 100000, KL = 0.05)),
              se = F)


# Video 4 -----------------------------------------------------------------

# https://www.youtube.com/watch?v=CwBldkG30Io&ab_channel=TLeao
# Fits the van Genuchten (1980) equation to water retention data (curva caracteristica)

datos <-
  tibble(
    h = c(10, 20, 40, 60, 80, 100, 300, 500, 800, 1000, 3000, 5000, 10000, 15000),
    theta = c(0.5, 0.49, 0.489, 0.480, 0.45, 0.4, 0.35, 0.299, 0.28, 0.25, 0.249, 0.245, 0.24, 0.239)
  ) %>% 
  # Transformar a logaritmo
  mutate(lh = log(h))

attach(datos)

# Modelo

fit <- nls(
  formula = theta ~ qr + (qs - qr) / (1 + (alpha * h) ^ n) ^ (1 - 1 / n),
  data = datos,
  start = list(
    qs = 0.5,
    qr = 0.2,
    alpha = .01,
    n = 2
  )
)

tidy(fit)
glance(fit)

datos_augment <- augment(fit)

# Plot

ggplot(data = datos, aes(x = lh, y = theta)) +
  geom_point() +
  # geom_line(aes(y = predict(fit), x = lh))
  # Crear una linea a partir de la posición de los puntos predichos
  geom_line(data = datos_augment, aes(y = .fitted), color = "steelblue")


ggplot(data = datos_augment, aes(x = log(h), y = theta)) +
  geom_point() +
  stat_smooth(
    method = "nls",
    formula = theta ~ qr + (qs - qr) / (1 + (alpha * h) ^ n) ^ (1 - 1 / n),
    se = F,
    mapping = aes(y = .fitted, x = log(h)),
    method.args = list(start = list(
      qs = 0.5,
      qr = 0.2,
      alpha = .01,
      n = 2
    ))
  )
              
  
# geom_line(aes(y = predict(object = fit, newdata = lh)))
 
# plot(theta ~ lh)
# lines(predict(fit) ~ lh)


# Self-starting Nonlinear Models ------------------------------------------

# Construit un modelo no-lineal con partida automática para ser usado en la función nls. Se obtienen valores de parámetros aproximados desde los datos, los modelos resultantes no requieren del argumento start en nls().

stats::selfStart()

stats::getInitial()
