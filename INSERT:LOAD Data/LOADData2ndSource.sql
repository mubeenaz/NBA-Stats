USE NBA;

DROP TABLE IF EXISTS Games_ALL;
CREATE TABLE Games_ALL ( 
GAME_DATE_EST DATE,
GAME_ID INT,
GAME_STATUS_TEXT TEXT,
HOME_TEAM_ID INT,
VISITOR_TEAM_ID INT,
SEASON INT,
TEAM_ID_home INT,
PTS_home INT,
FG_PCT_home DOUBLE,
FT_PCT_home DOUBLE,
FG3_PCT_home DOUBLE,
AST_home INT,
REB_home INT,
TEAM_ID_away INT,
PTS_away INT,
FG_PCT_away DOUBLE,
FT_PCT_away DOUBLE,
FG3_PCT_away DOUBLE,
AST_away INT,
REB_away INT,
HOME_TEAM_WINS BOOLEAN
);

DROP TABLE IF EXISTS Games_Player_Stats;
CREATE TABLE Games_Player_Stats (
GAME_ID INT,
TEAM_ID INT,
TEAM_ABBREVIATION CHAR(3),
TEAM_CITY TEXT,
PLAYER_ID INT,
PLAYER_NAME TEXT,
FIRST_NAME TEXT,
START_POSITION ENUM('G', 'F', 'C', 'Bench'),
NOTES TEXT,
MIN_played TIME,
FGM INT,
FGA INT,
FG_PCT DOUBLE,
FG3M INT,
FG3A INT,
FG3_PCT DOUBLE,
FTM INT,
FTA INT,
FT_PCT DOUBLE,
OREB INT,
DREB INT,
REB INT,
AST INT,
STL INT,
BLK INT,
TOV INT,
PF INT,
PTS INT,
PLUS_MINUS INT 
);

DESC games_all;
DESC games_player_stats;

-- Check server-side permission for loading local data. If OFF, turn ON
-- **Client-side permission has already been set to ON in Workbench 
SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';					-- Verify 

-- USE LOAD DATA LOCAL command to import data into Games_ALL table from input file 
LOAD DATA LOCAL INFILE '/Users/mubeen/Documents/Projects/SQL/NBA Project/gamesED.csv' INTO TABLE Games_ALL
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES 
(@GAME_DATE_EST,GAME_ID,GAME_STATUS_TEXT,HOME_TEAM_ID,VISITOR_TEAM_ID,SEASON,TEAM_ID_home,PTS_home,FG_PCT_home,FT_PCT_home,
FG3_PCT_home,AST_home,REB_home,TEAM_ID_away,PTS_away,FG_PCT_away,FT_PCT_away,FG3_PCT_away,AST_away,REB_away,HOME_TEAM_WINS)

-- Convert input date string to proper format
SET GAME_DATE_EST = STR_TO_DATE(@GAME_DATE_EST, '%m/%d/%y');

-- Upon first execution, 1024 warnings displayed, but 1188 actual warnings 
SHOW WARNINGS;
-- Change number of warnings displayed by server by setting max_error_count variable 
SHOW VARIABLES LIKE 'max_error%';						-- 1024
SET max_error_count = 65000;
SHOW VARIABLES LIKE 'max_error%';						-- Verify 


-- 2nd execution was a success with 0 warnings 
LOAD DATA LOCAL INFILE '/Users/mubeen/Documents/Projects/SQL/NBA Project/gamesED.csv' INTO TABLE Games_ALL
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES 
(@GAME_DATE_EST,GAME_ID,GAME_STATUS_TEXT,HOME_TEAM_ID,VISITOR_TEAM_ID,SEASON,TEAM_ID_home,@PTS_home,@FG_PCT_home,@FT_PCT_home,
@FG3_PCT_home,@AST_home,@REB_home,TEAM_ID_away,@PTS_away,@FG_PCT_away,@FT_PCT_away,@FG3_PCT_away,@AST_away,@REB_away,HOME_TEAM_WINS)

