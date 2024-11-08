library('ggplot2')
library('tilemakr')
library('dplyr')


layout <- tilemakr::tile_layouts$`US States`


electoral <- list(
  list(state = "WA", electoral_votes = 12),
  list(state = "OR", electoral_votes = 8),
  list(state = "CA", electoral_votes = 54),
  list(state = "CO", electoral_votes = 10),
  list(state = "NM", electoral_votes = 5),
  list(state = "IL", electoral_votes = 19),
  list(state = "NY", electoral_votes = 28),
  list(state = "MD", electoral_votes = 10),
  list(state = "DC", electoral_votes = 3),
  list(state = "NJ", electoral_votes = 14),
  list(state = "DE", electoral_votes = 3),
  list(state = "CT", electoral_votes = 7),
  list(state = "VT", electoral_votes = 3),
  list(state = "MA", electoral_votes = 11),
  list(state = "ME", electoral_votes = 4),
  list(state = "HI", electoral_votes = 4),
  list(state = "RI", electoral_votes = 4),
  list(state = "AK", electoral_votes = 3),
  list(state = "NV", electoral_votes = 6),
  list(state = "TX", electoral_votes = 40),
  list(state = "AZ", electoral_votes = 11),
  list(state = "ID", electoral_votes = 4),
  list(state = "UT", electoral_votes = 6),
  list(state = "MT", electoral_votes = 4),
  list(state = "WY", electoral_votes = 3),
  list(state = "ND", electoral_votes = 3),
  list(state = "SD", electoral_votes = 3),
  list(state = "NE", electoral_votes = 5),
  list(state = "KS", electoral_votes = 6),
  list(state = "OK", electoral_votes = 7), 
  list(state = "MO", electoral_votes = 10),
  list(state = "AR", electoral_votes = 6),
  list(state = "LA", electoral_votes = 8),
  list(state = "IN", electoral_votes = 11),
  list(state = "KY", electoral_votes = 8),
  list(state = "TN", electoral_votes = 11),
  list(state = "MS", electoral_votes = 6),
  list(state = "AL", electoral_votes = 9),
  list(state = "WV", electoral_votes = 4),
  list(state = "SC", electoral_votes = 9),
  list(state = "NH", electoral_votes = 4),
  list(state = "MN", electoral_votes = 10),
  list(state = "IA", electoral_votes = 6),
  list(state = "OH", electoral_votes = 17),
  list(state = "WI", electoral_votes = 10),
  list(state = "MI", electoral_votes = 15),
  list(state = "VA", electoral_votes = 13),
  list(state = "NC", electoral_votes = 16),
  list(state = "GA", electoral_votes = 16),
  list(state = "FL", electoral_votes = 30),
  list(state = "PA", electoral_votes = 19)
)



electoral <- do.call(rbind, lapply(electoral, as.data.frame))


results <- list(
  Harris = c(
    "WA", "OR", "CA", "CO", "NM", "IL", "NY", "VT", "ME", "NH", "MA", "CT", 
    "RI", "NJ", "DE", "DC", "MD", "VA", "MN", "HI"
  ), 
  Trump = c(
    "FL", "GA", "SC", "NC", "WV", "PA", "OH", "KY", "IN", "TN", "AL", "MS", 
    "LA", "AR", "MO", "IA", "KS", "TX", "OK", "NE", "SD", "ND",
    "MT", "ID", "WY", "UT",
  )
)

results_df <- data.frame(
  candidate = rep(names(results), sapply(results, length)),
  state = unlist(results, use.names = FALSE)
) |>
  mutate(
    flip = state %in% c("GA", "WI", "PA")
  )


color_lookup <- list(
  "Harris" = list (
    "Flipped" = "#002B7A", 
    "Safe" = "#0043BF", 
    "Likely" = "#3D70CD", 
    "Leaning" = "#7A9CDA", 
    "Tilting" = "#B7C9E7"
  ), 
  "Trump" = list (
    "Flipped" = "#8F0000", 
    "Safe" = "#D31714", 
    "Likely" = "#DC4F4C", 
    "Leaning" = "#E48684", 
    "Tilting" = "#ECBEBC"
  )
)

get_col <- function(x, y) {
  if(is.na(x)) {
    return("gray")
  } else if(is.na(y)) {
    return(color_lookup[[x]][["Safe"]])
  } else {
    return(color_lookup[[x]][[y]])
  }
}

full_data <- 
  electoral |>
  left_join(results_df) |>
  mutate(margin = as.character(NA)) |>
  mutate(
    fill = purrr::map2_chr(candidate, margin, get_col), 
    text_color = ifelse(margin %in% c("Leaning", "Tilting"), "black", "white"), 
    margin = factor(margin, levels = c("Safe", "Likely", "Leaning", "Tilting"))
  )



shapes <- tilemakr::make_tiles(layout, "hexagon")

df <- shapes |>
  left_join(full_data, by = join_by(id == state)) |>
  mutate(
    fill = ifelse(is.na(fill), "lightgray", fill), 
    pattern_fill = '#8F0000', 
    pattern = ifelse(is.na(flip), "none", ifelse(flip, "stripe", "none"))
  )

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
  na.omit() |>
  mutate(
    x = c(80, 122), 
    y = 140, 
    e_votes = e_votes + ifelse(candidate == "Harris", -2, 0)
  )




ggplot() + 
  ggpattern::geom_polygon_pattern(
    aes(
      x, y, group = id, fill = fill, 
      pattern = pattern, pattern_fill = pattern_fill
    ), 
    df, 
    pattern_density = .5, 
    pattern_spacing = 0.015,
    pattern_color = NA, 
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
  # geom_rect(
  #   aes(xmin = x, xmax = x + 5, ymin = y, ymax = y + 5, fill = color), 
  #   leg
  # ) +
  # geom_text(
  #   aes(
  #     x + 14, y, 
  #     label = margin, 
  #     size = ifelse(candidate == "Harris", 2, 0)
  #   ), 
  #   leg, 
  #   fontface = "bold", 
  #   hjust = 0, 
  #   vjust = -0.4
  # ) + 
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
  geom_point(
    aes(x, y, color = fill), 
    data.frame(
      x = c(100, 233), 
      y = c(63, 129), 
      fill = c("#0043BF", "#D31714")
    ), 
    size = 2
  ) +
  labs(
    title = "2024 Election Tile Map"
  ) +
  ggpattern::scale_pattern_fill_identity() +
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