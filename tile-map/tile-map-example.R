library('ggplot2')
library('tilemakr')
library('dplyr')


layout <- tilemakr::tile_layouts$`US States`
layout[3,2] <- 



data <- list(
  # Harris
  list(state = "WA", electoral_votes = 12, candidate = "Harris", margin = "Solid"), 
  list(state = "OR", electoral_votes = 8, candidate = "Harris", margin = "Solid"), 
  list(state = "CA", electoral_votes = 54, candidate = "Harris", margin = "Solid"), 
  list(state = "CO", electoral_votes = 10, candidate = "Harris", margin = "Solid"), 
  list(state = "IL", electoral_votes = 19, candidate = "Harris", margin = "Solid"), 
  list(state = "NY", electoral_votes = 28, candidate = "Harris", margin = "Solid"), 
  list(state = "MD", electoral_votes = 10, candidate = "Harris", margin = "Solid"), 
  list(state = "DC", electoral_votes = 3, candidate = "Harris", margin = "Solid"), 
  list(state = "NJ", electoral_votes = 14, candidate = "Harris", margin = "Solid"), 
  list(state = "DE", electoral_votes = 3, candidate = "Harris", margin = "Solid"), 
  list(state = "CT", electoral_votes = 7, candidate = "Harris", margin = "Solid"), 
  list(state = "VT", electoral_votes = 3, candidate = "Harris", margin = "Solid"), 
  list(state = "MA", electoral_votes = 11, candidate = "Harris", margin = "Solid"), 
  list(state = "ME", electoral_votes = 5, candidate = "Harris", margin = "Solid"), 
  list(state = "HI", electoral_votes = 4, candidate = "Harris", margin = "Solid"), 
  
  # Trump
  list(state = "ID", electoral_votes = 4, candidate = "Trump", margin = "Solid"), 
  list(state = "UT", electoral_votes = 6, candidate = "Trump", margin = "Solid"), 
  list(state = "MT", electoral_votes = 4, candidate = "Trump", margin = "Solid"), 
  list(state = "WY", electoral_votes = 3, candidate = "Trump", margin = "Solid"), 
  list(state = "ND", electoral_votes = 3, candidate = "Trump", margin = "Solid"), 
  list(state = "SD", electoral_votes = 3, candidate = "Trump", margin = "Solid"), 
  list(state = "NE", electoral_votes = 5, candidate = "Trump", margin = "Solid"), 
  list(state = "KS", electoral_votes = 6, candidate = "Trump", margin = "Solid"), 
  list(state = "OK", electoral_votes = 7, candidate = "Trump", margin = "Solid"), 
  list(state = "MO", electoral_votes = 10, candidate = "Trump", margin = "Solid"), 
  list(state = "AR", electoral_votes = 6, candidate = "Trump", margin = "Solid"), 
  list(state = "LA", electoral_votes = 8, candidate = "Trump", margin = "Solid"), 
  list(state = "IN", electoral_votes = 11, candidate = "Trump", margin = "Solid"), 
  list(state = "KY", electoral_votes = 8, candidate = "Trump", margin = "Solid"), 
  list(state = "TN", electoral_votes = 11, candidate = "Trump", margin = "Solid"), 
  list(state = "MS", electoral_votes = 6, candidate = "Trump", margin = "Solid"), 
  list(state = "AL", electoral_votes = 9, candidate = "Trump", margin = "Solid"), 
  list(state = "WV", electoral_votes = 4, candidate = "Trump", margin = "Solid"), 
  list(state = "SC", electoral_votes = 9, candidate = "Trump", margin = "Solid")
)



data <- do.call(rbind, lapply(data, as.data.frame))

shapes <- tilemakr::make_tiles(layout, "hexagon")

df <- shapes |>
  left_join(data, by = join_by(id == state))


              
ggplot() + 
  geom_polygon(
    aes(x, y, group = id), 
    df
  ) + 
  geom_text(
    aes(center_x, center_y, label = id), 
    color = "white", 
    unique.data.frame(df[,c("center_x", "center_y", "id")])
  ) + 
  coord_equal() + 
  theme_void()