-- Convert input date string to proper format
-- Use IF logic to replace all empty cells in input file with NULLs. else, keep original value upon mapping
SET 
	GAME_DATE_EST = STR_TO_DATE(@GAME_DATE_EST, '%m/%d/%y'), 
    PTS_home = NULLIF(@PTS_home, ''),
    FG_PCT_home = NULLIF(@FG_PCT_home, ''),
	FT_PCT_home = NULLIF(@FT_PCT_home, ''),
    FG3_PCT_home = NULLIF(@FG3_PCT_home, ''),
    AST_home = NULLIF(@AST_home, ''),
	REB_home = NULLIF(@REB_home, ''),
	PTS_away = NULLIF(@PTS_away, ''),
	FG_PCT_away = NULLIF(@FG_PCT_away, ''),
	FT_PCT_away = NULLIF(@FT_PCT_away, ''),
	FG3_PCT_away = NULLIF(@FG3_PCT_away, ''),
	AST_away = NULLIF(@AST_away, ''),
	REB_away = NULLIF(@REB_away, '')
    ;

-- Confirm successfull import of all data 
SELECT*
FROM games_all;

/* NEW SESSION */

-- Check server-side permission for loading local data. If OFF, turn ON
-- **Client-side permission has already been set to ON in Workbench 
SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';					-- Verify 

-- Check Warning message constraints 
SHOW VARIABLES LIKE 'max_error%';						-- 1024
SET max_error_count = 65000;
SHOW VARIABLES LIKE 'max_error%';						-- Verify 

-- USE LOAD DATA LOCAL command to import data into Games_Player_Stats table from input file
LOAD DATA LOCAL INFILE '/Users/mubeen/Documents/Projects/SQL/NBA Project/games_detailsED.csv' INTO TABLE Games_Player_Stats
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(GAME_ID,TEAM_ID,TEAM_ABBREVIATION,TEAM_CITY,PLAYER_ID,PLAYER_NAME,FIRST_NAME,@START_POSITION,NOTES,@MIN_played,@FGM,@FGA,@FG_PCT,@FG3M,@FG3A,
@FG3_PCT,@FTM,@FTA,@FT_PCT,@OREB,@DREB,@REB,@AST,@STL,@BLK,@TOV,@PF,@PTS,@PLUS_MINUS)

SET 
	START_POSITION = (CASE WHEN @START_POSITION = '' THEN 'Bench' ELSE @START_POSITION END),
    MIN_played = (CASE WHEN @MIN_played = '' THEN NULL ELSE STR_TO_DATE(@MIN_played, '%i:%s:%H') END),
    FGM = NULLIF(@FGM, ''), 
    FGA = NULLIF(@FGA, ''), 
    FG_PCT = NULLIF(@FG_PCT, ''), 
    FG3M = NULLIF(@FG3M, ''), 
    FG3A = NULLIF(@FG3A, ''), 
	FG3_PCT = NULLIF(@FG3_PCT, ''), 
    FTM = NULLIF(@FTM, ''), 
    FTA = NULLIF(@FTA, ''), 
    FT_PCT = NULLIF(@FT_PCT, ''), 
    OREB = NULLIF(@OREB, ''), 
    DREB = NULLIF(@DREB, ''), 
    REB = NULLIF(@REB, ''), 
    AST = NULLIF(@AST, ''), 
    STL = NULLIF(@STL, ''), 
    BLK = NULLIF(@BLK, ''), 
    TOV = NULLIF(@TOV, ''), 
    PF = NULLIF(@PF, ''), 
    PTS = NULLIF(@PTS, ''), 
    PLUS_MINUS = NULLIF(@PLUS_MINUS, '')
;
    
-- Confirm successfull import of all data 
Select*
From Games_Player_Stats;

-- Disable sql_safe_updates for successful UPDATE execution
SHOW VARIABLES LIKE 'sql_safe%';
SET sql_safe_updates = 0;					-- Turn OFF
SHOW VARIABLES LIKE 'sql_safe%';			-- Verify 

