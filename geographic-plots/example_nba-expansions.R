##################################
# NBA Expansions                 #
# A look at cities and divisions #
# Using {ggplot2} & {usmap}      #
# Adam Bushman                   #
##################################

library('usmap')
library('ggplot2')
library('dplyr')
library('ggrepel')


# Data setup
# Ensure local repository is your working directory
data = read.csv('nba-expansion-data.csv')

# Register using your own key (below is fake)
# register_google(key = 'AizaSyCFd4FGbI7axkMV4iS63rl-SvJGfT4m3F3')

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


plot_usmap(regions = c("states"), exclude = c("Alaska", "Hawaii")) +
  geom_point(data = expansionDF %>% filter(author == "@adam_bushman"), 
             aes(x = lon.1, y = lat.1, color = division), 
             size = 3) +
  geom_label_repel(data = expansionDF %>% filter(author == "@adam_bushman"),
                  aes(x = lon.1, y = lat.1, 
                      label = ifelse(franchise == '', location, franchise), 
                      color = division),
                  size = 2.75,
                  fontface = "bold", 
                  max.overlaps = Inf, 
                  box.padding = 0.5,
                  fill = "white", 
                  show.legend=FALSE) +
  labs(title = "Prospective NBA Expansion", 
       subtitle = "32 Teams | 8 Divisions", 
       color = "Divisions") +
  theme(legend.position = "right", 
        plot.title = element_text(size = 20, face = "bold", hjust = 0.5), 
        plot.subtitle = element_text(size = 13, face = "italic", hjust = 0.5))
