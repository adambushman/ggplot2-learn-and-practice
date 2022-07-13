###################
# Gague Plots     #
# Using {ggplot2} #
# Adam Bushman    #
###################

library('ggplot2')
library('dplyr')
library('patchwork')


###
# Data Setup
###

data <-
  data.frame(
    client_name = c(
      "Stoney International", 
      "Global Financial of the Globe", 
      "Pearson's Correlary Institute", 
      "Abra Abra and Sons", 
      "Judiciary Juicing"
    ), 
    segment_name = c(
      rep("International", 2), 
      rep("Domestic", 3)
    ), 
    sales_forecast = c(rnorm(2, 100000, 15000), rnorm(3, 450000, 75000))
  ) %>%
  mutate(sales_tally = rnorm(5, sales_forecast * 0.5, sales_forecast * 0.1), 
         perc_to_forecast = round(sales_tally / sales_forecast, 3))


###
# Basic Gague
###

p <-
  ggplot(data, aes(fill = sales_tally / sales_forecast, 
                 ymin = 0, ymax = sales_tally / sales_forecast, 
                 xmin = 1, xmax = 2)) +
  geom_rect(aes(ymin = 0, ymax = 1, xmin = 1, xmax = 2), fill = "#ECE2D0") +
  geom_rect(show.legend = FALSE) +
  coord_polar("y", start = pi/2) +
  xlim(0,2) + ylim(-1,1) +
  theme_void()

p # Quick peek

p <- 
  p + # Additional labeling
  annotate("text", x = 2, y = 0, label = "\n$0", hjust = 0) +
  annotate("text", x = 2, y = 1, 
           label = paste("\n$", round(sum(data$sales_forecast),0), sep = ""), 
           hjust = 1) +
  annotate("text", x = 0, y = 0, 
           label = paste(
             round((sum(data$sales_tally)/sum(data$sales_forecast))*100, 1), 
             "%", 
             sep = ""), 
           size = 6) +
  labs(title = "Sales to Forecast") +
  theme(
    plot.title = element_text(hjust = 0.5, size = 15)
  )

p # Final peek


###
# Dual Value Gague
###

p2 <- 
  ggplot(data %>% 
         group_by(segment_name) %>% 
         summarise(s_tally = sum(sales_tally), s_forecast = sum(sales_forecast))) +
  geom_rect(aes(ymin = 0, ymax = 1, xmin = 1, xmax = 2), fill = "#ECE2D0") +
  geom_rect(aes(ymin = 0, ymax = s_tally[1]/s_forecast[1], xmin = 1.49, xmax = 2), 
            fill = "#A26769") +
  geom_rect(aes(ymin = 0, ymax = s_tally[2]/s_forecast[2], xmin = 1, xmax = 1.51), 
            fill = "#6D2E46") +
  coord_polar("y", start = pi/2) +
  xlim(0,2) + ylim(-1,1) +
  theme_void()

p2 # Quick Peek

p2 <- 
  p2 +
  annotate("text", x = 2, y = 0, 
           label = "\nDomestic", 
           color = "#A26769", 
           hjust = 0) +
  annotate("text", x = 2, y = 0, 
           label = "\n\n\nInternational", 
           color = "#6D2E46", 
           hjust = 0) +
  labs(title = "Sales to Forecast", 
       subtitle = "By Segment") +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 16), 
    plot.subtitle = element_text(hjust = 0.5, face = "italic", size = 11)
  )

p2 # Final peek


###
# Faceted Gagues
###

p3 <- 
  ggplot(data, aes(fill = perc_to_forecast, 
                 ymin = 0, ymax = perc_to_forecast, 
                 xmin = 1, xmax = 2)) +
  geom_rect(aes(ymin = 0, ymax = 1, xmin = 1, xmax = 2), fill = "#ECE2D0") +
  geom_rect(show.legend = FALSE) +
  coord_polar("y", start = pi/2) +
  xlim(0,2) + ylim(-1,1) +
  facet_wrap(~client_name) +
  geom_text(aes(x = 0, y = 0, 
                label = paste(round(perc_to_forecast*100, 1), "%", sep = "")), 
            size = 4) +
  theme_void()

p3 # Quick peek

p3 <- 
  p3 +
  labs(title = "Sales to Forecast", 
       subtitle = "By Client Name") +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 16, vjust = 12), 
    plot.subtitle = element_text(hjust = 0.5, face = "italic", size = 11, vjust = 20)
  )

p3 # Final peek


###
# Gague with Needle and Ticks
###

p4 <- 
  ggplot() +
  geom_rect(aes(ymin = 0, ymax = 1, xmin = 1.5, xmax = 1.75), fill = "#F9F6F1") +
  geom_rect(data = data, aes(ymin = 0, 
                             ymax = sum(sales_tally) / sum(sales_forecast), 
                             xmin = 1.25, xmax = 1.5), 
            fill = '#A26769') +
  coord_polar("y", start = pi/2) +
  xlim(0,2) + ylim(-1,1) +
  theme_void()

p4 # Quick peek

p4 <- 
  p4 +
  geom_segment(aes(x = rep(1.65, 5), 
                   xend = rep(1.85, 5), 
                   y = seq(from = 0, to = 1, by = 1/4), 
                   yend = seq(from = 0, to = 1, by = 1/4)), 
               color = '#565656', 
               size = 2) +
  geom_segment(aes(x = rep(1.7, 13), 
                   xend = rep(1.8, 13), 
                   y = seq(from = 0, to = 1, by = 1/12), 
                   yend = seq(from = 0, to = 1, by = 1/12)), 
               color = '#565656', 
               size = 1.35) +
  geom_segment(aes(x = 0, 
                   xend = 1.55, 
                   y = sum(data$sales_tally) / sum(data$sales_forecast), 
                   yend = sum(data$sales_tally) / sum(data$sales_forecast)), 
               color = '#565656', 
               size = 3) +
  geom_point(aes(x = 0, y = 0), size = 6, color = "#565656")


p4 # Final peek


###
# Gague with Zones
###

p5 <- 
  ggplot() +
  geom_rect(aes(ymin = 0, ymax = (1/3)+0.01, xmin = 1, xmax = 2), fill = "#DA2B3D") +
  geom_rect(aes(ymin = 1/3, ymax = (2/3)+0.01, xmin = 1, xmax = 2), fill = "#FFE74C") +
  geom_rect(aes(ymin = 2/3, ymax = 1, xmin = 1, xmax = 2), fill = "#8CC235") +
  coord_polar("y", start = pi/2) +
  xlim(0,2) + ylim(-1,1) +
  theme_void()


p5 # Quick peek

p5 <- 
  p5 +
  geom_segment(aes(x = 0, 
                   xend = 1.55, 
                   y = 0.8, 
                   yend = 0.8), 
               color = '#565656', 
               size = 3) +
  geom_point(aes(x = 0, y = 0), size = 6, color = "#565656")


p5 # Final peek


###
# Save Gague Examples
###

p + p2 + p4 + p5
