# Packages ----------------------------------------------------------------

library(dtplyr)
library(tidyverse)
library(data.table)


# Notes: dplyr and it's backends -------------------------------------------------------------------

# https://dplyr.tidyverse.org/
# https://www.tidyverse.org/blog/2019/11/dtplyr-1-0-0/
# https://dtplyr.tidyverse.org/

# dplyr is a grammar of data manipulation that provides a consistent set of verbs that help to solve the most common data manipulation challenges. As well as the single-table verbs (mutate, select, etc), dplyr also provides a variety of two-table verbs (joins and more).

# In addition to data frames and tibbles, dplyr makes working with other computational backends accessible and efficient. 
#* (1) dtplyr: Translates the dplyr code to high performance data.table code capable of working with LARGE IN-MEMORY datasets.
#* (2) dbplyr: Translates the dplyr code to SQL, programming language that is capable of managing HUGE VOLUMES (TERABYTES) of external (out-of-memory) RELATIONAL DATABASES.
#* (3) sparklyr: For very large datasets stored in Apache Spark.


# dtplyr ------------------------------------------------------------------

# dtplyr provides a data.table backend for dplyr allowing us to write dplyr code that is automatically translated to the equivalent (faster and more efficient memory-wise) data.table code. The idea is that dtplyr gives the speed of data.table with the syntax of dplyr.

data("mtcars")

# "Lazy" data table for a higher performance translation
# Lazy data table: Lazy captures the intent of dplyr verbs only performing computation when requested. This allows dtplyr to convert dplyr verbs into AS FEW data.table expressions as possible, leading to higher performance translation

(mtcars2 <- lazy_dt(mtcars))

# We can use dplyr verbs with this object as if it was a data frame. But there's a big difference behind the scenes: instead of immediately performing the operation, dtplyr just records what we are doing so when needed it can generate a SINGLE AND EFFICIENT data.table statement

mtcars2 %>% 
  filter(wt < 5) %>% 
  mutate(l100k = 235.21 / mpg) %>% 
  group_by(cyl) %>% 
  summarise(l100k = mean(l100k))

# We can preview the transformation (including the generated data.table code) by printing the result. However, this preview should be reserved for exploration and debugging because it only generates the data.table code, it does not run it.

# To apply the translation we use as.data.table(), as.data.frame() or as_tibble() to indicare that you are done writing the transformation and want to access the results

mtcars2 %>% 
  filter(wt < 5) %>% 
  mutate(l100k = 231.21 / mpg) %>% 
  group_by(cyl) %>% 
  summarise(l100k = mean(l100k)) %>%
  as_tibble()


# Performance -------------------------------------------------------------

# data.table is generally faster than dplyr but dtplyr has o do some work to perform the translation, is is worth to use dtplyr? How fast is it? Do the benefits of using data.table outweigh the cost of the automated translation? The experimentation done by Hadley Wickham suggest that dtplyr is worth it: the cost of translation is LOW, and INDEPENDENT of the size of the data.

# The translation cost scales with the complexity of the pipeline (very low, just miliseconds), not the size of the data. This means dtplyr does not impose a significant overhead on top of data.table.

# dtplyr is slightly slower that data.table but ~ 4 to ~ 5x faster than dplyr.


# Copies ------------------------------------------------------------------

# dtplyr matches dplyr semantics (which never modifies in place) by default. This means that most expressions involving mutate() must make a copy that would not be necessary if you were using data.table directly. 

(mtcars2 <- lazy_dt(mtcars))

mtcars2 %>% 
  select(mpg, cyl, disp) %>% 
  mutate(disp = disp * 2) %>% 
  # Show the translation more directly
  show_query()

# However, dtplyr never generates more than one copy no matter how many mutates you use, and it also recognises many situations where data.table creates an implicit copy

# If we can very large datasets, craeting a deep copy can be expensive. dtplyr allows you to opt out by setting immutable = FALSE in lazy_dt() ensuring that dtplyr NEVER makes a copy.

(mtcars2 <- lazy_dt(x = as.data.table(mtcars), 
                    immutable = F))
