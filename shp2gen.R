# Script to R import a shape file (with extension .shp) and export a file in #
# ArcInfo generate format (with extension .gen). The script also exports a   #
# file of region IDs (with extension .id).                                   #

library(rgdal)
library(tidyverse)

# Read the shape file. The result is a SpatialPolygonsDataFrame. #############
shp_file <- "canada/gadm36_CAN_1.shp"  # Change file path as needed.
spdf <- readOGR(shp_file)

# Automatically give names to the .gen and .id file. #########################
gen_file <- str_replace(shp_file, ".shp", ".gen")
id_file <- str_replace(shp_file, ".shp", ".id")

# Remove equally named .gen file and .id file. ###############################
if (file.exists(gen_file)) {
  file.remove(gen_file)
}
if (file.exists(id_file)) {
  file.remove(id_file)
}

# dt <- area@data
# for (i in seq_along(area@polygons)) {
#   cat(i, " ", as.character(dt$NAME_1[i]), "\n", file = id.file,
#       append = TRUE, sep = "")
#   aps <- area@polygons[[i]]
#   if (length(aps) != 1)
#     stop("length(aps) != 1")
#   ap <- aps@Polygons
#   for (j in seq_along(ap)) {
#     if (ap[[j]]@hole || ap[[j]]@ringDir != 1)
#       cat("hole in region", i, "\n")
#     m <- ap[[j]]@coords
#     cat(i, " ", as.character(dt$NAME_1[i]), "\n", file = gen.file,
#         append = TRUE, sep = "")
#     for (k in seq_len(nrow(m))) {
#       cat(m[k, 1], " ", m[k, 2], "\n", file = gen.file,
#           append = TRUE, sep = "")
#     }
#     cat("END\n", file = gen.file, append = TRUE)
#   }
# }
# cat("END\n", file = gen.file, append = TRUE)