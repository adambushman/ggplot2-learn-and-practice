###########################
# Beeswarm Plots          #
# {ggplot2}, {ggbeeswarm} #
# Adam Bushman            #
###########################


library('tidyverse')
library('ggbeeswarm')

# Data Setup

data <-
  tibble(
    player_name = c(
      "Lauri Markkanen", 
      "Jordan Clarkson", 
      "Malik Beasley", 
      "Collin Sexton", 
      "Mike Conley", 
      "Kelly Olynyk", 
      "Talen Horton-Tucker", 
      "Jarred Vanderbilt", 
      "Walker Kessler", 
      "Nickeil Alexander-Walker", 
      "Rudy Gay", 
      "Ochai Agbaji", 
      "Simone Fontecchio"
    ), 
    TSp = c(
      0.657, 0.562, 0.535, 0.62, 0.552, 
      0.638, 0.494, 0.607, 0.698, 0.609, 
      0.472, 0.617, 0.491
    ), 
    TSAgm = c(
      18.9, 18.7, 12.5, 11.5, 9.7, 9.5, 7.8, 
      6.8, 5.9, 5.2, 5.1, 3.7, 3.7
    )
  )


# Visualization

# Basic beeswarm

ggplot(
  data, 
  aes(x = "Utah Jazz", y = TSp)
) +
  geom_beeswarm(
    shape = 21, 
    fill = "#f6ee26", 
    color = "black", 
    stroke = 1.25, 
    size = 3, # Controls radius
    cex = 3.5 # Controls spacing
  ) +
  coord_flip() +
  scale_y_continuous(
    labels = scales::label_percent()
  ) +
  labs(
    title = "Efficiency Distribution", 
    subtitle = "Utah Jazz players and their true shooting percentage efficiency", 
    y = "True Shooting Percentage", 
    x = ""
  )


# Advanced beeswarm

ggplot(
  data, 
  aes(
    x = "Utah Jazz", 
    y = TSp, 
    label = stringr::str_sub(
      player_name, 
      stringr::str_locate(player_name, " ")[,1], 
      stringr::str_length(player_name)
    )
  )
) +
  geom_beeswarm(
    aes(size = TSAgm), 
    shape = 21, 
    fill = "#f6ee26", 
    color = "black", 
    stroke = 1.25, 
    cex = 5
  ) +
  ggrepel::geom_text_repel(
    aes(point.size = TSAgm), 
    max.overlaps = Inf, 
    min.segment.length = 0
  ) +
  coord_flip() +
  scale_y_continuous(
    labels = scales::label_percent()
  ) +
  labs(
    title = "Efficiency Distribution", 
    subtitle = "Utah Jazz players and their true shooting percentage efficiency", 
    y = "True Shooting Percentage", 
    x = ""
  )

