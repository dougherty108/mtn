#### script to look into the anoxia found at Turkey Creek Lake, San Juan mountain range ###

# load packages
library(tidyverse)

setwd("/Users/chdo4929/Library/CloudStorage/OneDrive-SharedLibraries-UCB-O365/Mountain limnology lab - Data/Sensors/miniDOT/TUC_0.5_BOT/")
# point R to the directory where the bottom logger files are contained
miniDOT_bot_dir = list.files()

combined_bot = data.frame()
# bottom sensor
for (file_name in miniDOT_bot_dir) {
  # Read the current file into a temporary data frame
  temp_df <- read_delim(file_name, delim = ",", skip = 2) 
  # Append the temporary data frame to the combined data frame
  combined_bot <- rbind(combined_bot, temp_df)
}

combined_bottom = combined_bot %>% 
  mutate(`  DO (mg/l)` = as.numeric(`  DO (mg/l)`), 
         `  T (deg C)` = as.numeric(`  T (deg C)`), 
         date = as.POSIXct(origin = "1970-01-01", x = `Time (sec)`))

# set wd to the top sensor
setwd("/Users/chdo4929/Library/CloudStorage/OneDrive-SharedLibraries-UCB-O365/Mountain limnology lab - Data/Sensors/miniDOT/TUC_13.5_BOT/")
# point R to the directory where the bottom logger files are contained
miniDOT_top_dir = list.files()

combined_surf = data.frame()
# bottom sensor
for (file_name in miniDOT_top_dir) {
  # Read the current file into a temporary data frame
  temp_df <- read_delim(file_name, delim = ",", skip = 2) 
  
  # Append the temporary data frame to the combined data frame
  combined_surf <- rbind(combined_surf, temp_df)
}

combined_surface = combined_surf %>% 
  mutate(`  DO (mg/l)` = as.numeric(`  DO (mg/l)`), 
         `  T (deg C)` = as.numeric(`  T (deg C)`), 
         date = as.POSIXct(origin = "1970-01-01", x = `Time (sec)`))

combined_bottom = combined_bottom %>% 
  mutate(`depth from bottom` = "0.5") %>% 
  filter(`  DO (mg/l)` < 0.20)

combined_surface = combined_surface %>% 
  mutate(`depth from bottom` = "13.5")

# how complete is the data between the two sensors? 
print(nrow(combined_bottom))
print(nrow(combined_surface))

#print difference between data
print(nrow(combined_bottom) - nrow(combined_surface))

combined_df = rbind(combined_bottom, combined_surface)

TUC_DO = combined_df %>% 
  filter(date > "2024-07-18" & date < "2025-07-15") %>% 
  mutate(month = as.character(month(date)))



# plot
ggplot(TUC_DO, aes(date, `  DO (mg/l)`)) + 
         geom_point(shape = 21, size = 2) + 
  geom_jitter() +
  facet_wrap(vars(`depth from bottom`), scales = "free") + 
  theme_bw() + 
  ggtitle("DO (mg/L), Turkey Creek Lake 2024-2025")

# plot by month
ggplot(TUC_DO, aes(date, `  DO (mg/l)`, color = month)) + 
  geom_point(shape = 21, size = 2) + 
  geom_jitter() +
  facet_wrap(vars(`depth from bottom`), scales = "free") + 
  theme_bw() + 
  ggtitle("DO (mg/L), Turkey Creek Lake 2024-2025 by month")






