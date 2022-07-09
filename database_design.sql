

-- Disable sql_safe_updates for successful UPDATE & DELETE execution
SHOW VARIABLES LIKE 'sql_safe%';
SET sql_safe_updates = 0;					-- Turn OFF
SHOW VARIABLES LIKE 'sql_safe%';			-- Verify 


-- Start Transaction in order to be safe when updating records
START TRANSACTION; 
-- UPDATE team city fields from their duplicates 
UPDATE Game SET
	TEAM_CITY_HOME = TEAM_CITY_NAME_HOME WHERE TEAM_CITY_HOME IS NULL; 
UPDATE Game SET
	TEAM_CITY_AWAY = TEAM_CITY_NAME_AWAY WHERE TEAM_CITY_AWAY IS NULL; 

-- Check to see if records properly updated 
SELECT 
    team_city_home,
    team_city_name_home,
    team_city_away,
    team_city_name_away
FROM
    game; 

-- Commit changes to server 
COMMIT;


-- DROP duplicate team ID and city fields in Game table 
ALTER TABLE Game
DROP COLUMN HOME_TEAM_ID, 
DROP COLUMN VISITOR_TEAM_ID,
DROP COLUMN TEAM_CITY_NAME_HOME, 
DROP COLUMN TEAM_CITY_NAME_AWAY
;

-- Confirm new table structure 
DESC Game;

-- DROP duplicate TO's fields 
ALTER TABLE Game
DROP COLUMN TOTAL_TURNOVERS_HOME, 
DROP COLUMN TOTAL_TURNOVERS_AWAY
;

-- Confirm new table structure 
DESC Game;


-- Set primary key for Game table 
ALTER TABLE Game
	ADD CONSTRAINT pk_GAME_ID PRIMARY KEY (GAME_ID), 
    MODIFY GAME_ID INT NOT NULL;
    

-- Start Transaction in order to be safe when updating records
START TRANSACTION; 
-- Delete duplicate entry for GAME_ID
DELETE FROM Game WHERE GAME_ID = 20200005 AND TEAM_CITY_HOME IS NULL;
-- Commit changes to server 
COMMIT; 


-- Display GAME_ID's with their duplicates 
SELECT*
FROM Game
WHERE GAME_ID IN (
	-- Select all GAME_ID's that have duplicates 
    SELECT game_id
	FROM (
		SELECT game_id, COUNT(*) dup
		FROM Game
		GROUP BY 1
		ORDER BY 2 DESC) t1
	WHERE dup > 1)
;


-- Start Transaction in order to be safe when updating records
START TRANSACTION; 
-- DELETE all duplicate entries for GAME_ID field in Game table 
DELETE FROM Game WHERE GAME_ID IN (
	SELECT game_id
	FROM (
		SELECT game_id, COUNT(*) dup
		FROM Game
		GROUP BY 1
		ORDER BY 2 DESC) t1
	WHERE dup > 1) AND TEAM_CITY_HOME IS NULL;
                    
-- Verify duplicate GAME_ID's properly deleted 
SELECT game_id, COUNT(*) dup
FROM Game
GROUP BY 1
ORDER BY 2 DESC;
-- Commit changes to server 
COMMIT; 


-- Run again
ALTER TABLE Game
	ADD CONSTRAINT pk_GAME_ID PRIMARY KEY (GAME_ID), 
    ADD CONSTRAINT FK_game_home FOREIGN KEY (TEAM_ID_HOME) REFERENCES Team (id),
	ADD CONSTRAINT FK_game_away FOREIGN KEY (TEAM_ID_AWAY) REFERENCES Team (id);
;


/* NEW SESSION */


-- RENAME PK in Game table 
DROP INDEX `PRIMARY` ON Game;
ALTER TABLE Game
	ADD CONSTRAINT pk_GAME PRIMARY KEY (GAME_ID)
;

-- Confirm new table structure 
DESC Game;


-- Set primary & foreign keys for Game_Inactive_Players table 
ALTER TABLE Game_Inactive_Players
	ADD CONSTRAINT PK_game_inactive PRIMARY KEY (PLAYER_ID, GAME_ID), 
	ADD CONSTRAINT FK_game_inactive FOREIGN KEY (GAME_ID) REFERENCES Game (GAME_ID), 
	ADD CONSTRAINT FK_game_inactive_player FOREIGN KEY (PLAYER_ID) REFERENCES Player (id),
    ADD CONSTRAINT FK_game_inactive_team FOREIGN KEY (TEAM_ID) REFERENCES Team (id)
    ;


-- Delete row in Game_Inactive_Players where player name is NULL 
START TRANSACTION;
DELETE FROM Game_Inactive_Players WHERE PLAYER_ID = 0 AND GAME_ID = 20000155;
COMMIT;

-- Confirm new table structure 
DESC Game_Inactive_Players;


-- Set primary & foreign keys for Game_Officials table 
ALTER TABLE Game_Officials
	ADD CONSTRAINT PK_game_officials PRIMARY KEY (OFFICIAL_ID, GAME_ID),
    MODIFY OFFICIAL_ID INT NOT NULL, 
    MODIFY GAME_ID INT NOT NULL,
    ADD CONSTRAINT FK_game_officials FOREIGN KEY (GAME_ID) REFERENCES Game (GAME_ID)
;

-- Confirm new table structure 
DESC Game_Officials;

