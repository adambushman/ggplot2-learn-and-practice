#################################
# Bar & Column Charts Practice  #
# Using {ggplot2}               #
# Adam Bushman                  #
#################################

library('dplyr')
library('ggplot2')


# Data setup



# Basic bar chart

ggplot(data = clothing %>% count(Type), 
       aes(x = n, y = reorder(Type, n))) +
  geom_bar(stat = "identity", aes(fill = Type), 
           show.legend = FALSE) +
  labs(title = 'Clothing Category Frequency',
       subtitle = 'Wardrobe Database', 
       y = '', 
       x = 'Count of Items in Wardrobe') +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = 'bold'), 
    plot.subtitle = element_text(hjust = 0.5, size =12, face = 'italic')
  )