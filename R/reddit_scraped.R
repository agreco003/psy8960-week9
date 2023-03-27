# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(rvest)
# library(httr)
# set_config(add_headers(`User-Agent` = "UMN Researcher greco031@umn.edu"))

rstats_html <- read_html("https://old.reddit.com/r/rstats/")

post <- rstats_html %>%
  html_elements(css = '.odd .title.may-blank, .even .title.may-blank' ) %>%
  html_text()

upvotes <- rstats_html %>% 
  html_elements(css = '.odd .score.unvoted, .even .score.unvoted') %>%
  html_text() %>%
  na_if("•") %>%
  as.numeric() %>%
  replace_na(replace = 0)

comments <- rstats_html %>% 
  html_elements(css = '.odd .first, .even .first') %>%
  html_text() %>% 
  str_remove(".?comment?.?") %>%
  as.numeric() %>%
  replace_na(replace = 0)

rstats_tbl <- tibble(post, upvotes, comments)

ggplot(rstats_tbl, aes(x = upvotes, y = comments)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE)

HTMLcor <- cor.test(x = rstats_tbl$upvotes, y = rstats_tbl$comments)

#Publication
paste("The correlation between upvotes and comments was r(", HTMLcor$parameter, ") = ", str_remove(round(HTMLcor$estimate, digits = 2), "^0+"),", p = ", str_remove(round(HTMLcor$p.value, digits = 2),"^0+"),". This test was not statistically significant.", sep = "")


#XPATH 
#post <- rstats_html %>% 
#html_elements(xpath = '//*[contains(concat( " ", @class, " " ), concat( " ", "title", " " )) and contains(concat( " ", @class, " " ), concat( " ", "outbound", " " ))] | //*[(@id = "thing_t3_11zn9bu")]//*[contains(concat( " ", @class, " " ), concat( " ", "title", " " )) and contains(concat( " ", @class, " " ), concat( " ", "may-blank", " " ))] | //*[(@id = "thing_t3_11zgjfx")]//*[contains(concat( " ", @class, " " ), concat( " ", "title", " " )) and contains(concat( " ", @class, " " ), concat( " ", "may-blank", " " ))] | //*[contains(concat( " ", @class, " " ), concat( " ", "self", " " ))]//*[contains(concat( " ", @class, " " ), concat( " ", "title", " " )) and contains(concat( " ", @class, " " ), concat( " ", "may-blank", " " ))]') %>%
#html_text()

#upvotes <- rstats_html %>% 
  #html_elements(xpath = '//*[contains(@class, "even") or contains(@class, "odd")]//div[@class = "score unvoted"]') %>%
  #html_text() %>%
  #as.numeric() %>%
  #replace_na(replace = 0)

#comments <- rstats_html %>% 
  #html_elements(xpath = '//*[contains(concat( " ", @class, " " ), concat( " ", "comments", " " ))]') %>%
  #html_text() %>% 
  #str_remove(".?comment?.?") %>%
  #as.numeric() %>%
  #replace_na(replace = 0)