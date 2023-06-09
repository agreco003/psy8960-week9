# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(jsonlite)
# Needs to be done first time only
# library(httr)
# set_config(add_headers(`User-Agent` = "UMN Researcher greco031@umn.edu"))

# Data Import and Cleaning
rstats_list <- fromJSON("https://www.reddit.com/r/rstats/.json", flatten = TRUE)


rstats_tbl <- tibble(rstats_list$data$children, stringsAsFactors = FALSE) %>%
  mutate(post = data.title, 
         upvotes = data.ups, #upvotes = data.score could also work for this JSON, but ups used because of instructions
         comments = data.num_comments) %>%
  select(c(post, upvotes, comments))

# Visualization
ggplot(rstats_tbl, aes(x = upvotes, y = comments)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE)

# Analyses
JSONcor <- cor.test(x = rstats_tbl$upvotes, y = rstats_tbl$comments)
JSONcor

# Publication
paste("The correlation between upvotes and comments was r(", JSONcor$parameter, ") = ", str_remove(round(JSONcor$estimate, digits = 2), "^0+"),", p = ", str_remove(round(JSONcor$p.value, digits = 2),"^0+"),". This test was not statistically significant.", sep = "")