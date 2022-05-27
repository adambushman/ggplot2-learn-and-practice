####################################
# Tree Map                         #
# Using {ggplot2} and {treemapify} #
# Adam Bushman                     #
####################################


library('ggplot2')
library('dplyr')

data = data.frame(
  opponent = rep(c(rep("DEN", 7), rep("MEM", 5), rep("LAC", 6), rep("DAL", 4)), 2), 
  type = c(rep("Opponent",22), rep("Team", 22)), 
  fga3 = c(
    ofga3 = c(39.05, 30.68, 40.86, 47.31, 36.84, 39.13, 35.23, 20.41, 23, 42.27, 35.35, 38.61, 45.65, 30.93, 38.3, 39.78, 42.55, 42.86, 35.96, 53.41, 44.68, 45.3), 
    tfga3 = c(44.76, 50, 39.78, 31.52, 36.56, 39.13, 38.64, 48.45, 38.61, 44.79, 33.66, 42.72, 54.35, 41.05, 47.31, 45.16, 57.45, 47.83, 24.72, 33.33, 30.11, 31.3)
  )
)


library('ggplot2')

p = c("#00538C", "#FEC524", "#C8102E", "#707271")

ggplot(data = data, aes(type, fga3)) +
  geom_jitter(size = 3, width = 0.15) +
  stat_summary(fun = mean, geom = "line", aes(group = opponent), size = 1.5) +
  scale_color_manual(values = p) +
  aes(color = opponent) +
  ggtitle("Playoff 3PAs by Jazz and Opponents", "Since 2019-20 Season") +
  ylab("3PAs per 100 Poss") +
  xlab("") +
  theme_minimal()
