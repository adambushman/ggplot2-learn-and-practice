###############################################
# Practice with geoplotting                   #
# Using {tidycensus}, {tidyverse}, & {tigris} #
# Adam Bushman                                #
###############################################

#install.packages('tidycensus')
#install.packages('tigris')
library('tidycensus')
library('tidyverse')
library('tigris')
library('sf')
library('stringr')
library('scales')


# Populate your API KEYS (the below are fake)
# census_api_key('2461f8c6a6e700c9a9cd5f2795c45347e4045A68', install = TRUE)
# register_google(key = 'aIzaSyCFd4FGbI7axkMV4iS63rl-SvJGfT4m3F4')

# Checking out the variables
v1 <- load_variables(2020, "pl", cache = TRUE)
view(v1)


# Data setup
countyDF <- get_decennial(geography = "county",
                       variables = "H1_001N", 
                       state = "North Carolina", 
                       year = 2020, 
                       geometry = TRUE)


# Basic {tigris} visualization

plot(countyDF['value'])


# Basic {ggplot} visualization
ggplot(data = countyDF, aes(fill = value)) +
  geom_sf() +
  scale_fill_distiller(palette = "RdPu") +
  theme_void()



# Additional labels and unique color scale
breakpoint = mean(countyDF$value)/max(countyDF$value)
ggplot(data = countyDF, aes(fill = value)) +
  geom_sf() +
  scale_fill_gradientn(colors = c('#6883BA', '#F6E8EA', '#EF626C'), 
                       values = c(0, breakpoint, 1),
                       limits = c(0, max(countyDF$value)),
                       labels = label_comma(suffix = "K", 
                                            bigmark = ",", 
                                            scale = 1e-3)) +
  labs(title = 'Texas Population by County', 
       subtitle = 'Per US Decennial Census 2020', 
       fill = 'Population') +
  guides(fill = guide_colorbar(barheight = 15)) +
  theme_void() +
  theme(plot.title = element_text(hjust = 0.5, size = 18, face = 'bold'), 
        plot.subtitle = element_text(hjust = 0.5, size = 13, face = 'italic'), 
        legend.title = element_text(size = 10, face = "bold"))


# Plotting city points and labels

cities = tigris::places("North Carolina", cb = TRUE) %>%
  filter(NAME %in% c('Bryson City', 'Edenton', 'Blowing Rock', 'Seagrove', 'Manteo', 
                     'Sylva', 'Hillsborough', 'Washington', 'Highlands', 'Pittsboro', 
                     'Banner Elk', 'Mount Airy')) %>%
  st_transform(.) %>%
  st_centroid(.)

breakpoint = mean(countyDF$value)/max(countyDF$value)
ggplot() +
  geom_sf(data = countyDF, aes(fill = value)) +
  scale_fill_gradientn(colors = c('#6883BA', '#F6E8EA', '#EF626C'), 
                       values = c(0, breakpoint, 1),
                       limits = c(0, max(countyDF$value)),
                       labels = label_comma(suffix = "K", 
                                            bigmark = ",", 
                                            scale = 1e-3)) +
  geom_sf(data = cities, color = "black", size = 4) +
  geom_sf_label(data = cities, aes(label = NAME), 
                hjust = 0, 
                vjust = 0) +
  labs(title = 'North Carolina Population by County', 
       subtitle = 'Per US Decennial Census 2020', 
       fill = 'Population') +
  guides(fill = guide_colorbar(barheight = 15)) +
  theme_void() +
  theme(plot.title = element_text(hjust = 0.5, size = 18, face = 'bold'), 
        plot.subtitle = element_text(hjust = 0.5, size = 13, face = 'italic'), 
        legend.title = element_text(size = 10, face = "bold"))
  