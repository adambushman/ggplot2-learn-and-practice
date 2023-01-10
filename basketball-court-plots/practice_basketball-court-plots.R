library('tidyverse')
library('hoopR')
library('sportyR')


df_pbp <- hoopR::load_nba_pbp()
colnames(df_pbp)

test <- 
  df_pbp |> 
  filter(type_text == 'Step Back Jump Shot') |> 
  select(coordinate_x, coordinate_y, score_value) |> 
  group_by(coordinate_x, coordinate_y) |>
  summarise(
    freq = n(), 
    .groups = 'drop'
  )

jazz_list = list(
  offensive_half_court = "#FDFBE7", 
  defensive_half_court = "#FDFBE7", 
  court_apron = "#050505", 
  free_throw_circle_fill = "#FDFBE7", 
  center_circle_fill = "#FDFBE7", 
  center_circle_outline = "#050505", 
  painted_area = c("#FDFBE7"), 
  restricted_arc = "#050505",
  free_throw_circle_dash = "#050505", 
  lane_space_mark = "#050505", 
  two_point_range = "#FDFBE7",
  backboard = "#050505"
)

geom_basketball(
  league = "NBA", 
  rotation = 270, 
  display_range = "offense", 
  color_updates = jazz_list, 
  x_trans = -42, 
  y_trans = 25
) +
  geom_point(
    data = test, 
    aes(coordinate_x, coorinate_y, color = freq), 
    alpha = 0.7, 
    show.legend = FALSE
  ) +
  scale_color_gradient(low = "blue", high = "red")
  
