library(ggplot2)
library(stringr)
library(dplyr)
library(tidytext)

rep_con_data <- readRDS("data/rep_con_data.rds")

covarying_viz <- function(rep_con_form){
  
  matched <-  rep_con_data %>%
    #filter(metric %in% c("obs.w1_2.in_c", "coll.strength")) %>%
    filter(construction.name == rep_con_form)
  
  require(showtext)
  showtext_auto()
  
  p <- ggplot(matched, aes(x=reorder_within(pair, strength, metric), y=strength)) +
    geom_bar(stat="identity", fill = "#7B90D2") +
    coord_flip() +
    facet_wrap(~ as.factor(metric), scales = "free") +
    scale_x_reordered() +
    xlab("Collexemes") +
    ggtitle(rep_con_form)
  
  return(p)
}