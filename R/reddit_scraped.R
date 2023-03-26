# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)

ggplot(rstats_tbl, aes(x = upvotes, y = comments)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE)

HTMLcor <- cor.test(x= rstats_tbl$upvotes, rstats_tbl$comments)

#Publication
paste("The correlation between upvotes and comments was r(", HTMLcor$parameter, ") = ", str_remove(round(HTMLcor$estimate, 2), "^0+"),", p = ", str_remove(round(HTMLcor$p.value, 2),"^0+"),". This test was not statistically significant.", sep = "")