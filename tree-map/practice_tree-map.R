####################################
# Tree Map                         #
# Using {ggplot2} and {treemapify} #
# Adam Bushman                     #
####################################

# install.packages('treemapify')
library('ggplot2')
library('treemapify')
library('dplyr')

data = data.frame (
  item = c(rep('TV', 6), rep('Sound Bar', 6)),
  location = rep(c('Amazon', 'Walmart', 'Target'), 4),
  inventory = c(round(rnorm(6, 1000, 600), 0), round(rnorm(6, 500, 300), 0)),
  group = rep(c(rep('Old', 3), rep('New', 3)), 2)
) %>% mutate(inventory = ifelse(inventory < 0, 0, inventory))



ggplot(data %>% filter(item == 'TV'), aes(area = inventory
                 , label = paste(location, '\n', inventory, sep = '')
                 , fill = group
                 , subgroup = group)) +
  geom_treemap() +
  geom_treemap_text(colour = "white", place = "centre") +
  labs(title = 'Inventory Totals Across Retailers') +
  labs(subtitle = 'Product Category: TV')
