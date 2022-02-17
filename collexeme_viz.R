library(ggplot2)
library(stringr)
library(dplyr)
library(tidytext)

rep_var_data <- readRDS("data/rep_var_data.rds")

collexeme_viz <- function(rep_var_form){
  
  matched <-  rep_var_data %>%
    filter(metric %in% c("obs.freq", "coll.strength")) %>%
    filter(construction.name == rep_var_form)
  
  require(showtext)
  showtext_auto()
  
  p <- ggplot(matched, aes(x=reorder_within(words, strength, metric), y=strength)) +
    geom_bar(stat="identity") +
    coord_flip() +
    facet_wrap(~ as.factor(metric), scales = "free") +
    scale_x_reordered() +
    xlab("Collexemes") +
    ggtitle(rep_var_form)
  
  return(p)
}