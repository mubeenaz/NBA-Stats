

-- Create table to hold number of possessions data for every game 
DROP TABLE IF EXISTS num_of_possessions;
CREATE TABLE num_of_possessions (
GAME_ID INT, 
SEASON INT, 
GAME_TYPE TEXT,
TEAM_CITY_HOME TEXT, 
TEAM_NAME_HOME TEXT, 
PACE_HOME REAL,
POSS_HOME INT,
TEAM_CITY_AWAY TEXT,
TEAM_NAME_AWAY TEXT,
PACE_AWAY REAL,
POSS_AWAY INT
);


-- Create table to hold average time of possessions data for every team 
DROP TABLE IF EXISTS time_of_possessions;
CREATE TABLE time_of_possessions (
TEAM_ID INT,
SEASON INT,
GAME_TYPE TEXT,
TEAM_NAME_FULL TEXT,
TEAM_CITY TEXT,
TEAM_NAME TEXT,
TIME_OF_POSS REAL,
AVG_SEC_PER_TOUCH REAL
);


/* Load data into num_of_possessions and time_of_possessions tables from their CSV files */
SHOW VARIABLES LIKE "%infile";
SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE "/Users/mubeen/Documents/Projects/SQL/NBA Project/numPOSS.csv" INTO TABLE num_of_possessions
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES

(GAME_ID,SEASON,GAME_TYPE,TEAM_CITY_HOME,TEAM_NAME_HOME,@PACE_HOME,@POSS_HOME,TEAM_CITY_AWAY,TEAM_NAME_AWAY,@PACE_AWAY,@POSS_AWAY)

SET 
	PACE_HOME = (CASE WHEN @PACE_HOME = '' THEN 0 ELSE @PACE_HOME END), 
	POSS_HOME = (CASE WHEN @POSS_HOME = '' THEN 0 ELSE @POSS_HOME END), 
	PACE_AWAY = (CASE WHEN @PACE_AWAY = '' THEN 0 ELSE @PACE_AWAY END), 
	POSS_AWAY = (CASE WHEN @POSS_AWAY = '' THEN 0 ELSE @POSS_AWAY END) 
;


LOAD DATA LOCAL INFILE "/Users/mubeen/Documents/Projects/SQL/NBA Project/timePOSS.csv" INTO TABLE time_of_possessions
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
;


-- Verify data import completeness 
SELECT*
FROM num_of_possessions;
SELECT*
FROM time_of_possessions;














