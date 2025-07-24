#### script to look into the anoxia found at Turkey Creek Lake, San Juan mountain range ###

# load packages
library(tidyverse)

# load in miniDOT files (and wiper data if that's available)
# since it's miniDOT files, it'll be a list of .txt files that need to be concatonated
top_DO = read_delim("../../../../OneDrive-SharedLibraries-UCB-O365/Mountain limnology lab - Data/Sensors/miniDOT/TUC_0.5_BOT/2024-07-17 142700Z.txt",
                    delim = ",", skip = 2)


# point R to the directory where the bottom logger files are contained
miniDOT_bot_dir = list.files ("../../../../OneDrive-SharedLibraries-UCB-O365/Mountain limnology lab - Data/Sensors/miniDOT/TUC_0.5_BOT/")

combined_df = data.frame()

setwd("/Users/chdo4929/Library/CloudStorage/OneDrive-SharedLibraries-UCB-O365/Mountain limnology lab - Data/Sensors/miniDOT/TUC_0.5_BOT/")
# for loop
for (file_name in miniDOT_bot_dir) {
  # Read the current file into a temporary data frame
  temp_df <- read_delim(file_name, delim = ",", skip = 2) # You can use other functions like read.delim for different file types
  
  # Append the temporary data frame to the combined data frame
  combined_df <- rbind(combined_df, temp_df)
}
