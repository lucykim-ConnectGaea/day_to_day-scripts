
library(raster)
library(rgdal)
library(rasterVis)
library(RColorBrewer)

iDir <- "D:\\OneDrive - CGIAR\\ZA_suitability"
aoi_mask <- readOGR("D:\\OneDrive - CGIAR\\ZA_suitability\\Admin\\admin0.shp")
admin <- readOGR("D:\\OneDrive - CGIAR\\ZA_suitability\\Admin\\admin1.shp")
cropList <- c("avena_sativa", 
              "brachiaria_mulato2", 
              "brachiaria_brizantha", 
              "brachiaria_decumbens", 
              "brachiaria_ruziziensis",
              "cajanus_cajan",
              "chloris_gayana",
              "desmodium_intortum",
              "desmodium_uncinatum",
              "lablab_purpureus",
              "leucaena_diversifolia",
              "leucaena_pallida",
              "macrotyloma_axillare",
              "medicago_sativa",
              "panicum_coloratum",
              "paspalum_dilatatum",
              "pennisetum_clandestinum",
              "pennisetum_purpureum_schumach",
              "stylosanthes_guanensis",
              "tripsacum_andersonii",
              "vicia_villosa")
periodList <- c("csuit", "fsuit")

for (crop in cropList){
  
  oDir <- paste0(iDir, "/plots/", sep="")
  if (!file.exists(oDir)) {dir.create(oDir, recursive=T)}
  
  for (period in periodList){
    
    if(!file.exists(paste0(oDir, crop, "_", period, ".tif", sep=""))){
      
      suitRas <- raster(paste0(iDir, "/ZA_", crop, "_", period, ".tif"))
      
      
      suitRas <- projectRaster(suitRas, crs = "+proj=longlat +datum=WGS84 +no_defs")
      
      suitRas <- mask(crop(suitRas, extent(aoi_mask)), aoi_mask)
      
      suit_class <- function(x){
        ifelse(x <= 0.25, 1,
               ifelse(x > 0.25 & x <= 0.5, 2, 
                      ifelse(x > 0.5 & x <= 0.75, 3, 
                             ifelse(x > 0.75 & x <= 0.9, 4, 
                                    ifelse(x > 0.9, 5, NA)))))
      }
      
      suitRas <- calc(suitRas , suit_class)
      
      #Plot settings%
      plot <- setZ(suitRas, c("suitability"))
      names(plot) <- c("suitability")
      zvalues <- seq(0, 5, 1)
      myColorkey <- list(at=zvalues, 
                         space = "bottom", 
                         height=0.95, 
                         width=1.5, 
                         labels=list(at=zvalues+0.5,
                                     labels=c("Very Low", "Low", "Medium", "High", "Very High"), cex=0.8, fontfamily="serif", font=1))
      
      
      myTheme <- BuRdTheme()
      myTheme$regions$col=colorRampPalette(brewer.pal(3, "RdYlGn"))(length(zvalues)-1)
      myTheme$strip.border$col = "transparent"
      myTheme$axis.line$col = "black"
      stripParams <- list(cex=0.8, lines=1, col="black", fontfamily='serif', font=2)
      
      #plot via levelplot
      tiff(paste(oDir, crop, "_", period, ".tif", sep=""), width=800, height=800, pointsize=12, compression='lzw', res=150)
      print(levelplot(plot,
                      at = zvalues,
                      scales = list(draw=FALSE),
                      xlab="",
                      ylab="",
                      xlim=c(xmin(suitRas)-0.2, xmax(suitRas)+0.2),
                      ylim=c(ymin(suitRas)-0.2, ymax(suitRas)+0.2),
                      par.settings = myTheme,
                      par.strip.text = stripParams,
                      colorkey = myColorkey,
                      margin=FALSE)
            + layer(sp.polygons(aoi_mask, col="black", lwd=1.5))
            + layer(sp.polygons(admin, col="black", lwd=1))
      )
      dev.off() 
    }
    cat(paste0('Processed ', crop, ' of ', period, '\n'))
    
    
  
  }
  
}
