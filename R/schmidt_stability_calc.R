# Schmidt Stability Calculations Loch Vale

# Author: Charlie Dougherty

# libraries
library(tidyverse)

# load temperature file

profile = read_csv("data/loch_temperature_profile.csv")

# define constants
g = 9.81 #m/s2
h = 5.0 #m - depth of lake
Az = 0.0 ### Cross sectional area of the lake
rho = 0.0 # density of water at depth z (constant?)
rho_mean = 0.0 # mean density of the lake after mixing


