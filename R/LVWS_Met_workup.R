
library(here)
library(tidyverse)

# load project root
here()

# point to data directory in OneDrive to get at the met data, update if changes
data_path = "~/Library/CloudStorage/OneDrive-SharedLibraries-UCB-O365/Mountain limnology lab - Data"

# load in all the met data that is available 1992-2019
clim = read_csv(paste0(data_path, "/LVWS/09_meteorology/WY1992to2019_LochVale_Climate.csv")) |> 
  mutate(date_time = mdy_hm(date_time), 
         month = month(date_time), 
         year = year(date_time))

completeness <- clim |> 
  group_by(year, month) |> 
  summarize(
    missing_SWin  = sum(is.na(SWin)),
    missing_SWout = sum(is.na(SWout)),
    missing_RH    = sum(is.na(RH)),
    missing_Tair  = sum(is.na(T_air)),
    missing_Wspd  = sum(is.na(WSpd)),
    missing_WDir  = sum(is.na(WDir)),
    .groups = "drop"
  ) |> 
  mutate(
    # require *all* variables to have < 40 missing values
    keep = missing_SWin  < 40 &
      missing_SWout < 40 &
      missing_RH    < 40 &
      missing_Tair  < 40 &
      missing_Wspd  < 40 &
      missing_WDir  < 40
  )


# group data by month to find averages
completeness |> 
  group_by(month) |> 
  summarize(mean_swin = mean(SWin, na.rm = T), 
            mean_swout = mean(SWout, na.rm = T), 
            mean_RH = mean(RH, na.rm = T), 
            mean_Tair = mean(T_air, na.rm = T), 
            mean_Wspd = mean(WSpd, na.rm = T), 
            mean_WDir = mean(WDir, na.rm = T)) |> 
  print()

clim |> mutate(month = month(date_time), 
         year = year(date_time)) |> 
  group_by(month, year) |> 
  summarize(mean_swin = mean(SWin, na.rm = T), 
            mean_swout = mean(SWout, na.rm = T), 
            mean_RH = mean(RH, na.rm = T), 
            mean_Tair = mean(T_air, na.rm = T), 
            mean_Wspd = mean(WSpd, na.rm = T), 
            mean_WDir = mean(WDir, na.rm = T)) |> 
  pivot_longer(cols = 3:8, names_to = "parameter", 
               values_to = "value") |> 
  mutate(date = make_date(month = month, year = year)) |> 
  ggplot() + 
  geom_line(aes(date, value)) + 
  geom_smooth() + 
  facet_wrap(vars(parameter), scales = "free") + 
  theme_bw(base_size = 18)




