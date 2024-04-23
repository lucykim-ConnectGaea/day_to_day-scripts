
setwd("C:\\Users\\Lucy Kimani\\OneDrive - CGIAR\\Work\\2023\\Dairy Zones\\Data\\Temp\\Temp\\2m_temperature\\2022tiff")
library(terra)
daily_temp <- list.files(pattern = '\\.tif$')
daily_temp

stack_dailytemp <- stack(daily_temp)
stack_dailytemp

rs_sum <- calc(stack_dailytemp, sum)
rs_avg <- rs_sum / 365
rs_avg
plot(rs_avg)
#
# Specify the name of the new folder
new_folder <- "annual average"

# Create the new folder
dir.create(new_folder)

# Specify the output file path
output_file <- paste0(new_folder, "/rs_avg.tif")

# Write the RasterLayer to a file
writeRaster(rs_avg, output_file, format='GTiff', overwrite=TRUE)

