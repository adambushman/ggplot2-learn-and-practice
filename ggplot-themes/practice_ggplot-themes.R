######################
# {ggplot2} Themes   #
# Using {ggplot2}    #
# Adam Bushman       #
######################

library('dplyr')
library('ggplot2')


# Data Setup

data = data.frame(
  date = seq.Date(date('2022-01-03'), date('2022-06-27'), by = 7), 
  weight = c(round(rnorm(10, 190, 3), 1), round(rnorm(10, 185, 8), 1), round(rnorm(6, 172, 4), 1)),
  bodyFatPercent = c(round(rnorm(10, 0.18, 0.03), 3), round(rnorm(10, 0.16, 0.08), 3), round(rnorm(6, 0.13, 0.04), 3)),
  muscleMassPercent = c(round(rnorm(10, 0.75, 0.07), 3), round(rnorm(10, 0.8, 0.02), 3), round(rnorm(6, 0.85, 0.04), 3))
)

goals = c(175, 0.149, 0.825)


# Main Plot

plot <- ggplot(data, aes(date, weight)) +
        geom_line(color = '#CA3CFF', size = 1.5) +
        geom_point(color = '#CA3CFF', size = 3.5) +
        geom_hline(yintercept = goals[1], color = '#00D9C0', size = 1.5) +
        labs(title = "Weight Loss Tracking",
              y = "Weight (lbs)",
              x = "Date") +
        annotate("label", label = "Goal Weight", 
                 x = data$date[2],
                 y = goals[1],
                 fill = '#00D9C0') +
        theme_minimal()


# Theme Adjustments 1

plot + theme(plot.title = element_text(hjust = 0.5, face = 'bold', size = 20),
        plot.background = element_rect(fill = '#1E1014'),
        text = element_text(color = '#F9DEC9'),
        panel.grid = element_line(color = '#F9DEC9'),
        axis.text = element_text(color = '#F9DEC9'), 
        axis.title = element_text(face = 'bold', size = 13))
