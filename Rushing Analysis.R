## Rushing Analysis 

#Finally, I am going to explore rushing in this dataset.

### Distribution of Rushing Yards
#There are three different positions that can rush the ball: running backs, and full backs. To start, I want to examine the distribution or rushing yards of both positions.


rush_yds_dist <- nfloffensiveplayers_new |>
  filter(position == "RB" | position == "FB") |>
  ggplot(aes(x = rush_yds)) +
  geom_histogram(fill = "blue", bins = 40) +
  labs(title = "Distribution of Rush Yards Per Game", x = "Rush Yards", y = "Frequency")

rush_yds_dist

ggsave("plots/rush_yds_dist.png", rush_yds_dist, width = 6, height = 6)

#![A histrogram showing the frequency of rush yards per game for both Running Backs and Full Back](plot/rush_yds_dist.png){#fig-plot-12}

  rush_yds_player_dist <-nfloffensiveplayers_new |>
    filter(position == "RB" | position == "FB") |>
    group_by(player) |>
    summarise(avg_rush_yds = mean(rush_yds)) |>
    ggplot(aes(x = avg_rush_yds)) +
    geom_histogram(fill = "blue", bins = 30) +
    labs(title = "Distribution of Average Rush Yards Per Player", x = "Rush Yards", y = "Frequency")
  
  rush_yds_player_dist
  
  ggsave("plots/rush_yds_player_dist.png", rush_yds_player_dist, width = 6, height = 6)

  #![A histrogram showing the frequency of average rush yards per player for both Running Backs and Full Back](plot/rush_yds_player_dist.png){#fig-plot-13}
    
    #@fig-plot-12 shows the distribution of rushing yards per game and @fig-plot-13 shows the rushing yards per player. Both @fig-plot-12 and @fig-plot-13 have similar overall distributions. They are both right skew and unimodel. However, the frequency of the average rushing yards is lower than total yards, althought that is to be expected.
    
    #I am personally not surprised by the right skew. Rushing is generally not meant to gain a lot of yards, so it makes send that both the majority of  rushing yards per game per and the average rushing yards per player is in the 0-25 range. However, some plays end up gaining a large number of rushing yards, which explains the right skew and the outliers on both graphs. There is one outlier in average yards, which will be explored below in the "Top Running Backs" section.p;
    
    
    ### Distribution of Rushing Yards by Position
    
    Next, I want to compare the distribution of rushing yards among the 2 positions.
    

    rec_yds_count <- nfloffensiveplayers_new |>
      filter(position == "RB" | position == "FB") |>
      group_by(position, year) |>
      summarise(mean_rush_yds = mean(rush_yds)) |>
      ungroup()
    
    # Create a side-by-side bar graph
    avg_rushyds_pos <- rec_yds_count |>
      ggplot(aes(x = year, y = mean_rush_yds, fill = position)) +
      geom_bar(stat = "identity", position = "dodge") +
      labs(title = "Average Rushing Yards by Year and Position", x = "Year", y = "Average Rushing Yards", fill="Position") +
      theme_minimal()
    avg_rushyds_pos
    
    ggsave("plots/avg_rushyds_pos.png", avg_rushyds_pos, width = 6, height = 6)

    #![A side-by-side comparison of the average rushing yards across four years for two positions: running backs and full backs](plot/avg_rushyds_pos.png){#fig-plot-14}

      rec_yds_count <- nfloffensiveplayers_new |>
        filter(position == "RB" | position == "FB") |>
        group_by(position, year) |>
        summarise(total_rush_yds = sum(rush_yds)) |>
        ungroup()
      
      # Create a side-by-side bar graph
      tot_rushyds_pos <- rec_yds_count |>
        ggplot(aes(x = year, y = total_rush_yds, fill = position)) +
        geom_bar(stat = "identity", position = "dodge") +
        labs(title = "Total Rushing Yards by Year and Position", x = "Year", y = "Total Rushing Yards", fill="Position") +
        theme_minimal()
      tot_rushyds_pos
      
      ggsave("plots/tot_rushyds_pos.png", tot_rushyds_pos, width = 6, height = 6)

      #![A side-by-side comparison between running backs and full backs of the total rushing yards across four seasona](plot/tot_rushyds_pos.png){#fig-plot-15}
        
        #@fig-plot-14 and @fig-plot-15 produce consistent results. In both graphs, running backs have significantly higher rushing yards than fullbacks. At first, these results surprised me since running backs and full backs are virtually the same position. However, after analyzing it more and looking at the dataset, I realized that teams have siginificantly more running backs than fullbacks and they use running backs more. This explains the difference in both total yards and average yards. 
        
        ### Analysis of Rushing Yards by Year
        
        Now that we have analyzed the distribution of rushing yards, I want to examine how rushing yards have changed over the last 5 years. Since running backs and fullbacks are extremely similar positions, I am going to summarize both positions for this analysis.
 
        rushyds_nfloffensiveplayers_new <- nfloffensiveplayers_new |>
          filter(position == "RB" | position == "FB") |>
          group_by(year) |>
          summarize(mean_rush_yds = mean(rush_yds))
        kable(rushyds_nfloffensiveplayers_new)

        There is a extremely high consistency when it comes to rushing yards in the nfl. It remained around 33.7 average yards across the 4 years, never differentiating by more than a yard. The average yards are also lower than recieving and passing, which makes sense since rushing generally does not lead to as many yard gains as recieving does.

        rush_yds_year <- nfloffensiveplayers_new |>
          filter(position == "RB" | position == "FB") |>
          ggplot(aes(x = year, y = rush_yds, fill=year)) +
          geom_boxplot() +
          labs(title = "Rushing Yards by Year",
               x = "Year",
               y = "Recieving Yards", fill= "Year")
        rush_yds_year
        
        ggsave("plots/rush_yds_year.png", rush_yds_year, width = 6, height = 6)

       # ![An analysis of the change in the range of receiving yards for running backs and full backs from 2019-2022](plot/rush_yds_year.png){#fig-plot-16}
          
        #  @fig-plot-16 shows a similar range among all four years. However, there are many outliers in each year. 2021 has 2 outliers that are higher than any other year. 
          
          ### Top Running Backs
         
         # Similar to the other positions, I am interested in seeing which running backs performed high enough to be the outliers. 
          

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

         # These result are consistent with the outliers, since Jonathon Taylor and Derrick Henry not only had the two highest performing games, but were also the overall top 2 highest performing running backs in the past 5 years.
          
          ### Rush Yards vs. Other Rush Variables
          
 
          rushyds_cor <- nfloffensiveplayers_new |>
            filter(position == "RB") |>
            select(rush_yds, rush_att, rush_td, rush_long, rush_scrambles, rush_yds_before_contact, rush_yac, rush_broken_tackles) |>
            cor() |>
            ggcorrplot()+
            labs(title="Correlation Plot for Statistics Relating to Rushing")
          rushyds_cor
          

         # ![A heatmap demonstrating the correlation between 8 different variables that are in relation to rushing](plot/rushyds_cor.png){#fig-plot-17}
            
          #  @fig-plot-17 shows that unlike the passing variables, the rushing variables don't have as heavy of a correlation with each other. The only variables that seem to have somewhat of a heavy correlation is rushing yards and rushing attempts, and then rushing yards and rushing yards before contact.

