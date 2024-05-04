rm(list = ls(all = TRUE))

library(raster)
library(rgdal)


iDir <- "C:\\Users\\Lucy Kimani\\OneDrive - CGIAR\\Lucy\\relative_humidity"
oDir <- "C:\\Users\\Lucy Kimani\\OneDrive - CGIAR\\Lucy\\climatemapping"

shp = shapefile("C:\\Users\\Lucy Kimani\\OneDrive - CGIAR\\climate risk Mapping 2022\\Data\\shapefiles\\gadm41_SEN_shp\\gadm41_SEN_0.shp")

rastLs <- list.files(iDir, pattern = '.tif$', full.names = T)

country <- c("Senegal")

for (j in rastLs){
  
  img <- raster(j)
  
  for (i in 1:length(country)){
    
    filtered = shp[match(toupper(country[i]),toupper(shp$COUNTRY)),]
    
    name <- filtered$COUNTRY
    
    oDir <- paste0(iDir, "/output/", name, sep = "")
    
    if (!file.exists(oDir)) {
      dir.create(oDir, recursive = T)
    }
    
    img_clipped <- mask(crop(img, filtered), filtered)
    
    writeRaster(img_clipped, filename = paste0(oDir, "/", name, "_", names(img)), format = "GTiff", overwrite = TRUE)
    
    
    
  }
  
  
}
