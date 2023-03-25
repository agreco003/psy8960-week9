# **Script Settings and Resources**
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(jsonlite)

# Data Import and Cleaning
rstats_list <- fromJSON("https://www.reddit.com/r/rstats/.json")

rstats_original_tbl <- rstats_list
rstats_tbl <- tibble(rstats_original_tbl) 

%>%
  mutate(post = title) %>%
  mutate(upvotes = ups) %>%
  mutate(comments = num_comments) %>%
  select()