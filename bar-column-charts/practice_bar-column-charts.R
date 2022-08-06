#################################
# Bar & Column Charts Practice  #
# Using {ggplot2}               #
# Adam Bushman                  #
#################################

library('dplyr')
library('ggplot2')
library('scales')
library('forcats')
library('camcorder')


camcorder::gg_record(
  dir = 'C:/Users/Adam Bushman/Pictures/_test', 
  device = 'png', 
  width = 12, 
  height = 9, 
  units = "cm", 
  dpi = 300
)


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
p <- 
  data %>%
  left_join(data %>%
              group_by(salesman) %>%
              summarise(total = sum(sales))) %>%
  mutate(sales_adj = sales / total, 
         sales_lab = paste("$", round(sales/1000, 0), "K", sep="")) %>% 
  group_by(salesman) %>%
  arrange(salesman, fct_rev(month)) %>%
  mutate(sales_pos = cumsum(sales_adj) - sales_adj + ifelse(sales_lab == "$0K", -0.03, 0.03)) %>%
  
  
  ggplot(aes(sales_adj, salesman, label = sales_lab)) +
  geom_bar(aes(fill = month), stat = "identity") +
  labs(
    title = "Office Sales Share by Month per Salesmen", 
    y = "", 
    x = "",
    fill = ""
  ) +
  theme_minimal()

p


# Advanced, styled chart
p +
  geom_label(aes(x = sales_pos, fill = month), 
             size = 2.5, show.legend = FALSE) +
  labs(subtitle = "Percent of Sales for each Salesman by Month") +
  scale_fill_manual(values = c("#8B8B98", "#E9AFA3", "#AEC5EB", "#F9DEC9")) +
  scale_x_continuous(label = label_number(suffix = "%", scale = 1e2)) +
  guides(fill = guide_legend(override.aes = list(size = 1))) +
  theme(
    plot.background = element_rect(fill = "#FFFCFA", color = NA), 
    legend.position = "top", 
    legend.justification = "left", 
    legend.text = element_text(size = 7), 
    plot.title = element_text(size = 12, face = "bold"), 
    plot.subtitle = element_text(size = 9, face = "italic"), 
    axis.text.y = element_text(face = "bold", size = 8)
  )


camcorder::gg_stop_recording()
