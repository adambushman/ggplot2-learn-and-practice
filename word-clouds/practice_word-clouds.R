###################################
# Word Clouds Practice            #
# Using {ggplot2} & {ggwordcoud}  #
# Adam Bushman                    #
###################################

library('tidyverse')
library('ggwordcloud')


# Visual export setup

camcorder::gg_record(
  dir = 'C:/Users/Adam Bushman/Pictures/_test', 
  device = 'png', 
  width = 10, 
  height = 8, 
  units = 'cm', 
  dpi = 300
)


# Data setup

data <- 
  data.frame(
    keyword = c(
      'dressy', 'comfy', 'sporty', 'short sleeve', 
      't-shirt', 'long sleeve', 'button down', 'basketball', 
      'exercise', 'adjustable', 'utah jazz', 'zipper', 'medium', 
      'skinny', 'disney', 'jersey', 'snap back', 'casual', 
      'mission', 'hoodie', 'jabber jazz', 'polo', 'soccer', 
      'fitted', 'flannel', 'spirit jersey', 'star wars', 
      'trucker', 'baseball', 'data', 'jackson hole', 'jeans', 
      'john mayer', 'la dodgers', 'sweats', 'usa', 'all-star', 
      'boots', 'buttons', 'cali', 'camping', 'charleston sc', 
      'chile', 'christmas', 'cincinnati bengals', 'colo-colo', 
      'grow', 'hiking', 'hood', 'marvel', 'one tree hill', 
      'pearsons', 'real salt lake', 'smithsonian', 'the office', 
      'work', 'yard work'
    ), 
    frequency = c(
      51, 35, 35, 34, 31, 25, 16, 15, 14, 12, 11, 11, 10, 10, 9, 8, 
      8, 7, 7, 6, 5, 5, 5, 3, 3, 3, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2, 1, 
      1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    )
  )


head(data)

set.seed(14)



###
# Basic word cloud / No dynamic sizing
###

basic_wc <- 
  ggplot(
    data, 
    aes(label = keyword)
  ) +
  geom_text_wordcloud() +
  theme_minimal()

basic_wc

# Some additional styling

basic_wc +
  labs(
    title = "A Basic Keyword Cloud", 
    subtitle = "In {ggplot2} and {ggwordcloud}"
  ) +
  theme(
    plot.background = element_rect(fill = "#D7DEDC", color = NA), 
    plot.title = element_text(hjust = 0.5, face = "bold", size = 16), 
    plot.subtitle = element_text(hjust = 0.5, face = "italic", size = 10)
  )


###
# Intermediate word cloud with dynamic sizing
###

inter_wc <- 
  ggplot(
    data, 
    aes(label = keyword, size = frequency)
  ) +
  geom_text_wordcloud() +
  theme_minimal()

inter_wc

# Additional styling

inter_wc +
  labs(
    title = "An Intermediate Keyword Cloud", 
    subtitle = "In {ggplot2} and {ggwordcloud}"
  ) +
  scale_size_area(max_size = 12) +
  theme(
    plot.background = element_rect(fill = "#D7DEDC", color = NA), 
    plot.title = element_text(hjust = 0.5, face = "bold", size = 16), 
    plot.subtitle = element_text(hjust = 0.5, face = "italic", size = 10)
  )

