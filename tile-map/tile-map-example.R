library('ggplot2')
library('tilemakr')
library('dplyr')


layout <- tilemakr::tile_layouts$`US States`
layout[3,2] <- "ID"
layout[4,11] <- "0"




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
  list(state = "FL", electoral_votes = 29, candidate = "Trump", margin = "Likely"), 
  list(state = "PA", electoral_votes = 19, candidate = "Trump", margin = "Tilting")
)



data <- do.call(rbind, lapply(data, as.data.frame))
  
data <- data |> 
  mutate(
    fill = case_when(
      candidate == "Trump" ~ case_when(
        margin == "Safe" ~ "#FF0803", 
        margin == "Likely" ~ "#FF4643", 
        margin == "Leaning" ~ "#FF8785", 
        margin == "Tilting" ~ "#FFAFAD", 
      ), 
      candidate == "Harris" ~ case_when(
        margin == "Safe" ~ "#0000FF", 
        margin == "Likely" ~ "#5C69FF", 
        margin == "Leaning" ~ "#8597FF", 
        margin == "Tilting" ~ "#ADC2FF", 
      )
    )
  )



shapes <- tilemakr::make_tiles(layout, "hexagon")

df <- shapes |>
  left_join(data, by = join_by(id == state)) |>
  mutate(fill = ifelse(is.na(fill), "lightgray", fill))


              
ggplot() + 
  geom_polygon(
    aes(x, y, group = id, fill = fill), 
    df, 
    show.legend = FALSE
  ) + 
  geom_text(
    aes(center_x, center_y, label = id), 
    color = "white", 
    unique.data.frame(df[,c("center_x", "center_y", "id")]), 
    size = 3, 
    vjust = -0.4, 
    fontface = "bold"
  ) + 
  geom_text(
    aes(center_x, center_y, label = electoral_votes), 
    color = "white", 
    unique.data.frame(df[,c("center_x", "center_y", "electoral_votes")]), 
    size = 3, 
    vjust = 1.2
  ) + 
  scale_fill_identity() +
  coord_equal() + 
  theme_void()



