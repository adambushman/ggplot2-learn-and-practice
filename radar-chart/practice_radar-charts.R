#####################
# Radar Charts      #
# {ggplot2}, {fmsb} #
# Adam Bushman      #
#####################


library('fmsb')
library('tidyverse')

# Data Setup
data <- data.frame(
  category = sort(rep(c('Sleeping Bags', 'Backpacks', 'Camp Pads', 
                   'Tents', 'Cots', 'Accessories'), 3)), 
  client = rep(paste('Client', c('A', 'B', 'C'), sep="_"), 6), 
  units = round(rnorm(18, 1000, 500), 0)
) %>%
  mutate(units = ifelse(units < 0, 0, units)) %>%
  pivot_wider(names_from = client, values_from = units)
  

# radarchart(data)