-- Set primary key for Games_ALL table 
ALTER TABLE Games_ALL
	ADD CONSTRAINT PK_games_all PRIMARY KEY (GAME_ID), 
    MODIFY GAME_ID INT NOT NULL
;


-- Disable sql_safe_updates for successful DELETE execution
SHOW VARIABLES LIKE 'sql_safe%';
SET sql_safe_updates = 0;					-- Turn OFF
SHOW VARIABLES LIKE 'sql_safe%';			-- Verify 


-- ADD id column to Games_ALL table so that duplicate GAME_ID records could be uniquely identified for deletion 
ALTER TABLE Games_ALL
	ADD COLUMN id INT FIRST;
    
    
-- Auto fill id column for every row of table 
ALTER TABLE Games_ALL
	ADD CONSTRAINT PK_games_all PRIMARY KEY (id), 
    MODIFY id INT AUTO_INCREMENT;


-- DELETE all duplicate entries for GAME_ID field in Games_ALL table 
START TRANSACTION;
DELETE FROM Games_ALL WHERE id IN 
	-- SELECT id's of only records that have duplicate GAME_ID's 
	(SELECT id 
	FROM 
		-- Identify duplicate entries for GAME_ID field 
		(SELECT id, GAME_ID, ROW_NUMBER() OVER (PARTITION BY GAME_ID ORDER BY GAME_ID) row_num
		FROM Games_ALL
		ORDER BY row_num DESC) t1
		WHERE row_num > 1)
;
COMMIT;


-- DROP id column in Games_ALL table (only used to delete duplicates) 
ALTER TABLE Games_ALL
DROP COLUMN id;

-- Run Again 
ALTER TABLE Games_ALL
	ADD CONSTRAINT PK_games_all PRIMARY KEY (GAME_ID), 
    ADD CONSTRAINT FK_games_all_home FOREIGN KEY (TEAM_ID_home) REFERENCES Team (id),
	ADD CONSTRAINT FK_games_all_away FOREIGN KEY (TEAM_ID_away) REFERENCES Team (id);
;


-- DROP duplicate columns for home team & away team ID's in Games_ALL table 
ALTER TABLE Games_ALL
DROP HOME_TEAM_ID, 
DROP VISITOR_TEAM_ID;

-- Confirm new table structure 
DESC Games_ALL;


/* NEW SESSION */


-- Set primary & foreign keys for Games_Player_Stats table 
ALTER TABLE Games_Player_Stats
	ADD CONSTRAINT PK_games_player_stats PRIMARY KEY (GAME_ID, PLAYER_ID), 
    ADD CONSTRAINT FK_games_player_stats FOREIGN KEY (GAME_ID) REFERENCES Games_ALL (GAME_ID),
    ADD CONSTRAINT FK_games_player_stats_team FOREIGN KEY (TEAM_ID) REFERENCES Team (id);
;


-- ADD id column to Games_Player_Stats table so that duplicate compound key (GAME_ID, PLAYER_ID) records could be uniquely identified for deletion 
ALTER TABLE Games_Player_Stats
	ADD COLUMN id INT FIRST;
-- Auto fill id column for every row of table 
ALTER TABLE Games_Player_Stats
    ADD CONSTRAINT PK_games_player_stats PRIMARY KEY (id), 
    MODIFY id INT AUTO_INCREMENT;
 
-- DELETE all duplicate entries for compound key combination (GAME_ID, PLAYER_ID) fields in Games_Player_Stats table 
START TRANSACTION;
DELETE FROM Games_Player_Stats WHERE id IN
	(SELECT id
	FROM (
		SELECT id, GAME_ID, PLAYER_ID, ROW_NUMBER() OVER (PARTITION BY GAME_ID, PLAYER_ID ORDER BY GAME_ID, PLAYER_ID) row_num
		FROM Games_Player_Stats
		ORDER BY row_num DESC) t1
	WHERE row_num > 1)
;
COMMIT;


-- DROP id column in Games_Player_Stats table (only used to delete duplicates) 
ALTER TABLE Games_Player_Stats
DROP COLUMN id;

-- Run Again 
ALTER TABLE Games_Player_Stats
	ADD CONSTRAINT PK_games_player_stats PRIMARY KEY (GAME_ID, PLAYER_ID), 
    ADD CONSTRAINT FK_games_player_stats FOREIGN KEY (GAME_ID) REFERENCES Games_ALL (GAME_ID)
;


-- Set primary key for Player table 
ALTER TABLE Player 
	ADD CONSTRAINT PK_player PRIMARY KEY (id);


-- INSERT missing PLAYER_ID's from Game_Inactive_Players table into Player table for successful FK reference  
START TRANSACTION; 
INSERT INTO Player (id, full_name, first_name, last_name) SELECT* FROM (
	SELECT DISTINCT PLAYER_ID, CONCAT(FIRST_NAME, ' ', LAST_NAME) full_name, FIRST_NAME, LAST_NAME
	FROM Game_Inactive_Players
	WHERE PLAYER_ID NOT IN (
		SELECT id
		FROM Player)) t1;
COMMIT;


/* NEW SESSION */


-- Add foreign key for Player_Attributes table 
ALTER TABLE Player_Attributes
	ADD CONSTRAINT FK_player_attributes_ID FOREIGN KEY (ID) REFERENCES Player (id),
    ADD CONSTRAINT FK_player_attributes_team FOREIGN KEY (TEAM_ID) REFERENCES Team (id);


