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

# LIST-COLUMNS? NESTED?
{
  # List-columns is a subset of data that is grouped in a single column being able to put models, expressions, functions, visualizations and other types of data inside. List-columns correspond to a way of programming that is memory efficient, safer to apply and easy to understand at a cognitive level. To understand list-columns one need to understand the different types of R data structures (vector, list, data.frames), functions specifically for table management, list management and functional programming.
  
  # In the usual workflow we import-tidy-transform  the data to a nice tibble only to be forgotten once we start with the modelling and the visualizations. This way of working tend to fill the environment with not so important or relevant objects favouring clutter and disorganization.
  
  # Data frames or tibbles can be so much more than just the object in which we locate the data before we analyze it. It can be a framework that helps organize other sections of the workflow cycle such as model-visualize.
  
  # A list is a vector, so you can have a  column in a data frame that is a list. And lists can contain everything in R (data frames, models, graphics, etc).
  
  # Why do this? (1) working with list-columns encourages functional programming, (2) keep things organized, (3) computational and parallelizing advantages. The list-column framework displays the actions and data in a nice row structure where each column makes sense in that each one represents one important step in the analysis, making it easier to manipulate using the tidyverse tools. This workflow with list-columns is useful because it keeps related things together.
  
  # There are different formats of data frames in R such as tidy or widy form but once we work with list-column in the data frame we are using a nested format, ideal to work with functional programming techniques (functions that use a function as an argument to apply it to the object given).
}

# LIST-COLUMNS AND DATA RECTANGLING
{
  # It refers to a special type of data wrangling inside the cells of tables which is strongly influenced by the tidyverse. The rectangle structure gives safety and holistic management to the otherwise disperse, disaggregated and unlinked usual workflow focused on creating objects followed by more objects. Instead of having free ranging objects in the environment it is better to collect them, store and manage them holistically through a functional programming and row-oriented workflow (locking them down in on of the rectangular cells)
  
  # The implementation of list columns allows for rectangling (data wrangling in data tables) whichs tends to store the differents steps of the analysis as columns and has been shown to be a highly productive way of programming. Data rectangling (and every type of wrangling) should be focus on "taking charge of the situation" approach being willing to reshape the data so it gets to the best form possible to face the problem at hand. Finally, lots of our problems would be resolved if only we expand our minds in respect to what is allowed to be in a data frame.
  
  # When working with list-columns in data rectangling is useful to have the different steps that need to be done: (1) INSPECT (what is this? what form does this take in a unnested way), (2) QUERY (extract and inspect each element of a list-column), (3) MODIFY (create more other list-columns) and (4) SIMPLIFY (optional, simplify what would be best to simplify).
}

# THE TAO OF TIDY AND LIST-COLUMNS
{
  # What is the essence of tidy data? Data is not just values, they are values set in a context. There are two types of context; (1) Other values of the same variable (column), and (2) Other values of the same observation (row). This way, tidy data is set in such a way that both of this contexts are easy to see and to access (each variable is set in its own column meanwhile each observation or case is in its own row).
  
  # What does vectorize operations mean? If two vectors are summed (or other arithmetic operation) R is going to maintain the existing rows. This way, because each column is a vector, we can apply functions to it without affecting the rows that are set (preserve the observations).
  
  # What does it mean to use list-columns in tidy data? You can use the existing tidy data system to organize much more than just the values of the data.
}


# LISTS, DATA FRAMES and TIBBLES
{
  # LIST
  # What is a list? A list is a type of data structure that allows to store any type and combination of classes. In the case of a list that can turn into the usual data frame each one of these elements correspond to vectors but as it turns out lists can contain other lists.
  
  # DATA FRAMES
  # What is a data frame? a data frame is just a LIST OF VECTORS that must be of equal length. That is why if you change the class of a data frame to a list it can be done without problem. Each of the columns of the data frame turn to a vector of the list, in this case the Species, Sepal and Petal and everything else are mere vectors in the list as well as in the data frame. This is why list-columns are possible.
  
  # TIBBLES
  # The way to visualize tables with list-columns is organized in the tibbles. If you visualize the same objects as a native data.frame the data is all over the place. Tibbles make it easier to visualize the data in list-columns on a fashionable and organized way. Tibbles make list-columns easy to create and easy to inspect.
}
data("iris")

class(iris) <- "data.frame"

is.vector(iris$Sepal.Length)


class(iris) <- "list"

is.vector(iris[[1]])


tibble(N = 1:4,
       L = LETTERS[1:4],
       list = list(1:3, 1:3, "A", 4))

