# **Script Settings and Resources**
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(jsonlite)

# Data Import and Cleaning
#rstats_list <- fromJSON("https://www.reddit.com/r/rstats/.json")
#rstats_original_tbl <- rstats_list$data$children$data

rstats_list <- fromJSON("https://www.reddit.com/r/rstats/.json", flatten = TRUE)
rstats_original_tbl <- data_frame(rstats_list$data$children, stringsAsFactors = FALSE)

rstats_tbl <- tibble(rstats_original_tbl) %>%
  mutate(post = data.title) %>%
  mutate(upvotes = data.ups) %>%
  mutate(comments = data.num_comments) %>%
  select(c(post, upvotes, comments))

ggplot(rstats_tbl, aes(x = upvotes, y = comments)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE)
