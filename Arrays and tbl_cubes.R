# Packages ----------------------------------------------------------------

library(tidyverse)
library(abind)
library(cubelyr)


# Notas -------------------------------------------------------------------

# https://adv-r.hadley.nz/vectors-chap.html

# Along with vectors, matrix, data frames and list, arrays are a type of data structure in R. As with vectors and matrix arrays can only have one type of data but is the only structure that can store n dimensions.

# Attributes
# Attributes are name-value pairs that attach metadata to an object. Individual attributes can be retrieved and modified with attr() or retrieved en masse with attributes() and set en masse with structure().

a <- 1:3

attr(a, "x") <- "abcdef"
attr(a, "y") <- 4:6

attributes(a) %>% str()

# Or what is the same to..
a <- structure(
  1:3,
  x = "abcdefg",
  y = 4:6
)

# Attributes should generally be thought of as ephemeral (most are lost by most operations). There are only 2 attributes that are routinely preserved: 
#* (1) names: character vector giving each element a name
#* (2) dim: short for dimensions, an integer vector, used to turn vectors into matrices or arrays

# To preserve other attributes you'll need to create your own S3 class.

# NAMES
# We can name a vector in three ways:

# When creating it
x <- c(a = 1, b = 2, c = 3)

# By assigning a character vector to names()
x <- 1:3
names(x) <- c("a", "b", "c")

# Inline, with setNames()
x <- setNames(1:3, c("a", "b", "c"))

# We can remove names from a vector by using 
x <- unname(x)


# DIMENSIONS
# along with names, dim is the other important attribute that sticks around in operations. Adding a dim attribute to a vector allows it to behave like a 2-dimensional matrix or a multidimensional array. 

# We can create this type of data structures with matrix(), array() or by using the assignment form of dim(). These data structures are relatively esoteric but they can be useful if you want to arrange objects in a grid-like structure (running models on a spatio-temporal grid).



# matrices
x <- matrix(1:6, nrow = 2, ncol = 3)

# Array: multidimensional data structures.
y <- array(data = 1:18, dim = c(2, 3, 3), 
           dimnames = list(c("rol1", "rol2"), c("col1", "col2", "col3"), c("mat1", "mat2", "mat3")))

y[1,2,3]

# In an array we can use the row index, column index and thematrix level,to access the matrix elements

# We can also modify an object in place by setting dim()
z <- 1:6
dim(z) <- c(3, 2)

# Many of the functions for working with vectors have generalisations for matrices and arrays (dimnames(), dim(), abind::abind(), aperm(), is.array())


# cubelyr package ---------------------------------------------------------

# A cube tbl stores data in a compact array format where dimension anmes are not needlessly repeated. It was created by Hadley Wickam (tidyverse). Some of the dplyr verbs can be applied to an object tbl_cube where:
#* (1) select, pull, mutate and transpose affect the columns (attributes or measures)
#* (2) filter or slices (dimensions)

nasa # Example of a data cube

as.tbl_cube(Titanic)




