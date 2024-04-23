
rm(list = ls())

# Load the necessary libraries
library(raster)
library(terra)
library(ncdf4)

# Specify the directories
iDir <- "C:\\Users\\Lucy Kimani\\OneDrive - CGIAR\\Work\\2023\\Dairy Zones\\Data\\Temp\\Temp\\2m_temperature\\2022"
oDir <- "C:\\Users\\Lucy Kimani\\OneDrive - CGIAR\\Work\\2023\\Dairy Zones\\Data\\Temp\\Temp\\2m_temperature\\2022\\Monthly"

# Initialize an empty list to store the daily temperatures
daily_temps <- list()

for (i in 1:365) {
  # Generate the date string
  date_string <- format(as.Date("2022-01-01") + i - 1, "%Y_%m_%d")
  
  # Generate the input file path
  file_path <- file.path(iDir, paste0("2m_temperature_", date_string, ".nc"))
  
  # Open the NetCDF file
  nc <- nc_open(file_path)
  
  # Extract the temperature variable
  temperature_kelvin <- ncvar_get(nc, "t2m")
  
  # Convert from Kelvin to Celsius
  temperature_celsius <- temperature_kelvin - 273.15
  
  # Store the daily temperature in the list
  daily_temps[[date_string]] <- temperature_celsius
  
  # Close the original NetCDF file
  nc_close(nc)
}

# Convert the list to a data frame
df <- data.frame(Date = as.Date(names(daily_temps)), Temperature = unlist(daily_temps))

# Convert the Date column to a Date object
df$Date <- as.Date(df$Date)

# Get the month and year for each date
df$Month <- format(df$Date, format="%m")
df$Year <- format(df$Date, format="%Y")

# Calculate the monthly means
monthly_means <- aggregate(Temperature ~ Month + Year, df, mean)

# Convert the monthly means to a raster
monthly_means_raster <- raster(matrix(monthly_means$Temperature, nrow=num_rows, ncol=num_cols))

# Save the raster as a GeoTIFF file
writeRaster(monthly_means_raster, filename="monthly_means.tif", format="GTiff")

