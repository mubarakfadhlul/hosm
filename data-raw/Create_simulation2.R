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
loc<-capitals[1:5,]
loc<-c(loc$city_country)
distance <- st_distance(slice(capitals, c(1:5)),slice(capitals, c(1:5)))
distance <-set_units(distance, "km")

drop_units <- function(x) {
  class(x) <- setdiff(class(x), "units")
  attr(x, "units") <- NULL
  x
}
distance<-drop_units(distance)

colnames(distance)<-loc
rownames(distance)<-loc
simulation2<-as.data.frame(distance)

library(tibble)
simulation2 <- tibble::rownames_to_column(simulation2, "Location")

usethis::use_data(simulation2,compress="xz")
