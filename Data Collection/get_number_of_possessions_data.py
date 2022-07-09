"""
Script used to extract number of possessions data for each team in all regular season and playoffs games
from 2003-2021 using nba_api client package
"""

# obtain nba_api dependencies
from nba_api.stats.endpoints import boxscoreadvancedv2
# import pandas as pd
import pandas as pd
# import csv module
import csv
from time import sleep


""" The following is a sample to obtain data for a single game """


# return all dataframes from API call
boxscore_advanced = boxscoreadvancedv2.BoxScoreAdvancedV2(game_id='0042000406').get_data_frames()

# extract only the TeamStats dataframe from the two returned in API response
df_team_boxscore = boxscore_advanced[1]

# extract individual records of each team in game and combine into single row
dfrow1 = df_team_boxscore.iloc[[0]]
dfrow2 = df_team_boxscore.iloc[[1]].reset_index(drop=True)
finaldf = dfrow1.join(dfrow2, lsuffix='_AWAY', rsuffix='_HOME')     # distinguish separate records in combined row by
# home team and away team


""" The following code automates the sample procedure above for all games in my analysis """


# read csv file which contains all GAME_IDs and place into list
with open('GAME_IDs.csv', encoding='utf-8-sig') as csv_file:
    reader = csv.reader(csv_file)
    GAME_IDs = list(reader)


# extract GAME_ID element from list of lists
GAME_IDs = [row[0] for row in GAME_IDs]


# Function to get possessions data for any game
def get_possessions_data(game_id):
    boxscore_advanced = boxscoreadvancedv2.BoxScoreAdvancedV2(game_id=game_id, timeout=100).get_data_frames()
    df_team_boxscore = boxscore_advanced[1]
    dfrow1 = df_team_boxscore.iloc[[0]]
    dfrow2 = df_team_boxscore.iloc[[1]].reset_index(drop=True)
    finaldf = dfrow1.join(dfrow2, lsuffix='_AWAY', rsuffix='_HOME')
    return finaldf


# define lists which will hold returned dataframes from subsets of API calls
possessions_data1 = []
possessions_data2 = []
possessions_data3 = []
possessions_data4 = []
possessions_data5 = []
possessions_data6 = []
possessions_data7 = []
possessions_data8 = []
possessions_data9 = []
possessions_data10 = []
possessions_data11 = []
possessions_data12 = []


# iterate to get possessions data for every game in GAME_IDs
for game in GAME_IDs[19000:]:
    POSS = get_possessions_data(game)
    possessions_data9.append(POSS)
    sleep(.600)


# combine individual lists into single list of all dataframes
final_list = possessions_data1+possessions_data2+possessions_data3+possessions_data4+possessions_data5+possessions_data6+\
             possessions_data7+possessions_data8+possessions_data9


# combine list of dataframes into single dataframe
final_POSS_df = pd.concat(final_list, axis=0, ignore_index=True)


# retrieve columns of interest
POSS_data = final_POSS_df.loc[:, ['GAME_ID_AWAY', 'TEAM_CITY_AWAY', 'TEAM_NAME_AWAY', 'PACE_AWAY', 'POSS_AWAY',
                                  'TEAM_CITY_HOME', 'TEAM_NAME_HOME', 'PACE_HOME', 'POSS_HOME']]

# write final dataframe to csv
POSS_data.to_csv('number_of_possessions_data', index=False)

