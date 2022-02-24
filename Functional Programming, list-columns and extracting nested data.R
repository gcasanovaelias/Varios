# Links -------------------------------------------------------------------

# https://www.youtube.com/watch?v=gme4Fb9JVjk&ab_channel=BryanShalloway

# https://r4ds.had.co.nz/many-models.html

# https://www.rstudio.com/resources/webinars/how-to-work-with-list-columns/

# https://www.rstudio.com/resources/rstudioconf-2018/data-rectangling/

# https://www.rstudio.com/resources/webinars/thinking-inside-the-box-you-can-do-that-inside-a-data-frame/

# https://www.youtube.com/watch?v=rz3_FDVt9eg&ab_channel=PsychologyattheUniversityofEdinburgh

# Packages ----------------------------------------------------------------

library(tidyverse)
library(broom)

# Functional Programming --------------------------------------------------
{
  # Functional Programming (FP) provides a set of tools for reducing duplication in your code. The goal of FP is to make it easy to express repeated actions using high-level verbs. In R we can use the purrr package (belonging to the tidyverse) to develop FP in our code.
  # For loops tend to put too much focus on the objects and not the actions, this tends to put more difficulty in noticing what the code is actually doing. FP does not go to the other extreme but focus on weighting the action and object equally.
  
  # Somewhere deep inside the functions in the purrr package are for loops being implemented. "Of course someone has to write loops, but it doesn't have to be you" - Jenny Bryan.
}
# acumulate() permite ir obteniendo los resultados acumulados tras ir aplicando sucesivamente la función a los valores, el valor anterior se vuelve la nueva base.

purrr::accumulate(.x = 1:10,
                  # .Primitive("-")
                  .f = `-`)

purrr::reduce(.x = 1:15,
              .f = .Primitive("*"),
              # First value to start the accumulation
              .init = 3)

# map(). Existen muchas variaciones de esta función de acuerdo al número de listas o vectores incluidos en .x (map2, pmap), o versiones especializadas que permiten especificar el formato final deseado (map_chr, map_dbl, map_dfr, map_int, etc)

purrr::map(.x = 1:4,
           .f = factorial)


purrr::map2_dbl(.x = 1:100,
                .y = 201:300,
                # `/`
                .f = .Primitive("/"))

# walk(). walk() realiza lo mismo que map() a excepción de que el primero descarta el output obtenido por la función realizada.

purrr::walk(.x = , .f =)

# Parallel map. Similar a map2 pero generalizado, ahora las funciones no son aplicadas a dos grupos de listas sino a n listas especificados en el argumento .l.
purrr::pmap(.l = list(2:7,
                      5:10,
                      100:105,
                      1200:1205),
            .f = sum)



# List-columns ------------------------------------------------------------

# LIST-COLUMNS?
{
  # List-columns is a subset of data that is grouped in a single column being able to put models, expressions, functions, visualizations and other types of data inside. List-columns correspond to a way of programming that is memory efficient, safer to apply and easy to understand at a cognitive level. To understand list-columns one need to understand the different types of R data structures (vector, list, data.frames), functions specifically for table management, list management and functional programming.
  
  # In the usual workflow we import-tidy-transform  the data to a nice tibble only to be forgotten once we start with the modelling and the visualizations. This way of working tend to fill the environment with not so important or relevant objects favouring clutter and disorganization.
  
  # data frames or tibbles can be so much more than just the object in which we locate the data before we analyze it. It can be a framework that helps organize other sections of the workflow cycle such as model-visualize.
  
  # Why do this? (1) working with list-columns encourages functional programming, (2) keep things organized, (3) computational and parallelizing advantages. The list-column framework displays the actions and data in a nice row structure where each column makes sense in that each one represents one important step in the analysis, making it easier to manipulate using the tidyverse tools.
  
}

# THE TAO OF TIDY AND LIST-COLUMNS
{
  # What is the essence of tidy data? Data is not just values, they are values set in a context. There are two types of context; (1) Other values of the same variable (column), and (2) Other values of the same observation (row). This way, tidy data is set in such a way that both of this contexts are easy to see and to access (each variable is set in its own column meanwhile each observation or case is in its own row).
  
  # What does vectorize operations mean? If two vectors are summed (or other arithmetic operation) R is going to maintain the existing rows. This way, because each column is a vector, we can apply functions to it without affecting the rows that are set (preserve the observations).
  
  # What does it mean to use list-columns in tidy data? You can use the existing tidy data system to organize much more than just the values of the data.
}


