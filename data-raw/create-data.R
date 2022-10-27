# Create eez, maritime boundaries, meow, lme, marinerealms and zoorealms data files

# Set file directory
filedir <- "/home/matt/Documents/"

# Load packages
library(dplyr); library(sf)

# Adapt according to EEZ!
# download.file("http://www.marineregions.org/download_file.php?name=EEZ.zip", destfile="EEZ.zip")
# eez <- unzip("EEZ.zip")
eez <- sf::st_read(paste0(filedir, "EEZ/World_EEZ_v10_20180221/eez_v10.shp"))
eez <- eez %>% sf::st_make_valid() %>% sf::st_simplify(preserveTopology = TRUE, dTolerance = 20)
save(eez, file="data/eez.rda", compress="xz")

# Add maritime boundaries
# same file as for EEZ
eez_boundaries <- sf::st_read(paste0(filedir, "EEZ/World_EEZ_v10_20180221/eez_boundaries_v10.shp"))
save(eez_boundaries, file="data/eez_boundaries.rda", compress="xz")

# Add Marine Ecoregions of the World
# download.file("http://www.marineregions.org/download_file.php?name=MEOW.zip", destfile="MEOW.zip")
# meow <- unzip("MEOW.zip")
meow <- sf::st_read(paste0(filedir, "MEOW/meow_ecos.shp"))
save(meow, file="data/meow.rda", compress="xz")

# Add Large Marine Ecosystems
lme <- sf::st_read(paste0(filedir, "LME_PolygonBoundaries/lmes_64.shp"))
save(lme, file="data/lme.rda", compress="xz")

# Add marine biogeographic realms (see paper by Costello et al. 2017 Nature Communications)
#https://figshare.com/articles/GIS_shape_files_of_realm_maps/5596840
#tmp <- tempfile(fileext=".zip")
download.file("https://ndownloader.figshare.com/files/9737926", destfile="MarineRealmsShapeFile.zip")
dat <- unzip("MarineRealmsShapeFile.zip")
marinerealms <- sf::st_read(dat[grep(dat, pattern=".shp$")])
marinerealms$ID <- cut(marinerealms$Realm, breaks=c(1,2,3,9,10,11,29,30,31), right=F,
                       labels=c("Inner Baltic Sea", "Black Sea", "NE and NW Atlantic and \n Mediterranean, Arctic \n and North Pacific",
                                "Mid-tropical North Pacific Ocean", "South-east Pacific", "Mid-Atlantic, Pacific \n and Indian Oceans",
                                "North West Pacific", "Southern Ocean"))
marinerealms$ID2 <- cut(marinerealms$Realm, breaks=c(1,2,3,6,8,9,10,11,13,17,18,24,26,29,30,31), right=F,
                        labels=c("Inner Baltic Sea", "Black Sea", "NE and Atlantic and \n Mediterranean", "Arctic and N Pacific",
                                 "N Atlantic boreal & \n sub Arctic", "Mid-tropical N Pacific Ocean", "South-east Pacific", 
                                 "Tropical W Atlantic & \n Tropical E Pacific", "Coastal Indian Ocean, \n W Pacific, ...", 
                                 "Mid South Tropical Pacific", "Open Atlantic, Indian & \n Pacific Oceans", "S South America", 
                                 "S Africa, S Australia & \n New Zealand", "North West Pacific", "Southern Ocean"))
save(marinerealms, file="data/marinerealms.rda", compress="xz")
file.remove(dat); file.remove(tmp)

#' Read Terrestrial ecoregions of the world shapefile
tmp <- tempfile(fileext=".zip")
download.file("https://c402277.ssl.cf1.rackcdn.com/publications/15/files/original/official_teow.zip?1349272619", 
              destfile=tmp)
dat <- unzip(tmp, junkpaths=T)
teow <- sf::st_read(dat[grep(dat, pattern=".shp$")]) %>% st_make_valid()
save(teow, file="data/teow.rda", compress="xz")
file.remove(dat); file.remove(tmp)

#' Create biome layer
biomes <- teow %>% group_by(BIOME) %>% summarise()
save(biomes, file="data/biomes.rda", compress="xz")

#' CMEC Zoogeographic Realms and Regions which can be downloaded here: 
tmp <- tempfile(fileext = ".zip")
download.file("https://macroecology.ku.dk/resources/wallace/cmec_regions___realms.zip", destfile=tmp)
dat <- unzip(tmp, junkpaths=T)
zoorealms <- sf::st_read(dat[grep(dat, pattern="newRealms.shp$")])
# Correct Oceanian realm name
zoorealms$Realm <- factor(zoorealms$Realm, levels=zoorealms$Realm, 
                             labels=c("Neotropical", "Australian", "Afrotropical", "Madagascan",
                                      "Oceanian", "Oriental", "Panamanian", "Saharo-Arabian", 
                                      "Nearctic", "Sino-Japanese", "Palearctic"))

zooregions <- sf::st_read(dat[grep(dat, pattern="Regions.shp$")])
#zoorealms_old <- sf::st_read(dat[grep(dat, pattern="realms.shp$")])
save(zoorealms, file="data/zoorealms.rda", compress="xz")
save(zooregions, file="data/zooregions.rda", compress="xz")
file.remove(dat); file.remove(tmp)
