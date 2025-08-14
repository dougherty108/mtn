#### Hobo Temp Pendant Visualization ######

# Author
# Charlie Dougherty

# Load libraries
library(tidyverse)
library(lubridate)
library(readxl) # Required for read_excel
library(stringr) # Required for str_match

# Set working directory to folder containing HOBO data
setwd("~/Library/CloudStorage/OneDrive-SharedLibraries-UCB-O365/Mountain limnology lab - Data/Sensors/HOBO")

# Define the folder containing the specific site's files
folder_path <- "TUC"

# List all files in the subfolder
files <- list.files(folder_path, full.names = TRUE)

# Initialize empty list to store each file's data
data_list <- list()

# Loop through each file
for (file in files) {
  
  # Extract just the filename
  filename <- basename(file)
  
  # Extract depth (e.g., 12.0) from filename using regex
  # Matches "_12.0m_" or "_5.5m_" in the filename
  length_match <- str_match(filename, "_(\\d+\\.?\\d*)m_")[, 2]
  
  if (!is.na(length_match)) {
    # Read the Excel file
    data <- read_excel(file)
    
    # Add a new column with the depth info (as numeric)
    data$depth_m <- as.numeric(length_match)
    
    # Add this data frame to the list
    data_list[[length_match]] <- data
  } else {
    warning(paste("No length found in filename:", filename))
  }
}

#convert list output to dataframe
output = bind_rows(data_list)

# plot output
