# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(rvest)
# library(httr)
# set_config(add_headers(`User-Agent` = "UMN Researcher greco031@umn.edu"))

#Data import and cleaning
rstats_html <- read_html("https://old.reddit.com/r/rstats/")

post <- html_elements(rstats_html, css = '.odd .title.may-blank, .even .title.may-blank') %>%
  html_text()

upvotes <- html_elements(rstats_html, css = '.odd .score.unvoted, .even .score.unvoted') %>%
  html_text() %>%
  na_if("•") %>%
  as.numeric() %>%
  replace_na(replace = 0)

comments <- html_elements(rstats_html, css = '.odd .first, .even .first') %>%
  html_text() %>% 
  str_remove(".?comment?.?") %>%
  as.numeric() %>%
  replace_na(replace = 0)

rstats_tbl <- tibble(post, upvotes, comments)

# Analyses
ggplot(rstats_tbl, aes(x = upvotes, y = comments)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE)

HTMLcor <- cor.test(x = rstats_tbl$upvotes, y = rstats_tbl$comments)
HTMLcor

#Publication
paste("The correlation between upvotes and comments was r(", HTMLcor$parameter, ") = ", str_remove(round(HTMLcor$estimate, digits = 2), "^0+"),", p = ", str_remove(round(HTMLcor$p.value, digits = 2),"^0+"),". This test was not statistically significant.", sep = "") #could also use sprintf(), format(), or formatC() to remove the leading 0