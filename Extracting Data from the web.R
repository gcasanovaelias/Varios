# utils ------------------------------------------------------------------

# https://www.rstudio.com/resources/webinars/part-1-easy-ways-to-collect-different-types-of-data-from-the-web-with-r/

# Download a file from the internet

utils::download.file(
  url = "https://www.bcn.cl/obtienearchivo?id=repositorio/10221/10395/2/Aeropuertos.zip",
  destfile = "../aeropuertos.zip"
  )

# zip and unzip data (.zip)

utils::unzip(
  zipfile = "../aeropuertos.zip",
  # Give a list with the names of the files?
  list = F,
  # The directory to extract the files to (created if necessary). By default they are extracted to the directory
  exdir = "..",
  overwrite = T,
  )

utils::zip(
  zipfile = "../aeropuertos2.zip",
  files = c("../Aeropuertos.shx", "../Aeropuertos.shp"),
)

# Delete (unlink) files

base::unlink(
  x = c(
    "../incendios.rar",
    "../aeropuertos.zip",
    "../Aeropuertos.shx")
  )

# APIs --------------------------------------------------------------------

# What is an API? is data that has been pre-packed to be available on the internet.

# An API (Application Programming Interface) are a set of instructions for how a program should interact with a piece of software. In this way, an API acts as an intermediary between computers and computers programs. This interface con be to a database, operational system (OS), software package or (commonly) a web application. This webinar focus on the last type of API with web applications so that they can act as a source of data that can be extracted to R.

# The connection to the internet can be seen as an example of an API architecture where the client computer reaches the server at the other side of the internet for the content of a certain web page. This interaction has to be according to a certain format, in other words, when the web browser connects to the server it has be in a specific way. This way is with and API Protocol named HTTP. HTTP stand for all source of web interfaces.


# HTTP and URL
# The API Protocol used by the web servers is HTTP (HyperText Transfer Protocol). This means the internet is basically based in HyperText (texts that are linked to other pieces of texts and so on). 

# HTTP itself revolves on the idea of URL (Uniform Resource Locator) and is what we universally know as a web address. This adress is the sum of different parts of information (protocol, domain, port, path, query parameters and fragment ID). We can think URLs as file paths to a resource in the internet just as a file path in our own computers. The communication bewtween the client and server in HTTP is through request and responses, which are basically plain text files with a defined message structure (3 parts: initial line, optional headers and optional body).

# In a request the most important part of the HTTP message is the initial line with the HTTP verb that dictates the action that is solicited by the browser. There are multiple verbs but the most important are four: 

# GET: Retrieve whatever is specified by the URL
# POST: Create resource at URL with data in body (attached data included)
# PUT: Update resource at URL with data in body (attached data included)
# DELETE: Remove resource at URL

# httr package
# What we are going to do today is use the httr package (Hadley Wickham, RStudio) to equip R to behave like a web browser so that it can fetch content straight from a web server to R (send HTTP request and receive responses). This resources can be stuff we see in web pages like images, text or actual data that has been put in the internet for us to download.

# To create a request with httr you can use functions that matches the verb names. The argument with the complete URL is preprocessed in the background so that we as R users don't have to worry about dividing this information in different sections.

# What are we going to obtain running the code? We obtain the server response to the request we just made.

library(httr)
library(tidyverse)

r <- httr::GET(url = "http://httpbin.org/get")

# We can modify the request adding different optional components (configuration settings) with functions used as arguments

httr::GET(url = "http://httpbin.org/get", 
          # Name and Giancarlo are the Key and Value, respectively
          httr::add_headers(Name = "Giancarlo"))

# It is frequent that some kind of authentication is needed to accese de API (som servers want to at least know who is accesing the data). This can be done with authenticate()

httr::GET(url = "http://httpbin.org/get", 
          httr::authenticate(user = , password = ))

# Add content with the body and encode arguments. This data is posted on the server so people can access through that URL. This data is an R object (list, data frame, vector) so the web API doesn't know what to do with it. Because of this, we need to transform (encode) the data in a format more common for APIs ("form", "multipart", "raw" and "json")

lista <- list(a = 1, b = 2, c = 3)

httr::POST(url = "http://httpbin.org/post",
           body = lista,
           encode = "json")

# What is JSON? is an acronym for JavaScript Object Notation. It refers to a collection of key:value pairs organized hierarchically in a group (actually becoming standard data format for web APIs)

# If we want to see the actual HTTP request that httr as is sending with the response that we get from the server we specify the verbose() as an argument

httr::GET(url = "http://httpbin.org/get", verbose())

# In the response that we get from the server we identify the same 3 sections as in the request. Similarly, the initial line is the most important with the status code (number, 404: can't be found) and the english explanation (words) of it that indicates if the request has succeded or not.

# Managing responses
# The response we get is similar to the format of a model (a lot of information in a untidy format) so we need to apply helper functions that allows us to acces the information of this response object.

r$status_code

httr::status_code(r) # Extract the http status code

httr::http_status(r) # Extract and convert the status code to readable message

# Program defensively to receive a warning if the status code (make the program check of the status is appropriate or not). 

httr::http_error(r) # check for an http error

httr::warn_for_status(r) # https errors are warned in R

httr::stop_for_status(r) # https errors are converted to R errors

# Access the metadata of the response within the body with headers()

httr::headers(r)$server

# Extract the content from the body with content(). What we will get are the raw bytes sent through the response.

r$content

# Use the argument in the content() helper function to parse through this raw bytes data into the desired output ("raw", "text", "parsed" content) in a list object. This function can parse html, xml, xsv, tsv, json, jpeg, png and forms.

httr::content(x = r, as = "parsed")


# Web Scrapping -----------------------------------------------------------

# rvest is a package design to scrape data from the web through html. While this gives more freedom to the user because you don't have to depend whether the server has prepacked the information to download in a API what you obtain is messy data that takes time to process and put in order.



