##################################
# NBA Expansions                 #
# A look at cities and divisions #
# Using {ggplot2} & {usmap}      #
# Adam Bushman                   #
##################################

library('usmap')
library('ggmap')
library('ggplot2')
library('dplyr')
library('ggrepel')


# Data setup
# Ensure local repository is your working directory
data = read.csv('nba-expansion-data.csv')

# Register using your own key (below is fake)
register_google(key = 'AIzaSyCFd4FGbI7axkMV4iS63rl-SvJGfT4m3F4')

coords <- 
  data %>% 
  select(location) %>%
  unique(.) %>%
  mutate_geocode(., location)

expansionDF <-
  data %>% 
  left_join(., coords, by = c('location' = 'location')) %>%
  select(lon, lat, franchise, location, division, type, author) %>%
  usmap_transform(.)

# Filter by Author
auth = "@adam_bushman"

plot_usmap(regions = c("states"), exclude = c("Alaska", "Hawaii")) +
  geom_point(data = expansionDF %>% filter(author == auth), 
             aes(x = lon.1, y = lat.1, color = division), 
             size = 3) +
  geom_label_repel(data = expansionDF %>% filter(author == auth),
                  aes(x = lon.1, y = lat.1, 
                      label = ifelse(franchise == '', location, franchise), 
                      color = division),
                  size = 2.75,
                  fontface = "bold", 
                  max.overlaps = Inf, 
                  box.padding = 0.5,
                  fill = "white", 
                  show.legend=FALSE) +
  annotate("text", x = -2000000, y = -2000000, 
           label = paste("Expansion Author\n", auth, sep = ''), 
           hjust = 0) +
  labs(title = "Prospective NBA Expansion", 
       subtitle = "32 Teams | 4 Divisions", 
       color = "Divisions") +
  theme(legend.position = "right", 
        plot.title = element_text(size = 20, face = "bold", hjust = 0.5), 
        plot.subtitle = element_text(size = 13, face = "italic", hjust = 0.5))


locationName = c()
divisionName = c()
totalMiles = c()

for(d in unique(expansionDF$division)) {
  teams = expansionDF %>% 
    filter(author == "@adam_bushman" & division == d) %>%
    select(location) %>%
    unlist(., use.names = FALSE)
  
  for(t in teams) {
    total = 0
    
    for(o in (teams[teams != t])) {
      total = total + pracma::haversine(
        rev(unlist(coords[coords$location == t, 2:3], use.names = FALSE)), 
        rev(unlist(coords[coords$location == o, 2:3], use.names = FALSE))
      ) * 0.621371192
    }
    
    locationName[length(locationName)+1] = t
    divisionName[length(divisionName)+1] = d
    totalMiles[length(totalMiles)+1] = total / 8
  }
}

# TRAVEL STUFF

x <- data.frame(locationName, divisionName, totalMiles)

x %>% 
  group_by(divisionName) %>% 
  summarise(avg = mean(totalMiles), range = max(totalMiles) - min(totalMiles)) %>%
  arrange(desc(avg))

x %>% arrange(desc(totalMiles))
