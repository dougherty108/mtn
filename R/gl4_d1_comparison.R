######## D1 to GL4 Met Comparison #######

library(tidyverse)

# only daily climate data is available (like cmon)

# load site files

gl4 = read_csv("data/gl4cr10-cr1000.daily.kc.data.csv")

d1 = read_csv("data/d-1cr23x-cr1000.daily.ml.data.csv")

# variables of interest for metabolism modeling
# air temperature
# wind speed
# solar radiation

# filter gl4 and d1 down to the above variables, and join for easier plotting
# they named the columms differently depending on the station (ANNOYING), going to do some renaming and only look at averages
# for now. 
gl4_temp = gl4 |> 
  select(date, local_site, airtemp_max, airtemp_min, airtemp_avg, ws_max, ws_min, ws_avg, 
         wd_avg, shortrad_avg) |> 
  mutate(shortrad_abg = shortrad_avg / 24)
  
d1_temp = d1 |> 
  select(date, local_site, airtemp_max, airtemp_min, airtemp_avg, ws_max, ws_min, ws_avg, 
         wd, solrad_tot) |> 
  rename(wd_avg = "wd", 
         shortrad_avg = "solrad_tot")

met_avg = rbind(gl4_temp, d1_temp)

# comparison plot
# temp
ggplot(met_avg, aes(date, airtemp_avg, color = local_site)) + 
  geom_line() + 
  ggtitle("Average air temperature (C)", 
          subtitle = "D1 vs. GL4") + 
  theme_minimal()

# wind
ggplot(met_avg, aes(date, ws_avg, color = local_site)) + 
  geom_line() + 
  ggtitle("Average Wind Speed (m/s)", 
          subtitle = "D1 vs. GL4") + 
  theme_minimal()

#solar
# error here, one is reported as total solar radiation daily, the other is the avg. 
ggplot(met_avg, aes(date, shortrad_avg, color = local_site)) + 
  geom_line() + 
  ggtitle("Average Solar Radiation (w/m2)", 
          subtitle = "D1 vs. GL4") + 
  theme_minimal()