-- Find team id's missing in Team table from Player_Attributes table 
SELECT TEAM_ID 
FROM Player_Attributes 
WHERE TEAM_ID NOT IN (
	SELECT id 
    FROM Team)
ORDER BY 1;

-- INSERT missing TEAM_ID's from Player_Attributes table into Team table for successful FK reference  
START TRANSACTION;
INSERT INTO Team (id, full_name, abbreviation, nickname, city, state, year_founded) VALUES
(1610610023, 'Anderson Packers', 'AND', 'Packers', 'Anderson', 'Indiana', 1949),
(1610610024, 'Baltimore Bullets', 'BAL', 'Bullets', 'Baltimore', 'Maryland', 1947), 
(1610610025, 'Chicago Stags', 'CHS', 'Stags', 'Chicago', 'Illinois', 1946),
(1610610026, 'Cleveland Rebels', 'CLR', 'Rebels', 'Cleveland', 'Ohio', 1946),
(1610610027, 'Denver Nuggets', 'DN', 'Nuggets', 'Denver', 'Colorado', 1949),
(1610610028, 'Detroit Falcons', 'DEF', 'Falcons', 'Detroit', 'Michigan', 1946),
(1610610029, 'Indianapolis Jets', 'JET', 'Jets', 'Indianapolis', 'Indiana', 1948), 
(1610610030, 'Indianapolis Olympians', 'INO', 'Olympians', 'Indianapolis', 'Indiana', 1949),
(1610610031, 'Pittsburgh Ironmen', 'PIT', 'Ironmen', 'Pittsburgh', 'Pennsylvania', 1946),
(1610610032, 'Providence Steamrollers', 'PRO', 'Steamrollers', 'Providence', 'Rhode Island', 1946),
(1610610033, 'Sheboygan Redskins', 'SHE', 'Redskins', 'Sheboygan', 'Wisconsin', 1949),
(1610610034, 'St. Louis Bombers', 'BOM', 'Bombers', 'St. Louis', 'Missouri', 1946),
(1610610035, 'Toronto Huskies', 'HUS', 'Huskies', 'Toronto', 'Canada', 1946),
(1610610036, 'Washington Capitols', 'WAS', 'Capitols', 'Washington', 'District of Columbia', 1946),
(1610610037, 'Waterloo Hawks', 'WAT', 'Hawks', 'Waterloo', 'Iowa', 1949)
;
COMMIT;


-- *SUB*
-- Find only the same player ID's first extracted in Games_Player_Stats table
-- Extract exactly one TEAM_ID for every PLAYER_ID so that missing TEAM_ID's in Player_Attributes table could be properly filled 
SELECT PLAYER_ID, MAX(TEAM_ID)
FROM Games_Player_Stats
WHERE PLAYER_ID IN (
	-- Extract all player ID's for which TEAM_ID=0
    SELECT ID 
	FROM (
		SELECT*
		FROM Player_Attributes 
		WHERE team_id = 0) t1)
GROUP BY 1
ORDER BY player_id;

-- Create TEMP table to hold previous result of player id and team id 
CREATE TEMPORARY TABLE fill_team_id (
player_id INT,
team_id INT
);

-- Fill TEMP table using *SUB* result set 
INSERT INTO fill_team_id (player_id, team_id)
SELECT PLAYER_ID, MAX(TEAM_ID)
FROM Games_Player_Stats
WHERE PLAYER_ID IN (
	SELECT ID 
	FROM (
		SELECT*
		FROM Player_Attributes 
		WHERE team_id = 0) t1)
GROUP BY 1
ORDER BY player_id;

-- Confirm proper insertion of records into TEMP table 
SELECT*
FROM fill_team_id;


-- Update TEAM_ID's that had 0's in Player_Attributes table with UPDATE JOIN statement and records from fill_team_id TEMP table 
START TRANSACTION;
UPDATE Player_Attributes p
JOIN fill_team_id f
	ON p.ID = f.player_id
SET p.TEAM_ID = f.team_id 
WHERE p.TEAM_ID = 0;
COMMIT;


START TRANSACTION;
DELETE FROM Player_Attributes WHERE TEAM_ID = 0;
COMMIT;


/* Run most recent ALTER TABLE statement again */


-- Add primary key for Team table 
ALTER TABLE Team
	ADD CONSTRAINT PK_team PRIMARY KEY (id);
    
-- Add foreign key for Team_Attributes table 
ALTER TABLE Team_Attributes
	ADD CONSTRAINT FK_team_attributes_id FOREIGN KEY (ID) REFERENCES Team (id);

-- Add foreign key for Team_History table 
ALTER TABLE Team_History
	ADD CONSTRAINT FK_team_history_id FOREIGN KEY (ID) REFERENCES Team (id);

-- Before dropping duplicates from Playoffs_Data table, ensure 1st and 2nd instance of duplicate pairs are exactly the same 
SELECT 	TEAM_CITY_HOME, TEAM_CITY_AWAY, TEAM_CITY_NAME_HOME, TEAM_CITY_NAME_AWAY, TEAM_ID_HOME, HOME_TEAM_ID, TEAM_ID_AWAY, VISITOR_TEAM_ID, 
		TOV_HOME, TOTAL_TURNOVERS_HOME, TOV_AWAY, TOTAL_TURNOVERS_AWAY
