---
  title: "Final Project"
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

# Introduction

#Since I was younger, I have been a huge fan of the Kansas City Chiefs football team. I've watched the team go through several different players, and have many up and down seasons. I have also followed the nfl for several years, so I chose an nfl centered dataset.

#When looking at the player and team datasets, my main goal is analyzing nfl stats at both a player level. I have seen many different types of players, so I am interested what the stats looks like of each position, and how the stats have changed over the last 5 years. I am interested in analyzing how player stats have changed over the last few years, and how stats contribute to a team's performance. 

# Data Overview & Quality
#clean data
nfloffensiveplayers_new <- nfloffensiveplayers |>
  mutate(year = substr(game_id, 1, 4)) |>
  filter(position == "WR" | position == "TE" | position == "QB" | position == "RB" | position == "T" | position == "P" | position == "C" | position == "K"| position == "FB" | position == "G") |>
  select(player, position, year, team, rec, rec_yds, rec_td, rec_long, rec_yds_bonus, pass_cmp, pass_att, pass_yds, pass_int, pass_sacked, pass_sacked_yds, pass_long, pass_rating, pass_target_yds, pass_poor_throws, pass_blitzed, pass_hurried, rush_att, rush_yds, rush_td, rush_long, rush_yac, rush_broken_tackles, rush_scrambles, rush_yds_before_contact, targets, fumbles_lost)
# Save clean data to CSV
write.csv(nfloffensiveplayers_new, "nfloffensiveplayers_new.csv", row.names = FALSE)


#I am using a dataset from kaggle that showns the offensive stats for every offensive player in every game in the nfl from 2019-2022. The dataset has 69 columns that cover a variety of stats for differet positions, and 19,973 observations. Each observation correlates with one players stats during one NFL game within those 4 years. There are both categorical and numerical variables, althought the dataset has several more numerical variables.  

#There was only missingness issues for one variable, which was "Vegas Favorite". This is the variable that says if the player was considered a favorite in the stats for betting, so it's not entirely surprising that some of the variables are missing. I don't believe the issues in this one variable will impact the analysis.

#There was a little bit of cleaning that had to go into this dataset. There were a few defensive players included in the datatset, so I removed those. I also removed a few columns that were not neccesary to my data exploration, such as "player_id", "team_abbr", and a few stats that did not relate to offensive player performance. Lastly, I also mutated the game id column so it just showed the year of the game, rather than the long number id.

# Exploration

#There a 3 main functions of players in football that contibute to a team's success: passing, rushing, and receiving. In this past of the analysis, I am interested in exploring each of the 3 functions more deeply.

## Recieving Analysis

#First, I want to look at receiving. 

### Frequency of Recieving Yards

#To begin, I am curious about what the distribution looks like of receiving yards. There are two positions that receive: wide receivers and tight ends. I want to look at the distribution for overalls stats.
nfloffensiveplayers_new |>
  filter(position == "TE" | position == "WR") |>
  ggplot(aes(x = rec_yds)) +
    geom_density(alpha = 0.4, color="lightblue", fill="skyblue") +
    labs(title = "Density of Receiving Yards", x = "Receiving Yards (yds)")
#The majority of recieving yards lie in the 0-50 range. However, the graph has a right skew, and there are outliers which are players with above 150+ yards in a game.

#Next, I want to look at the distribution for overalls stats by position.
nfloffensiveplayers_new |>
  filter(position == "WR" | position == "TE") |>
  ggplot(aes(x = rec_yds, color=position, fill=position)) +
    geom_density(alpha = 0.4) +
    labs(title = "Density of Receiving Yards By Position", x = "Receiving Yards (yds)")

#Splitting up the density plot by position reveals that Tight Ends have lower overall receiving stats than wide receivers. This is not surprising, since tight ends have two jobs: blocking and receiving. Not all tight ends catch, but all wide receivers catch. This difference in position nature explains the difference in the range of receiving yards between the two positions.

### Wide Reciever Receiving Yards Across Years

