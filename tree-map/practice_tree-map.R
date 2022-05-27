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


# Simple Tree Map

ggplot(data, aes(area = inventory
                 , label = paste(location, '\n', inventory, sep = '')
                 , fill = group
                 , subgroup = group)) +
  geom_treemap()


# Adding labels, titles, etc.

ggplot(data, aes(area = inventory
                 , label = paste(location, '\n', inventory, sep = '')
                 , fill = group
                 , subgroup = group)) +
  geom_treemap() +
  geom_treemap_text(colour = "white", place = "centre") +
  labs(title = 'Inventory Totals Across Retailers') +
  labs(subtitle = 'Product Category: TV')


# Playing with different borders, groupings, and colors

ggplot(data, aes(area = inventory
                 , label = paste(location, '\n', inventory, sep = '')
                 , fill = group
                 , subgroup = group)) +
  geom_treemap() +
  scale_fill_manual(values = c('#987284', '#9DBF9E')) +
  geom_treemap_text(colour = "white", place = "centre") +
  geom_treemap_subgroup_border(colour = "black") +
  labs(title = 'Inventory Totals Across Retailers') +
  labs(subtitle = 'Product Category: TV')


# New group, group labels, etc.

ggplot(data, aes(area = inventory
                 , label = paste(location, '\n', inventory, sep = '')
                 , fill = group
                 , subgroup = item)) +
  geom_treemap() +
  scale_fill_manual(values = c('#987284', '#9DBF9E')) +
  geom_treemap_text(colour = "white", place = "centre") +
  geom_treemap_subgroup_border(colour = "black") +
  geom_treemap_subgroup_text(colour = "black", size = 10, place = "topleft", alpha = 0.6) +
  labs(title = 'Inventory Totals Across Retailers') +
  labs(subtitle = 'Product Category: TV')


# Adding additional sub-group, changing label

ggplot(data, aes(area = inventory
                 , label = paste(prettyNum(inventory, big.mark = ","))
                 , fill = group
                 , subgroup = item
                 , subgroup2 = location)) +
  geom_treemap() +
  scale_fill_manual(values = c('#987284', '#9DBF9E')) +
  geom_treemap_text(colour = "white", place = "centre") +
  geom_treemap_subgroup2_border(colour = "gray") +
  geom_treemap_subgroup_border(colour = "black") +
  geom_treemap_subgroup_text(colour = "black", size = 15, place = "topleft", alpha = 0.6) +
  geom_treemap_subgroup2_text(colour = "black", size = 10, place = "bottomleft", alpha = 0.6) +
  labs(title = 'Inventory Totals') +
  labs(subtitle = 'By Category and Retailer')