# DATA FRAMES
# What is a data frame? a data frame is just a LIST OF VECTORS that must be of equal length. That is why if you change the class of a data frame to a list it can be done without problem. Each of the columns of the data frame turn to a vector of the list, in this case the Species, Sepal and Petal and eveything else are mere vectors in the list as well as in the data frame. This is why list-columns are possible.

data("iris")

class(iris) <- "data.frame"

is.vector(iris$Sepal.Length)

# LIST
# What is a list? A list is a type of data structure that allows to store any type and combination of classes. In the case od a list that can turn into the usual data frame each one of these elements correspond to vectors but as it turns out lists can contain other lists.

class(iris) <- "list"

is.vector(iris[[1]])

# TIBBLES
# The way to visualize tables with list-columns is organized in the tibbles. If you visualize the same objects as a native data.frame the data is all over the place. Tibbles make it easier to visualize the data in list-columns ons a fashionable and organized way. Tibbles make list-columns easy to create and easy to inspect.

tibble(N = 1:4,
       L = LETTERS[1:4],
       list = list(1:3, 1:3, "A", 4))

# TIDYVERSE
# The heart of the tidyverse is a system for manipulating tables and the data inside them. At the heart of this is the dplyr package with the single table verbs (filter, select, mutate, summarise, etc).
# Other functions that are essential for list-columns are two, both of the tidyr package: nest() and unnest(). 

# The purrr package brings some excelent functions oriented towards functional programming like map() which are essential in working with list-column they serve as the intermediary of the functions that work with the table (table verbs from the dplyr) and the functions that can work with the type of elements that the list-column contains.

# NEST
{
  n_iris <- iris %>%
    mutate(Reino = c(rep("Plantae", 75),
                     rep("Animalia", 75))) %>%
    group_by(Reino, Species) %>%
    nest() %>%
    # Adding models data
    mutate(
      model = map(.x = data, .f = ~ lm(Sepal.Length ~ ., data = .x)),
      model.tidy = map(.x = model,
                       .f = tidy,
                       conf.int = T),
      model.glance = map(.x = model, .f = glance),
      model.augment = map(
        .x = model,
        .f = augment,
        se_fit = T,
        interval = "confidence"
      )
    ) %>%
    # Adding visualizations
    mutate(visualization = pmap(
      .l = list(data, Species, Reino),
      .f = ~ ggplot(data = .x, aes(x = Petal.Width, y = Sepal.Length)) +
        geom_point() +
        labs(title = "Sepal Length vs Petal Width",
             subtitle = paste(Species, Reino)) +
        theme_bw()
    ))
}

# Graphs

n_iris %>% pluck("visualization")

# Save data

saveRDS(object = n_iris, file = "n_iris.rds")


# Managing nested data ----------------------------------------------------

# purrr::pluck() allows to access to the nested data through position or string name accessors for indexing. This function is essential working with list-columns because allows to do multiple extractions (different from dplyr::pull()).

n_iris %>% pluck(
  # list-column (list) 
  "data", 
  # 3rd element of the list-column as a tibble
  3, 
  # Vector
  "Sepal.Length")

n_iris$data[[1]]$Petal.Length
# is the same as
n_iris %>% pluck("data", 1, "Petal.Length")

# TURN NESTED DATA INTO A COLUMN

n_iris %>% 
  mutate(
    r.squared = map_dbl(
      .x = model.glance,
      .f = ~ pluck(.x, "r.squared")
    ),
    estimate.SW = map_dbl(
      .x = model,
      # We can also avoid creating extra columns by applying them directly in the pluck()
      .f = ~ pluck(tidy(.x), "estimate", 2)
    )
  ) %>% select(r.squared, estimate.SW)


# WHAT DOES THIS MEAN?
{
  # The list-column with the tibbles as a unique element of a list
  n_iris$data
  
  # The first element of the list-column, so one list with an unique tibble
  n_iris$data[1]
  
  # The unique element of the first list in the list-column, so a tibble
  n_iris$data[[1]]
  
  # The vector
  n_iris$data[[1]]$Petal.Length
}





