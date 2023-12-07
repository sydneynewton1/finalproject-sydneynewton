## Recieving Analysis

#First, I want to look at receiving. 

### Frequency of Recieving Yards

#To begin, I am curious about what the distribution looks like of receiving yards. There are two positions that receive: wide receivers and tight ends. I want to look at the distribution for the overall stats.
rec_yds_frequency <- nfloffensiveplayers_new |>
  filter(position == "TE" | position == "WR") |>
  ggplot(aes(x = rec_yds)) +
  geom_density(alpha = 0.4, color="lightblue", fill="skyblue") +
  labs(title = "Frequency of Amount of Receiving Yards Per Game", x = "Receiving Yards (yds)")

rec_yds_frequency

ggsave("plots/rec_yds_frequency.png", rec_yds_frequency, width = 6, height = 6)

#![The Distribution of Overall Receiver Yards per Game for Both Tight Ends and Wide Receivers](plot/rec_yds_frequency.png){#fig-plot-1}
  
  #@fig-plot-1 shows that majority of recieving yards lie in the 0-50 range. However, the graph has a right skew, and there are outliers which are players with above 150+ yards in a game.
  
  #Next, I want to look at the distribution for overalls stats by position.
  

  rec_yds_position_frequency <- nfloffensiveplayers_new |>
    filter(position == "WR" | position == "TE") |>
    ggplot(aes(x = rec_yds, color=position, fill=position)) +
    geom_density(alpha = 0.4) +
    labs(title = "Frequency of Receiving Yards By Position", x = "Receiving Yards (yds)")
  
  rec_yds_position_frequency
  
  ggsave("plots/rec_yds_position_frequency.png", rec_yds_position_frequency, width = 6, height = 6)

 # ![The Distribution of Overall Receiver Yards per Game for Tight Ends vs Wide Receivers](plot/rec_yds_position_frequency.png){#fig-plot-2}
    
   # @fig-plot-2 reveals that Tight Ends have lower overall receiving stats than wide receivers. This is not surprising, since tight ends have two jobs: blocking and receiving. Not all tight ends catch, but all wide receivers catch. This difference in position nature explains the difference in the range of receiving yards between the two positions.
    
    ### Wide Reciever Receiving Yards Across Years
    
    #Next, I want to explore how the receiving yards stats have changed across years. Since tight ends and wide receivers are fairly different positions, I am going to explore the position separately. First, I am going to look at wide receivers.
    

    recyds_nfloffensiveplayers_new <- nfloffensiveplayers_new |>
      filter(position == "WR") |>
      group_by(year) |>
      summarize(mean_rec_yds = mean(rec_yds))
    
    kable(recyds_nfloffensiveplayers_new)

   # The receiving yards by year of wide receivers shows a unique trend. The average yards went up in 2020, but then when down in 2021 and 2022. However, the average has not changed significantly, only going down a total of an average of 2 yards. This shows that the emphasis on throwing in the NFL has remained fairly consistent, and that the talent in the NFL has also stayed consistent. 

    wide_rec_year <- nfloffensiveplayers_new |>
      filter(position == "WR") |>
      ggplot(aes(x = year, y = rec_yds, fill=year)) +
      geom_boxplot() +
      labs(title = "Wide Reciever Recieving Yards by Year",
           x = "Year",
           y = "Recieving Yards", fill="Year")
    wide_rec_year
    
    ggsave("plots/wide_rec_year.png", wide_rec_year, width = 6, height = 6)

    #![The Distribution of Receiving Yards in 2019, 2020, 2021, and 2022 for Wide Receivers](plot/wide_rec_year.png){#fig-plot-3}
      
      #The range in @fig-plot-3 year by year is also fairly consistent. There seem to be many outliers each year, and there is one extreme outliers in 2020 and 2022.
      
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

#After exploring further, I learned that Tyreek Hill got 269 receiving yards while he played for the Kansas City Chiefs in a game against the Tampa Bay Buccaneers. I personally remember watching this game, and I recalled it as soon as I saw the outlier, which is why I wanted to explore further. Ja'Marr Chase got 266 receiving yards for the Cincinnati Bengals in a game against the Jacksonville Jaguars.
      
      #Both of these games set records, with Hill holding the 14th most receiving yards in a single game of all time and Chase holding the 16th most. Taking these stats into consideration, it makes sense that the outliers look so significant in the distribution.
      
      ### Tight End Receiving Yards Across Years
      
      #Now that I have explored the recieving yards of wide receivers from 2019 to 2022, I am interested in exploring the change in receiving yards of tight ends across years.
  
      recydste_nfloffensiveplayers_new <- nfloffensiveplayers_new |>
        filter(position == "TE") |>
        group_by(year) |>
        summarize(mean_rec_yds = mean(rec_yds))
      
      kable(recydste_nfloffensiveplayers_new)

      
      The average receiving stats of tight ends each year is more consistent than wide receivers, remaining around 17 each year, although it was higher in 2019.

      tight_end_year <- nfloffensiveplayers_new |>
        filter(position == "TE") |>
        ggplot(aes(x = year, y = rec_yds, fill=year)) +
        geom_boxplot() +
        labs(title = "Tight End Recieving Yards by Year",
             x = "Year",
             y = "Recieving Yards", fill= "Year")
      
      tight_end_year
      
      ggsave("plots/tight_end_year.png", tight_end_year, width = 6, height = 6)

      #![The Distribution of Receiving Yards by for 2019, 2020, 2021, and 2022 for Tight Ends](plot/tight_end_year.png){#fig-plot-4}
        
        #When looking at @fig-plot-4, there are similar ranges across years. There also seems to be several outliers each year. However, 2020 and 2021 have higher outliers than either of the other years.
        
        ### Top Tight Ends
        
        Similar to Wider Receivers, I am curious to see which tight ends the outliers are.
 
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
]
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

