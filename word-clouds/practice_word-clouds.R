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
  height = 10, 
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




