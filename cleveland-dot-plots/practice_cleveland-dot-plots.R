##################################
# Cleveland Dot Plots w/ ggplot2 #
#                                #
# Adam Bushman                   #
##################################

library('ggplot2')
library('scales')
library('dplyr')

data <- data.frame(
  products = rep(c('13-in Laptop', '8-in Tablet', 'Desktop Tower', '32-in Monitor'), 2),
  month = c(rep('May', 4), rep('June', 4)),
  traffic = round(rnorm(8, 2000000, 300000), 0),
  sales = round(rnorm(8, 50000, 750), 2)
)

ggplot(data, aes(sales, products)) +
  geom_line(aes(group = products)) +
  geom_point(aes(color = month, size = traffic)) +
  ggtitle("Sales and Traffic Differences by Family", "A Comparison of May and June") +
  labs(size = "Sales", colour = "Month") +
  scale_size_continuous(labels = label_number(suffix = "K", scale = 1e-3)) +
  xlab("Sales") +
  theme_minimal()
