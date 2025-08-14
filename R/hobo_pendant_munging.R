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
folder_path <- "UFM/raw"

# List all files in the subfolder
files <- list.files(folder_path, full.names = TRUE, pattern = ".csv")

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
    # Read the Excel or csv file
    data <- read_csv(file)
    
    # Add a new column with the depth info (as numeric)
    data$depth_m <- as.numeric(length_match)
    
    # Add this data frame to the list
    data_list[[length_match]] <- data
  } else {
    warning(paste("No length found in filename:", filename))
  }
}

#convert list output to dataframe
output = bind_rows(data_list) %>% 
  mutate(Temp_C = coalesce(`Temperature (°C)`, `Temperature   (°C)`)) %>%
  mutate(lux = coalesce(`Light (lux)`, `Light   (lux)`)) %>%# only use this step if date columns are wonky
  filter(`Temperature   (°C)` < 20) %>% 
  mutate(`Date-Time (MDT)` = mdy_hms(`Date-Time (MDT)`))

# check structure of output to make sure columns are in correct format
str(output)

# make any req corrections (none needed here)


# Get end times for each depth group
end_times <- output %>%
  group_by(depth_m) %>%
  summarize(end_time = max(`Date-Time (MDT)`), .groups = "drop")

# Plot
ggplot(output, aes(`Date-Time (MDT)`, `Temp_C`)) + 
  geom_line(aes(color = as.factor(depth_m))) + 
  geom_vline(data = end_times, aes(xintercept = as.numeric(end_time)), 
             linetype = "dashed", color = "black") +
  ggtitle("Sky Pendants") + 
  scale_color_viridis_d(option = "D", name = "Depth from Bottom (m)") + 
  theme_bw()