#Next, I want to explore how the receiving yards stats have changed across years. Since tight ends and wide receivers are fairly different positions, I am going to explore the position separately. First, I am going to look at wide receivers.
recyds_nfloffensiveplayers_new <- nfloffensiveplayers_new |>
  filter(position == "WR") |>
  group_by(year) |>
  summarize(mean_rec_yds = mean(rec_yds))

kable(recyds_nfloffensiveplayers_new)

#The receiving yards by year of wide receivers shows a unique trend. The average yards went up in 2020, but then when down in 2021 and 2022. However, the average has not changed significantly, only going down a total of an average of 2 yards. This shows that the emphasis on throwing in the NFL has remained fairly consistent, and that the talent in the NFL has also stayed consistent. 
nfloffensiveplayers_new |>
  filter(position == "WR") |>
  ggplot(aes(x = year, y = rec_yds, fill=year)) +
  geom_boxplot() +
  labs(title = "Wide Reciever Recieving Yards by Year",
       x = "Year",
       y = "Recieving Yards", fill="Year")

#When looking at the range year by year, it's also fairly consistent. There seem to be many outliers each year, and there is one extreme outliers in 2020 and 2022.

### Top Wide Receivers

#Now, I am interested in looking at which players these 2 outliers are for.
nfloffensiveplayers_new_top5 <- nfloffensiveplayers_new |>
  filter(year == "2020" & position == "WR") |>
  select(player, position, year, team, rec_yds) |>
  arrange(desc(rec_yds)) |>
  slice(1:2)

kable(nfloffensiveplayers_new_top5)
nfloffensiveplayers_new_top5 <- nfloffensiveplayers_new |>
  filter(year == "2022" & position == "WR") |>
  select(player, position, year, team, rec_yds) |>
  arrange(desc(rec_yds)) |>
  slice(1:2)

kable(nfloffensiveplayers_new_top5)

#After looking into it more, I found that the outlier in 2020 was Tyreek Hill and the outlier in 2022 was Ja'Marr Chase.

#After exploring further, I learned that Tyreek Hill got 269 receiving yards while he played for the Kansas City Chiefs in a game against the Tampa Bay Bucaneers. I personally remember watching this game, and I recalled it as soon as I saw the outlier, which is why I wanted to explore further. Ja'Marr Chase got 266 receiving yards for the Cinncinati Bengals in a game against the Jacksonville Jaguars.

#Both of these games set records, with Hill holding the 14th most recieving yards in a single game of all time and Chase holding the 16th most. Taking these stats into consideration, it makes sense that the outliers look so significant in the distribution.

### Tight End Receiving Yards Across Years

#Now that I have explored the recieving yards of wide receivers from 2019 to 2022, I am interested in exploring the change in receiving yards of tight ends across years.
recydste_nfloffensiveplayers_new <- nfloffensiveplayers_new |>
  filter(position == "TE") |>
  group_by(year) |>
  summarize(mean_rec_yds = mean(rec_yds))

kable(recydste_nfloffensiveplayers_new)

#The average receiving stats of tight ends each year is more consistent than wide receivers, remaining around 17 each year, although it was higher in 2019.
nfloffensiveplayers_new |>
  filter(position == "TE") |>
  ggplot(aes(x = year, y = rec_yds, fill=year)) +
  geom_boxplot() +
  labs(title = "Tight End Recieving Yards by Year",
       x = "Year",
       y = "Recieving Yards", fill= "Year")

#When looking at the boxplot graph, there are similar ranges across years. There also seems to be several outliers each year. However, 2020 and 2021 have higher outliers than either of the other years.

### Top Tight Ends

#Similar to Wider Receivers, I am curious to see which tight ends the outliers are.
nfloffensiveplayers_new_top5 <- nfloffensiveplayers_new |>
  filter(year == "2020" & position == "TE") |>
  select(player, position, year, team, rec_yds) |>
  arrange(desc(rec_yds)) |>
  slice(1:5)

kable(nfloffensiveplayers_new_top5)
nfloffensiveplayers_new_top5 <- nfloffensiveplayers_new |>
  filter(year == "2021" & position == "TE") |>
  select(player, position, year, team, rec_yds) |>
  arrange(desc(rec_yds)) |>
  slice(1:5)

