##### Ice on/off and thickness for GL4 ######

library(tidyverse)

setwd("~/Library/CloudStorage/OneDrive-UCB-O365/Documents/R-Repositories/mtn")


# load GL4 lake ice file

gl4 <- read_csv("data/gl4_ice_thickness.nc.data.csv")

# plot data
ggplot(gl4, aes(date, thickness)) + 
  geom_point() + 
  facet_wrap(vars(year), scales = "free")


# load met data
saddle <-  read_csv("data/sdlcr23x-cr1000.hourly.ml.data.csv")
