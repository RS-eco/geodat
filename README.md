geodat - R package for easy access to various geographical data
================

## Install geodat package

To *use* the package, it can be installed directly from GitHub using the
`remotes` package.

``` r
# Install packages from Github
#install.packages("remotes")
remotes::install_github("RS-eco/geodat")
```

After installation, load the package

``` r
library(geodat)
```

## Data

### Marine data

``` r
# Exclusive economic zones
data(eez)

# Large marine ecosystems
data(lme)

# Marine realms
data(marinerealms)

# Maritime boundaries
data(maritime_boundaries)

# Marine ecoregions of the world
data(meow)
```

### Map of marine biogeographic realms

``` r
library(dplyr); library(ggplot2)

# Re-project realm data
marinerealms <- sf::st_transform(marinerealms, "+proj=moll +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs")

# Group by ID2
marinerealms %<>% group_by(ID2) %>% summarise()

# Correctly merge actual groups
marinerealms <- lapply(marinerealms$ID2, function(x){
  dat <- marinerealms %>% filter(ID2 == x)
  dat <- rgeos::gPolygonize(rgeos::gNode(as(as(dat, "Spatial"), "SpatialLines")))
  dat <- rgeos::gUnaryUnion(dat)
  dat <- sf::st_as_sf(dat)
  dat$ID2 <- x
  return(dat)
})
marinerealms <- bind_rows(marinerealms)

ggplot() + geom_sf(data=marinerealms, aes(fill=ID2)) + coord_sf(datum=NA) + 
  scale_fill_manual(name="Realm", values=ggsci::pal_d3("category20")(15)) + 
  theme_bw() + theme(panel.border = element_blank(), legend.position="bottom",
                     legend.margin=margin(t=0,r=0,b=0, l=0, "cm"),
                     plot.margin = unit(c(0,0,0,0), "cm"),
                     legend.title = element_text(size=12, face="bold", 
                                                 angle=90, vjust=0.5, hjust=0.5)) + 
  guides(fill = guide_legend(nrow = 5))
```

![](figures/marrealm_map-1.png)<!-- -->

### Terrestrial data

``` r
# Biomes
data(biomes)

# Terrestrial ecoregions of the world
data(teow)

# Zoogeographic realms of the world
data(zoorealms)
```

### Map of zoogeographic realm

``` r
library(sf)

# Remove invalid topologies and crop to desired extent
zoorealms <- st_make_valid(zoorealms)
zoorealms <- sf::st_crop(zoorealms, xmin=-180, ymin=-56, xmax=180, ymax=84)

# Re-project realm data
zoorealms <- sf::st_transform(zoorealms, "+proj=moll +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs")

# Plot map of realm data
ggplot() + geom_sf(data=zoorealms, aes(fill=Realm)) + coord_sf(datum=NA) + 
  scale_fill_manual(values=ggsci::pal_d3("category20")(11)) + 
  theme_bw() + theme(panel.border = element_blank(),
                     legend.title = element_text(size=12, face="bold"))
```

![](figures/zoorealm_map-1.png)<!-- -->
