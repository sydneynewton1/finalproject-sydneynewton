# Introduction
#Since I was a little kid, I have been a huge fan of the Kansas City Chiefs football team. I've watched the team go through several different players, and have many up and down seasons. I have also followed the nfl for several years, so I chose an nfl centered dataset.

#When looking at the player and team datasets, my main goal is analyzing nfl stats at both a player level. I have seen many different types of players, so I am interested what the stats looks like of each position, and how the stats have changed over the last 5 years. I am interested in analyzing how player stats have changed over the last few years, and how stats contribute to a team's performance. 



# Data Overview & Quality
#clean data
nfloffensiveplayers_new <- nfloffensiveplayers |>
  mutate(year = substr(game_id, 1, 4)) |>
  filter(position == "WR" | position == "TE" | position == "QB" | position == "RB" | position == "T" | position == "P" | position == "C" | position == "K"| position == "FB" | position == "G") |>
  select(player, position, year, team, rec, rec_yds, rec_td, rec_long, rec_yds_bonus, pass_cmp, pass_att, pass_yds, pass_int, pass_sacked, pass_sacked_yds, pass_long, pass_rating, pass_target_yds, pass_poor_throws, pass_blitzed, pass_hurried, rush_att, rush_yds, rush_td, rush_long, rush_yac, rush_broken_tackles, rush_scrambles, rush_yds_before_contact, targets, fumbles_lost)

# Save clean data to CSV
write.csv(nfloffensiveplayers_new, "data/nfloffensiveplayers_new.csv", row.names = FALSE)

#I am using a data set from kaggle.com that shown the offensive stats for every offensive player in every game in the NFL from 2019-2022. The data set has 69 columns that cover a variety of stats for different positions, and 19,973 observations. Each observation correlates with one players stats during one NFL game within those 4 years. There are both categorical and numerical variables, although the data set has several more numerical variables.  

#There was missingness issues for only one variable, which was "Vegas Favorite". It had 46 missing variables. This is the variable that says if the player was considered a favorite in the stats for betting, so it's not entirely surprising that some of the variables are missing. I don't believe the issues in this one variable will impact the analysis.

#There was a little bit of cleaning that had to go into this data set. There were a few defensive players included in the datatset, so I removed those. I also removed a few columns that were not necessary to my data exploration, such as "player_id", "team_abbr", and a few stats that did not relate to offensive player performance. Lastly, I also mutated the game id column so it just showed the year of the game, rather than the long number id.