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
  
  ggsave("plots/position_pie_chart.png", position_pie_chart, width = 6, height = 6)

  #![A pie chart showing the distributions of the offensive positions that help their NFL team score](plot/position_pie_chart.png){#fig-plot-20}
    
   # @fig-plot-20 highlights that Wide Recievers are the most common offensive position in the dataset, which makes sense since there are more wide recievers on the feild at a time than the other positions. Quarterback was the least common positions, which is also not surprising since teams normally only have 1 backup quarterback, and their main "franchise" quarterback remains on the field at all times. This is unlike the other positions where the players consistently switch out, so they need more backups.
    
    #I was surprised that there was more tight ends in the dataset than running backs. I see more running backs switch out than tight ends when I'm watching football, so I always assumed there would be more backup RBs than TEs. However, this assumption is untrue as shown by the pie chart.



position_pie_chart_2 <- nfloffensiveplayers_new |> 
  filter(position == "C" | position == "T" | position == "G") |>
  ggplot(aes(x = "", fill = position)) +
  geom_bar() + 
  coord_polar("y") +
  labs(title = "Offensive Line Position Distribution", x = NULL, y = NULL)

position_pie_chart_2

ggsave("plots/position_pie_chart_2.png", position_pie_chart_2, width = 6, height = 6)

#![A pie chart showing the distributions of the offensive positions in the offensive line, or O-line](plot/position_pie_chart_2.png){#fig-plot-21}

#In @fig-plot-21, there are more tackles than centers, which makes sense since there are more tackles on the field than centers at a time. It is surprising that there are more tackles than guards since both positions have 2 on the field at a time. I would assume it's because tackles get more easily injured since they are on the ends of the offensive line.
    
    ### Frequency of Positions by Year
    

    # Count players by position and year
    nfl_count <- nfloffensiveplayers_new |>
      group_by(position, year) |>
      summarize(n = n())
    
    # Create facet wrap bar graph
    freq_pos_year <- nfl_count |>
      ggplot(aes(x = position, y = n)) +
      geom_bar(stat = "identity") +
      facet_wrap(~ year) +
      labs(title = "Number of Players by Position and Year",
           x = "Position",
           y = "Number of Players")
    
    freq_pos_year
    
    ggsave("plots/freq_pos_year.png", freq_pos_year, width = 6, height = 6)

    #![A side-by-side comparison of the number of players for each positions for each in 2019, 2020, 2021, and 2022](plot/freq_pos_year.png){#fig-plot-22}
      
     # @fig-plot-22 shows that of the positions remained fairly consistent throughout each year, except for the decrease in 2022. This disparity can be explained by the fact that this dataset was created in 2022, so they likely missed players that were recruited towards the end of the year.
      
      
      # Conclusion
      
      #Throught this exploration, I looked at rushing, receiving, and passing. I found that the average years of each has remained consistent across the last four years, although passing yards has varied the most. It was surprisinging that passing yards varied more than receiving yards, since the two should in theory have a high correlation with one another. Each of the variables also had outliers. When these outliers were explored further, it was found that they were correlated to individual players that set NFL records with those numbers. Two of the variables, receiving and rushing, centered around two different position. In both cases, one position out performed the other, althought that was for different reasons. Wide recievers had higher receiving stats than tight ends since not all tight ends receive, and running backs had higher rushing stats than full backs since running backs are used more. I had expected the different in receiving yards since I follow the tight end position, but I did not expect the difference in rushing yards. 
      
      #When looking at the three categories, there were high correlations between variables in each one. Receiving yards was heavily correlated with receiving long, and rushing yards was with rushing yards before contact and rush attempts. Additionally, passing yards, pass attempts, and pass completions all had heavy correlations with each other. These correlations all made sense logically, and I expected most of them.
      
      #In the future, it would be interesting to take the players stats analysis and see how it impacted each of the games they played it. You could use this comparison to identiy trends between certain rushing, passing, or recieving stats and whether or not the team won, which could be very useful for offensive coaches. 
      
      
      # References
      #Fernandez, Daniel. “NFL Offensive Stats 2019 - 2022.” Kaggle, 23 Aug. 2022, www.kaggle.com/datasets/dtrade84/nfl-offensive-stats-2019-2022. 
      
      #“NFL Passing Yards Single Game Leaders.” Pro Football Reference, Sports Reference, www.pro-football-reference.com/leaders/pass_yds_single_game.htm. Accessed 6 Dec. 2023. 
      
      #“NFL Receiving Yards Single Game Leaders.” Pro Football Reference, Sports Reference, www.pro-football-reference.com/leaders/rec_yds_single_game.htm. Accessed 6 Dec. 2023. 
      
     # “NFL Rushing Yards Single Game Leaders.” Pro Football Reference, Sports Reference, www.pro-football-reference.com/leaders/rush_yds_single_game.htm. Accessed 6 Dec. 2023. 
    