FROM Playoffs_Data
WHERE (team_city_home != TEAM_CITY_NAME_HOME AND team_city_away != TEAM_CITY_NAME_AWAY) OR (TEAM_ID_HOME != HOME_TEAM_ID 
	AND TEAM_ID_AWAY != VISITOR_TEAM_ID) OR (TOV_HOME != TOTAL_TURNOVERS_HOME AND TOV_AWAY != TOTAL_TURNOVERS_AWAY); 

-- Drop 2nd instance of duplicate columns from Playoffs_Data
ALTER TABLE Playoffs_Data
DROP COLUMN TOTAL_TURNOVERS_HOME, 
DROP COLUMN TOTAL_TURNOVERS_AWAY,
DROP COLUMN TEAM_CITY_NAME_HOME, 
DROP COLUMN TEAM_CITY_NAME_AWAY, 
DROP COLUMN HOME_TEAM_ID,
DROP COLUMN VISITOR_TEAM_ID
;

-- Confirm new Playoffs_Data table structure 
DESC Playoffs_Data;


-- Set primary and foreign keys for Playoffs_Data table 
ALTER TABLE Playoffs_Data
	ADD CONSTRAINT PK_playoffs_data PRIMARY KEY (GAME_ID),
	ADD CONSTRAINT FK_playoffs_homeID FOREIGN KEY (TEAM_ID_HOME) REFERENCES Team (id),
    ADD CONSTRAINT FK_playoffs_awayID FOREIGN KEY (TEAM_ID_AWAY) REFERENCES Team (id);

-- Create table of interest with data of all regular season games from primary table Game 
DROP TABLE IF EXISTS season_game_data;
CREATE TABLE season_game_data (
	GAME_ID	INT,
	SEASON_ID	INT,
    SEASON	INT,
	TEAM_ID_HOME	INT,
	TEAM_ABBREVIATION_HOME	TEXT,
	TEAM_CITY_HOME	TEXT,
	TEAM_NAME_HOME	TEXT,
    TEAM_NICKNAME_HOME	TEXT,
	GAME_DATE	DATE,
	MATCHUP_HOME	TEXT,
	WL_HOME	ENUM('W', 'L'),
	MIN_HOME	INT,
	FGM_HOME	REAL,
	FGA_HOME	REAL,
	FG_PCT_HOME	REAL,
	FG3M_HOME	INT,
	FG3A_HOME	INT,
	FG3_PCT_HOME	REAL,
	FTM_HOME	REAL,
	FTA_HOME	REAL,
	FT_PCT_HOME	REAL,
	OREB_HOME	INT,
	DREB_HOME	INT,
	REB_HOME	INT,
	AST_HOME	INT,
	STL_HOME	INT,
	BLK_HOME	INT,
	TOV_HOME	INT,
	PF_HOME	REAL,
	PTS_HOME	INT,
	PLUS_MINUS_HOME	INT,
	VIDEO_AVAILABLE_HOME	INT,
	PTS_PAINT_HOME	INT,
	PTS_2ND_CHANCE_HOME	INT,
	PTS_FB_HOME	INT,
	LARGEST_LEAD_HOME	INT,
	LEAD_CHANGES_HOME	INT,
	TIMES_TIED_HOME	INT,
	TEAM_TURNOVERS_HOME	INT,
	TEAM_REBOUNDS_HOME	INT,
	PTS_OFF_TO_HOME	INT,
    PTS_QTR1_HOME	INT,
	PTS_QTR2_HOME	INT,
	PTS_QTR3_HOME	INT,
	PTS_QTR4_HOME	INT,
	PTS_OT1_HOME	INT,
	PTS_OT2_HOME	INT,
	PTS_OT3_HOME	INT,
	PTS_OT4_HOME	INT,
    TEAM_ID_AWAY	INT,
	TEAM_ABBREVIATION_AWAY	TEXT,
    TEAM_CITY_AWAY	TEXT,
	TEAM_NAME_AWAY	TEXT,
    TEAM_NICKNAME_AWAY	TEXT,
	MATCHUP_AWAY	TEXT,
	WL_AWAY	ENUM('W', 'L'),
	MIN_AWAY	INT,
	FGM_AWAY	REAL,
	FGA_AWAY	REAL,
	FG_PCT_AWAY	REAL,
	FG3M_AWAY	INT,
	FG3A_AWAY	INT,
	FG3_PCT_AWAY	REAL,
	FTM_AWAY	REAL,
	FTA_AWAY	REAL,
	FT_PCT_AWAY	REAL,
	OREB_AWAY	INT,
	DREB_AWAY	INT,
	REB_AWAY	INT,
	AST_AWAY	INT,
	STL_AWAY	INT,
	BLK_AWAY	INT,
	TOV_AWAY	INT,
	PF_AWAY	REAL,
	PTS_AWAY	INT,
	PLUS_MINUS_AWAY	INT,
	VIDEO_AVAILABLE_AWAY	INT,
    PTS_PAINT_AWAY	INT,
	PTS_2ND_CHANCE_AWAY	INT,
	PTS_FB_AWAY	INT,
	LARGEST_LEAD_AWAY	INT,
	LEAD_CHANGES_AWAY	INT,
	TIMES_TIED_AWAY	INT,
	TEAM_TURNOVERS_AWAY	INT,
	TEAM_REBOUNDS_AWAY	INT,
	PTS_OFF_TO_AWAY	INT,
    PTS_QTR1_AWAY	INT,
	PTS_QTR2_AWAY	INT,
	PTS_QTR3_AWAY	INT,
	PTS_QTR4_AWAY	INT,
	PTS_OT1_AWAY	INT,
	PTS_OT2_AWAY	INT,
	PTS_OT3_AWAY	INT,
	PTS_OT4_AWAY	INT,
	ATTENDANCE	INT
);

