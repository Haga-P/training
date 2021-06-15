##
##  Project Name:  Building the WIO Global Coral Reef Monitoring Network
##                 to make coral reef data secure & accessible
##
##  Objective:     Provide course structure and modules for data 
##                 systematisation and visualisation training course
##
##  Approach:      
##
##  Authors:       Franz Smith, Mishal Gudka, David Obura, and others
##                 Universidad San Francisco de Quito
##
##
##  Date:          2021-04-30
##

##  Notes:         1. This file is intended to provide a guide to the basic
##                    workflow of the project, attempting to 'integrate' the
##                    different steps necessary to conduct the analyses &
##                    create visual outputs

##
##  1. Set up the core functionality
##
  # clean up
    rm(list=ls())

  # call to core packages for data manipulation
    library(dplyr)
    library(tidyr)
    library(magrittr)
    library(purrr)
    library(lubridate)
    library(hms)
    library(stringr)
    library(forcats)

  # for importing different formats
    library(readr)
    library(readxl)

  # call to visualisation & output generation
    library(ggplot2)
    library(GGally)
    library(Cairo)
    library(extrafont)
    library(RColorBrewer)
    library(viridis)

  # functionality for spatial analyses
    library(raster)
    library(rgdal)
    library(sf)
    library(rgeos)

  # point to working directory        ## -- will need to adjust for local copy -- ##
    # setwd("research/gcrmn_wio_data_course")

  # set font for graphical outputs
    theme_set(theme_bw(base_family = "Helvetica"))
    CairoFonts(  # slight mod to example in ?CairoFonts page
               regular    = "Helvetica:style = Regular",
               bold       = "Helvetica:style = Bold",
               italic     = "Helvetica:style = Oblique",
               bolditalic = "Helvetica:style = BoldOblique"
               )

  # call to map theme
    source("R/theme_nothing.R")

  # create helper function for reviewing data
    quickview <- function(x, n = 3L) {head(data.frame(x), n = n)}

  # set utm details
    utm_details <-
      paste0("+proj=utm +zone=15 +south +datum=WGS84 +units=m",
             " +no_defs +ellps=WGS84 +towgs84=0,0,0") %>% CRS()


##
## 2. Generate core data objects
##

##
## 3. Create usage data
##

##
## 3. Evaluate tourism usage
##

##
## 4. Analyse proposed zoning scheme
##

##
## 5. Analyse general movement
##

##
## 6. Analyse fisheries indicators
##

##
## 7. Analyse activity at gmr boundary 
##

##
## 8. Dissemination Materials, & Presentations
##

##
## 9. Clean up workspace
##
  # remove paths
    rm(analysis_path,
       biodiversity_locale,
       ecoservices_locale)

  # remove paths for uses
    rm(creation_locale)

