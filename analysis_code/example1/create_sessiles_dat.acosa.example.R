##
##  Name:       create_sessiles_dat.acosa.R 
##
##  Objective:  Create percent cover data objects for ACOSA, Costa Rica
##
##  Approach:   Import data for sessiles and species, converted to
##              long format.
##
##              Data objects saved to *.rda.
##
##  Authors:    Franz Smith, Juan José Alvarado & Jorge Cortés
##              Department of Ecology & Evolutionary Biology, Brown University 
##              Universidad de Costa Rica
##
##  Date:       2019-01-29
##

##
## 1. Set up
##
  # point to data locale
    data_locale <- "data_raw/costa_rica/acosa/"

##
## 2. Import sessiles
##
 ## -- call to 2013-2014 data -- ##
  # point to data file 
    fondo_file <-
      "FONDO monitoreo ACOSA_ACT_ACMIC 2013_2014  CIMAR_CI.xlsx"

  # call to sessiles data
    sessiles_dat.acosa <-
      paste0(data_locale, fondo_file) %>%
      read_excel(sheet = "FONDO")

  # set fecha to date
    sessiles_dat.acosa %<>%
      mutate(Fecha                 = Fecha                 %>% as.Date(),
             `fecha de digitación` = `fecha de digitación` %>% as.Date()) 

 ## -- import 2017 data -- ##
  # point to data file
    file_2017 <- "Fondo_ACOSA2017_COMPLETO.xlsx"

  # call to data
    sessiles_dat.acosa_2017 <-
      paste0(data_locale, file_2017) %>%
        read_excel(sheet = "FONDO") %>%
        mutate(Fecha = Fecha %>%
                         as.numeric() %>% 
                         as.Date(origin = "1899-12-30"),
               `fecha de digitación` = `fecha de digitación` %>% 
                         as.numeric() %>% 
                         as.Date(origin = "1899-12-30")) %>%
     distinct()

 ## -- import 2006 data -- ##
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

##
## 4. Import species
##
  # call to species
    sessiles_species.acosa <-
      paste0(data_locale, fondo_file) %>%
      read_excel(sheet = "spp")

  # join species data
    sessiles_species.acosa %<>%
      bind_rows(paste0(data_locale, file_2017) %>%
                  read_excel(sheet = "spp") %>%
                  dplyr::select(Codigo  = Codigo...1,
                                `Nombre cientifico`,
                                a,
                                b,
                                `Nombre comun español`,
                                `nombre comun ingles`,
                                Autor,
                                NT,
                                GF,
                                `uicn red list`,
                                cites,
                                Codigo...15,
                                agrupacion)) %>%
      distinct()

  # group with 2006 species
    sessiles_species.acosa %<>%
      mutate(Source = "2013-2017") %>%
      bind_rows(sessiles_dat.acosa_2006 %>%
                  mutate(`Nombre cientifico` = Taxa,
                         agrupacion          = Taxa) %>%
                  dplyr::select(`Nombre cientifico`,
                                agrupacion) %>%
                  mutate(Source = "2006"))

##
## 5. Groom data
##
  # set core data into long format
    sessiles_dat.acosa %<>%
      gather(Quadrat, Value,
             -`# sitio`,
             -`Area de Conservacion`,
             -Localidad,
             -Sitio,
             -Buzo,
             -Transecto,
             -Fecha,
             -digitador,
             -`fecha de digitación`,
             -Profundidad,
             -`Categoria prof`,
             -Codigo,
             -Categoría,
             -Promedio,
             -Porcentaje,
             -Agrupacion)

   # remove totals
     sessiles_dat.acosa %<>%
       dplyr::filter(!Quadrat %in% c("Total"))

   # bind with 2006 data
     sessiles_dat.acosa %<>%
       bind_rows(sessiles_dat.acosa_2006 %>%
                   mutate(QUADRAT = QUADRAT %>% as.character()) %>%
                   dplyr::select(Fecha,
                                 Sitio            = SITE,
                                 Buzo             = OBSERVER,
                                 `Categoria prof` = DEPTH,
                                 Quadrat          = QUADRAT,
                                 Agrupacion       = Taxa,
                                 Value,
                                 Total            = TOTAL))


 ## -- add dataset id -- ##
  # set id
    dat_id <- "gulfo_dulce_2006-2014"

  # set id
    sessiles_dat.acosa %<>%
      mutate(Dataset_id = dat_id)


##
## 6. Generate outputs
##
  # point to save locale
    save_locale <- "data_intermediate/costa_rica/acosa/"

  # save sessiles
    save(sessiles_dat.acosa,
      file = paste0(save_locale, "sessiles_dat.acosa.rda"))

  # save species table
    save(sessiles_species.acosa,
      file = paste0(save_locale, "sessiles_species.acosa.rda"))


 ## -- clean up workspace -- ##
  # remove pathways
    rm(data_locale,
       fondo_file,
       file_2017,
       file_2006,
       save_locale)

  # remove species tables
    rm(sessiles_species.acosa)

  # remove core data objects
    rm(sessiles_dat.acosa_2006,
       sessiles_dat.acosa_2017,
       sessiles_dat.acosa)

