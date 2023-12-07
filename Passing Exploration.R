## Passing Analysis
  
  N#ext, I want to examine passing.
  
  ### Passing Yards Across Years
  
  #First, I am going to analyze the passing yards across years.
  

  passyds_nfloffensiveplayers_new <- nfloffensiveplayers_new |>
    filter(position == "QB") |>
    group_by(year) |>
    summarize(mean_pass_yds = mean(pass_yds))
  kable(passyds_nfloffensiveplayers_new)

  
  #The average passing yards in the nfl is interesting. You have to pass a ball to recieve it, so I am surprised that there is a higher range of differences year by year in passing than in recieving. There was a downward trend in average recieving yards from 2019 to 2021, but then it went back up. I think the disaparity between throwing and recieving could be explained by the fact that there is only one quarterback on an nfl team, compared to multiple recievers.
  

  pass_yds_year <- nfloffensiveplayers_new |>
    filter(position == "QB") |>
    ggplot(aes(x = year, y = pass_yds, fill=year)) +
    geom_boxplot() +
    labs(title = "Passsing Yards by Year",
         x = "Year",
         y = "Passing Yards", fill= "Year")
  pass_yds_year
  
  ggsave("plots/pass_yds_year.png", pass_yds_year, width = 6, height = 6)

 # ![A side-by-side comparison of the overall passing yards for quarterbacks across 4 years](plot/pass_yds_year.png){#fig-plot-9}
    
    #@fig-plot-9 shows that the range of passing yards is pretty consistent, similar to the averages, althought there is a small downward trend. There are almost now outliers, except for 1 extreme outlier in 2019 and 2 extreme outliers in 2021.
    
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
    
    Now that we have analyzed passing yards, I am interested in analyzing the relationship between passing yards and the other variables related to passing: pass completions, pass attempts, pass interceptions, passes sacked, and pass rating.
    

    pass_cor <- nfloffensiveplayers_new |>
      filter(position == "QB") |>
      select(pass_cmp, pass_yds, pass_att, pass_int, pass_sacked, pass_rating, pass_target_yds, pass_poor_throws, pass_blitzed, pass_hurried) |>
      cor() |>
      ggcorrplot() +
      labs(title="Correlation Plot for Statistics Relating to Passing")
    
    pass_cor
    
    ggsave("plots/pass_cor.png", pass_cor, width = 6, height = 6)

    #![A heatmap showing the correlation between 10 different variables related to passing: the part of football being explored](plot/pass_cor.png){#fig-plot-10}
      
      #@fig-plot-10 shows that the three variables with the highest correlations to each other are pass completions, pass yards, and pass attempts. I am interested in further exploring relationship with those 3 variables.
      
      ### Pass Completions vs. Pass Yards vs. Pass Attempts
      
      #First, I want to further explore the correlation between passing yards, pass completions, and pass attempts for quarterbacks. 
      

      pass_var_core <- nfloffensiveplayers_new |>
        select(pass_cmp, pass_att, pass_yds) |>
        ggpairs(aes(alpha = 0.2)) +
        labs(title="The Correlation Between Pass Completions, Pass Attempts, and Pass Yards", x="Yards", y="Frequency")
      
      pass_var_core
      
      ggsave("plots/pass_var_core.png", pass_var_core, width = 6, height = 6)

      #![A representation of the visual and numeric correlation between three variables: passing yards, passing attempts, and pass completions](plot/pass_var_core.png){#fig-plot-11}
        
       # @fig-plot-11 explores the relationship between all 3 at the same time. The variables all have high correlations with each other and demonstrates a positive correlation in the graphs. 
        
        #Althought they are all similar, pass completions and pass attempts have a slightly higher correlation than the other variables. Pass yards and pass completions have the second highest correlation, and pass yards and pass attempts have the lowest correlation. 