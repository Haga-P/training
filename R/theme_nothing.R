## update to theme_nothing
theme_nothing <- function (base_size = 12, base_family = "sans") 
{
    theme_bw(base_size = base_size, base_family = base_family) %+replace% 
        theme(rect              = element_blank(), 
              line              = element_blank(), 
              axis.ticks.length = unit(0.01, "cm"), 
              # axis.ticks.margin = unit(0, "lines"),   ## depreciated
              axis.text         = element_blank(), 
              axis.ticks        = element_blank(), 
              axis.title        = element_blank())
}
