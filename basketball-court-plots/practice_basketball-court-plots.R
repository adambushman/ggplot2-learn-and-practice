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


geom_basketball(
  league = "NBA", 
  display_range = "offense"
) +
  geom_point(
    data = test, 
    aes(coordinate_x, coordinate_y), 
    alpha = 0.5
  )
