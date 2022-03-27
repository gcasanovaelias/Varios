# Packages ----------------------------------------------------------------

library(tidyverse)

# We don't need to load dbplyr. dplyr does this automatically when it notices we are working with a database


# SQL, Python and R together ----------------------------------------------

# https://www.youtube.com/watch?v=rtixRiDxbwc&ab_channel=Sisense

# SQL vs Python/R: They are different tools that are focused on different problems. In this sense we can use this programming languages in different stages of the data analysis.

# SQL is a BLUNT INSTRUMENT that is really good at the heavy lifting (managing BILLION of rows)
# Python or R are more REFINED tools, is not for heavy lifting. Stat analysis, feature engineering, visualizations.

# Summary: Maybe start with SQL to do the heavy lifting, modelling data with Python/R

# Notes -------------------------------------------------------------------

# Links:
# https://dbplyr.tidyverse.org/
# https://dbplyr.tidyverse.org/articles/sql.html
# https://dbplyr.tidyverse.org/articles/dbplyr.html

# As well as working with local in-memory data stored in data frames dplyr also works with remote on-disk data stored in databases. This is particularly useful in two scenarios:
#* (1) Your data is already in a database.
#* (2) You have so much data that it does not all fit into memory simultaneously and you need to use some EXTERNAL STORAGE ENGINE.

# The first scenario is the most common. If we are using R to do data analysis inside a company, most of the data you need probably already lives in a database

# Important: If your data fits in the memory of your computer there is no advantage to putting it in a database: it will only be slower and more frustrating.

# dbplyr is the database backend for dplyr. It allows the use of remote (external, non-local) database tables as if they are in-memory data frames by automatically converting dplyr code into SQL. dbplyr is designed to work with database tables as if they are local data frames


# DBI backend package -----------------------------------------------------

# The DBI package is needed. This package provides a common interface that allows dplyr to work with many different databases using the same code. DBI is automatically installed with dbplyr but we will need to install a specific backend for the database that we want to connect to.

# The five more commonly backends are:
#*(1) RMariaDB: Connects to MySQL and Maria DB
#*(2) RPostgres: Connects to Postgres and Redshift
#*(3) RSQLite: Embeds a SQLite database
#*(4) odbc: Connects to many commercial databases via the open database connectivity protocol
#*(5) bigrquery: connects to Google's BigQuery

# SQLite is surprisingly powerful and with little practice you can use it to easily with with many gigabytes of data.


# SQL ---------------------------------------------------------------------

# To interact with a database you usually use SQL, the "Structured Query Language". SQL is a standardized programming language that is used to manage relational databases (data with pre-defined relationships organized as a set of tables) and perform various operations on the data in them. SQL is over 40 years old and is used by pretty much EVERY database in existence.

# SQL is used for:
#* modifying database table and index structures
#* adding, updating and deleting rows of data
#* retrieving subsets of information from within the relational database 

# This way, SQL is fundamentally a programming language designed for accessing, modifying and extracting information from relational databases. As a programming language, SQL has commands and a syntax for issuing those commands.

# Relational? relational databases are relational because they are composed of tables that relate to each other. For example, a SQL database used for customer service can have one table for customer names and addresses and other tables that hold information about specific purchases, product codes and customer contacts.

# The goal of dbplyr is to automatically generate SQL for you so that you are not forced to use it. However, SQL is a very large language and dbplyr does not do everything. It focuses on SELECT statements (the SQL you write most often as an analyst). The result? MOst of the time we don't need to know anything about SQL and we can continue to use dplyr verbs that we are already familiar with.

# However, in the long-run, Hadley highly recommends that at least we learn the basics of SQL. It's a valuable skill for any data scientist and it will help us to debug problems if we run into problems with the automatic translation.

# Some material to study SQL:
#*  https://www.codecademy.com/learn/learn-sql
#*  https://www.sqlite.org/queryplanner.html
#*  https://blog.jooq.org/10-easy-steps-to-a-complete-understanding-of-sql/

# What is the most important difference between ordinary data frames and remote databases queries? The R code is translated into SQL and executed in the database ON the remote server, NOT IN YOUR LOCAL MACHINE.


# Database ----------------------------------------------------------------

# https://www.techtarget.com/searchdatamanagement/definition/SQL

# A table is the most basic unit of a database and consists of rows and columns of data. A single table holds records, and each record is stored in a row of the table. Each column in a table corresponds to a category of data while each row contains a data value for the intersecting column. Tables are the most used type of database objects, or structures that hold or reference data in a relational database.

# Other types of database objects are:
#*  Views: logical representations of data assembled from one or more database tables
#*  Indexes: lookup tables that help speed up database lookup functions
#*  Reports: Consists of data retrieved from one or more tables, usually a subset of the data that is selected based on search criteria


# Why external databases? -------------------------------------------------

# The information that is usually stored in databases are large amounts of data. Excel, text or csv files are not well suited for this amount of information because they manage pretty "small" datasets (~ 1 million row limit).

# On the other hand, the SQL server for databases can have much greater capacity for handling enormous volumes of data (520 thousand terabytes).

# SQL queries -------------------------------------------------------------------

# https://support.microsoft.com/en-us/office/introduction-to-queries-a9739a09-d3ff-4f36-8ac3-5760249fb65c

# SQL queries and other operations take the form of commands written as statements

# A query is defined in the dictionary as a question. In a database context a query can either be a request for data results from your database or for action on the data, or both. A query can give us an answer to a simple question, perform calculations, combine data from different tables, add, change or delete data from a database.

