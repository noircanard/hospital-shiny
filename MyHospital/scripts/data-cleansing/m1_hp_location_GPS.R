#####################################################################################
#
# The following code merges the data from hospital.csv with the 2016LGA.shp file
# Mapping each Hospital to a LGA
#
#####################################################################################
#
rm(list = ls())




library(rgdal)
library(rgeos)
library(raster)
library(rgdal)
library(spatialEco)
library(sp)
library(maptools)


wd.3 <- "C:/Users/Romanee/Desktop/DataLibrary/MyHospital/processed_csv/2ndEd"
wd.4 <- "C:/Users/Romanee/Desktop/DataLibrary/2016_LGA_shape"
#######################################################################################

list.files()
wd.4 <- "C:/Users/Romanee/Desktop/DataLibrary/2016_LGA_shape"
setwd(wd.4)
LGA_shp <- readOGR(dsn = '.', layer = "LGA_2016_AUST")

setwd(wd.3)

hp <- read.csv("Hospital.csv")
str(hp)

coordinates(hp) <- ~  Long  + Lat 
crs(hp) <- crs(LGA_shp)
pts.poly <- point.in.poly(hp, LGA_shp)
head(pts.poly)
setwd(wd.3)
write.csv(pts.poly, "_hosp_LGA.csv", row.names = F)


