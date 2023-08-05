############################
# Histogram/Density Charts #
# {ggplot2}                #
# Adam Bushman             #
############################


library('tidyverse')

###
# Visual Setup
###

camcorder::gg_record(
  dir = 'waffle-chart', 
  device = "png", 
  width = 16, 
  height = 11,
  units = "cm", 
  dpi = 300
)

###
# Function Setup
###

expand <- function(perc) {
  seq1 = 0:(as.integer(perc * 100) - 1)
  seq2 = (as.integer(perc * 100)):99
  
  return(list(
    slice = seq1, 
    converse = seq2
  ))
}

to_seq <- function(p1, p2) {
  return(list(vals = p1:p2))
}

###
# Data Setup
###


###
# Basic example
###

data <- 
  # Main data setup
  tibble(
    year = c(2021, 2022), 
    perc = c(0.18, 0.07)
  ) %>%
  # Determine ranges of waffle chart to color
  mutate(
    expand = purrr::map(perc, expand)
  ) %>%
  unnest(expand) %>%
  mutate(
    len = purrr::map_int(expand, length), 
    my_fill = ifelse(len == as.integer(perc * 100), "#F4AC45", "#6C6060")
  ) %>%
  unnest(expand) %>%
  # Setup logic for x/y rectangle coordinates
  mutate(
    x = ((expand %% 10) * 5) + 2, 
    x2 = ((expand %% 10) * 5) + 6,
    y = (floor(expand / 10) * 5) + 2, 
    y2 = (floor(expand / 10) * 5) + 6
  )


###
# Vizualization
###

ggplot() +
  # Plot the rectangles
  geom_rect(
    aes(
      xmin = x, xmax = x2, ymin = y, ymax = y2, 
      fill = my_fill
    ),
    data, 
    show.legend = FALSE
  ) +
  # Plot the top label
  # (allows for customization where facet title won't)
  geom_text(
    aes(
      x = x, 
      y = y, 
      label = label
    ), 
    # Group up the data to proper summary values
    data %>% 
      group_by(year) %>%
      summarise(
        x = ((max(x2) - min(x)) / 2) + min(x), 
        y = max(y2) + 5, 
        label = paste0(unique(year), ": ", unique(perc) * 100, '%')
      ), 
    size = 6, 
    color = "#F4AC45"
  ) +
  # Use the color values in variable mapped to fill
  scale_fill_identity() + 
  # Make a graph by country with a single row
  facet_wrap(~year, nrow = 1) +
  # Custom labels
  labs(
    title = "An example title", 
    subtitle = "An example subtitle we may or may not care about",
    caption = "An example caption"
  ) + 
  # Adjust the theme for basic needs
  theme_void() +
  theme(
    text = element_text(color = "#D9D3D3"), 
    plot.margin = margin(10, 15, 10, 15), 
    plot.background = element_rect(fill = "#363030", color = NA), 
    strip.text = element_blank(), 
    plot.title = element_text(size = 20, face = "bold", margin = margin(0, 0, 3, 0)), 
    plot.subtitle = element_text(size = 13, margin = margin(0, 0, 10, 0))
  )


###
# Advanced example
###

data <- 
  # Main data setup
  tibble(
    country = c(rep("UK", 4), rep("US", 4)), 
    category = rep(c("air", "sea", "train", "car"), 2), 
    perc = c(
      0.32, 0.29, 0.21, 0.18, 
      0.42, 0.12, 0.09, 0.37
  )
) %>%
  # Determine ranges of waffle chart to color
  group_by(country) %>%
  mutate(
    perc2 = cumsum(perc) - 0.01, 
    perc1 = lag(perc2, default = -0.01) + 0.01, 
    perc2 = as.integer(perc2 * 100),
    perc1 = as.integer(perc1 * 100)
  ) %>%
  mutate(
    expand = purrr::map2(perc1, perc2, to_seq)
  ) %>%
  unnest(expand) %>%
  # Add custom colors
  mutate(
    my_fill = case_when(
      category == "air" ~ "#D00000", 
      category == "sea" ~ "#3F88C5", 
      category == "train" ~ "#FFBA08", 
      category == "car" ~ "#1B9D8C"
    )
  ) %>%
  # Setup logic for x/y rectangle coordinates
  unnest(expand) %>%
  mutate(
    x = ((expand %% 10) * 5) + 2, 
    x2 = ((expand %% 10) * 5) + 6,
    y = (floor(expand / 10) * 5) + 2, 
    y2 = (floor(expand / 10) * 5) + 6
  )


###
# Vizualization
###

ggplot() +
  # Plot the rectangles
  geom_rect(
    aes(
      xmin = x, xmax = x2, ymin = y, ymax = y2, 
      fill = my_fill
    ),
    data, 
    show.legend = FALSE
  ) +
  # Plot the top label
  # (allows for customization where facet title won't)
  geom_text(
    aes(
      x = x, 
      y = y, 
      label = label
    ), 
    # Group up the data to proper summary values
    data %>% 
      group_by(country) %>%
      summarise(
        x = ((max(x2) - min(x)) / 2) + min(x), 
        y = max(y2) + 5, 
        label = paste0(unique(country))
      ), 
    size = 7, 
    color = "#292400"
  ) +
  # Use the color values in variable mapped to fill
  scale_fill_identity() + 
  # Make a graph by country with a single row
  facet_wrap(~country, nrow = 1) +
  # Custom labels including a subtitle with markdown
  labs(
    title = "An example title", 
    subtitle = glue::glue(
      "An example subtitle we may or may not care about<br>",
      "<i style='color:#D00000'>**AIR**</i>, ", 
      "<i style='color:#3F88C5'>**SEA**</i>, ", 
      "<i style='color:#FFBA08'>**TRAIN**</i>, and ", 
      "<i style='color:#1B9D8C'>**CAR**</i>"
    ),
    caption = "An example caption"
  ) + 
  # Adjust the theme for basic needs
  theme_void() +
  theme(
    text = element_text(color = "#292400"), 
    plot.margin = margin(10, 15, 10, 15), 
    plot.background = element_rect(fill = "#FFFDED", color = NA), 
    strip.text = element_blank(), 
    plot.title = element_text(size = 20, face = "bold", margin = margin(0, 0, 3, 0)), 
    plot.subtitle = ggtext::element_markdown(size = 13, lineheight = 1.15, margin = margin(0, 0, 10, 0))
  )
