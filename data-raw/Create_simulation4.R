if(!require("tidyverse")) install.packages("tidyverse")
if(!require("units")) install.packages("units")
if(!require("sf")) install.packages("sf")
if(!require("maps")) install.packages("maps")
if(!require("readxl")) install.packages("readxl")
if(!require("tibble")) install.packages("tibble")

library(maps)
library(sf)
library(tidyverse)
library(units)
library(readxl)
library(tibble)

cities <- st_as_sf(world.cities, coords = c("long", "lat"), crs = 4326)
capitals <- filter(cities, capital == 1)
capitals <- mutate(capitals, city_country = str_c(name, " (", country.etc, ")"))
head(capitals)
tail(capitals)
nrow(capitals)
capmat<-as.data.frame(capitals)
head(capmat)
capitals <- st_distance(capitals %>% filter(
  country.etc == "USA" | country.etc == "UK" | country.etc == "Turkey" | country.etc == "Indonesia"
))
distance <-set_units(capitals, "km")

r.units = function(x){
  y = as.vector(x)
  dim(y) = dim(x)
  return(y)
}
distance<-r.units(distance)

loc<-capmat %>% filter(
  country.etc == "USA" | country.etc == "UK" | country.etc == "Turkey" | country.etc == "Indonesia"
)
loc<-c(loc$city_country)

colnames(distance)<-loc
rownames(distance)<-loc
simulation4<-as.data.frame(distance)

library(tibble)
simulation4 <- tibble::rownames_to_column(simulation4, "Location")
usethis::use_data(simulation4,compress="xz")
