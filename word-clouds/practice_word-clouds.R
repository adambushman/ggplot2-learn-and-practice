##################################
# Word Clouds Practice           #
# Using {ggplot2} & {wordcloud}  #
# Adam Bushman                   #
##################################

install.packages('rtweet')
#install.packages('wordcloud')
library('dplyr')
library('ggplot2')
library('wordcloud')
library('rtweet')


# Data setup



# Word cloud generation

set.seed(14)
wordcloud(words = kwData$keyword, freq = kwData$freq, 
          min.freq = 1, random.order=FALSE, 
          rot.per=0.35, colors=brewer.pal(8, "Dark2"))


# Adding {ggplot} components