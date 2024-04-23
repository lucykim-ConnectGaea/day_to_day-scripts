library(ncdf4) # package for netcdf manipulation
library(raster) # package for raster manipulation
library(rgdal) # package for geospatial analysis


library(ggplot2) # package for plotting

iDir <- "C:\\Users\\Lucy Kimani\\OneDrive - CGIAR\\climate risk Mapping 2022\\Data\\World Bank Group\\Input"
oDir <- "C:\\Users\\Lucy Kimani\\OneDrive - CGIAR\\climate risk Mapping 2022\\Data\\World Bank Group\\Output"
varL <- ('tas')

temp <- nc_open("C:\\Users\\Lucy Kimani\\OneDrive - CGIAR\\climate risk Mapping 2022\\Data\\World Bank Group\\Input\\timeseries-tas-annual-mean_cru_annual_cru-ts4.06-timeseries_mean_1901-2021.nc")
metadata = ncdump::NetCDF("C:\\Users\\Lucy Kimani\\OneDrive - CGIAR\\climate risk Mapping 2022\\Data\\World Bank Group\\Input\\timeseries-tas-annual-mean_cru_annual_cru-ts4.06-timeseries_mean_1901-2021.nc")





# Save the print(nc) dump to a text file
{
  sink('mean_1901-2021.txt')
  print(temp)
  sink()
}

lon <- ncvar_get(temp, "lon")
lat <- ncvar_get(temp, "lat", verbose = F)
t <- ncvar_get(temp, "time")

head(lon) # look at the first few entries in the longitude vector

#Read in the data from the NDVI variable and verify the dimensions of the array. There should be 720 lons, 360 lats, and 1 times
temp_mean.array <- ncvar_get(temp, "timeseries-tas-annual-mean") # store the data in a 3-dimensional array
dim(temp_mean.array) 

#Lets’s see what fill value was used for missing data.
fillvalue <- ncatt_get(temp, "timeseries-tas-annual-mean", "_FillValue")
fillvalue


#Let’s replace all those pesky fill values with the R-standard ‘NA’.
temp_mean.array[temp_mean.array == fillvalue$value] <- NA


#If there are a number of years of data in this array
#This is how you get the first year data and plot it.
temp.slice <- temp_mean.array[, , 121] 

#take a look at the dimensions of this temp slice. The dimensions should be X longitudes by Y latitudes.
#like the original dimensions of the array.
dim(temp.slice)



#But in this case we only have one data layer ~ mean annual temperature
#take a look at the dimensions of this array. The dimensions should be 720 longitudes by 360 latitudes.
#like the original dimensions of the array.

dim(temp.slice)

#save this data in a raster.Provide the coordinate reference system “CRS” in the standard well-known text format.
r <- raster(t(temp.slice), xmn=min(lon), xmx=max(lon), ymn=min(lat), ymx=max(lat), crs=CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs+ towgs84=0,0,0"))

#t <- brick(temp_mean.array, crs=CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs+ towgs84=0,0,0"))

plot(r) #It is upside down

#We will need to transpose and flip to orient the data correctly. 
#The best way to figure this out is through trial and error, 
#but remember that most netCDF files record spatial data from the bottom left corner.
rflipped <- flip(r, direction='y')
#rflipped2 <- flip(rflipped,direction='y')
plot(rflipped)


writeRaster(rflipped, paste0(oDir, "/timeseries_121"), format="GTiff", overwrite=T)

