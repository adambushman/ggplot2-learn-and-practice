library('ggplot2')
library('tilemakr')
library('dplyr')


layout <- tilemakr::tile_layouts$`US States`



data <- list(
  # Harris
  list(state = "WA", electoral_votes = 12, candidate = "Harris", margin = "Safe"), 
  list(state = "OR", electoral_votes = 8, candidate = "Harris", margin = "Leaning"), 
  list(state = "CA", electoral_votes = 54, candidate = "Harris", margin = "Safe"), 
  list(state = "CO", electoral_votes = 10, candidate = "Harris", margin = "Likely"), 
  list(state = "NM", electoral_votes = 5, candidate = "Harris", margin = "Likely"), 
  list(state = "IL", electoral_votes = 19, candidate = "Harris", margin = "Safe"), 
  list(state = "NY", electoral_votes = 28, candidate = "Harris", margin = "Safe"), 
  list(state = "MD", electoral_votes = 10, candidate = "Harris", margin = "Safe"), 
  list(state = "DC", electoral_votes = 3, candidate = "Harris", margin = "Safe"), 
  list(state = "NJ", electoral_votes = 14, candidate = "Harris", margin = "Safe"), 
  list(state = "DE", electoral_votes = 3, candidate = "Harris", margin = "Safe"), 
  list(state = "CT", electoral_votes = 7, candidate = "Harris", margin = "Safe"), 
  list(state = "VT", electoral_votes = 3, candidate = "Harris", margin = "Safe"), 
  list(state = "MA", electoral_votes = 11, candidate = "Harris", margin = "Safe"), 
  list(state = "ME", electoral_votes = 4, candidate = "Harris", margin = "Leaning"), 
  list(state = "HI", electoral_votes = 4, candidate = "Harris", margin = "Safe"), 
  list(state = "RI", electoral_votes = 4, candidate = "Harris", margin = "Safe"), 
  
  # Trump
  list(state = "AK", electoral_votes = 3, candidate = "Trump", margin = "Safe"), 
  list(state = "NV", electoral_votes = 6, candidate = "Trump", margin = "Tilting"), 
  list(state = "TX", electoral_votes = 40, candidate = "Trump", margin = "Leaning"), 
  list(state = "AZ", electoral_votes = 11, candidate = "Trump", margin = "Leaning"), 
  list(state = "ID", electoral_votes = 4, candidate = "Trump", margin = "Safe"), 
  list(state = "UT", electoral_votes = 6, candidate = "Trump", margin = "Safe"), 
  list(state = "MT", electoral_votes = 4, candidate = "Trump", margin = "Safe"), 
  list(state = "WY", electoral_votes = 3, candidate = "Trump", margin = "Safe"), 
  list(state = "ND", electoral_votes = 3, candidate = "Trump", margin = "Safe"), 
  list(state = "SD", electoral_votes = 3, candidate = "Trump", margin = "Safe"), 
  list(state = "NE", electoral_votes = 5, candidate = "Trump", margin = "Likely"), 
  list(state = "KS", electoral_votes = 6, candidate = "Trump", margin = "Safe"), 
  list(state = "OK", electoral_votes = 7, candidate = "Trump", margin = "Safe"), 
  list(state = "MO", electoral_votes = 10, candidate = "Trump", margin = "Likely"), 
  list(state = "AR", electoral_votes = 6, candidate = "Trump", margin = "Safe"), 
  list(state = "LA", electoral_votes = 8, candidate = "Trump", margin = "Safe"), 
  list(state = "IN", electoral_votes = 11, candidate = "Trump", margin = "Safe"), 
  list(state = "KY", electoral_votes = 8, candidate = "Trump", margin = "Safe"), 
  list(state = "TN", electoral_votes = 11, candidate = "Trump", margin = "Safe"), 
  list(state = "MS", electoral_votes = 6, candidate = "Trump", margin = "Safe"), 
  list(state = "AL", electoral_votes = 9, candidate = "Trump", margin = "Safe"), 
  list(state = "WV", electoral_votes = 4, candidate = "Trump", margin = "Safe"), 
  list(state = "SC", electoral_votes = 9, candidate = "Trump", margin = "Likely"),
  
  list(state = "NH", electoral_votes = 4, candidate = "Harris", margin = "Likely"),
  list(state = "MN", electoral_votes = 10, candidate = "Harris", margin = "Leaning"),
  list(state = "IA", electoral_votes = 6, candidate = "Trump", margin = "Leaning"),
  list(state = "OH", electoral_votes = 17, candidate = "Trump", margin = "Likely"),
  list(state = "WI", electoral_votes = 10, candidate = "Trump", margin = "Leaning"),
  list(state = "MI", electoral_votes = 15, candidate = "Trump", margin = "Leaning"), 
  list(state = "VA", electoral_votes = 13, candidate = "Harris", margin = "Leaning"), 
  list(state = "NC", electoral_votes = 16, candidate = "Trump", margin = "Tilting"), 
  list(state = "GA", electoral_votes = 16, candidate = "Trump", margin = "Leaning"), 
  list(state = "FL", electoral_votes = 30, candidate = "Trump", margin = "Likely"), 
  list(state = "PA", electoral_votes = 19, candidate = "Trump", margin = "Tilting")
)



