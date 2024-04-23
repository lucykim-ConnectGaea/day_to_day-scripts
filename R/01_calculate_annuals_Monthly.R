require(raster)

iDir <- "D:\\consultancy\\Work\\Targetting Tools\\New folder"
oDir <- "D:\\consultancy\\Work\\Targetting Tools\\New folder\\annual"
varLs <- c("vapr", "wind")
mthLs <- c(paste0("0",1:9), 10:12)


for (var in varLs){
  
  varStack <- stack(paste0(iDir, "/wc2.1_30s_", var, "/wc2.1_30s_", var, "_", mthLs, ".tif"))
  
  
  
  if (var=="prec"){
    
    annual_stat <- sum(varStack)
    
  }else{
    
    annual_stat <- varStack/12
    
  }
  
  
  writeRaster(annual_stat, paste0(oDir, "/annual_", var), format="GTiff", overwrite=T)
  
  
}
                                                                             