-- Start Transaction in order to be safe when updating records
START TRANSACTION;
-- UPDATE 8 MIN_played records where input file value was >= 60:00:00 
UPDATE Games_Player_Stats SET 
	MIN_played = '01:00:06' WHERE GAME_ID = 20800575 AND TEAM_ID = 1610612744 AND PLAYER_ID = 2037;
UPDATE Games_Player_Stats SET 
    MIN_played = '01:00:06' WHERE GAME_ID = 20500438 AND TEAM_ID = 1610612756 AND PLAYER_ID = 1890;
UPDATE Games_Player_Stats SET 
	MIN_played = '01:00:12' WHERE GAME_ID = 20300809 AND TEAM_ID = 1610612745 AND PLAYER_ID = 1749;  
UPDATE Games_Player_Stats SET 
    MIN_played = '01:04:58' WHERE GAME_ID = 41800233 AND TEAM_ID = 1610612743 AND PLAYER_ID = 203999;
UPDATE Games_Player_Stats SET 
    MIN_played = '01:00:01' WHERE GAME_ID = 41800233 AND TEAM_ID = 1610612757 AND PLAYER_ID = 203468;
UPDATE Games_Player_Stats SET 
    MIN_played = '01:00:07' WHERE GAME_ID = 21600711 AND TEAM_ID = 1610612737 AND PLAYER_ID = 200794;
UPDATE Games_Player_Stats SET 
    MIN_played = '01:00:20' WHERE GAME_ID = 21300566 AND TEAM_ID = 1610612741 AND PLAYER_ID = 202710;
UPDATE Games_Player_Stats SET 
    MIN_played = '01:00:00' WHERE GAME_ID = 21200095 AND TEAM_ID = 1610612761 AND PLAYER_ID = 201942;

-- Check to see if records properly updated 
SELECT*
FROM Games_Player_Stats
WHERE EXTRACT(HOUR FROM MIN_played) >= 1;

-- Commit changes to server 
COMMIT;

/* NEW SESSION */

-- Disable sql_safe_updates for successful UPDATE execution
SHOW VARIABLES LIKE 'sql_safe%';
SET sql_safe_updates = 0;					-- Turn OFF
SHOW VARIABLES LIKE 'sql_safe%';			-- Verify 

-- Start Transaction in order to be safe when updating records
START TRANSACTION; 
-- UPDATE all records for which FIRST_NAME is empty 
UPDATE Games_Player_Stats SET 
	FIRST_NAME = LEFT(PLAYER_NAME, LOCATE(' ', PLAYER_NAME) - 1)
WHERE FIRST_NAME = '';

-- Check to see if records properly updated 
SELECT PLAYER_NAME, FIRST_NAME
FROM Games_Player_Stats;

-- UPDATE Nene's FIRST_NAME records 
UPDATE Games_Player_Stats SET
	FIRST_NAME = 'Nene' 
WHERE FIRST_NAME = '';

-- Commit changes to server 
COMMIT;

-- ADD last name column to Games_Player_Stats table
ALTER TABLE Games_Player_Stats
ADD COLUMN LAST_NAME TEXT AFTER FIRST_NAME;

-- Verify updated table structure 
DESC Games_Player_Stats;

-- Start Transaction in order to be safe when updating records
START TRANSACTION;
-- Populate new last name column
UPDATE Games_Player_Stats SET
	LAST_NAME = RIGHT(PLAYER_NAME, LENGTH(PLAYER_NAME) - LOCATE(' ', PLAYER_NAME));

-- Leave last name empty for Nene
UPDATE Games_Player_Stats SET
	LAST_NAME = ''
    WHERE FIRST_NAME = 'Nene';

-- Check to see proper updates of records 
SELECT PLAYER_NAME, FIRST_NAME, LAST_NAME
FROM Games_Player_Stats;

-- Commit changes to server 
COMMIT;


