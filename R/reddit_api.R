# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(jsonlite)
# Needs to be done first time only
# library(httr)
# set_config(add_headers(`User-Agent` = "UMN Researcher greco031@umn.edu"))

# Data Import and Cleaning
#rstats_list <- fromJSON("https://www.reddit.com/r/rstats/.json")
#rstats_original_tbl <- rstats_list$data$children$data

rstats_list <- fromJSON("https://www.reddit.com/r/rstats/.json", flatten = TRUE)
rstats_original_tbl <- tibble(rstats_list$data$children, stringsAsFactors = FALSE)

rstats_tbl <- tibble(rstats_original_tbl) %>%
  mutate(post = data.title, 
         upvotes = data.ups,
         comments = data.num_comments) %>%
  select(c(post, upvotes, comments))

ggplot(rstats_tbl, aes(x = upvotes, y = comments)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE)

JSONcor <- cor.test(x= rstats_tbl$upvotes, rstats_tbl$comments)

# Publication
paste("The correlation between upvotes and comments was r(", JSONcor$parameter, ") = ", str_remove(round(JSONcor$estimate, 2), "^0+"),", p = ", str_remove(round(JSONcor$p.value, 2),"^0+"),". This test was not statistically significant.", sep = "")