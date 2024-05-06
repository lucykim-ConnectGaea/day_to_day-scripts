library(terra)
library(sf)
library(ggplot2)
library(raster)
library(maptiles)
library(leaflet)


#input dir
iDir <-  'C:\\Users\\Lucy Kimani\\lucy\\Projects\\my_projects\\rprojects\\Meru\\Data'
# List files in the current working directory
files <- list.files()

#read the shp files

datadir <- file.path(iDir, "meru_sampling_sites_locations")


samplePoints_path <- file.path(datadir, "meru_sampling_sites_locations.shp")
samplePoints <- st_read(samplePoints_path)
plot(samplePoints)

keSublocations_path <- file.path(datadir, "Ken_Sublocations.shp")
keSublocations <- st_read(keSublocations_path)
keSublocations <- vect(keSublocations)
plot(keSublocations)

keCounties_path <- file.path(datadir, "gadm41_KEN_1.shp")
keCounties <- st_read(keCounties_path)
counties <- vect(keCounties)
counties
plot(counties, "NAME_1")




#select by attribute and export as a shp
counties$NAME_1
#Find the index of rows where NAME_1 is 'Meru'
meruCounty <- which(counties$NAME_1 == 'Meru')
#Subset the keCounties data frame for Meru County
meru <- counties[meruCounty,]
meru
plot(meru)

#crop ke sublocations to meru
meruSub <- intersect(meru, keSublocations)
plot(meruSub)

#writmeru#write as shp
outfile <- file.path(datadir,"meru_subcounties.shp")
writeVector(meru, outfile, overwrite=TRUE)

#read tif

livestockprod <- file.path(iDir, "Archive_1")
lps <- list.files(livestockprod, pattern = '.tif$', full.names = T)
lps <- rast(lps)
lps

plot(lps)
lines(meruSub, lwd=2)
points(samplePoints,pch = 20, col="red", cex=1)

bg <- get_tiles(ext(meruSub))
plotRGB(bg)
lines(meruSub, col="blue", lwd=3)

m <- plet(meruSub)
m <- addRasterImage(m, lps, opacity = 0.7)
m <- addCircleMarkers(m, data = samplePoints, radius = 5, color = "red", fill = TRUE, fillOpacity = 0.8)

m


