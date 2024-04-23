#merge two csvs

library(tidyverse)

iDir <- "C:/Users/Lucy Kimani/OneDrive - CGIAR/Work/2023/Sylvia/Dairy Zones/Rwanda dairy Zones/data/Statistics/Extracts"
oDir <- "C:/Users/Lucy Kimani/OneDrive - CGIAR/Work/2023/Dairy Zones/Rwanda dairy Zones/data/Statistics/Extracts/Merge"

fLS = list.files(path=iDir, pattern="*.csv", full.names=TRUE)


fLS


# Read the first CSV file to initialize the merged dataset
merged_data <- read.csv(fLS[1], stringsAsFactors = FALSE)

merged_data


# Loop through the remaining CSV files and merge them based on the first column
for (i in 2:length(fLS)) {
  # Read the next CSV file
  next_data <- read.csv(fLS[i], stringsAsFactors = FALSE)
  
  # Merge the datasets based on the first column
  merged_data <- merge(merged_data, next_data, by = intersect(names(merged_data), names(next_data)))
}
str(merged_data)

#new_data <- Reduce(rbind, lapply(fLS, read.csv))

write_csv(merged_data, paste0(oDir, "/", "Data Extracts.csv"))
