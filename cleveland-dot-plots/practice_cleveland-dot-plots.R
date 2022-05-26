##################################
# Cleveland Dot Plots w/ ggplot2 #
# Adam Bushman                   #
##################################

library('ggplot2')
library('scales')
library('dplyr')

data <- data.frame(
  products = rep(c('13-in Laptop', '8-in Tablet', 'Desktop Tower', '32-in Monitor'), 2),
  month = c(rep('May', 4), rep('June', 4)),
  traffic = round(rnorm(8, 2000000, 300000), 0),
  sales = round(rnorm(8, 50000, 7500), 2)
)

ggplot(data, aes(sales, products)) +
  geom_line(aes(group = products)) +
  geom_point(aes(color = month, size = traffic)) +
  ggtitle("Sales and Traffic Differences by Family", "A Comparison of May and June") +
  labs(size = "Traffic", colour = "Month") +
  scale_size_continuous(labels = label_number(suffix = "M", scale = 1e-6)) +
  scale_x_continuous(labels = label_number(prefix = "$", suffix = "K", scale = 1e-3)) +
  ylab("Products") +
  xlab("Sales") +
  theme_minimal()
