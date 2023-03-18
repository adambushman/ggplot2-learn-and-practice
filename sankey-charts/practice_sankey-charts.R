####################################
# Sankey Chart                     #
# Using {networkD3} and {ggsankey} #
# Adam Bushman                     #
####################################


# install.packages('ggsankey')
# install.packages('networkD3')
library('ggplot2')
library('ggsankey')
library('networkD3')
library('dplyr')


# Data Setup

data <- data.frame(
  start_career = c("ATL", "ATL", "BKN", "BKN", "CHA"),  
  end_career = c("BOS", "BKN", "CHA", "CHI", "CHI"), 
  value = c(3, 6, 1, 2, 8)
)

nodes <- data.frame(
  name = c(
    as.character(data$start_career), 
    as.character(data$end_career)
  ) %>% unique()
)

data$IDstart <- match(data$start_career, nodes$name)-1 
data$IDend <- match(data$end_career, nodes$name)-1


# Basic Viz

sankeyNetwork(
  Links = data, 
  Nodes = nodes, 
  Source = "IDstart", 
  Target = "IDend", 
  Value = "value", 
  NodeID = "name", 
  sinksRight=FALSE
)