-- Create table of interest with data of all playoffs games from primary table Playoffs_Data 
CREATE TABLE playoffs_game_data (
	GAME_ID	INT,
	SEASON_ID	INT,
    SEASON	INT,
	TEAM_ID_HOME	INT,
	TEAM_ABBREVIATION_HOME	TEXT,
	TEAM_CITY_HOME	TEXT,
	TEAM_NAME_HOME	TEXT,
    TEAM_NICKNAME_HOME	TEXT,
	GAME_DATE	DATE,
	MATCHUP_HOME	TEXT,
	WL_HOME	ENUM('W', 'L'),
	MIN_HOME	INT,
	FGM_HOME	REAL,
	FGA_HOME	REAL,
	FG_PCT_HOME	REAL,
	FG3M_HOME	INT,
	FG3A_HOME	INT,
	FG3_PCT_HOME	REAL,
	FTM_HOME	REAL,
	FTA_HOME	REAL,
	FT_PCT_HOME	REAL,
	OREB_HOME	INT,
	DREB_HOME	INT,
	REB_HOME	INT,
	AST_HOME	INT,
	STL_HOME	INT,
	BLK_HOME	INT,
	TOV_HOME	INT,
	PF_HOME	REAL,
	PTS_HOME	INT,
	PLUS_MINUS_HOME	INT,
	VIDEO_AVAILABLE_HOME	INT,
	PTS_PAINT_HOME	INT,
	PTS_2ND_CHANCE_HOME	INT,
	PTS_FB_HOME	INT,
	LARGEST_LEAD_HOME	INT,
	LEAD_CHANGES_HOME	INT,
	TIMES_TIED_HOME	INT,
	TEAM_TURNOVERS_HOME	INT,
	TEAM_REBOUNDS_HOME	INT,
	PTS_OFF_TO_HOME	INT,
    PTS_QTR1_HOME	INT,
	PTS_QTR2_HOME	INT,
	PTS_QTR3_HOME	INT,
	PTS_QTR4_HOME	INT,
	PTS_OT1_HOME	INT,
	PTS_OT2_HOME	INT,
	PTS_OT3_HOME	INT,
	PTS_OT4_HOME	INT,
    TEAM_ID_AWAY	INT,
	TEAM_ABBREVIATION_AWAY	TEXT,
    TEAM_CITY_AWAY	TEXT,
	TEAM_NAME_AWAY	TEXT,
    TEAM_NICKNAME_AWAY	TEXT,
	MATCHUP_AWAY	TEXT,
	WL_AWAY	ENUM('W', 'L'),
	MIN_AWAY	INT,
	FGM_AWAY	REAL,
	FGA_AWAY	REAL,
	FG_PCT_AWAY	REAL,
	FG3M_AWAY	INT,
	FG3A_AWAY	INT,
	FG3_PCT_AWAY	REAL,
	FTM_AWAY	REAL,
	FTA_AWAY	REAL,
	FT_PCT_AWAY	REAL,
	OREB_AWAY	INT,
	DREB_AWAY	INT,
	REB_AWAY	INT,
	AST_AWAY	INT,
	STL_AWAY	INT,
	BLK_AWAY	INT,
	TOV_AWAY	INT,
	PF_AWAY	REAL,
	PTS_AWAY	INT,
	PLUS_MINUS_AWAY	INT,
	VIDEO_AVAILABLE_AWAY	INT,
    PTS_PAINT_AWAY	INT,
	PTS_2ND_CHANCE_AWAY	INT,
	PTS_FB_AWAY	INT,
	LARGEST_LEAD_AWAY	INT,
	LEAD_CHANGES_AWAY	INT,
	TIMES_TIED_AWAY	INT,
	TEAM_TURNOVERS_AWAY	INT,
	TEAM_REBOUNDS_AWAY	INT,
	PTS_OFF_TO_AWAY	INT,
    PTS_QTR1_AWAY	INT,
	PTS_QTR2_AWAY	INT,
	PTS_QTR3_AWAY	INT,
	PTS_QTR4_AWAY	INT,
	PTS_OT1_AWAY	INT,
	PTS_OT2_AWAY	INT,
	PTS_OT3_AWAY	INT,
	PTS_OT4_AWAY	INT,
	ATTENDANCE	INT
);

