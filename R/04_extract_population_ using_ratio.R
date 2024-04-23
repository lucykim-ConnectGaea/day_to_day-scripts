# Load the required library
library(raster)

# Replace "path/to/your/total_population_raster.tif" with the actual path to your raster file representing total cattle population

total_population_raster <- raster("C:\\Users\\Lucy Kimani\\OneDrive - CGIAR\\Work\\2023\\Dairy Zones\\Data\\dataverse_files\\6_Ct_2015_Aw.tif")
plot(total_population_raster)
# Define the constant percentage of dairy cattle to total population
constant_dairy_percentage <- 28  # Replace with the actual percentage value

# Read raster values into a matrix
total_population_values <- extract(total_population_raster, total_population_raster)

# Calculate the density of dairy cattle using the constant percentage
density_dairy_cattle <- total_population_values * (constant_dairy_percentage / 100)

# Sum the density values
total_density_dairy_cattle <- sum(density_dairy_cattle, na.rm = TRUE)

# Print the result
print(paste("Total Dairy Cattle:", total_density_dairy_cattle))
