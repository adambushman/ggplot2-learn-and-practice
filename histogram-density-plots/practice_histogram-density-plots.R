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
  dir = 'C:/Users/Adam Bushman/Pictures/_test', 
  device = "png", 
  width = 16, 
  height = 9,
  units = "cm", 
  dpi = 300
)

###
# Data Setup
###

data <-
  tibble(
    store_name = c(
      rep("Farmington, UT", 20), 
      rep("St. George, UT", 20)
    ), 
    store_sales = round(
      sample(
        rnorm(100, 1000, 300)
        , 40
      )
      , 2
    ), 
    store_visits = ceiling(
      sample(
        rnorm(100, 5000, 700), 
        40
      )
    )
  )


###
# Basic Histogram
###

ggplot(
  data
) +
  geom_histogram(
    aes(store_sales), 
    bins = 10, 
    fill = "salmon"
  )

###
# Basic Density
###

ggplot(
  data
) +
  geom_density(
    aes(store_visits), 
    fill = "turquoise", 
    alpha = 0.7
  )

###
# Two Category Histogram
###

h <-
  ggplot(
    data
  ) +
  geom_histogram(
    aes(store_sales, fill = store_name), 
    alpha = 0.7, 
    bins = 10
  )

h


###
# Two Category Density
###

d <-
  ggplot(
    data
  ) +
  geom_density(
    aes(store_visits, fill = store_name), 
    alpha = 0.5, 
    color = "darkgray"
  )

d +
  scale_y_continuous(labels = scales::label_percent()) +
  scale_x_continuous(labels = scales::label_comma()) +
  labs(
    title = "Simple Density Example", 
    subtitle = "Mock store sales by location", 
    x = "Store Visits", 
    y = "Density", 
    fill = ""
  ) +
  theme(
    legend.position = "top", 
    legend.justification = "left", 
    plot.background = element_rect(fill = "#FFFFFF")
  )


###
# Advanced Histogram
###

h +
  scale_x_continuous(labels = scales::label_dollar()) +
  labs(
    title = "Advanced Histogram Example", 
    x = "Store Sales", 
    y = "Count", 
    fill = ""
  ) +
  theme_minimal() +
  theme(
    legend.position = "top", 
    legend.justification = 0, 
    plot.background = element_rect(fill = "#FFFFFF")
  )


###
# Advanced Density
###

d +
  scale_x_continuous(labels = scales::label_number(big.mark = ",")) +
  scale_y_continuous(labels = scales::label_percent()) +
  labs(
    title = "Advanced Density Example", 
    x = "Store Visits", 
    y = "Density", 
    fill = ""
  ) +
  theme_minimal() +
  theme(
    legend.position = "top", 
    legend.justification = 0, 
    plot.background = element_rect(fill = "#FFFFFF")
  )


###
# Basic 2D Density
###

ggplot(
  data
) +
  geom_density2d(
    aes(store_sales, store_visits), 
    color = "maroon"
  )





###
# Basic 2D Density with Two Categories
###

ggplot(
  data, 
  aes(store_sales, store_visits)
) +
  geom_density_2d(
    aes(color = store_name)
  )


###
# Advanced 2D Density
###

ggplot(
  data, 
  aes(store_sales, store_visits)
) +
  stat_density_2d(
    geom = "polygon", 
    contour = TRUE,
    aes(fill = after_stat(level)), 
    color = "gray", 
    bins = 5
  )

###
# Advanced 2D Density with Two Categories
###

ggplot(
  data, 
  aes(
    store_sales, store_visits
  )
) +
  stat_density_2d(
    geom = "polygon", 
    aes(alpha = after_stat(level), fill = store_name), 
    color = "darkgray", 
    bins = 5
  ) +
  scale_x_continuous(labels = scales::label_dollar()) +
  scale_y_continuous(labels = scales::label_number(big.mark = ",")) +
  labs(
    title = "Advanced 2D Density Example", 
    subtitle = "Mock store sales vs visits between two stores", 
    x = "Store Sales", 
    y = "Store Visits", 
    fill = "", 
    alpha = "Density"
  ) +
  theme_minimal() +
  theme( 
    legend.justification = 0, 
    plot.background = element_rect(fill = "#FFFFFF")
  )
