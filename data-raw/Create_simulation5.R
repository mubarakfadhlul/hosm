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
country.gt <- mutate(cities, city_country = str_c(name, " (", country.etc, ")"))
head(country.gt)
tail(country.gt)
nrow(country.gt)
capmat<-as.data.frame(country.gt)
head(capmat)
center.gt <- st_distance(country.gt %>% filter(
  city_country == "Banda Aceh (Indonesia)" | city_country == "Edison (USA)" | city_country == "Hakkari (Turkey)" | city_country == "London (UK)"
))
distance.gt <-set_units(center.gt, "km")


r.units = function(x){
  y = as.vector(x)
  dim(y) = dim(x)
  return(y)
}
distance.gt<-r.units(distance.gt)

loc<-capmat %>% filter(
  city_country == "Banda Aceh (Indonesia)" | city_country == "Edison (USA)" | city_country == "Hakkari (Turkey)" | city_country == "London (UK)"
)
loc<-c(loc$city_country)

colnames(distance.gt)<-loc
rownames(distance.gt)<-loc
simulation5<-as.data.frame(distance.gt)

library(tibble)
simulation5 <- tibble::rownames_to_column(simulation5, "Location")
usethis::use_data(simulation5,compress="xz")
