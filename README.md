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

### Terrestrial data

``` r
# Biomes
data(biomes)

# Terrestrial ecoregions of the world
data(teow)

# Zoogeographic realms of the world
data(zoorealms)
```
