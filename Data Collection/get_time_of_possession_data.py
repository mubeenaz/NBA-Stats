"""
Script used to extract average Time of Possession data for all NBA teams for both regular season and
playoffs games from 2013-2021 by web scraping NBA stats website and using the NBA API.
"""


# import requests module to work with server
import requests
import pandas as pd


# set request header for successful return of data
header = {
    'Accept': 'application/json, text/plain, */*',
    'Accept-Encoding': 'gzip, deflate, br',
    'Accept-Language': 'en-US,en;q=0.9',
    'Connection': 'keep-alive',
    'Referer': 'https://www.nba.com/',
    'Sec-Fetch-Mode': 'cors',
    'Sec-Fetch-Site': 'same-site',
    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) '
                  'Chrome/103.0.0.0 Safari/537.36',
    'x-nba-stats-origin': 'stats',
    'x-nba-stats-token': 'true'}


# define all column names so data can be stored in dataframe form
columns_list = [
    "TEAM_ID",
    "TEAM_ABBREVIATION",
    "TEAM_NAME",
    "GP",
    "W",
    "L",
    "MIN",
    "POINTS",
    "TOUCHES",
    "FRONT_CT_TOUCHES",
    "TIME_OF_POSS",
    "AVG_SEC_PER_TOUCH",
    "AVG_DRIB_PER_TOUCH",
    "PTS_PER_TOUCH",
    "ELBOW_TOUCHES",
    "POST_TOUCHES",
    "PAINT_TOUCHES",
    "PTS_PER_ELBOW_TOUCH",
    "PTS_PER_POST_TOUCH",
    "PTS_PER_PAINT_TOUCH"
]


# define all seasons for which data will be extracted
seasons = ['2003-04',
           '2004-05',
           '2005-06',
           '2006-07',
           '2007-08',
           '2008-09',
           '2009-10',
           '2010-11',
           '2011-12',
           '2012-13',
           '2013-14',
           '2014-15',
           '2015-16',
           '2016-17',
           '2017-18',
           '2018-19',
           '2019-20',
           '2020-21'
           ]


# create list which will hold all regular season dataframes
TOP_regseason = []
for season in seasons:
    # define url to be passed in get request
    time_of_possession_url_rs = 'https://stats.nba.com/stats/leaguedashptstats?College=&Conference=&Country=&DateFrom' \
                             '=&DateTo=&Division=&DraftPick=&DraftYear=&GameScope=&GameSegment=&Height=&LastNGames=0' \
                             '&LeagueID=00&Location=&Month=0&OpponentTeamID=0&Outcome=&PORound=0&PerMode=PerGame' \
                             '&Period=0&PlayerExperience=&PlayerOrTeam=Team&PlayerPosition=&PtMeasureType=Possessions' \
                             '&Season='+season+'&SeasonSegment=&SeasonType=Regular+Season&StarterBench=&TeamID=0' \
                             '&VsConference=&VsDivision=&Weight= '
    # obtain response from server in json form
    response = requests.get(url=time_of_possession_url_rs, headers=header).json()
    # access desired data from returned json
    time_of_possession_data_rs = response['resultSets'][0]['rowSet']
    # create dataframe using data and column labels
    TOPrs_df = pd.DataFrame(data=time_of_possession_data_rs, columns=columns_list)
    # add two columns which identify season year and season type
    TOPrs_df['SEASON'] = season
    TOPrs_df['GAME_TYPE'] = 'Regular Season'
    print(season)
    # append each season's data to list
    TOP_regseason.append(TOPrs_df)

# combine list of dataframes into single dataframe
final_TOP_regseason_df = pd.concat(TOP_regseason, ignore_index=True)


""" Repeat the above procedure to obtain playoffs data """


TOP_playoffs = []
for season in seasons:
    time_of_possession_url_p = 'https://stats.nba.com/stats/leaguedashptstats?College=&Conference=&Country=&DateFrom' \
                             '=&DateTo=&Division=&DraftPick=&DraftYear=&GameScope=&GameSegment=&Height=&LastNGames=0' \
                             '&LeagueID=00&Location=&Month=0&OpponentTeamID=0&Outcome=&PORound=0&PerMode=PerGame' \
                             '&Period=0&PlayerExperience=&PlayerOrTeam=Team&PlayerPosition=&PtMeasureType=Possessions' \
                             '&Season='+season+'&SeasonSegment=&SeasonType=Playoffs&StarterBench=&TeamID=0' \
                             '&VsConference=&VsDivision=&Weight= '
    response = requests.get(url=time_of_possession_url_p, headers=header).json()
    time_of_possession_data_p = response['resultSets'][0]['rowSet']
    TOPp_df = pd.DataFrame(data=time_of_possession_data_p, columns=columns_list)
    TOPp_df['SEASON'] = season
    TOPp_df['GAME_TYPE'] = 'Playoffs'
    print(season)
    TOP_playoffs.append(TOPp_df)


# combine list of dataframes into single dataframe
final_TOP_playoffs_df = pd.concat(TOP_playoffs, ignore_index=True)


# combine regular season and playoffs data into single dataframe
df_list = [final_TOP_regseason_df, final_TOP_playoffs_df]
final_TOP_df = pd.concat(df_list, ignore_index=True)


# retrieve columns of interest
TOP_data = final_TOP_df.loc[:, ['TEAM_ID', 'TEAM_NAME', 'TIME_OF_POSS', 'AVG_SEC_PER_TOUCH', 'SEASON', 'GAME_TYPE']]


# write final dataframe to csv
TOP_data.to_csv('time_of_possessions_data', index=False)