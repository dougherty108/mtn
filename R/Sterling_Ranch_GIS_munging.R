###### Sterling Ranch GIS Visualization #######

library(tidyverse)
library(sf)
library(terra)
library(ggspatial)
library(maptiles)

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
conduit_webmerc <- st_cast(conduit_webmerc, "MULTILINESTRING") %>% 
  filter(!is.na(SLOPE))
pond_webmerc <- st_transform(pond_sf, 3857)
open_channel_webmerc <- st_transform(open_channel_sf, 3857)

# Get the basemap (you can change provider, e.g., "CartoDB.Positron", "OpenStreetMap", etc.)

#Conduit
basemap <- get_tiles(conduit_webmerc, provider = "CartoDB.Positron", crop = TRUE)

ggplot() +
  layer_spatial(basemap) +  # Basemap layer
  geom_sf(data = conduit_webmerc, 
          aes(color = SLOPE), 
          size = 1.0) +  # Your data
  geom_sf(
    data = open_channel_sf
  ) +
  annotation_scale(location = "bl") +
  annotation_north_arrow(location = "tl", which_north = "true") +
  labs(title = "Sterling Ranch--Conduit", color = "SLOPE") +
  theme_minimal()


