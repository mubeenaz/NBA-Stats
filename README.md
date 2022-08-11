# NBA Stats

To view the visualization which supplements this project, [Click Here](https://public.tableau.com/app/profile/mubeen1173/viz/NBARegularSeasonvsPlayoffs/Dashboard1)

## Introduction

I fell in love with the game of basketball at a very young age. I knew it was something deep when I found myself waking up at 5 or 6 A.M. some mornings and working on my craft in an empty gym. This passion translated into viewing every aspect of the game with great detail. To this day, there's a certain level of excitement that I feel and something to always look forward to in my days when the NBA season is in full swing. That is why choosing to do a project around my love for basketball as I transition into the data field was a no-brainer for me. 

There are 3 stages of games in every NBA season: Pre-Season, Regular Season, and Playoffs (also known as Post-Season). Any avid NBA fan who watches the games in detail can tell that teams and players don't necessarily play the same way in each of these season types. For example, many star players on every team don't play in all Pre-Season games, if any at all sometimes. However, you sure won't see them miss any games in the Playoffs barring any serious injuries. Additionally, you might notice teams tightening up their schemes and playstyles in the Playoffs as opposed to the Pre-Season where they may be a little more sloppy. As a fan and someone who has watched NBA games for almost two decades now, I can tell such differences - along with many others - exist but wanted to be able to statistically analyze them. 

So, in this project I specifically explore if NBA teams play differently in Regular Season games versus Playoffs games by analyzing their performances in various stat categories (Assists, Points, etc.) between the two season types. If differences do exist, I'd like to further analyze if they're statistically significant through statistical testing. 

## Highlights 

### Data Collection 

The datasets used for analysis were obtained through a couple different methods. All regular season and playoffs data was available for download on Kaggle.com through users Wyatt Walsh and Nathan Lauga, respectively. However, after realizing that the playoffs dataset did not complement my analysis the way I initially hoped, I decided to obtain the playoffs data myself through other means. 

Using Python and Walsh's source code as a guide, I extracted NBA playoffs data from the NBA API client package, nba_api. One specific stat - Time of Possession/game - I wanted to include in my analysis was not available in either of the regular season or playoffs datasets, so I utilized Python once again along with the nba_api package and web scraping to obtain the desired data. 

### Data Cleaning 

Data cleaning operations and transformations were performed in both Excel and SQL. Some of these included:
 - removing unwanted data points 
 - removing duplicates 
 - re-formatting/converting data types 
 - handling empty data (NULLs)
 - splitting compound fields 
 - structuring data 

### Analysis 

The analysis phase consisted of two parts: 
1. **Descriptive & Exploratory Analysis** (SQL) - querying the database using SQL, I was able to obtain the averages of all stats for every team and NBA season in my analysis. For example, the avergage number of Points, Assists, etc. the Los Angeles Lakers had for all Regular Season games in 2009. 
2. **Statistical Testing using Dependent Samples t-Test** (Excel) - Since the same subjects (NBA teams) performance in various stats was analyzed at different times in a given NBA season, such testing allowed to determine if any differences in stats between Regular Season and Playoffs games were *significantly different*. 

### Results 

A dashboard was created (linked at top of page) to portray the results. Generally, NBA teams perform significantly different between Regular Season and Playoffs games in the following stats: AST, FGA, OREB, PF, PTS, PTS PAINT, TIME per POSS, TOV (8 out of 9 stats used in analysis). Therefore, it can be concluded that NBA teams do, in fact, play a different game in the Playoffs versus the Regular Season. 

## Repository Contents

`CSV Files`: list of input files whose tables were loaded into MySQL NBA database. The `GAME_IDs.csv` carried the list of games which were iterated over in the `get_number_of_possessions_data.py` script to obtain total number of possessions stat for each team in every matchup 

`Data Collection`: contains Python scripts used to extract desired stats data from NBA stats API

`ERD Files`: contains PDF versions of Entity Relationship Diagram models for NBA database 

`Excel Files`: contains files which were used to create dashboard 

`INSERT:LOAD Data`: SQL scripts which loaded all data sources into MySQL NBA database 

`Misc. Files`: miscellaneous files 

`Original Data Sources`: contains all original data source files 
- file names suffixed OG denote original files 
- file names suffixed ED denote edited files 

`NBA Project Documentation.docx`: step-by-step documentation for entire project including commentary 

`Statistical Significance.xlsx`: Excel file which contains work for statistical testing 

`database_design.sql`: contains SQL queries/commands used to manage NBA database design

`querying_NBA_database.sql`: contains SQL queries to extract data from NBA database 

`NBA Team Logos`: folder that contains images of all NBA team logos used in Tableau visualization 

## Acknowledgments 

I wouldn't have been able to complete this project without the help of some notable people. I'd like to thank Wyatt Walsh for providing probably the most detailed NBA dataset available online through Kaggle. Although I didn't end up using Nathan Lauga's dataset on Kaggle which contained NBA playoffs data, I still incorporated it in my database as it may prove to be useful for future developments. The Learn With Jabe YouTube channel really helped me during the data collection process and using Python to extract desired stats from NBA.com through it's API; so, many thanks to John Mannelly. Lastly, I'd like to thank Tableau Forum Ambassador Ayinde Hammed for assisting me with conditionally formatting the stats table displayed in the dashboard. Most of the support from these people was indirect and they may never see this project, but I wanted to make it known how much I appreciated their efforts in helping bring this project to life. 







