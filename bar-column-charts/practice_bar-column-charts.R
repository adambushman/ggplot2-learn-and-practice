#################################
# Bar & Column Charts Practice  #
# Using {ggplot2}               #
# Adam Bushman                  #
#################################

library('dplyr')
library('ggplot2')


# Data setup
data <- 
  data.frame(
    month = sort(rep(c("November", "December", "January", "February"), 6)), 
    salesman = rep(c("Jim", "Dwight", "Stanley", "Phyllis", "Andy", "Warehouse"), 4), 
    sales = rnorm(24, 15000, 6000)
  ) %>%
  mutate(month = factor(month, levels = c("November", "December", "January", "February")))


# Basic column chart
ggplot(data, aes(month, sales)) +
  geom_bar(stat = "identity", fill = "turquoise") +
  labs(
    title = "Office Sales by Month"
  ) +
  theme_minimal()



# Basic bar chart
ggplot(data, aes(sales, month)) +
  geom_bar(stat = "identity", fill = "turquoise") +
  labs(
    title = "Office Sales by Month"
  ) +
  theme_minimal()


# Stacked column chart
ggplot(data, aes(month, sales)) +
  geom_bar(aes(fill = salesman), stat = "identity") +
  labs(
    title = "Office Sales by Month per Salesmen"
  ) +
  theme_minimal()



# Side-by-side column chart
ggplot(data, aes(month, sales)) +
  geom_bar(aes(fill = salesman), stat = "identity", 
           position = "dodge", 
           width = 0.65) +
  labs(
    title = "Office Sales by Month per Salesmen"
  ) +
  theme_minimal()



# 100% column chart
data %>%
  left_join(data %>%
              group_by(month) %>%
              summarise(total = sum(sales))) %>%
  mutate(sales_adj = sales / total) %>%
  
  ggplot(aes(month, sales_adj)) +
  geom_bar(aes(fill = salesman), stat = "identity") +
  labs(
    title = "Office Sales Share by Month per Salesmen", 
    y = ""
  ) +
  theme_minimal()



# 100% bar chart
data %>%
  left_join(data %>%
              group_by(salesman) %>%
              summarise(total = sum(sales))) %>%
  mutate(sales_adj = sales / total) %>%
  
  ggplot(aes(sales_adj, salesman)) +
  geom_bar(aes(fill = month), stat = "identity") +
  labs(
    title = "Office Sales Share by Month per Salesmen", 
    y = ""
  ) +
  theme_minimal()