Now that we have explored the receiving yards across years among tight ends and wide receivers individually, I am interested in comparing them during each year.

nfl_filtered <- nfloffensiveplayers_new[nfloffensiveplayers_new$position %in% c("WR", "TE"),]

# Count total rec_yds for each player
rec_yds_count <- nfl_filtered |>
  group_by(position, year) |>
  summarise(total_rec_yds = sum(rec_yds)) |>
  ungroup()

# Create a side-by-side bar graph
total_rec_yds_position <- rec_yds_count |>
ggplot(aes(x = year, y = total_rec_yds, fill = position)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Total Receiving Yards by Year and Position", x = "Year", y = "Total Receiving Yards", fill="Position") +
  theme_minimal()
total_rec_yds_position

ggsave("plots/total_rec_yds_position.png", total_rec_yds_position, width = 6, height = 6)

#![A side-by-side comparison of the total receiving yards for Tight Ends versus Wide Receivers for each year in the data](plot/total_rec_yds_position.png){#fig-plot-5}


nfl_filtered <- nfloffensiveplayers_new[nfloffensiveplayers_new$position %in% c("WR", "TE"),]

# Count total rec_yds for each player
rec_yds_count <- nfl_filtered |>
  group_by(position, year) |>
  summarise(avg_rec_yds = mean(rec_yds)) |>
  ungroup()

# Create a side-by-side bar graph
avg_rec_yds_position <- rec_yds_count |>
ggplot(aes(x = year, y = avg_rec_yds, fill = position)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Average Receiving Yards by Year and Position", x = "Year", y = "Average Receiving Yards", fill="Position") +
  theme_minimal()

avg_rec_yds_position

ggsave("plots/avg_rec_yds_position.png", avg_rec_yds_position, width = 6, height = 6)

#![A side-by-side comparison of the average receiving yards individual Tight Ends versus Wide Receivers across 4 years](plot/avg_rec_yds_position.png){#fig-plot-6}

#@fig-plot-5 and @fig-plot-6 make it clear that wide receivers have a much higher amount of receiving yards than tight ends, both total and average. Neither of these graphs is surprising.

#First, there are 3 wide recievers on a team, compared to 1 tight end on a team. This explains why the total receiving yards is higher. Second, since the positions functions differently, it is understandable why the average receiving yards is higher for wide receivers.

### Recieving Yards vs Other Recieving Variables

rec_yds_cor <- nfloffensiveplayers_new |>
  filter(position == "WR" | position == "TE") |>
  select(rec_yds, rec_td, rec_long, rec_yds_bonus) |>
  cor() |>
  ggcorrplot() +
  labs(title="Correlation Plot for Statistics Relating to Receiving")
rec_yds_cor

ggsave("plots/rec_yds_cor.png", rec_yds_cor, width = 6, height = 6)

#![A heatmap showing the relationship between 4 receiving variables: receiving yards, receiving touchdowns, receiving yards bonuses, and receiving longs](plot/rec_yds_cor.png){#fig-plot-7}

#When looking at the variables in @fig-plot-7, none of them seem to have an extremely high correlation with one another. The only variables that look to have a somewhat high relation to the other is receiving yards and receiving long.

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

ggsave("plots/correlation_rec.png", correlation_rec, width = 6, height = 6)

#![A correlation plot showing the relationship between receiving yards and receiving long](plot/correlation_rec.png){#fig-plot-8}


nfl_rec <- nfloffensiveplayers_new |>
   filter(position == "WR" | position == "TE") |>
  select(rec_yds, rec_long) |>
  cor()
kable(nfl_rec)


#@fig-plot-6 shows a heavy relation between the two variables, which is confirmed by the table that shows an 84% correlation between receiving yards and receiving long. This correlation makes sense, since the "receiving long" variable means that the receiving was running a long route when they caught the call. The longer the route, the more yards they in turn get, causing more receiving yards. 