-- Fill season_game_data table with values from its primary table, Game
START TRANSACTION;
INSERT INTO season_game_data SELECT 
	GAME_ID,SEASON_ID,SEASON,TEAM_ID_HOME,TEAM_ABBREVIATION_HOME,TEAM_CITY_HOME,TEAM_NAME_HOME,TEAM_NICKNAME_HOME,GAME_DATE,
    MATCHUP_HOME,WL_HOME,MIN_HOME,FGM_HOME,FGA_HOME,FG_PCT_HOME,FG3M_HOME,FG3A_HOME,FG3_PCT_HOME,FTM_HOME,FTA_HOME,FT_PCT_HOME,
    OREB_HOME,DREB_HOME,REB_HOME,AST_HOME,STL_HOME,BLK_HOME,TOV_HOME,PF_HOME,PTS_HOME,PLUS_MINUS_HOME,VIDEO_AVAILABLE_HOME,PTS_PAINT_HOME,
    PTS_2ND_CHANCE_HOME,PTS_FB_HOME,LARGEST_LEAD_HOME,LEAD_CHANGES_HOME,TIMES_TIED_HOME,TEAM_TURNOVERS_HOME,TEAM_REBOUNDS_HOME,
    PTS_OFF_TO_HOME,PTS_QTR1_HOME,PTS_QTR2_HOME,PTS_QTR3_HOME,PTS_QTR4_HOME,PTS_OT1_HOME,PTS_OT2_HOME,PTS_OT3_HOME,PTS_OT4_HOME,
    TEAM_ID_AWAY,TEAM_ABBREVIATION_AWAY,TEAM_CITY_AWAY,TEAM_NAME_AWAY,TEAM_NICKNAME_AWAY,MATCHUP_AWAY,WL_AWAY,MIN_AWAY,FGM_AWAY,
    FGA_AWAY,FG_PCT_AWAY,FG3M_AWAY,FG3A_AWAY,FG3_PCT_AWAY,FTM_AWAY,FTA_AWAY,FT_PCT_AWAY,OREB_AWAY,DREB_AWAY,REB_AWAY,AST_AWAY,STL_AWAY,
    BLK_AWAY,TOV_AWAY,PF_AWAY,PTS_AWAY,PLUS_MINUS_AWAY,VIDEO_AVAILABLE_AWAY,PTS_PAINT_AWAY,PTS_2ND_CHANCE_AWAY,PTS_FB_AWAY,
    LARGEST_LEAD_AWAY,LEAD_CHANGES_AWAY,TIMES_TIED_AWAY,TEAM_TURNOVERS_AWAY,TEAM_REBOUNDS_AWAY,PTS_OFF_TO_AWAY,PTS_QTR1_AWAY,
    PTS_QTR2_AWAY,PTS_QTR3_AWAY,PTS_QTR4_AWAY,PTS_OT1_AWAY,PTS_OT2_AWAY,PTS_OT3_AWAY,PTS_OT4_AWAY,ATTENDANCE
    FROM Game
    WHERE GAME_DATE > '2003-10-01';

-- Confirm successful insertion of values 
SELECT*
FROM season_game_data;


-- Fill playoffs_game_data table with values from its primary table, Playoffs_Data
INSERT INTO playoffs_game_data SELECT 
GAME_ID,SEASON_ID,SEASON,TEAM_ID_HOME,TEAM_ABBREVIATION_HOME,TEAM_CITY_HOME,TEAM_NAME_HOME,TEAM_NICKNAME_HOME,GAME_DATE,
    MATCHUP_HOME,WL_HOME,MIN_HOME,FGM_HOME,FGA_HOME,FG_PCT_HOME,FG3M_HOME,FG3A_HOME,FG3_PCT_HOME,FTM_HOME,FTA_HOME,FT_PCT_HOME,
    OREB_HOME,DREB_HOME,REB_HOME,AST_HOME,STL_HOME,BLK_HOME,TOV_HOME,PF_HOME,PTS_HOME,PLUS_MINUS_HOME,VIDEO_AVAILABLE_HOME,PTS_PAINT_HOME,
    PTS_2ND_CHANCE_HOME,PTS_FB_HOME,LARGEST_LEAD_HOME,LEAD_CHANGES_HOME,TIMES_TIED_HOME,TEAM_TURNOVERS_HOME,TEAM_REBOUNDS_HOME,
    PTS_OFF_TO_HOME,PTS_QTR1_HOME,PTS_QTR2_HOME,PTS_QTR3_HOME,PTS_QTR4_HOME,PTS_OT1_HOME,PTS_OT2_HOME,PTS_OT3_HOME,PTS_OT4_HOME,
    TEAM_ID_AWAY,TEAM_ABBREVIATION_AWAY,TEAM_CITY_AWAY,TEAM_NAME_AWAY,TEAM_NICKNAME_AWAY,MATCHUP_AWAY,WL_AWAY,MIN_AWAY,FGM_AWAY,
    FGA_AWAY,FG_PCT_AWAY,FG3M_AWAY,FG3A_AWAY,FG3_PCT_AWAY,FTM_AWAY,FTA_AWAY,FT_PCT_AWAY,OREB_AWAY,DREB_AWAY,REB_AWAY,AST_AWAY,STL_AWAY,
    BLK_AWAY,TOV_AWAY,PF_AWAY,PTS_AWAY,PLUS_MINUS_AWAY,VIDEO_AVAILABLE_AWAY,PTS_PAINT_AWAY,PTS_2ND_CHANCE_AWAY,PTS_FB_AWAY,
    LARGEST_LEAD_AWAY,LEAD_CHANGES_AWAY,TIMES_TIED_AWAY,TEAM_TURNOVERS_AWAY,TEAM_REBOUNDS_AWAY,PTS_OFF_TO_AWAY,PTS_QTR1_AWAY,
    PTS_QTR2_AWAY,PTS_QTR3_AWAY,PTS_QTR4_AWAY,PTS_OT1_AWAY,PTS_OT2_AWAY,PTS_OT3_AWAY,PTS_OT4_AWAY,ATTENDANCE
    FROM Playoffs_Data;

-- Confirm successful insertion of values 
SELECT* 
FROM playoffs_game_data;

-- ROLLBACK changes 
ROLLBACK;
-- COMMIT changes to server 
COMMIT;


