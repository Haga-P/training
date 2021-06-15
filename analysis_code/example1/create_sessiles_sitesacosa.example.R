##
##  Name:       create_sessiles_sites.acosa.R 
##
##  Objective:  Create site locations for ACOSA, Costa Rica
##
##  Approach:   Import data for sites, project coordinates and set in
##              long format.
##
##              Data objects saved to *.rda.
##
##  Authors:    Franz Smith, Juan José Alvarado & Jorge Cortés
##              Department of Ecology & Evolutionary Biology, Brown University 
##              Universidad de Costa Rica
##
##  Date:       2019-02-02
##

##
## 1. Set up
##
 ## -- set up for projections -- ##
  # call to degree, minute, second converter
    source("R/convert_deg-min-sec.R")

  # set utm details
    utm_details <- 
      paste0("+proj=utm +zone=17 +north +datum=WGS84",
             " +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0")

 ## -- import data -- ##
  # point to data locale
    data_locale <- "data_raw/costa_rica/acosa/"

 # -- call to 2013-2014 data -- ##
  # point to data file 
    fondo_file <-
      "FONDO monitoreo ACOSA_ACT_ACMIC 2013_2014  CIMAR_CI.xlsx"

  # call to sites
    sessiles_sites.acosa <-
      paste0(data_locale, fondo_file) %>%
      read_excel(sheet = "Sitios")

 ## -- import 2017 data -- ##
  # point to data file
    file_2017 <- "Fondo_ACOSA2017_COMPLETO.xlsx"

  # merge core data with 2017
    sessiles_sites.acosa_2017 <-
      paste0(data_locale, file_2017) %>%
      read_excel(sheet = "Sitios")

##
## 2. Import 2006 data
##
  # point to file
    file_2006 <- "MATRIZ COBERTURA EVALUACION_IX_2006.xls"

  # call to data
    sessiles_dat.acosa_2006 <-
      paste0(data_locale, file_2006) %>%
      read_excel(sheet = "MATRIZ ORIGINAL") %>%
      rename(Fecha = DATE) %>%
      mutate(Fecha  = gsub("SET", "Sep", Fecha),
             Fecha = Fecha %>% as.Date(format = "%d%b%y"))

  # set into long format
    sessiles_dat.acosa_2006 %<>%
      gather(Taxa, Value,
             -CODE,
             -Fecha,
             -SITE,
             -LATITUDE,
             -LONGITUDE,
             -HABITAT,
             -OBSERVER,
             -DEPTH,
             -QUADRAT,
             -TOTAL,
             -RELIEVE) %>%
       mutate(SITE     = SITE     %>% str_to_title(),
              HABITAT  = HABITAT  %>% str_to_title(),
              OBSERVER = OBSERVER %>% str_to_title(),
              DEPTH    = DEPTH    %>% str_to_title(),
              Taxa     = Taxa     %>% str_to_title())

  # create sites from 2006
    sessiles_sites.acosa_2006 <-
      sessiles_dat.acosa_2006 %>%
        dplyr::select(Sitio     = SITE,
                      Latitude  = LATITUDE,
                      Longitude = LONGITUDE) %>%
        distinct()

##
## 3. Groom data
##
 ## -- join data -- ##
  # combine 2013-2014 and 2017 data
    sessiles_sites.acosa %<>%
      bind_rows(sessiles_sites.acosa_2017 %>%
                  dplyr::select(`#`,
                                Pais,
                                Costa,
                                `Area de Conservacion`,
                                Localidad,
                                Sitio,
                                Latitud,
                                Longitud)) %>%
     distinct()

  # check site list
    # sessiles_sites.acosa %>% data.frame() %>% arrange(Sitio)
 ## -- need to find La Llorona, Peninsula de Osa -- ##
# 40 60 Costa Rica Pacífico  ACOSA Peninsula de Osa  La Llorona  <NA>  <NA>

  # remove NAs
    sessiles_sites.acosa %<>%
      dplyr::filter(!Latitud %>% is.na())

  # clean up coordinates
    sessiles_sites.acosa %<>%
      mutate(Longitud = gsub("O", "W", Longitud)) %>%
      mutate(Latitud  = gsub(" ", "", Latitud),
             Longitud = gsub(" ", "", Longitud)) %>%
      mutate(Latitud  = gsub("''", '"', Latitud),
             Longitud = gsub("''", '"', Longitud))

  # convert to decimal degree
    sessiles_sites.acosa %<>%
      mutate(Latitud  = Latitud  %>% dg2dec(Dg = "°", Min = "'", Sec = '"'),
             Longitud = Longitud %>% dg2dec(Dg = "°", Min = "'", Sec = '"'))

  # bind with 2006 sites
    sessiles_sites.acosa %<>%
      bind_rows(sessiles_sites.acosa_2006 %>%
                  rename(Latitud  = Latitude,
                         Longitud = Longitude))

##
## 4. Project coordinates
##
  # get site coordinates
    sites_xy <- 
      sessiles_sites.acosa %>% 
        dplyr::select(Longitud, Latitud)

  # convert to spatial points
    sitePositions <- 
      sites_xy %>% 
        SpatialPoints(proj4string = CRS("+proj=longlat +ellps=WGS84"))

  # project
    sitePositions <- sitePositions %>% spTransform(CRS = utm_details)

  # get coordinates
    sites_xy.utm <- sitePositions %>% coordinates()

  # bind with the site positions & trim
    sessiles_sites.acosa %<>%
      bind_cols(sites_xy.utm %>% as_tibble()) %>%
      dplyr::select(Pais,
                    `Area de Conservacion`,
                    Localidad,
                    Sitio,
                    Longitud,
                    Latitud,
                    easting  = Longitud1,
                    northing = Latitud1)

##
## 5. Generate outputs
##
  # point to save locale
    save_locale <- "data_intermediate/costa_rica/acosa/"

  # save sites
    save(sessiles_sites.acosa,
      file = paste0(save_locale, "sessiles_sites.acosa.rda"))


 ## -- clean up workspace -- ##
  # remove pathways
    rm(data_locale,
       fondo_file,
       file_2017,
       file_2006,
       save_locale)

  # clean up spatial objects
    rm(utm_details,
       sites_xy,
       sitePositions,
       sites_xy.utm)

  # remove intermediate objects
    rm(sessiles_sites.acosa_2017,
       sessiles_dat.acosa_2006,
       sessiles_sites.acosa_2006)

  # remove core data objects
    rm(sessiles_sites.acosa)

