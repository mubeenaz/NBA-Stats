"""
Script used to extract detailed data for all NBA Playoffs games from 2003-2021 using
nba_api client package.
"""

# obtain nba_api dependencies
from nba_api.stats.endpoints import leaguegamelog
from nba_api.stats.endpoints import boxscoresummaryv2

# data analysis library
import pandas as pd
# import sleep to work with API calls
from time import sleep

# Example to get basic playoffs game data for teams for single NBA season
p_data = leaguegamelog.LeagueGameLog(league_id='00', season_type_all_star='Playoffs', season='2000-01')
playoff_games = p_data.league_game_log.get_data_frame()
playoff_games


# Function to get playoffs game data for any NBA season passed as argument
def get_playoffs_data(nba_season):
    games = leaguegamelog.LeagueGameLog(league_id='00', season_type_all_star='Playoffs', season=nba_season)
    df = games.league_game_log.get_data_frame()
    return df


# Function to get basic playoffs game data for teams in any NBA season passed as argument
def get_playoffs_data(nba_season):
    playoff_data = leaguegamelog.LeagueGameLog(league_id='00', season_type_all_star='Playoffs',
                                               season=nba_season).get_data_frames()
    # retrieve data frame from list
    df_b = playoff_data[0]
    df_b["TEAM_ID"] = df_b["TEAM_ID"].astype(str)
    p_game_ids = df_b["GAME_ID"].unique()      # returned data from API call contains two records for each game ID (one
    # for each team in matchup) get unique game ID

    # for each game, combine home team and away team data into single record
    # Drop columns that won't be renamed
    def get_df(df, game_id):
        season_id = df['SEASON_ID'].values[0]
        rows = df.loc[df["GAME_ID"] == game_id].drop(['GAME_ID', "SEASON_ID", "GAME_DATE"], axis=1)
        row_0 = rows.iloc[[0]]  # obtain record for one team in matchup
        row_1 = rows.iloc[[1]]  # obtain record for other team in matchup

        # Function to separate home team and away team records by renaming columns
        def rename_cols(df):
            if "vs" in df['MATCHUP'].values[0]:
                df.columns = [x + '_HOME' for x in df.columns]
            else:
                df.columns = [x + '_AWAY' for x in df.columns]
            return df

        # merge home team and away team records into one record across vertical axis
        # bring dropped columns back
        row_0 = rename_cols(row_0).reset_index(drop=True)
        row_1 = rename_cols(row_1).reset_index(drop=True)
        df = pd.concat([row_0, row_1], axis=1)
        cols = list(df.columns.values)
        cols = ['GAME_ID', "SEASON_ID"] + cols
        df["GAME_ID"] = game_id
        df["SEASON_ID"] = season_id
        df = df[cols]
        return df

    # iterate procedure for all playoff games in given season
    df_b = pd.concat([get_df(df_b, game_id) for game_id in p_game_ids], axis=0)
    return df_b


# Define seasons for which playoffs data will be extracted
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

# get basic playoffs game data for all teams in defined seasons
playoffs_data = []
for nba_season in seasons:
    print(nba_season)
    playoffs = get_playoffs_data(nba_season)
    playoffs_data.append(playoffs)

# combine basic playoffs game data from all seasons into one data frame
playoffs_df1 = pd.concat(playoffs_data, ignore_index=True)

# get list of game_id's for all playoff games in defined seasons
playoff_game_ids = playoffs_df1['GAME_ID'].tolist()

# Example to get detailed playoff game box score summary for single game
game_id = '0042000406'
game = boxscoresummaryv2.BoxScoreSummaryV2(game_id=game_id)
gamep = game.get_data_frames()


