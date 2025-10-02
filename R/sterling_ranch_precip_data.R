# Sterling Ranch Precip Data Breakdown

# install packages
library(tidyverse)
library(renv)


# load data
precip_accum = read_csv("data/MHFD_SterlingGulch/aug25/aem_Sterling_Gulch_10236_1_Precipitation_Accumulation_0.csv") %>% 
  mutate(measurement_type = "precipitation accumulation")

rain_increment = read_csv("data/MHFD_SterlingGulch/aug25/aem_Sterling_Gulch_10236_2_Rain_Increment_0A.csv") %>% 
  mutate(measurement_type = "rain increment")

total_flow = read_csv("data/MHFD_SterlingGulch/aug25/aem_Sterling_Gulch_10236_4_Total_Flow_cfs_7A.csv") %>% 
  mutate(measurement_type = "total flow")

water_temp = read_csv("data/MHFD_SterlingGulch/aug25/aem_Sterling_Gulch_10236_6_Water_Temperature_9.csv") %>% 
  mutate(measurement_type = "water temperature")

hydro = rbind(precip_accum, rain_increment, total_flow, water_temp) %>% 
  filter(Reading > "2025-08-27 12:00:00" & Reading < "2025-08-28 12:00:00")

# plot data in one plot
ggplot(hydro, aes(Reading, Value)) + 
  geom_path() +
  facet_wrap(vars(measurement_type), scales = "free") + 
  ggtitle("Week of Aug 25") + 
  theme_light()


# load data
precip_annum = read_csv("data/MHFD_SterlingGulch/oneyear/aem_Sterling_Gulch_10236_1_Precipitation_Accumulation_0 (1).csv") %>% 
  mutate(measurement_type = "precipitation accumulation", 
         date = as.Date(Reading))

rain_annum = read_csv("data/MHFD_SterlingGulch/oneyear/aem_Sterling_Gulch_10236_2_Rain_Increment_0A (1).csv") %>% 
  mutate(measurement_type = "rain increment", 
         date = as.Date(Reading))

flow_annum = read_csv("data/MHFD_SterlingGulch/oneyear/aem_Sterling_Gulch_10236_4_Total_Flow_cfs_7A (1).csv") %>% 
  mutate(measurement_type = "total flow", 
         date = as.Date(Reading))

temp_annum = read_csv("data/MHFD_SterlingGulch/oneyear/aem_Sterling_Gulch_10236_6_Water_Temperature_9 (1).csv") %>% 
  mutate(measurement_type = "water temperature", 
         date = as.Date(Reading))

hydro_annum = rbind(precip_annum, rain_annum, flow_annum, temp_annum)

# plot data in one plot
ggplot(hydro_annum, aes(Reading, Value)) + 
  geom_path() +
  facet_wrap(vars(measurement_type), scales = "free_y") + 
  ggtitle("OneYear") + 
  theme_light()

# group to precip events
precip_registered = rain_annum %>% 
  filter(Value > 0.00)

ggplot(precip_registered, aes(Reading, Value)) + 
  geom_point()

# desired dates 
desired_dates = precip_registered %>% 
  mutate(date = as.Date(Reading)) %>% 
  select(date)

# filter join to just the times when there was a change in precip
precip_events = desired_dates %>% 
  left_join(precip_annum)

rain_events = desired_dates %>% 
  left_join(rain_annum)

flow_events = desired_dates %>% 
  left_join(flow_annum)

temp_events = desired_dates %>% 
  left_join(temp_annum)

hydro_events =  rbind(precip_events, rain_events, flow_events, temp_events) %>% 
  filter(!is.na(Value)) %>% 
  mutate(month = month(date))

ggplot(hydro_events, aes(Reading, Value)) + 
  geom_point() +
  facet_wrap(vars(measurement_type), scales = "free") + 
  ggtitle("Events") + 
  theme_light()

# individual plotting by dataframe
ggplot(flow_events, aes(Reading, Value)) + 
  geom_point() +
  facet_wrap(vars(measurement_type, date), scales = "free_x") + 
  ggtitle("Flow Events") + 
  xlab("cfs") + 
  theme_light()

ggplot(rain_events, aes(Reading, Value)) + 
  geom_point() +
  facet_wrap(vars(measurement_type, date), scales = "free_x") + 
  ggtitle("Rain Events") + 
  xlab("in") + 
  theme_light()

ggplot(temp_events, aes(Reading, Value)) + 
  geom_point() +
  facet_wrap(vars(measurement_type, date), scales = "free_x") + 
  ggtitle("Temp Events") + 
  xlab("C") + 
  theme_light()



# notes from meeting: 
# rainmaker package from USGS, calculates different storm characteristics
# correctly sum rain increment data and compare to precip accumulation
# contact MHFD if the data looks funky between the two sensors