kable(nfloffensiveplayers_new_top5)

#Unlike Wide Receivers, there isn't any extreme outliers, but there are several that are significantly above average. The average receiving yards per tight end is 17-18, yet there are receivers with above 150 yards. When looking at the top 5 for the two outlier years, there are several players with high numbers, such as Travis Kelce and George Kittle.
top_5_players <- nfloffensiveplayers_new |>
  filter(position == "TE") |>
  group_by(player) |>
  summarise(avg_rec_yds = mean(rec_yds)) |>
  arrange(desc(avg_rec_yds)) |>
  head(5)

kable(top_5_players)

#When looking at the top tight ends with the best overall receiving yards, the data is consistent with the outliers in 2020 and 2021. Travis Kelce, Darren Waller, George Kittle, and Kyle Pitts have the highest average receiving yards across all games, so it makes sense those 4 make up many of the outliers. 

#It also makes sense that tight ends have a wider range of receiving yards that wide receivers since the position has two functions, as mentioned earlier. Since not all tight ends receive, it creates a high disparity between the average receiving yards among all tight ends and the average recieving yards among the top tight ends. 

### Tight Ends vs. Wide Receivers

#Now that we have explored the receiving yards across years among tight ends and wide receivers individually, I am interested in comparing them during each year.
nfl_filtered <- nfloffensiveplayers_new[nfloffensiveplayers_new$position %in% c("WR", "TE"),]

# Count total rec_yds for each player
rec_yds_count <- nfl_filtered |>
  group_by(position, year) |>
  summarise(total_rec_yds = sum(rec_yds)) |>
  ungroup()

