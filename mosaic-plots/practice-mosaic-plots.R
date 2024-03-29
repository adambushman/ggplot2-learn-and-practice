####################
# Mosaic Plots     #
# Using {ggplot2}  #
# Adam Bushman     #
####################

library('tidyverse')
library('camcorder')


###
# Plot Export Setup
###

camcorder::gg_record(
  dir = 'C:/Users/Adam Bushman/Pictures/_test', 
  device = 'png', 
  width = 12, 
  height = 12, 
  units = 'cm', 
  dpi = 300
)


###
# Data Setup
###

data <- 
  data.frame(
    regions = c(
      rep("North East", 20), 
      rep("South East", 20),
      rep("Midwest", 20), 
      rep("South West", 20), 
      rep("North West", 20)
    ), 
    store = paste(
      "Store #", 
      sample(1:100, 100), 
      sep = ""
    ), 
    category = rep(c(
      rep("Printers", 10), 
      rep("Paper", 10)
    ), 5), 
    inventory = c(
      round(rnorm(10, 2500, 250), 0), 
      round(rnorm(10, 1000, 100), 0), 
      round(rnorm(10, 1500, 150), 0), 
      round(rnorm(10, 600, 60), 0), 
      round(rnorm(10, 3500, 350), 0), 
      round(rnorm(10, 140, 140), 0), 
      round(rnorm(10, 1000, 100), 0), 
      round(rnorm(10, 400, 40), 0), 
      round(rnorm(10, 3000, 300), 0), 
      round(rnorm(10, 1200, 120), 0)
    )
  )

head(data)


###
# Data Transform
###

data_clean <-
  data %>%
  # Sum up sales and inventory by regions and store
  group_by(regions, category) %>%
  summarise(
    tInventory = sum(inventory), 
    .groups = "drop"
  ) %>%
  ungroup(.) %>%
  # Save a copy for later
  assign("grpd", ., envir = .GlobalEnv) %>%
  # Setup variables for the X and Y limits per category
  group_by(category) %>%
  mutate(
    high = cumsum(tInventory), 
    low = high - tInventory
  ) %>%
  ungroup(.) %>%
  group_by(regions) %>%
  mutate(
    xmax = max(high), 
    xmin = max(low)
  ) %>%
  ungroup(.) %>%
  inner_join(
    ., 
    (
      grpd %>%
        group_by(regions) %>%
        mutate(
          ymax_s = cumsum(tInventory), 
          ymin_s = ymax_s - tInventory
        ) %>%
        ungroup(.)
    )
  ) %>%
  # Setup y-axis label
  mutate(
    xmax_s = xmax / max(xmax, xmin), 
    xmin_s = xmin / max(xmax, xmin)
  ) %>%
  mutate(
    ylab = ymax_s, 
    ylab_s = 0, 
    lab_s = ifelse(category == "Paper", regions, ""), 
    xlab = ((xmax_s - xmin_s) / 2) + xmin_s, 
  ) %>%
  select(lab_s, category, tInventory, xmax_s, xmin_s, ymax_s, ymin_s, xlab, ylab, ylab_s, fills)




###
# Basic Mosaic Plot using geom_rect
###

p_basic <-
  ggplot(
  data_clean, 
  aes(
    xmax = xmax_s, xmin = xmin_s, 
    ymax = ymax_s, ymin = ymin_s, 
    fill = category,
  )
) +
  geom_rect(color = "black", size = 0.5)

p_basic


###
# Advanced Mosaic Plot
###

p_advanced <-
  p_basic +
  scale_fill_manual(values = c("#9E577C", "#B195A5")) +
  geom_label(
    aes(x = xlab, y = ylab, label = format(tInventory, big.mark = ",")), 
    size = 2.5
  ) +
  ggrepel::geom_text_repel(
    aes(x = xlab, y = ylab_s, label = lab_s), 
    segment.color = NA, 
    hjust = 1,
    angle = 22.5, 
    nudge_y = -500, 
    size = 2.75
  ) +
  scale_y_continuous(
    labels = scales::label_number(scale = 1e-3, big.mark = ",", suffix = "K"), 
    limits = c(-5000, 42500)
  ) +
  labs(
    title = "Inventory Levels", 
    subtitle = "By Category & Region"
  ) +
  annotate("segment", x = 0, xend = 0.310, y = 41000, yend = 41000, color = "#402926", 
           arrow = arrow(ends = "both", angle = 90, length = unit(.1,"cm"))) +
  annotate("text", x = 0, y = 42500, color = "#402926", hjust = 0, size = 2.5, 
           label = "Region inventory proportion")
  guides(
    fill = guide_legend(title = "", override.aes = aes(label = ""))
  ) +
  theme_minimal() +
  theme(
    legend.position = "top", 
    text = element_text(color = "#402926"), 
    plot.title = element_text(hjust = 0.5, face = "bold", size = 16), 
    plot.subtitle = element_text(hjust = 0.5, face = "italic", size = 10), 
    plot.background = element_rect(fill = "#F8F2F4", color = NA), 
    panel.grid = element_line(color = "#DFCECF"), 
    axis.title = element_blank(), 
    axis.text.x = element_blank()
  )


p_advanced

