# Script to import a shape file (with extension .shp) and export a file in   #
# ArcInfo generate format (with extension .gen). The script also exports a   #
# file (with extension .id) that matches region IDs in the database file     #
# (with extension .dbf) to the numeric IDs in the .gen file. Before running  #
# this script:                                                               #
# - change the file path to the .shp file,                                   #
# - check the .dbf file for a column name that contains identifying names    #
#   for the regions,                                                         #
# - choose an appropriate projection.                                        #
# Edit the corresponding lines below marked by arrows in the comments.       #

library(rgdal)
library(tidyverse)

# Read the shape file. The result is a SpatialPolygonsDataFrame. #############
shp_file <- "iceland/gadm36_ISL_1.shp"  # <------- Change file path as needed.
id_col <- "NAME_1"  # <--- Change to column name in .dbf file with region IDs.
spdf <- readOGR(shp_file) %>%
  spTransform(CRSobj = "+init=epsg:5325")  # <--- Change projection as needed.
plot(spdf)

# Automatically give names to the .gen and .id file. #########################
gen_file <- str_replace(shp_file, ".shp", ".gen")
id_file <- str_replace(shp_file, ".shp", ".id")

# Remove existing .gen file and .id file. ####################################
if (file.exists(gen_file)) {
  file.remove(gen_file)
}
if (file.exists(id_file)) {
  file.remove(id_file)
}

# Write to .gen and .id files. ###############################################
id <- as.character(spdf@data[[id_col]])  # IDs in .dbf.

# Loop over multipolygons.
lapply(seq_along(spdf@polygons), function(mp_index) {
  cat(mp_index, " ", id[mp_index], "\n",
      file = id_file,
      sep = "",
      append = TRUE)
  
  # Loop over polygons inside this multipolygon.
  lapply(spdf@polygons[[mp_index]]@Polygons, function(polygon) {
    if (polygon@hole) {
      cat("FYI: hole in region ", mp_index, " (", id[mp_index], ")\n",
          sep = "")
    }
    coords <- polygon@coords
    cat(mp_index, " ", id[mp_index], "\n",
        file = gen_file,
        sep = "",
        append = TRUE)
    
    # Loop over pairs of coordinates in this polygon.
    lapply(seq_len(nrow(coords)), function(r) {
      cat(coords[r, ], "\n",
          file = gen_file,
          append = TRUE)
    })
    cat("END\n", file = gen_file, append = TRUE)
  })
})
cat("END\n", file = gen_file, append = TRUE)

# Remove all variables created by this script.
rm(gen_file, id, id_col, id_file, shp_file, spdf)