# Create a side-by-side bar graph
ggplot(rec_yds_count, aes(x = year, y = total_rec_yds, fill = position)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Total Receiving Yards by Year and Position", x = "Year", y = "Total Receiving Yards", fill="Position") +
  theme_minimal()
nfl_filtered <- nfloffensiveplayers_new[nfloffensiveplayers_new$position %in% c("WR", "TE"),]

# Count total rec_yds for each player
rec_yds_count <- nfl_filtered |>
  group_by(position, year) |>
  summarise(mean_rec_yds = mean(rec_yds)) |>
  ungroup()

# Create a side-by-side bar graph
ggplot(rec_yds_count, aes(x = year, y = mean_rec_yds, fill = position)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Average Receiving Yards by Year and Position", x = "Year", y = "Average Receiving Yards", fill="Position") +
  theme_minimal()

#From the graph, it is clear that wide receivers have a much higher amount of receiving yards than tight ends, both total and average. Neither of these graphs is surprising.

#First, there are 3 wide recievers on a team, compared to 1 tight end on a team. This explains why the total receiving yards is higher. Second, since the positions functions differently, it is understandable why the average receiving yards is higher for wide receivers.

### Recieving Yards vs Other Recieving Variables
nfloffensiveplayers_new |>
  filter(position == "WR" | position == "TE") |>
  select(rec_yds, rec_td, rec_long, rec_yds_bonus) |>
  cor() |>
  ggcorrplot()

#When looking at the variables, noe of them seem to have an extremely high correlation with one another. The only variables that look to have a somewhat high relation to the other is receiving yards and receiving long.

### Recieving Yards vs Other Recieving Variables
correlation_rec <- nfloffensiveplayers_new |>
  filter(position == "WR" | position == "TE") |>
  ggplot(aes(x = rec_yds, y = rec_long)) +
  geom_point(alpha=0.3) +
  geom_smooth(method = "lm") +
  labs(title = "The Correlation Between Receiving Yards and Receiving Long",
       x = "Receiving Yards",
       y = "Receiving Long")
correlation_rec

nfl_rec <- nfloffensiveplayers_new |>
   filter(position == "WR" | position == "TE") |>
  select(rec_yds, rec_long) |>
  cor()
kable(nfl_rec)

#There was an 84% correlation between receiving yards and receiving long. This correlation makes sense, since the "receiving long" variable means that the receiving was running a long route when they caught the call. The longer the route, the more yards they in turn get, causing more receiving yards. 

## Passing Analysis

#Next, I want to examine passing.

### Passing Yards Across Years

#First, I am going to analyze the passing yards across years.
passyds_nfloffensiveplayers_new <- nfloffensiveplayers_new |>
  filter(position == "QB") |>
  group_by(year) |>
  summarize(mean_pass_yds = mean(pass_yds))
kable(passyds_nfloffensiveplayers_new)

#The average passing yards in the nfl is interesting. You have to pass a ball to recieve it, so I am surprised that there is a higher range of differences year by year in passing than in recieving. There was a downward trend in average recieving yards from 2019 to 2021, but then it went back up. I think the disaparity between throwing and recieving could be explained by the fact that there is only one quarterback on an nfl team, compared to multiple recievers.
nfloffensiveplayers_new |>
  filter(position == "QB") |>
  ggplot(aes(x = year, y = pass_yds, fill=year)) +
  geom_boxplot() +
  labs(title = "Passsing Yards by Year",
       x = "Year",
       y = "Passing Yards", fill= "Year")

#The range of passing yards is pretty consistent, similar to the averages, althought there is a small downward trend. There are almost now outliers, except for 1 extreme outlier in 2019 and 2 extreme outliers in 2021.

### Top Quarterbacks

#Now, I am interested in exploring what the who the 3 quarterback outliers are.
nfloffensiveplayers_new_2 <- nfloffensiveplayers_new |>
  filter(year == "2019" & position == "QB") |>
  select(player, position, year, team, pass_yds) |>
  arrange(desc(pass_yds)) |>
  slice(1:5)
kable(nfloffensiveplayers_new_2)
nfloffensiveplayers_new_1 <- nfloffensiveplayers_new |>
  filter(year == "2021" & position == "QB") |>
  select(player, position, year, team, pass_yds) |>
  arrange(desc(pass_yds)) |>
  slice(1:5)
kable(nfloffensiveplayers_new_1)

#The outlier in 2019 was Jared Goff when he played for the Los Angeles Rams. The outliers in 2021 were Joe Burrow when he played for the Cinncinati Bengals and Ben Roethlisberger when he played for the Pittsburg Steelers. These are outliers since they are all 50+ yards above the person below them. 

#Similar to the Wide Reciever stats, these games all set records. Burrows game was the 4th most passing yards of all time in an nfl game, Roethlisberger's was the 5th most, and Goff's was the 10th most. These records help explain why the outliers seem so significant.

### Correlation Between Passing Yards and Other Passing Variables

#Now that we have analyzed passing yards, I am interested in analyzing the relationship between passing yards and the other variables related to passing: pass completions, pass attempts, pass interceptions, passes sacked, and pass rating.

nfloffensiveplayers_new |>
  filter(position == "QB") |>
  select(pass_cmp, pass_yds, pass_att, pass_int, pass_sacked, pass_rating, pass_target_yds, pass_poor_throws, pass_blitzed, pass_hurried) |>
  cor() |>
  ggcorrplot()

#The heatmap shows that the three variables with the highest correlations to each other are pass completions, pass yards, and pass attempts. I am interested in further exploring relationship with those 3 variables.

### Pass Completions vs. Pass Yards vs. Pass Attempts

#First, I want to further explore the correlation between passing yards, pass completions, and pass attempts for quarterbacks. 

nfloffensiveplayers_new |>
  select(pass_cmp, pass_att, pass_yds) |>
  ggpairs(aes(alpha = 0.2))

#I created a scatterplot matrix to explore the relationship between all 3 at the same time. The variables all have high correlations with each other and demonstrates a positive correlation in the graphs. 

#Althought they are all similar, pass completions and pass attempts have a slightly higher correlation than the other variables. Pass yards and pass completions have the second highest correlation, and pass yards and pass attempts have the lowest correlation. 

## Rushing Analysis 

#Finally, I am going to explore rushing in this dataset.

### Distribution of Rushing Yards
#There are three different positions that can rush the ball: running backs, and full backs. To start, I want to examine the distribution or rushing yards of both positions.

nfloffensiveplayers_new |>
  filter(position == "RB" | position == "FB") |>
  ggplot(aes(x = rush_yds)) +
  geom_histogram(fill = "blue", bins = 40) +
  labs(title = "Distribution of Rush Yards Per Game", x = "Rush Yards", y = "Frequency")

nfloffensiveplayers_new |>
  filter(position == "RB" | position == "FB") |>
  group_by(player) |>
  summarise(avg_rush_yds = mean(rush_yds)) |>
  ggplot(aes(x = avg_rush_yds)) +
  geom_histogram(fill = "blue", bins = 30) +
  labs(title = "Distribution of Average Rush Yards Per Player", x = "Rush Yards", y = "Frequency")


#The distribution of rushing yards per game and rushing yards per player have similar overall distributions. They are both right skew and unimodel. However, the frequency of the average rushing yards is lower than total yards, althought that is to be expected.

#I am personally not surprised by the right skew. Rushing is generally not meant to gain a lot of yards, so it makes send that both the majority of  rushing yards per game per and the average rushing yards per player is in the 0-25 range. However, some plays end up gaining a large number of rushing yards, which explains the right skew and the outliers on both graphs. There is one outlier in average yards, which will be explored below in the "Top Running Backs" section.p;


### Distribution of Rushing Yards by Position

#Next, I want to compare the distribution of rushing yards among the 2 positions.
rec_yds_count <- nfloffensiveplayers_new |>
  filter(position == "RB" | position == "FB") |>
  group_by(position, year) |>
  summarise(mean_rec_yds = mean(rec_yds)) |>
  ungroup()

# Create a side-by-side bar graph
ggplot(rec_yds_count, aes(x = year, y = mean_rec_yds, fill = position)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Average Receiving Yards by Year and Position", x = "Year", y = "Average Receiving Yards", fill="Position") +
  theme_minimal()

rec_yds_count <- nfloffensiveplayers_new |>
  filter(position == "RB" | position == "FB") |>
  group_by(position, year) |>
  summarise(total_rec_yds = sum(rec_yds)) |>
  ungroup()

# Create a side-by-side bar graph
ggplot(rec_yds_count, aes(x = year, y = total_rec_yds, fill = position)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Total Receiving Yards by Year and Position", x = "Year", y = "Average Receiving Yards", fill="Position") +
  theme_minimal()

#These distributions produce consistent results. In both graphs, running backs have higher rushing yards than fullbacks. At first, these results surprised me since running backs and full backs are virtually the same position. However, after analyzing it more and looking at the dataset, I realized that teams have siginificantly more running backs than fullbacks and they use running backs more. This explains the difference in both total yards and average yards. 

### Analysis of Rushing Yards by Year

#Now that we have analyzed the distribution of rushing yards, I want to examine how rushing yards have changed over the last 5 years. Since running backs and fullbacks are extremely similar positions, I am going to summarize both positions for this analysis.
rushyds_nfloffensiveplayers_new <- nfloffensiveplayers_new |>
  filter(position == "RB" | position == "FB") |>
  group_by(year) |>
  summarize(mean_rush_yds = mean(rush_yds))
kable(rushyds_nfloffensiveplayers_new)

#There is a extremely high consistency when it comes to rushing yards in the nfl. It remained around 33.7 average yards across the 4 years, never differentiating by more than a yard. The average yards are also lower than recieving and passing, which makes sense since rushing generally does not lead to as many yard gains as recieving does.

nfloffensiveplayers_new |>
  filter(position == "RB" | position == "FB") |>
  ggplot(aes(x = year, y = rush_yds, fill=year)) +
  geom_boxplot() +
  labs(title = "Rushing Yards by Year",
       x = "Year",
       y = "Recieving Yards", fill= "Year")

#There is a similar range among all four years. However, there are many outliers in each year. 2021 has 2 outliers that are higher than any other year. 

### Top Running Backs

#Similar to the other positions, I am interested in seeing which running backs performed high enough to be the outliers. 
nfl_top <- nfloffensiveplayers_new |>
  filter(year == "2021" & position == "RB") |>
  select(player, position, year, team, rush_yds) |>
  arrange(desc(rush_yds)) |>
  slice(1:5)
kable(nfl_top)


#Jonathan Taylor had 253 yards in a single game while playing for the Indianapolis Colts, and Derrick Henry had 250 yards while playing for the Tennesee Titans. This is over 200 above the average and over 50 above the other outliers, which explains why it stands out in the graph. 

#Unsurpringsly, these games also set records in the nfl. Taylor had the 9th most rushign yards in an individual game in nfl history, and Henry had the 13th. It is interesting to compare the stand-out outliers to nfl records, since it puts into perspective how extreme the outliers truly are.
top_rb <- nfloffensiveplayers_new |>
  filter(position == "RB") |>
  group_by(player) |>
  summarise(avg_rush_yds = mean(rush_yds)) |>
  arrange(desc(avg_rush_yds)) |>
  head(2)

kable(top_rb )

#These result are consistent with the outliers, since Jonathon Taylor and Derrick Henry not only had the two highest performing games, but were also the overall top 2 highest performing running backs in the past 5 years.

### Rush Yards vs. Other Rush Variables

nfloffensiveplayers_new |>
  filter(position == "RB") |>
  select(rush_yds, rush_att, rush_td, rush_long, rush_scrambles, rush_yds_before_contact, rush_yac, rush_broken_tackles) |>
  cor() |>
  ggcorrplot()

#Unlike the passing variables, the rushing variables don't have as heavy of a correlation with each other. The only variables that seem to have somewhat of a heavy correlation is rushing yards and rushing attempts, and then rushing yards and rushing yards before contact.

### Rush Attempts vs. Rush Yards

#Now, I want to further explore the correlation between rushing yards and rush attempts for running backs. 

correlation_plot <- nfloffensiveplayers_new |>
  filter(position == "RB") |>
  ggplot(aes(x = rush_att, y = rush_yds)) +
  geom_point(alpha=0.3) +
  geom_smooth(method = "lm") +
  labs(title = "The Correlation Between Rush Attempts and Rush Yards",
       x = "Rushing Attempts",
       y = "Rushing Yards")
correlation_plot

nfl_rb <- nfloffensiveplayers_new |>
  filter(position == "RB") |>
  select(rush_att, rush_yds) |>
  cor()
kable(nfl_rb)

#There is a 87.5% correlation between rushing yards and rush attemps. This is consistent with the correlation shown by the heat map. It also makes sense that these two variables are related. The more attempts someone has at rushing, the more yards they will get. That said, it also makes sense that it is not extremely close to 100%, since an attempt doesn't guarantee that the running back will gain yards on the play.

### Rush Yards vs. Rush Yards Before Contact

#Next, I want to explore the relationship between rush yards and rush yards before contact.

nfl_rushyds_comparison <- nfloffensiveplayers_new |>
  filter(position == "RB") |>
  ggplot(aes(x = rush_att, y = rush_yds_before_contact)) +
  geom_point(alpha=0.3) +
  geom_smooth(method = "lm") +
  labs(title = "Rushing Yards vs. Rushing Yards Before Contact",
       x = "Rushing Yards",
       y = "Rushing Yards Before Contact")
nfl_rushyds_comparison

nfl_rushyds <- nfloffensiveplayers_new |>
   filter(position == "RB") |>
  select(rush_yds, rush_yds_before_contact) |>
  cor()
kable(nfl_rushyds)

#There is also a heavy correlation between these two variables, at 90%. However, I am surrpised the correlation is not even higher. One of the variables represents the total rush yards in a game, and the other variable represents the total rush yards in a game before the player is hit. Normally, when the player gets hit, it means the play is over. Because of this, I am surprised the correlation is not closer to 100%.

## Overall Analysis

#Now that we have explored rushing, passing, and recieving more deeply, I am interested in analyzing the dataset as a whole. 

### Frequency of Positions

#First, I am interested in looking at how common each position is in the dataset.
position_pie_chart <- nfloffensiveplayers_new |> 
  filter(position == "QB" | position == "RB" | position == "TE" | position == "WR" | position == "FB" | position == "HB") |>
  ggplot(aes(x = "", fill = position)) +
  geom_bar() + 
  coord_polar("y") +
  labs(title = "Offensive Scoring Positions Distribution", x = NULL, y = NULL)

position_pie_chart

#Wide Recievers are the most common offensive position in the dataset, which makes sense since there are more wide recievers on the feild at a time than the other positions. Quarterback was the least common positions, which is also not surprising since teams normally only have 1 backup quarterback, and their main "franchise" quarterback remains on the field at all times. This is unlike the other positions where the players consistently switch out, so they need more backups.

#I was surprised that there was more tight ends in the dataset than running backs. I see more running backs switch out than tight ends when I'm watching football, so I always assumed there would be more backup RBs than TEs. However, this assumption is untrue as shown by the pie chart.

position_pie_chart_2 <- nfloffensiveplayers_new |> 
  filter(position == "C" | position == "T" | position == "G") |>
  ggplot(aes(x = "", fill = position)) +
  geom_bar() + 
  coord_polar("y") +
  labs(title = "Offensive Line Position Distribution", x = NULL, y = NULL)

position_pie_chart_2

#In this pie chart, there are more tackles than centers, which makes sense since there are more tackles on the field than centers at a time. It is surprising that there are more tackles than guards since both positions have 2 on the field at a time. I would assume it's because tackles get more easily injured since they are on the ends of the offensive line.

### Frequency of Positions by Year

# Count players by position and year
nfl_count <- nfloffensiveplayers_new |>
  group_by(position, year) |>
  summarize(n = n())

# Create facet wrap bar graph
ggplot(nfl_count, aes(x = position, y = n)) +
  geom_bar(stat = "identity") +
  facet_wrap(~ year) +
  labs(title = "Number of Players by Position and Year",
       x = "Position",
       y = "Number of Players")

#All of the positions remained fairly consistent throughout each year, except for the decrease in 2022. This disparity can be explained by the fact that this dataset was created in 2022, so they likely missed players that were recruited towards the end of the year.

# Conclusion

#Throught this exploration, I looked at rushing, receiving, and passing. I found that the average years of each has remained consistent across the last four years, although passing yards has varied the most. It was surprisinging that passing yards varied more than receiving yards, since the two should in theory have a high correlation with one another. Each of the variables also had outliers. When these outliers were explored further, it was found that they were correlated to individual players that set NFL records with those numbers. Two of the variables, receiving and rushing, centered around two different position. In both cases, one position out performed the other, althought that was for different reasons. Wide recievers had higher receiving stats than tight ends since not all tight ends receive, and running backs had higher rushing stats than full backs since running backs are used more. I had expected the different in receiving yards since I follow the tight end position, but I did not expect the difference in rushing yards. 

#When looking at the three categories, there were high correlations between variables in each one. Receiving yards was heavily correlated with receiving long, and rushing yards was with rushing yards before contact and rush attempts. Additionally, passing yards, pass attempts, and pass completions all had heavy correlations with each other. These correlations all made sense logically, and I expected most of them.

#In the future, it would be interesting to take the players stats analysis and see how it impacted each of the games they played it. You could use this comparison to identiy trends between certain rushing, passing, or recieving stats and whether or not the team won, which could be very useful for offensive coaches. 

# References
#Fernandez, Daniel. “NFL Offensive Stats 2019 - 2022.” Kaggle, 23 Aug. 2022, www.kaggle.com/datasets/dtrade84/nfl-offensive-stats-2019-2022. 

#“NFL Passing Yards Single Game Leaders.” Pro Football Reference, Sports Reference, www.pro-football-reference.com/leaders/pass_yds_single_game.htm. Accessed 6 Dec. 2023. 

#“NFL Receiving Yards Single Game Leaders.” Pro Football Reference, Sports Reference, www.pro-football-reference.com/leaders/rec_yds_single_game.htm. Accessed 6 Dec. 2023. 

#“NFL Rushing Yards Single Game Leaders.” Pro Football Reference, Sports Reference, www.pro-football-reference.com/leaders/rush_yds_single_game.htm. Accessed 6 Dec. 2023. 
