##
##  Name:       create_reef_data.R
##
##  Objective:  Exercise creating reef data for WIO data course
##
##  Approach:   Set site list, number of replicate quadrates,
##              and mean cover for each site.
##
##              Random normal percent cover generated with
##              varying standard deviations.
##
##  Authors:    Franz Smith
##              Dirección Parque Nacional de Galápagos
##              Universidad San Francisco de Quito
##
##  Date:       2021-06-16
##

##
## 1. Set up
##
 # create a list of sites
   site_list <-
     c("coral garden",
       "kanamai",
       "kasa",
       "likoni",
       "nyali",
       "ras iwatine",
       "shark point",
       "shelly")

 ## -- create reef data -- ##
  # set number of replicates
    n_quads <- 5

  # set relative cover per site
    cvr_cor <- 0.60
    cvr_kan <- 0.65
    cvr_kas <- 0.45
    cvr_lik <- 0.78
    cvr_nya <- 0.73
    cvr_ras <- 0.68
    cvr_sha <- 0.76
    cvr_she <- 0.58

  # set seed for reproducibility
    set.seed(3)

  # generate data
    reef_data <-
      data.frame(
        sites         = rep(site_list, each = n_quads),
        quadrate      = rep(seq(1:5), times = length(site_list)),
        percent_cover = c(rnorm(5, cvr_cor, (cvr_cor / 3.0)),
                          rnorm(5, cvr_kan, (cvr_kan / 5.2)),
                          rnorm(5, cvr_kas, (cvr_kas / 3.2)),
                          rnorm(5, cvr_lik, (cvr_lik / 6.8)),
                          rnorm(5, cvr_nya, (cvr_nya / 4.2)),
                          rnorm(5, cvr_ras, (cvr_ras / 4.4)),
                          rnorm(5, cvr_sha, (cvr_sha / 4.1)),
                          rnorm(5, cvr_she, (cvr_she / 5.4)))
        )

    ## -- create reef data -- ##
    # set number of replicates
    n_quads <- 5
    
    # set relative cover per site
    cvr_cor <- 0.60
    cvr_kan <- 0.65
    cvr_kas <- 0.45
    cvr_lik <- 0.78
    cvr_nya <- 0.73
    cvr_ras <- 0.68
    cvr_sha <- 0.76
    cvr_she <- 0.58
    
    # set seed for reproducibility
    set.seed(3)
    
    # generate data
    reef_data <-
      data.frame(
        sites         = rep(site_list, each = n_quads),
        quadrate      = rep(seq(1:5), times = length(site_list)),
        percent_cover = c(rnorm(5, cvr_cor, (cvr_cor / 3.0)),
                          rnorm(5, cvr_kan, (cvr_kan / 5.2)),
                          rnorm(5, cvr_kas, (cvr_kas / 3.2)),
                          rnorm(5, cvr_lik, (cvr_lik / 6.8)),
                          rnorm(5, cvr_nya, (cvr_nya / 4.2)),
                          rnorm(5, cvr_ras, (cvr_ras / 4.4)),
                          rnorm(5, cvr_sha, (cvr_sha / 4.1)),
                          rnorm(5, cvr_she, (cvr_she / 5.4)))
      )
    site_list <-
           c("coral garden",
        "kanamai",
        "kasa",
        "likoni",
        "nyali",
        "ras iwatine",
        "shark point",
        "shelly")
    
    ## -- using indexing to select the quadrate data from "coral garden"  
    
    reef_data[reef_data$sites =="coral garden",] 
    
    #$ used here to define/specify column header with site name
    
    ## QN What if i wanted write the subset data as a data frame?   
    
    #  Subset quadrates 1-3 from each site   
    
    require(magrittr)
    
    reef_data %>% subset(quadrate <=2) #Selects quadrants 1-3 for each site
    
    reef_data[reef_data$quadrate <=3,] # does the same as line 117 above
    
    ## Create a similar subset using a list object, e.g.:
    
    qs_of_interest <-reef_data[reef_data$quadrate <=3,]
    
    #Other optional ways
    #qs_of_interest <- reef_data[which(reef_data$quadrate <=3),]
    #qs_of_interest <- subset(reef_data, quadrate <=3)
      
    ## Calculating mean
    
    reef_data[reef_data$sites == "coral garden",]$percent_cover %>% mean() 
    
    ## Use the function `round()` to roundoff the percent cover values to 3 digits
    
    round(reef_data[reef_data$sites == "coral garden",]$percent_cover %>% mean(),3) # last digit ,x defines # of decimal places
    
    
    ## -- base visualisation -- Use the function `boxplot()` to examine the variation of `percent_cover`for each site
    boxplot(reef_data$percent_cover)
    
    boxplot(percent_cover~sites, data = reef_data, main="variation of percent_cover across sites")
    
    
    