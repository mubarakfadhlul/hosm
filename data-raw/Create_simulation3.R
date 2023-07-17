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
loc<-capitals[226:230,]
loc<-c(loc$city_country)
distance <- st_distance(slice(capitals, c(226:230)),slice(capitals, c(226:230)))
distance <-set_units(distance, "km")

drop_units <- function(x) {
  class(x) <- setdiff(class(x), "units")
  attr(x, "units") <- NULL
  x
}
distance<-drop_units(distance)

colnames(distance)<-loc
rownames(distance)<-loc
simulation3<-as.data.frame(distance)

library(tibble)
simulation3 <- tibble::rownames_to_column(simulation3, "Location")

usethis::use_data(simulation3,compress="xz")