-- Set primary and foreign keys for season_game_data table 
ALTER TABLE season_game_data
	ADD CONSTRAINT PK_season_data PRIMARY KEY (GAME_ID), 
    ADD CONSTRAINT FK_season_data_home FOREIGN KEY (TEAM_ID_HOME) REFERENCES Team (id),
	ADD CONSTRAINT FK_season_data_away FOREIGN KEY (TEAM_ID_AWAY) REFERENCES Team (id);
;

-- Set primary and foreign keys for playoffs_game_data table 
ALTER TABLE playoffs_game_data
	ADD CONSTRAINT PK_playoffs_data PRIMARY KEY (GAME_ID), 
    ADD CONSTRAINT FK_playoffs_data_home FOREIGN KEY (TEAM_ID_HOME) REFERENCES Team (id),
	ADD CONSTRAINT FK_playoffs_data_away FOREIGN KEY (TEAM_ID_AWAY) REFERENCES Team (id);
;


-- ADD column to season_game_data table which denotes game type 
ALTER TABLE season_game_data
	ADD COLUMN GAME_TYPE TEXT AFTER SEASON;
    
-- ADD column to playoffs_game_data table which denotes game type 
ALTER TABLE playoffs_game_data
	ADD COLUMN GAME_TYPE TEXT AFTER SEASON;
 
 
-- Disable sql_safe_updates for successful UPDATE & DELETE execution
SHOW VARIABLES LIKE 'sql_safe%';
SET sql_safe_updates = 0;					-- Turn OFF
SHOW VARIABLES LIKE 'sql_safe%';			-- Verify 


-- Fill entire GAME_TYPE column with single value in season_game_data table 
START TRANSACTION;
UPDATE season_game_data 
	SET GAME_TYPE = "Regular Season";

-- Fill entire GAME_TYPE column with single value in playoffs_game_data table 
UPDATE playoffs_game_data
	SET  GAME_TYPE = "Playoffs";

COMMIT;


-- Combine season_game_data and playoffs_game_data datasets into single table  
SELECT*
FROM season_game_data
UNION
SELECT*
FROM playoffs_game_data;


-- Create table to hold UNIONED result between season_game_data and playoffs_game_data tables 
DROP TABLE IF EXISTS season_and_playoffs_data;
CREATE TABLE season_and_playoffs_data (
	GAME_ID	INT,
	SEASON_ID	INT,
    SEASON	INT,
    GAME_TYPE TEXT,
	TEAM_ID_HOME	INT,
	TEAM_ABBREVIATION_HOME	TEXT,
	TEAM_CITY_HOME	TEXT,
	TEAM_NAME_HOME	TEXT,
    TEAM_NICKNAME_HOME	TEXT,
	GAME_DATE	DATE,
	MATCHUP_HOME	TEXT,
	WL_HOME	ENUM('W', 'L'),
	MIN_HOME	INT,
	FGM_HOME	REAL,
	FGA_HOME	REAL,
	FG_PCT_HOME	REAL,
	FG3M_HOME	INT,
	FG3A_HOME	INT,
	FG3_PCT_HOME	REAL,
	FTM_HOME	REAL,
	FTA_HOME	REAL,
	FT_PCT_HOME	REAL,
	OREB_HOME	INT,
	DREB_HOME	INT,
	REB_HOME	INT,
	AST_HOME	INT,
	STL_HOME	INT,
	BLK_HOME	INT,
	TOV_HOME	INT,
	PF_HOME	REAL,
	PTS_HOME	INT,
	PLUS_MINUS_HOME	INT,
	VIDEO_AVAILABLE_HOME	INT,
	PTS_PAINT_HOME	INT,
	PTS_2ND_CHANCE_HOME	INT,
	PTS_FB_HOME	INT,
	LARGEST_LEAD_HOME	INT,
	LEAD_CHANGES_HOME	INT,
	TIMES_TIED_HOME	INT,
	TEAM_TURNOVERS_HOME	INT,
	TEAM_REBOUNDS_HOME	INT,
	PTS_OFF_TO_HOME	INT,
    PTS_QTR1_HOME	INT,
	PTS_QTR2_HOME	INT,
	PTS_QTR3_HOME	INT,
	PTS_QTR4_HOME	INT,
	PTS_OT1_HOME	INT,
	PTS_OT2_HOME	INT,
	PTS_OT3_HOME	INT,
	PTS_OT4_HOME	INT,
    TEAM_ID_AWAY	INT,
	TEAM_ABBREVIATION_AWAY	TEXT,
    TEAM_CITY_AWAY	TEXT,
	TEAM_NAME_AWAY	TEXT,
    TEAM_NICKNAME_AWAY	TEXT,
	MATCHUP_AWAY	TEXT,
	WL_AWAY	ENUM('W', 'L'),
	MIN_AWAY	INT,
	FGM_AWAY	REAL,
	FGA_AWAY	REAL,
	FG_PCT_AWAY	REAL,
	FG3M_AWAY	INT,
	FG3A_AWAY	INT,
	FG3_PCT_AWAY	REAL,
	FTM_AWAY	REAL,
	FTA_AWAY	REAL,
	FT_PCT_AWAY	REAL,
	OREB_AWAY	INT,
	DREB_AWAY	INT,
	REB_AWAY	INT,
	AST_AWAY	INT,
	STL_AWAY	INT,
	BLK_AWAY	INT,
	TOV_AWAY	INT,
	PF_AWAY	REAL,
	PTS_AWAY	INT,
	PLUS_MINUS_AWAY	INT,
	VIDEO_AVAILABLE_AWAY	INT,
    PTS_PAINT_AWAY	INT,
	PTS_2ND_CHANCE_AWAY	INT,
	PTS_FB_AWAY	INT,
	LARGEST_LEAD_AWAY	INT,
	LEAD_CHANGES_AWAY	INT,
	TIMES_TIED_AWAY	INT,
	TEAM_TURNOVERS_AWAY	INT,
	TEAM_REBOUNDS_AWAY	INT,
	PTS_OFF_TO_AWAY	INT,
    PTS_QTR1_AWAY	INT,
	PTS_QTR2_AWAY	INT,
	PTS_QTR3_AWAY	INT,
	PTS_QTR4_AWAY	INT,
	PTS_OT1_AWAY	INT,
	PTS_OT2_AWAY	INT,
	PTS_OT3_AWAY	INT,
	PTS_OT4_AWAY	INT,
	ATTENDANCE	INT,
	CONSTRAINT PK_seasonUplayoffs_data PRIMARY KEY (GAME_ID), 
	CONSTRAINT FK_seasonUplayoffs_home FOREIGN KEY (TEAM_ID_HOME) REFERENCES Team (id),
	CONSTRAINT FK_seasonUplayoffs_away FOREIGN KEY (TEAM_ID_AWAY) REFERENCES Team (id)
);


