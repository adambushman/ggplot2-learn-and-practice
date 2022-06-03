#####################
# Custom Theme      #
# Using {ggplot2}   #
# Adam Bushman      #
#####################

library('dplyr')
library('ggplot2')
library('showtext')


# Data Setup

data = data.frame(
    date = seq.Date(date('2021-01-01'), date('2021-12-31'), by = 1), 
    inv_SLC = round(rnorm(365, 1000, 250), 0), 
    inv_LA = round(rnorm(365, 1000, 250), 0), 
    inv_PHX = round(rnorm(365, 1000, 250), 0)
  ) %>%
  mutate(val_SLC = round(inv_SLC * rnorm(365, 65, 10), 2), 
         val_LA = round(inv_LA * rnorm(365, 85, 24), 2), 
         val_PHX = round(inv_PHX * rnorm(365, 45, 12), 2)) %>%
  pivot_longer(cols = c(inv_SLC:val_PHX), names_to = c(".value", "location"), names_sep = "_") %>%
  rename(inventoryTotal = inv, inventoryValuation = val)


# {ggplot} Custom Theme

font_add_google('Montserrat', 'Mont')

my_theme <- 
  ggplot2::theme_minimal() +
  ggplot2::theme(
    # Text
    text = element_text(color = '#252627', family = 'Mont'),
    plot.title = element_text(hjust = 0.5, face = 'bold', size = 18),
    plot.subtitle = element_text(hjust = 0.5, face = "italic", size = 13), 
    # Plot area
    plot.background = element_rect(fill = '#f2efe9'),
    panel.grid = element_line(color = '#d7b377'),
    axis.text = element_text(color = '#252627'), 
    axis.title = element_text(face = 'bold', size = 12)
  )



# Examples with custom theme

p1 <- 
  ggplot(data, aes(date, inventoryValuation)) +
  geom_line(aes(color = location)) +
  labs(title = "Inventory Valuation by Location",
       subtitle = "Year of 2021",
       x = 'Date',
       y = 'Value of Inventory',
       color = 'Location')

# Line Graph
p1 + my_theme 


p2 <- 
  ggplot(data, aes(location, inventoryTotal)) +
  geom_boxplot(aes(color = location)) +
  labs(title = "Inventory Distribution by Location",
       subtitle = "Daily Totals for Year of 2021",
       x = 'Location',
       y = 'Inventory Totals',
       color = 'Location')

# Box Plot
p2 + my_theme 


p3 <-
  ggplot(data, aes(inventoryTotal, inventoryValuation)) +
  geom_point(aes(color = location), size = 3, alpha = 0.7) +
  labs(title = "Inventory Valuation vs Totals",
       subtitle = "Year of 2021 by Location",
       x = 'Inventory Total',
       y = 'Value of Inventory',
       color = 'Location')

# Scatter Plot
p3 + my_theme


data.alt <-
  data %>% 
  mutate(period = ifelse(date < '2021-07-01', '1H', '2H')) %>%
  group_by(period, location) %>%
  summarise(inventoryTotal = sum(inventoryTotal), .groups = 'drop')

p4 <-
  ggplot(data.alt, aes(inventoryTotal, location)) +
  geom_line(alpha = 0.85) +
  geom_point(aes(color = period), size = 5, alpha = 0.8) +
  ggtitle("Sales and Traffic Differences by Family", "A Comparison of May and June") +
  labs(title = 'Inventory Total Comparison',
       subtitle = '2021 1st/2nd Half', 
       x = 'Inventory Total', 
       y = 'Location', 
       colour = 'Period')

# Cleveland Dot Plot
p4 + my_theme

