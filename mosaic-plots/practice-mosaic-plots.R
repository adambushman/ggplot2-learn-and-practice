####################
# Mosaic Plots     #
# Using {ggplot2}  #
# Adam Bushman     #
####################

library('tidyverse')
library('camcorder')


###
# Plot Export Setup
###

camcorder::gg_record(
  dir = 'C:/Users/Adam Bushman/Pictures/_test', 
  device = 'png', 
  width = 12, 
  height = 12, 
  units = 'cm', 
  dpi = 300
)


###
# Data Setup
###

data <- 
  data.frame(
    regions = c(
      rep("North East", 20), 
      rep("South East", 20),
      rep("Midwest", 20), 
      rep("South West", 20), 
      rep("North West", 20)
    ), 
    store = paste(
      "Store #", 
      sample(1:100, 100), 
      sep = ""
    ), 
    category = rep(c(
      rep("Printers", 10), 
      rep("Paper", 10)
    ), 5), 
    inventory = c(
      round(rnorm(10, 2500, 250), 0), 
      round(rnorm(10, 1000, 100), 0), 
      round(rnorm(10, 1500, 150), 0), 
      round(rnorm(10, 600, 60), 0), 
      round(rnorm(10, 3500, 350), 0), 
      round(rnorm(10, 140, 140), 0), 
      round(rnorm(10, 1000, 100), 0), 
      round(rnorm(10, 400, 40), 0), 
      round(rnorm(10, 3000, 300), 0), 
      round(rnorm(10, 1200, 120), 0)
    )
  )

head(data)



