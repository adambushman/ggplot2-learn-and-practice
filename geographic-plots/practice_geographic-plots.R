##############################################
# Practice with geoplotting                  #
# Using {tidycensus}, {tidyverse}, & {usmap} #
# Adam Bushman                               #
##############################################

#install.packages('tidycensus')
#install.packages('tigris')
library('tidycensus')
library('tidyverse')
library('tigris')
library('usmap')
library('stringr')

# Populate your API KEY (the below is fake)
# census_api_key('2461f8c6a6e700c9a9cd5f2795c45347e4045A68', install = TRUE)


# Checking out the variables
v1 <- load_variables(2020, "pl", cache = TRUE)
view(v1)


# Data setup
countyDF <- get_decennial(geography = "county",
                       variables = "H1_001N", 
                       state = "Texas", 
                       year = 2020, 
                       geometry = TRUE)


# Basic tigris visualization

plot(countyDF['value'])


# Basic ggplot visualization
ggplot(data = countyDF, aes(fill = value)) +
  geom_sf() +
  scale_fill_gradient2(low = '#6883BA', mid = '#F6E8EA', high = '#EF626C', 
                       midpoint = median(countyDF$value)) +
  labs(title = 'Texas Population by County', 
       subtitle = 'Per US Decennial Census 2020', 
       fill = 'Population') +
  theme_void() +
  theme(plot.title = element_text(hjust = 0.5, size = 18, face = 'bold'), 
        plot.subtitle = element_text(hjust = 0.5, size = 13, face = 'italic'))

  