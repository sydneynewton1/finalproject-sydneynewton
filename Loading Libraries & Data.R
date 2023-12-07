---
  title: "An Analysis of NFL Offensive Stats"
subtitle: |
  | Data Science 1 with R (STAT 301-1)
format:
  html:
  toc: true
embed-resources: true
editor: visual
author: Sydney Newton
date: today
---

# Github Repo Link

#[My GitHub Link](https://github.com/sydneynewton1/finalproject-sydneynewton.git)

library(tidyverse)
library(naniar)
library(dplyr)
library(kableExtra)
library(ggcorrplot)
library(corrplot)
library(GGally)
nfloffensiveplayers <- read_csv("data/raw/nfl_offensive_stats.csv")
