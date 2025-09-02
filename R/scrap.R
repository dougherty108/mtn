####### quick plot
library(tidyverse)


setwd("/Users/chdo4929/Library/CloudStorage/OneDrive-SharedLibraries-UCB-O365/Mountain limnology lab - Data/")

profile = read.csv("Sensors/YSI Pro DSS/MIR/raw/Mirror_Lake_Zmax_20250816.csv",  fileEncoding = "UTF-16", 
                   skip = 9)