data <- do.call(rbind, lapply(data, as.data.frame))

color_lookup <- list(
  "Harris" = list (
    "Safe" = "#0043BF", 
    "Likely" = "#3D70CD", 
    "Leaning" = "#7A9CDA", 
    "Tilting" = "#B7C9E7"
  ), 
  "Trump" = list (
    "Safe" = "#D31714", 
    "Likely" = "#DC4F4C", 
    "Leaning" = "#E48684", 
    "Tilting" = "#ECBEBC"
  )
)

get_col <- function(x, y) {
  return(color_lookup[[x]][[y]])
}
  
data <- data |> 
  mutate(
    fill = purrr::map2_chr(candidate, margin, get_col), 
    text_color = ifelse(margin %in% c("Leaning", "Tilting"), "black", "white"), 
    margin = factor(margin, levels = c("Safe", "Likely", "Leaning", "Tilting"))
  )



shapes <- tilemakr::make_tiles(layout, "hexagon")

df <- shapes |>
  left_join(data, by = join_by(id == state)) |>
  mutate(fill = ifelse(is.na(fill), "lightgray", fill))

leg <- 
  do.call(rbind, lapply(color_lookup, as.data.frame)) |>
  tibble::rownames_to_column("candidate") |>
  tidyr::pivot_longer(-candidate, names_to = "margin", values_to = "color") |>
  mutate(
    margin = factor(margin, levels = c("Safe", "Likely", "Leaning", "Tilting")), 
    x = c(rep(215, 4), rep(222, 4)), 
    y = rep(seq(20, 20 + (7 * 3), 7), 2)
  )

votes <- 
  df |>
  select(candidate, id, electoral_votes) |>
  distinct() |>
  group_by(candidate) |>
  summarise(e_votes = sum(electoral_votes)) |>
  ungroup() |>
  mutate(
    x = c(80, 122), 
    y = 140
  )



              
ggplot() + 
  geom_polygon(
    aes(x, y, group = id, fill = fill), 
    df, 
    show.legend = FALSE
  ) + 
  geom_text(
    aes(center_x, center_y, label = id, color = text_color), 
    unique.data.frame(df[,c("center_x", "center_y", "text_color", "id")]), 
    size = 2.25, 
    vjust = -0.4, 
    fontface = "bold"
  ) + 
  geom_text(
    aes(center_x, center_y, label = electoral_votes, color = text_color), 
    unique.data.frame(df[,c("center_x", "center_y", "text_color", "electoral_votes")]), 
    size = 2.75, 
    vjust = 1.2
  ) + 
  geom_rect(
    aes(xmin = x, xmax = x + 5, ymin = y, ymax = y + 5, fill = color), 
    leg
  ) +
  geom_text(
    aes(
      x + 14, y, 
      label = margin, 
      size = ifelse(candidate == "Harris", 2, 0)
    ), 
    leg, 
    fontface = "bold", 
    hjust = 0, 
    vjust = -0.4
  ) + 
  geom_rect(
    aes(
      xmin = x, xmax = x + 40, ymin = y, ymax = y + 10, 
      fill = ifelse(candidate == "Trump", "#D31714", "#0043BF")
    ), 
    votes
  ) +
  geom_text(
    aes(
      x, y, label = candidate
    ), 
    votes, 
    color = "white", 
    vjust = -0.7, 
    hjust = -0.1, 
    size = 2.8, 
    fontface = "bold"
  ) + 
  geom_text(
    aes(
      x + 40, y, label = e_votes
    ), 
    votes, 
    color = "white", 
    vjust = -0.7, 
    hjust = 1.2, 
    size = 2.8
  ) + 
  labs(
    title = "2024 Election Tile Map"
  ) +
  scale_color_identity() +
  scale_fill_identity() +
  scale_size_identity() +
  coord_equal() + 
  theme_void() +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5)
  )



camcorder::gg_record(
  'C:/Users/adamb/Pictures/Camcorder',
  device = "jpeg", 
  height = 9, 
  width = 16, 
  units = "cm", 
  dpi = 300
)