# TIDYVERSE
{
  # The heart of the tidyverse is a system for manipulating tables and the data inside them. At the heart of this is the dplyr package with the single table verbs (filter, select, mutate, summarise, etc).
  # Other functions that are essential for list-columns are two, both of the tidyr package: nest() and unnest().
  
  # The purrr package brings some excellent functions oriented towards functional programming like map() which are essential in working with list-column. map() serves as the intermediary of the functions that work with the table (table verbs from the dplyr) and the functions that can work with the type of elements that the list-column contains.
}
  
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

paste(n_iris$Species, n_iris$Reino)



# Row-oriented workflows --------------------------------------------------

# Base R is column oriented which implies that as a trade off row-oriented work is harder to implement. In data frames columns represent atomic vectors with the same type of data over all of it's elements. In contrast, rows of the same data frame most likely present different types of data which means that, if extracted, the result is a 1-row data frame, not a vector.

# What's a safe way to iterate over rows over a data frame? This question had a lot of responses in social media, but the answer is quite simple.

# PRO-TIP 1: VECTORIZE FUNCTIONS...
# ...instead of writing your own iterative code
# A surprising number of "iterate over rows" problems can be eliminated by exploiting functions that are already vectorized. With vectorized functions there is no need for the user to iterate by hand because it does it automatically.
# What are vectorized functions? they are functions that, when applied to a vector or pair of them, they iterate and are applied over the different i-position elements that are contained in the vectors. The takeaway is that we as users need to start paying attention to whether the functions that we area applying are vectorized or not, this in turn can bring benefits such as more fluent work, less complications and worry-less state in general.

# For example, the paste() is an example of vectorized function.
paste(n_iris$Species, n_iris$Reino)

# PRO-TIP 2: USE purrr::map() family functions...
# ...specially pmap() for data frames
# Although important, vectorized functions are not always going to be the key player in solving iterations problems because we have to take into account the different types of elements that are contained in a vector and the type of data that the function was implemented to work with.
# One way we can "vectorize" some functions is by applying the map() family functions in the purrr package which become highly relevant in working with list-columns because they can work with the inner elements that are contained inside the list-element present in the unit of the table. This vectorization only works with a list type of data structure because it is the basis in which the map() is constructed.

n_iris %>% pull(data) %>% nrow() #nrow() is expecting a data frame, not a list

n_iris %>% pluck("data") %>% map(.f = nrow)

# If the problem is not resolved with the previous tips (function is truly not vectorized and the situation is not simple enough for map()) we can use pmap() which is a generalized version of map2(). With pmap() we extract the ith element from each list and form a tupple (put them together).

# .l argument refers to a list of list of the same length. This means that a data frame could be put as the .l argument in which the function is applied to each one of the rows (ith elements of the columns). So, pmap() is a fantastic way to do row-based workflow through a whole data frame.

as.list(iris)

# In this example we sum the numeric values BY ROW in the Iris data, actions that is usually applied to a column
iris %>% select(-Species) %>% pmap_dbl(.f = sum)

# Answer: How do we get one list element per row (the ith list contains the ith element of each column that is in the data frame) 
iris %>% pmap(.f = list) %>% tibble(data = .)

# You can also apply the transpose()
iris %>% purrr::transpose() %>% tibble(data = .)

# If instead of a list for each row you want a vector you can use c()
iris %>% pmap(.f = c) %>% tibble(data = .)


# PRO TIP 3: USE group_by() AND summarise() to work with groups
# group_by and summarise() are a couple of functions of the tidyverse that lets you work with the data by applying loops behind the scenes (so you don't have to actively do it).

# Doing more with summarise and list-columns
iris %>% group_by(Species) %>% summarise(
  # Creates a list column of the three values for a single Species (row)
  pl_qtile = list(quantile(Petal.Length, c(0.25, 0.5, 0.75)))) %>% 
  mutate(pl_qtile = map(
    .x = pl_qtile,
    # enframe() turns a list or atomic vector to a data frame (including col names)
    .f = ~ enframe(x = .x, name = "Qtile", value = "length")
  )) %>% unnest(pl_qtile) %>% 
  mutate(Qtile = as.factor(Qtile))
  
# PRO TIP 4: NESTING
# Compared to the splitting approach, nesting keeps the work done in the data frame which gives the advantage that whatever your do in it, it stays. With the split many information is "lost", specially factor and character information and it is due to the "out-of the box" approach needing to be called back into the data.