# dbplyr ------------------------------------------------------------------

# To work with a database in dplyr we must first connect to it

# Connect to a DBMS
(con <- DBI::dbConnect(drv = RSQLite::SQLite(), dbname = ":memory:"))

# SQLite only needs one other argument aside from the database backend: the path to the database. Most existing databases don't live in a file but instead live on another server, That means in real-life the code will look more like this:

DBI::dbConnect(RMariaDB::MariaDB(),
               host = "database.rstudio.com",
               user = "hadley",
               password = rstudioapi::askForPassword("Database password"))

# The temporary database has no data in it so we'll need to start by copying over some data with copy_to():Uploads a local data frame to a remote data source.
copy_to(dest = con, df = mtcars)

# Retrieve or reference the data using tbl(). It looks like a tibble with the main difference that it's indicated that it posses a remote source in a SQLite database
(mtcars2 <- tbl(con, "mtcars"))

# All dplyr calls are evaluated lazily, generating SQL that is only sent to the database when you request the data

# Generate the query (lazily)
(
  summary <- mtcars2 %>% 
    group_by(cyl) %>% 
    summarise(mpg = mean(mpg, na.rm = T)) %>% 
    arrange(desc(mpg))
)

# See query
summary %>% show_query()

# Execute query and retrieve results (pull all the data down into a local tibble)
summary %>% collect()


# Flights database --------------------------------------------------------

# Connect to a database
(con <- DBI::dbConnect(drv = RSQLite::SQLite(), dbname = ":memory:"))

# Copy (upload) data to the empty database
copy_to(dest = con, df = nycflights13::flights, "flights",
        temporary = F,
        # Supply indexes for the table
        indexes = list(
          c("year", "month", "day", "carrier", "tailnum", "dest")
        ))

# Reference the data
(flights_db <- tbl(
  # Database
  con, 
  # Name of the desired table in the database
  "flights"))

# Querys
flights_db %>% select(year:day, dep_delay, arr_delay) %>% 
  # See the SQL that is being generated
  show_query()

flights_db %>% filter(dep_delay > 240) %>% show_query()

flights_db %>% group_by(dest) %>% 
  summarise(delay = mean(dep_time)) %>% show_query()

(tailnum_delay_db <- flights_db %>% 
    group_by(tailnum) %>% 
    summarise(delay = mean(arr_delay),
              n = n()) %>% 
    arrange(desc(delay)) %>% 
    filter(n > 100))

tailnum_delay_db %>% show_query()

# Pull the data down into a local tibble
(tailnum_delay <- tailnum_delay_db %>% collect())

# How does the database plans to execute the query?
tailnum_delay_db %>% explain()

# Why use dbplyr instead of writing SQL ourselfs? -------------------------

(mf <- memdb_frame(x = 1, y = 2))

# One simple nicety of dplyr is thata it will automatically generate subqueries if you want to use a freshly created variable in mutate()

mf %>% 
  mutate(
    a = y *x,
    b = a ^ 2
  ) %>% 
  show_query()

# In general, it´s much easier to work iteratively in dbplyr. You can easily give intermediate queries names, and reuse them in multiple places.

# What happens when dbplyr fails? -----------------------------------------

# dbplyr aims to translate the most common R functions to their SQL equivalents, allowing us to ignore the vagaries of the SQL dialect and we can focus on the data analysis problem at hand. But, different backends have different capabilities, and sometimes there are SQL functions that don't have exact equivalents in R. In those cases we will need to write SQL code directly. This sections shows you how you can do so.

# Because SQL functions are general case insensitive, Wickham recommends using UPPER CASE when we are using SQL functions in R code making it easier to spot that we are inserting something "unusual" in the code.

# dbplyr translates prefix functions (where the name of the function comes before the arguments) and infix functions (allowing the use of expressions like LIKE which does a limited form of pattern matching)

# Prefix functions
mf %>% 
  mutate(z = FOOFIFY(x, y)) %>% 
  show_query()

# Infix functions
mf %>% 
  filter(x %LIKE% "%foo%") %>% 
  show_query()

# Or use || for string concatenation (backends should translate paste() and paste0())

mf %>% 
  transmute(z = x %||% y) %>% 
  show_query()

# Special forms
# SQL functions tend to have a greater variety of syntax than R meaning that there are a number of expressions that can't be translated directly from R code. To insert these in our own queries we can use litera SQL inside sql()
mf %>% 
  transmute(factorial = sql("x!")) %>% 
  show_query()

mf %>% 
  transmute(factorial = sql("CAST(x AS FLOAT)")) %>% 
  show_query()

# We can use sql() at any depth inside the expression
mf %>% 
  filter(x == sql("ANY VALUES(1, 2, 3)")) %>% 
  show_query()


# Different types of databases -----------------------------------------------

# There are SQL databases and noSQL ones. The first ones refer to relational databases that are tabulated in a usually table format while the later one stands for Not-Only SQL meaning that it can also store data in the database that is not tabulated.

# All relational databases use the same SQL syntax and we can transfer our knowledge between them.

# SQLite is by far the easiest to get started with. PostgreSQL is a considerably more powerful database than SQLite. It has a much wider range of built-in functions, and is generally a more featureful database.

# MySQL and MariaDB are the ones we should not bother with learning: they are a pain to set up, the documentation is subpar and has limited features compared to the other ones. Google BisQuery might be a good fit if you have a very large data or if we are willing to pay a small amount of money.

# All these databases follow a client-server model: a computer that connects to the database and the computer that is running the database (the two may be one and the same but it usually is not).
