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
  
  # Extract depth (e.g., 12.0) from the full file path using regex
  # Matches "_12.0m_" or "_5.5m_" in the file path
  length_match <- str_match(file, "_(\\d+\\.?\\d*)m_")[, 2]
  
  if (!is.na(length_match)) {
    # Read the CSV file (assuming all are CSVs; adjust if Excel support is needed)
    data <- readr::read_csv(file)
    
    # Add a new column with the depth info (as numeric)
    data$depth_m <- as.numeric(length_match)
    
    # Add this data frame to the list, optionally using depth as the name
    data_list[[length_match]] <- data
  } else {
    warning(paste("No length found in filename:", file))
  }
}

#convert list output to dataframe
output = bind_rows(data_list) %>% 
  mutate(Temp_C = coalesce(`Temperature (°C)`, `Temperature   (°C)`)) %>%
  mutate(lux = coalesce(`Light (lux)`, `Light   (lux)`)) %>%# only use this step if date columns are wonky
  mutate(`Date-Time (MDT)` = mdy_hms(`Date-Time (MDT)`)) %>% 
  filter(`Date-Time (MDT)` > "2024-09-07 00:00:00")

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
  ggtitle("Upper Four Mile Pendants") + 
  scale_color_viridis_d(option = "D", name = "Depth from Bottom (m)") + 
  theme_bw()



