###### Sterling Ranch GIS Visualization #######

library(tidyverse)
library(sf)
library(terra)
library(ggspatial)
library(maptiles)
library(readxl)

gdb_path <- "data/MHFD_SR_Request.gdb"

st_layers(gdb_path)

inlet = "INLET"
junction = "JUNCTION"
outfall = "OUTFALL"
conduit = "CONDUIT"
pond = "POND"
open_channel = "OPEN_CHANNEL"

inlet_sf <- st_read(dsn = gdb_path, layer = inlet)
junction_sf <- st_read(dsn = gdb_path, layer = junction)
outfall_sf <- st_read(dsn = gdb_path, layer = outfall)
conduit_sf <- st_read(dsn = gdb_path, layer = conduit)
pond_sf <- st_read(dsn = gdb_path, layer = pond)
open_channel_sf <- st_read(dsn = gdb_path, layer = open_channel)

#load sub-type attributes
glimpse(inlet_sf)
glimpse(junction_sf)
glimpse(outfall_sf)
glimpse(conduit_sf)
glimpse(pond_sf)
glimpse(open_channel_sf)

# Transform your data to Web Mercator (needed for tiles)
inlet_webmerc <- st_transform(inlet_sf, 3857)
junction_webmerc <- st_transform(junction_sf, 3857)
outfall_webmerc <- st_transform(outfall_sf, 3857)
conduit_webmerc <- st_transform(conduit_sf, 3857)
conduit_webmerc <- st_cast(conduit_webmerc, "MULTILINESTRING") #%>% 
  #filter(!is.na(SLOPE))
pond_webmerc <- st_transform(pond_sf, 3857)
open_channel_webmerc <- st_transform(open_channel_sf, 3857)

# Get the basemap (you can change provider, e.g., "CartoDB.Positron", "OpenStreetMap", etc.)


# load in coordinates of proposed sample sites
site_metadata = read_excel(path ="data/Sterling_Ranch_site_metadata.xlsx")
site_sf = st_as_sf(site_metadata, coords = c("longitude", "latitude"), crs = 4326)
site_webmerc = st_transform(site_sf, crs = 3857)

#Conduit
basemap <- get_tiles(conduit_webmerc, provider = "CartoDB.Positron", crop = TRUE)

ggplot() +
  layer_spatial(basemap) +  # Basemap layer
  geom_sf(data = conduit_webmerc, 
          #aes(color = SLOPE), 
          size = 2.0) +  # Your data
  geom_sf(
    data = open_channel_sf, 
    color = "blue"
  ) +
  geom_sf(
    data = site_webmerc, 
    aes(shape = site_ID), 
    #shape = 21, 
    size = 2) + 
  annotation_scale(location = "bl") +
  annotation_north_arrow(location = "tl", which_north = "true") +
  labs(title = "Sterling Ranch--Conduit", color = "SLOPE") +
  theme_minimal()


# calculate conduit drainage area
site_buffered = st_buffer(site_webmerc, dist = 20)

conduit_hits <- st_intersection(conduit_webmerc, site_buffered)
open_channel_hits <- st_intersection(open_channel_webmerc, site_buffered)

conduit_hits$length_m <- st_length(conduit_hits)
open_channel_hits$length_m <- st_length(open_channel_hits)

conduit_summary <- conduit_hits %>%
  st_drop_geometry() %>%
  group_by(site_ID) %>%
  summarise(conduit_length_m = sum(as.numeric(Shape_Length)))

open_channel_summary <- open_channel_hits %>%
  st_drop_geometry() %>%
  group_by(site_ID) %>%
  summarise(open_channel_length_m = sum(as.numeric(Shape_Length)))

print(conduit_summary)
print(open_channel_summary)



ggplot() +
  layer_spatial(basemap) +  # Basemap layer
  geom_sf(data = conduit_webmerc, 
          #aes(color = SLOPE), 
          size = 2.0) +  # Your data
  geom_sf(
    data = open_channel_sf, 
    color = "blue"
  ) +
  geom_sf(
    data = site_buffered,
    shape = 21, 
    color = "red",
    size = 2) + 
  annotation_scale(location = "bl") +
  annotation_north_arrow(location = "tl", which_north = "true") +
  labs(title = "Sterling Ranch--Conduit", color = "SLOPE") +
  theme_minimal()
