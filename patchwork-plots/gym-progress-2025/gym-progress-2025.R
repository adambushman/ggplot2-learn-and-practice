library('tidyverse')
library('ggtext')
library('patchwork')



skeleton <- expand.grid(
  x = 1:8, y = 1:25
)


last_month = "January"


data <- tibble(
  month = month.name
) %>%
  mutate(scans = c(
    20, # January
    # 8, # February
    rep(as.numeric(NA), nrow(.) - 1)
  )) %>%
  filter(!is.na(scans)) %>%
  uncount(scans)


prepped_scans <- data %>%
  bind_rows(
    data.frame(month = rep(as.character(NA), nrow(skeleton) - nrow(data)))
  )

combined_data <-
  skeleton |> 
  bind_cols(prepped_scans) |>
  mutate(my_col = case_when(
    is.na(month) ~ "#343a40", 
    month == last_month ~ "#F0F0F0", 
    TRUE ~ "#e21c37"
  ))


tracker_plot <- 
  ggplot(
    combined_data, 
    aes(x, y, color = my_col)
  ) +
  geom_point(
    shape = 15, 
    size = 2.25
  ) +
  scale_color_identity() + 
  coord_flip() +
  theme(
    plot.margin = margin(0,0,0,0),
    panel.background = element_rect(fill = "#212529", color = NA), 
    
    panel.grid = element_blank(), 
    axis.title = element_blank(), 
    axis.text = element_blank(), 
    axis.ticks = element_blank(), 
    axis.line = element_blank()
  )

pace = nrow(data) - ceiling(as.integer(today() - ymd("2025-01-01")) * 200 / 365)
pace_wording = ifelse(pace > 0, "ahead of", "behind")

text_data <- tibble(
  x = 1:3, 
  y = 1, 
  text = c(
    nrow(data[data$month == last_month,]),
    paste(nrow(data), "/ 200", collapse = " "), 
    pace
  ), 
  desc = c(
    paste(c("Scans in ", last_month), collapse = ""), 
    "Total scans to date", 
    paste(c("Scans", pace_wording, "pace"), collapse = " ")
  ), 
  my_col = c("#f0f0f0", "#e21c37", "#495057")
)


kpi_plot <-
  ggplot() +
  geom_text(
    aes(x, y, label = text, color = my_col), 
    text_data, 
    size = 6, 
    fontface = "bold", 
    vjust = 0
  ) +
  geom_text(
    aes(x, y, label = scales::label_wrap(15)(desc), color = my_col), 
    text_data, 
    size = 2.5, 
    vjust = 1.5
  ) +
  scale_color_identity() +
  ylim(c(0.9625, 1.025)) +
  xlim(c(0.5,3.5)) + 
  theme(
    plot.title = element_text(face = "bold", color = "#F0F0F0"), 
    plot.subtitle = element_text(face = "bold", color = "#F0F0F0"), 

    plot.background = element_rect(fill = "#212529", color = NA), 
    panel.background = element_rect(fill = "#212529", color = NA), 
    
    panel.grid = element_blank(), 
    axis.title = element_blank(), 
    axis.text = element_blank(), 
    axis.ticks = element_blank(), 
    axis.line = element_blank()
  )


description_text = "This goal is about building a sustainable habit of exercise and strength training. In years past, I've achieved consistency over a series of months. The goal of 200 gym visits in 2025 is meant to keep me consistent for an entire year. Let's get it!"


desc_plot <- 
  ggplot() +
  geom_text(
    aes(x, y, label = text), 
    data.frame(
      x = 1, y = 1, 
      text = scales::label_wrap(70)(description_text)
    ), 
    color = "#f0f0f0", 
    size = 2.25, 
    hjust = 0
  ) +
  xlim(1,3) + 
  theme(
    plot.title = element_text(face = "bold", color = "#F0F0F0"), 
    plot.subtitle = element_text(face = "bold", color = "#F0F0F0"), 
    
    plot.background = element_rect(fill = "#212529", color = NA), 
    panel.background = element_rect(fill = "#212529", color = NA), 
    
    panel.grid = element_blank(), 
    axis.title = element_blank(), 
    axis.text = element_blank(), 
    axis.ticks = element_blank(), 
    axis.line = element_blank()
  )


patchwork <- (kpi_plot | desc_plot) / tracker_plot


patchwork +
  theme(
    plot.margin = margin(0,0,0,0), 
    plot.background = element_rect(fill = "#212529", color = NA)
  ) &
  plot_annotation(
    title = "Progress to 200 Gym Days", 
    subtitle = "Adam's 2025 Goal", 
    theme = theme(
      plot.title = element_text(
        size = 16, face = "bold", 
        hjust = 0.5, color = "#F0F0F0", 
        margin = margin(10,0,0,0)
      ), 
      plot.subtitle = element_text(
        size = 8, 
        hjust = 0.5, color = "#F0F0F0", 
        margin = margin(5,0,0,0)
      ), 
      plot.margin = margin(0,5,15,5), 
      plot.background = element_rect(fill = "#212529", color = NA)
    )
  )
  


camcorder::gg_record(
  dir = "~/Pictures/Camcorder", 
  device = "jpeg", 
  width = 16, 
  height = 8, 
  units = "cm",
  dpi = 300
)

camcorder::gg_stop_recording()