# function to get detailed playoff game box score summary for all playoff games in defined seasons
def get_playoff_box_score_summaries(game_id_p):
    pgame = boxscoresummaryv2.BoxScoreSummaryV2(game_id_p, timeout=100)
    playoff_game_details_df = pgame.get_data_frames()

    # merge separate dataframes returned for each game into single dataframe across vertical axis
    playoff_game_summary = playoff_game_details_df[0]
    home_team_id = playoff_game_summary['HOME_TEAM_ID'].values[0]
    visitor_team_id = playoff_game_summary['VISITOR_TEAM_ID'].values[0]
    playoff_game_summary['GAME_STATUS_ID'] = playoff_game_summary['GAME_STATUS_ID'].astype(str)
    playoff_game_summary['HOME_TEAM_ID'] = playoff_game_summary['HOME_TEAM_ID'].astype(str)
    playoff_game_summary['VISITOR_TEAM_ID'] = playoff_game_summary['VISITOR_TEAM_ID'].astype(str)

    other_stats = playoff_game_details_df[1]
    other_stats['TEAM_ID'] = other_stats['TEAM_ID'].astype(str)
    other_stats_home = other_stats.loc[other_stats['TEAM_ID'] == str(home_team_id)].drop(['LEAGUE_ID'],
                                                                                         axis=1).reset_index(drop=True)
    other_stats_visitor = other_stats.loc[other_stats['TEAM_ID'] == str(visitor_team_id)].drop(['LEAGUE_ID'],
                                                                                               axis=1).reset_index(
        drop=True)
    try:
        league_id = other_stats['LEAGUE_ID'].values[0]
    except:
        try:
            league_id = other_stats['LEAGUE_ID'].values
        except:
            league_id = None

    # separate stats by home team and away team
    other_stats_home.columns = [col + '_HOME' for col in other_stats_home.columns]
    other_stats_visitor.columns = [col + '_AWAY' for col in other_stats_visitor.columns]
    other_stats = pd.concat([other_stats_home, other_stats_visitor], axis=1)
    other_stats['LEAGUE_ID'] = league_id

    # concatenate previous two dataframes across horizontal axis
    dfp = pd.concat([playoff_game_summary, other_stats], axis=1)

    game_info = playoff_game_details_df[4]

    # concatenate current dataframe with subsequent dataframe
    dfp = pd.concat([dfp, game_info], axis=1)

    # drop columns that won't be renamed, separate each game data by home team and away team
    line_score = playoff_game_details_df[5]
    line_score['TEAM_ID'] = line_score['TEAM_ID'].astype(str)
    line_score = line_score.drop(['GAME_DATE_EST', "GAME_SEQUENCE", "GAME_ID"], axis=1)
    line_score_home = line_score.loc[line_score['TEAM_ID'] == str(home_team_id)].reset_index(drop=True)
    line_score_visitor = line_score.loc[line_score['TEAM_ID'] == str(visitor_team_id)].reset_index(drop=True)
    line_score_home.columns = [col + '_HOME' for col in line_score.columns]
    line_score_visitor.columns = [col + '_AWAY' for col in line_score.columns]
    line_score = pd.concat([line_score_home, line_score_visitor], axis=1)

    # concatenate current dataframe with subsequent dataframe
    dfp = pd.concat([dfp, line_score], axis=1)

    # change column type
    last_meeting = playoff_game_details_df[6]
    last_meeting = last_meeting.drop(['GAME_ID'], axis=1)
    last_meeting['LAST_GAME_HOME_TEAM_ID'] = last_meeting['LAST_GAME_HOME_TEAM_ID'].astype(str)
    last_meeting['LAST_GAME_VISITOR_TEAM_ID'] = last_meeting['LAST_GAME_VISITOR_TEAM_ID'].astype(str)

    # concatenate current dataframe with subsequent dataframe
    dfp = pd.concat([dfp, last_meeting], axis=1)

    # drop duplicate columns
    season_series = playoff_game_details_df[7]
    season_series = season_series.drop(['GAME_ID', 'HOME_TEAM_ID', 'VISITOR_TEAM_ID', 'GAME_DATE_EST'], axis=1)
    season_series = season_series.rename({'LAST_GAME_VISITOR_TEAM_CITY1': "LAST_GAME_VISITOR_TEAM_CITY"}, axis=1)

    # concatenate current dataframe with subsequent dataframe
    dfp = pd.concat([dfp, season_series], axis=1)

    available_video = playoff_game_details_df[8]
    available_video = available_video.drop(['GAME_ID'], axis=1)

    # drop duplicate columns
    # concatenate current dataframe with subsequent dataframe
    dfp = pd.concat([dfp, available_video], axis=1).drop(['TEAM_ID_HOME', 'TEAM_ID_AWAY', 'TEAM_ABBREVIATION_HOME',
                                                          'TEAM_ABBREVIATION_AWAY', 'PTS_AWAY', 'PTS_AWAY'], axis=1)
    # return final dataframe
    return dfp


# iterate through to get detailed playoff game box score data for each playoff game in defined seasons
# sleep in between each API call to avoid timeout errors
playoffs_df2 = []
playoffs_df2 = [(sleep(.600), get_playoff_box_score_summaries(game_id_p)) for game_id_p in playoff_game_ids]
playoffs_df2 = pd.concat([df[1] for df in playoffs_df2], axis=0)
playoffs_df2 = playoffs_df2.reset_index(drop=True)


# find position of records with duplicate game id's
# drop second instance of duplicate game id records
dup = playoffs_df2.duplicated(subset=['GAME_ID'], keep=False)
playoffs_df2.drop_duplicates(subset=['GAME_ID'], inplace=True, ignore_index=True)


# combine basic and detailed playoffs game stats dataframes into single dataframe
final_playoffs_df = pd.concat([playoffs_df1, playoffs_df2], axis=1)


# write final dataframe to csv file
final_playoffs_df.to_csv('playoffs_data', index=False, date_format='%Y/%m/%d')
final_playoffs_df.info(verbose=True)