-- Fill season_and_playoffs_data table with UNIONED result of season_game_data and playoffs_game_data tables 
INSERT INTO season_and_playoffs_data 
	SELECT*
	FROM season_game_data
	UNION
	SELECT*
	FROM playoffs_game_data;


/* UPDATE all records where inconsistencies lie in city name and team name columns for the Los Angeles Clippers Team 
	in season_and_playoffs_data table */

SELECT GAME_ID
FROM (
SELECT GAME_ID, TEAM_CITY_HOME, TEAM_NAME_HOME
FROM season_and_playoffs_data
WHERE TEAM_CITY_HOME = 'LA') dup;

SELECT GAME_ID
FROM (
SELECT GAME_ID, TEAM_CITY_AWAY, TEAM_NAME_AWAY
FROM season_and_playoffs_data
WHERE TEAM_CITY_AWAY = 'LA') dup;

START TRANSACTION;
UPDATE season_and_playoffs_data
SET 
    TEAM_CITY_HOME = 'Los Angeles',
    TEAM_NAME_HOME = 'Los Angeles Clippers'
WHERE GAME_ID IN (SELECT GAME_ID
				  FROM (
						SELECT GAME_ID, TEAM_CITY_HOME, TEAM_NAME_HOME
						FROM season_and_playoffs_data
						WHERE TEAM_CITY_HOME = 'LA') dup)
;

UPDATE season_and_playoffs_data
SET 
    TEAM_CITY_AWAY = 'Los Angeles',
    TEAM_NAME_AWAY = 'Los Angeles Clippers'
WHERE GAME_ID IN (SELECT GAME_ID
				  FROM (
						SELECT GAME_ID, TEAM_CITY_AWAY, TEAM_NAME_AWAY
						FROM season_and_playoffs_data
						WHERE TEAM_CITY_AWAY = 'LA') dup)
;

COMMIT;


-- ADD time per possession stat to season_and_playoffs_data table 
ALTER TABLE season_and_playoffs_data
	ADD COLUMN TIME_per_POSS_HOME REAL AFTER PF_HOME, 
    ADD COLUMN TIME_per_POSS_AWAY REAL AFTER PF_AWAY;


-- Start a transaction so that changes are only committed to server once verified for accuracy 
START TRANSACTION;
-- UPDATE new column TIME_per_POSS_HOME in season_and_playoffs_data table using TEMP table in UPDATE JOIN statement 
UPDATE season_and_playoffs_data s
	JOIN fill_TIME_per_POSS_HOME f
	ON s.GAME_ID = f.GAME_ID AND s.GAME_TYPE = f.GAME_TYPE AND s.TEAM_NICKNAME_HOME = f.TEAM_NAME_HOME
SET s.TIME_per_POSS_HOME = f.TIME_per_POSS_HOME;


-- Verify records in updated table match with records from table that data came from 
SELECT GAME_ID, TEAM_NICKNAME_HOME, TIME_per_POSS_HOME
FROM season_and_playoffs_data
WHERE TIME_per_POSS_HOME IS NOT NULL AND TIME_per_POSS_HOME NOT IN (SELECT TIME_per_POSS_HOME FROM fill_TIME_per_POSS_HOME);


-- UPDATE new column TIME_per_POSS_AWAY in season_and_playoffs_data table using TEMP table in UPDATE JOIN statement 
UPDATE season_and_playoffs_data s
	JOIN fill_TIME_per_POSS_AWAY f
	ON s.GAME_ID = f.GAME_ID AND s.GAME_TYPE = f.GAME_TYPE AND s.TEAM_NICKNAME_AWAY = f.TEAM_NAME_AWAY
SET s.TIME_per_POSS_AWAY = f.TIME_per_POSS_AWAY;


-- Verify records in updated table match with records from table that data came from 
SELECT GAME_ID, TEAM_NICKNAME_HOME, TIME_per_POSS_AWAY
FROM season_and_playoffs_data
WHERE TIME_per_POSS_AWAY IS NOT NULL AND TIME_per_POSS_AWAY NOT IN (SELECT TIME_per_POSS_AWAY FROM fill_TIME_per_POSS_AWAY);

COMMIT;
ROLLBACK;


   
