###### Sterling Ranch GIS Visualization #######

library(tidyverse)
library(sf)
library(terra)

gdb_path <- "data/MHFD_SR_Request.gdb"

st_layers(gdb_path)

#inlet
inlet <- st_read(dsn = gdb_path, layer = "INLET")

glimpse(inlet)

plot(inlet["STORMWATER_ID"])


ggplot(data = inlet) +
  geom_sf(aes(color = Shape)) +
  theme_minimal() +
  labs(title = "test", color = "SHAPE")

# pond
pond = st_read(dsn = gdb_path, layer = "POND")

glimpse(pond)

plot(pond["COLOR_RANK"])