### Rush Attempts vs. Rush Yards

#Now, I want to further explore the correlation between rushing yards and rush attempts for running backs. 

rush_correlation_plot <- nfloffensiveplayers_new |>
  filter(position == "RB") |>
  ggplot(aes(x = rush_att, y = rush_yds)) +
  geom_point(alpha=0.3) +
  geom_smooth(method = "lm") +
  labs(title = "The Correlation Between Rush Attempts and Rush Yards",
       x = "Rushing Attempts",
       y = "Rushing Yards")
rush_correlation_plot

ggsave("plots/rush_correlation_plot.png", rush_correlation_plot, width = 6, height = 6)

#![A scatterplot showing the positive, linear relationship between two variables: Rushing Attempts and Rushing Yards](plot/rush_correlation_plot.png){#fig-plot-18}

nfl_rb <- nfloffensiveplayers_new |>
   filter(position == "RB") |>
  select(rush_att, rush_yds) |>
  cor()
kable(nfl_rb)


#@fig-plot-18 showing a high correlation between rushing yards and rushing attempts, which is an 87.5% correlation according to the table. This is consistent with the correlation shown by the heat map. It also makes sense that these two variables are related. The more attempts someone has at rushing, the more yards they will get. That said, it also makes sense that it is not extremely close to 100%, since an attempt doesn't guarantee that the running back will gain yards on the play.
            
            ### Rush Yards vs. Rush Yards Before Contact
            
          #  Next, I want to explore the relationship between rush yards and rush yards before contact.
            
 
            nfl_rushyds_comparison <- nfloffensiveplayers_new |>
              filter(position == "RB") |>
              ggplot(aes(x = rush_att, y = rush_yds_before_contact)) +
              geom_point(alpha=0.3) +
              geom_smooth(method = "lm") +
              labs(title = "The Relationship between Rushing Yards and Rushing Yards Before Contact",
                   x = "Rushing Yards",
                   y = "Rushing Yards Before Contact")
            nfl_rushyds_comparison
            
            ggsave("plots/nfl_rushyds_comparison.png", nfl_rushyds_comparison, width = 6, height = 6)

          #  ![A scatterplot demonstrating a positive correlation between between Rushing Yards Before Contact and Rushing Yards](plot/nfl_rushyds_comparison.png){#fig-plot-19}
              

              nfl_rushyds <- nfloffensiveplayers_new |>
                filter(position == "RB") |>
                select(rush_yds, rush_yds_before_contact) |>
                cor()
              kable(nfl_rushyds)

              
             # @fig-plot-19 demonstrates that there is also a heavy correlation between these two variables, at 90%. However, I am surpised the correlation is not even higher. One of the variables represents the total rush yards in a game, and the other variable represents the total rush yards in a game before the player is hit. Normally, when the player gets hit, it means the play is over. Because of this, I am surprised the correlation is not closer to 100%.