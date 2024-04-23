rm(list = ls())

library(ncdf4)
library(raster)
library(abind)

iDir <- "C:\\Users\\Lucy Kimani\\OneDrive - CGIAR\\Work\\2023\\Dairy Zones\\Data\\Temp\\Temp\\2m_temperature\\2022"
oDir <- "C:\\Users\\Lucy Kimani\\OneDrive - CGIAR\\Work\\2023\\Dairy Zones\\Data\\Temp\\Temp\\2m_temperature\\2022tiff"

# Initialize an empty list to store the temperature data
temperature_list <- list()

# Loop over all NetCDF files
for (i in 1:365) {
  # Generate the date string
  date_string <- format(as.Date("2022-01-01") + i - 1, "%Y_%m_%d")
  
  # Generate the file path
  file_path <- file.path(iDir, paste0("2m_temperature_", date_string, ".nc"))
  
  # Open the NetCDF file
  nc <- nc_open(file_path)
  
  # Print the names of all variables
  print(names(nc$var))
  
  
  # Extract the temperature variable
  temperature <- ncvar_get(nc, "t2m")
  
  # Add the temperature data to the list
  temperature_list[[i]] <- temperature
  
  # Close the NetCDF file
  nc_close(nc)
}

# Calculate the annual average temperature
annual_avg_temp <- apply(do.call(abind, c(temperature_list, along=3)), c(1, 2), mean, na.rm = TRUE)

# Convert the annual average temperature to a raster object
r <- raster(annual_avg_temp)

# Write the raster object to a TIFF file
output_file_path <- file.path(oDir, "annual_avg_temp.tif")
writeRaster(r, output_file_path, format = "GTiff")
