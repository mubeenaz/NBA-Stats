/* The following queries compare several different stats between regular season and playoffs games for every team that has 
played in the NBA from 2003-2021 */ 


/*			FGA STAT			*/		


-- JOIN data to get total averages of every team for regular season 
SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_FGA_HOME_rs, t2_away.TEAM_NAME_AWAY, t2_away.AVG_FGA_AWAY_rs, 
		(AVG_FGA_HOME_rs+AVG_FGA_AWAY_rs)/2 TOTAL_AVG_FGA_rs
FROM (
	-- get average FGA for all home games in regular season for every team 
	SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(FGA_HOME) AVG_FGA_HOME_rs
	FROM season_and_playoffs_data
	WHERE GAME_TYPE = "Regular Season"
	GROUP BY GAME_TYPE, TEAM_NAME_HOME
	ORDER BY TEAM_NAME_HOME) t1_home
JOIN 
	-- get average FGA for all away games in regular season for every team 
	(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(FGA_AWAY) AVG_FGA_AWAY_rs
	FROM season_and_playoffs_data
	WHERE GAME_TYPE = "Regular Season"
	GROUP BY GAME_TYPE, TEAM_NAME_AWAY
	ORDER BY TEAM_NAME_AWAY) t2_away
ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY;



-- JOIN data to get total averages of every team for playoffs
SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_FGA_HOME_p, t2_away.TEAM_NAME_AWAY, t2_away.AVG_FGA_AWAY_p, 
		(AVG_FGA_HOME_p+AVG_FGA_AWAY_p)/2 TOTAL_AVG_FGA_p
FROM (
	-- get average FGA for all home games in playoffs for every team 
	SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(FGA_HOME) AVG_FGA_HOME_p
	FROM season_and_playoffs_data
	WHERE GAME_TYPE = "Playoffs"
	GROUP BY GAME_TYPE,TEAM_NAME_HOME
	ORDER BY TEAM_NAME_HOME) t1_home
JOIN 
	-- get average FGA for all away games in playoffs for every team 
	(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(FGA_AWAY) AVG_FGA_AWAY_p
	FROM season_and_playoffs_data
	WHERE GAME_TYPE = "Playoffs"
	GROUP BY GAME_TYPE, TEAM_NAME_AWAY
	ORDER BY TEAM_NAME_AWAY) t2_away
ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY;


-- JOIN previous two queries to create a single table which compares FGA stat between regular season and playoffs for each team 
WITH	regular_season_FGA AS (SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_FGA_HOME_rs, t2_away.TEAM_NAME_AWAY, 
								t2_away.AVG_FGA_AWAY_rs, (AVG_FGA_HOME_rs+AVG_FGA_AWAY_rs)/2 TOTAL_AVG_FGA_rs
								FROM (
									SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(FGA_HOME) AVG_FGA_HOME_rs
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Regular Season"
									GROUP BY GAME_TYPE, TEAM_NAME_HOME
									ORDER BY TEAM_NAME_HOME) t1_home
								JOIN 
									(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(FGA_AWAY) AVG_FGA_AWAY_rs
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Regular Season"
									GROUP BY GAME_TYPE, TEAM_NAME_AWAY
									ORDER BY TEAM_NAME_AWAY) t2_away
								ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY),
		playoffs_FGA	AS 	(SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_FGA_HOME_p, t2_away.TEAM_NAME_AWAY, 
								t2_away.AVG_FGA_AWAY_p, (AVG_FGA_HOME_p+AVG_FGA_AWAY_p)/2 TOTAL_AVG_FGA_p
								FROM (
									SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(FGA_HOME) AVG_FGA_HOME_p
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Playoffs"
									GROUP BY GAME_TYPE,TEAM_NAME_HOME
									ORDER BY TEAM_NAME_HOME) t1_home
								JOIN 
									(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(FGA_AWAY) AVG_FGA_AWAY_p
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Playoffs"
									GROUP BY GAME_TYPE, TEAM_NAME_AWAY
									ORDER BY TEAM_NAME_AWAY) t2_away
								ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY)
        

SELECT	rs_FGA.TEAM_NAME_HOME AS TEAM_NAME, rs_FGA.TOTAL_AVG_FGA_rs AS TOTAL_AVG_FGA_RS, p_FGA.TOTAL_AVG_FGA_p AS TOTAL_AVG_FGA_P
FROM 	regular_season_FGA rs_FGA
LEFT JOIN playoffs_FGA p_FGA 
ON rs_FGA.TEAM_NAME_HOME = p_FGA.TEAM_NAME_HOME AND rs_FGA.TEAM_NAME_AWAY = p_FGA.TEAM_NAME_AWAY;

    
/*			FG3A STAT			*/		


-- JOIN data to get total averages of every team for regular season 
SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_FG3A_HOME_rs, t2_away.TEAM_NAME_AWAY, t2_away.AVG_FG3A_AWAY_rs, 
		(AVG_FG3A_HOME_rs+AVG_FG3A_AWAY_rs)/2 TOTAL_AVG_FG3A_rs
FROM (
	-- get average FG3A for all home games in regular season for every team 
	SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(FG3A_HOME) AVG_FG3A_HOME_rs
	FROM season_and_playoffs_data
	WHERE GAME_TYPE = "Regular Season"
	GROUP BY GAME_TYPE, TEAM_NAME_HOME
	ORDER BY TEAM_NAME_HOME) t1_home
JOIN 
	-- get average FG3A for all away games in regular season for every team 
	(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(FG3A_AWAY) AVG_FG3A_AWAY_rs
	FROM season_and_playoffs_data
	WHERE GAME_TYPE = "Regular Season"
	GROUP BY GAME_TYPE, TEAM_NAME_AWAY
	ORDER BY TEAM_NAME_AWAY) t2_away
ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY;



-- JOIN data to get total averages of every team for playoffs
SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_FG3A_HOME_p, t2_away.TEAM_NAME_AWAY, t2_away.AVG_FG3A_AWAY_p, 
		(AVG_FG3A_HOME_p+AVG_FG3A_AWAY_p)/2 TOTAL_AVG_FG3A_p
FROM (
	-- get average FG3A for all home games in playoffs for every team 
	SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(FG3A_HOME) AVG_FG3A_HOME_p
	FROM season_and_playoffs_data
	WHERE GAME_TYPE = "Playoffs"
	GROUP BY GAME_TYPE,TEAM_NAME_HOME
	ORDER BY TEAM_NAME_HOME) t1_home
JOIN 
	-- get average FG3A for all away games in playoffs for every team 
	(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(FG3A_AWAY) AVG_FG3A_AWAY_p
	FROM season_and_playoffs_data
	WHERE GAME_TYPE = "Playoffs"
	GROUP BY GAME_TYPE, TEAM_NAME_AWAY
	ORDER BY TEAM_NAME_AWAY) t2_away
ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY;


-- JOIN previous two queries to create a single table which compares FG3A stat between regular season and playoffs for each team 
WITH	regular_season_FG3A AS (SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_FG3A_HOME_rs, t2_away.TEAM_NAME_AWAY, 
								t2_away.AVG_FG3A_AWAY_rs, (AVG_FG3A_HOME_rs+AVG_FG3A_AWAY_rs)/2 TOTAL_AVG_FG3A_rs
								FROM (
									SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(FG3A_HOME) AVG_FG3A_HOME_rs
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Regular Season"
									GROUP BY GAME_TYPE, TEAM_NAME_HOME
									ORDER BY TEAM_NAME_HOME) t1_home
								JOIN 
									(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(FG3A_AWAY) AVG_FG3A_AWAY_rs
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Regular Season"
									GROUP BY GAME_TYPE, TEAM_NAME_AWAY
									ORDER BY TEAM_NAME_AWAY) t2_away
								ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY), 
		playoffs_FG3A	AS 		(SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_FG3A_HOME_p, t2_away.TEAM_NAME_AWAY, 
								t2_away.AVG_FG3A_AWAY_p, (AVG_FG3A_HOME_p+AVG_FG3A_AWAY_p)/2 TOTAL_AVG_FG3A_p
								FROM (
									SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(FG3A_HOME) AVG_FG3A_HOME_p
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Playoffs"
									GROUP BY GAME_TYPE,TEAM_NAME_HOME
									ORDER BY TEAM_NAME_HOME) t1_home
								JOIN 
									(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(FG3A_AWAY) AVG_FG3A_AWAY_p
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Playoffs"
									GROUP BY GAME_TYPE, TEAM_NAME_AWAY
									ORDER BY TEAM_NAME_AWAY) t2_away
								ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY)


SELECT	rs_FG3A.TEAM_NAME_HOME AS TEAM_NAME, rs_FG3A.TOTAL_AVG_FG3A_rs AS TOTAL_AVG_FG3A_RS, p_FG3A.TOTAL_AVG_FG3A_p AS TOTAL_AVG_FG3A_P
FROM 	regular_season_FG3A rs_FG3A
LEFT JOIN playoffs_FG3A p_FG3A
ON rs_FG3A.TEAM_NAME_HOME = p_FG3A.TEAM_NAME_HOME AND rs_FG3A.TEAM_NAME_AWAY = p_FG3A.TEAM_NAME_AWAY;


/*			AST STAT			*/		


-- JOIN data to get total averages of every team for regular season 
SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_AST_HOME_rs, t2_away.TEAM_NAME_AWAY, t2_away.AVG_AST_AWAY_rs, 
		(AVG_AST_HOME_rs+AVG_AST_AWAY_rs)/2 TOTAL_AVG_AST_rs
FROM (
	-- get average AST for all home games in regular season for every team 
	SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(AST_HOME) AVG_AST_HOME_rs
	FROM season_and_playoffs_data
	WHERE GAME_TYPE = "Regular Season"
	GROUP BY GAME_TYPE, TEAM_NAME_HOME
	ORDER BY TEAM_NAME_HOME) t1_home
JOIN 
	-- get average AST for all away games in regular season for every team 
	(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(AST_AWAY) AVG_AST_AWAY_rs
	FROM season_and_playoffs_data
	WHERE GAME_TYPE = "Regular Season"
	GROUP BY GAME_TYPE, TEAM_NAME_AWAY
	ORDER BY TEAM_NAME_AWAY) t2_away
ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY;



-- JOIN data to get total averages of every team for playoffs
SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_AST_HOME_p, t2_away.TEAM_NAME_AWAY, t2_away.AVG_AST_AWAY_p, 
		(AVG_AST_HOME_p+AVG_AST_AWAY_p)/2 TOTAL_AVG_AST_p
FROM (
	-- get average AST for all home games in playoffs for every team 
	SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(AST_HOME) AVG_AST_HOME_p
	FROM season_and_playoffs_data
	WHERE GAME_TYPE = "Playoffs"
	GROUP BY GAME_TYPE,TEAM_NAME_HOME
	ORDER BY TEAM_NAME_HOME) t1_home
JOIN 
	-- get average AST for all away games in playoffs for every team 
	(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(AST_AWAY) AVG_AST_AWAY_p
	FROM season_and_playoffs_data
	WHERE GAME_TYPE = "Playoffs"
	GROUP BY GAME_TYPE, TEAM_NAME_AWAY
	ORDER BY TEAM_NAME_AWAY) t2_away
ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY;


-- JOIN previous two queries to create a single table which compares AST stat between regular season and playoffs for each team 
WITH	regular_season_AST  AS (SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_AST_HOME_rs, t2_away.TEAM_NAME_AWAY, 
								t2_away.AVG_AST_AWAY_rs, (AVG_AST_HOME_rs+AVG_AST_AWAY_rs)/2 TOTAL_AVG_AST_rs
								FROM (
									SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(AST_HOME) AVG_AST_HOME_rs
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Regular Season"
									GROUP BY GAME_TYPE, TEAM_NAME_HOME
									ORDER BY TEAM_NAME_HOME) t1_home
								JOIN  
									(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(AST_AWAY) AVG_AST_AWAY_rs
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Regular Season"
									GROUP BY GAME_TYPE, TEAM_NAME_AWAY
									ORDER BY TEAM_NAME_AWAY) t2_away
								ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY), 
		playoffs_AST 	AS 	    (SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_AST_HOME_p, t2_away.TEAM_NAME_AWAY, 
								t2_away.AVG_AST_AWAY_p, (AVG_AST_HOME_p+AVG_AST_AWAY_p)/2 TOTAL_AVG_AST_p
								FROM ( 
									SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(AST_HOME) AVG_AST_HOME_p
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Playoffs"
									GROUP BY GAME_TYPE,TEAM_NAME_HOME
									ORDER BY TEAM_NAME_HOME) t1_home
								JOIN 
									(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(AST_AWAY) AVG_AST_AWAY_p
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Playoffs"
									GROUP BY GAME_TYPE, TEAM_NAME_AWAY
									ORDER BY TEAM_NAME_AWAY) t2_away
								ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY)


SELECT	rs_AST.TEAM_NAME_HOME AS TEAM_NAME, rs_AST.TOTAL_AVG_AST_rs AS TOTAL_AVG_AST_RS, p_AST.TOTAL_AVG_AST_p AS TOTAL_AVG_AST_P
FROM 	regular_season_AST rs_AST
LEFT JOIN playoffs_AST p_AST
ON rs_AST.TEAM_NAME_HOME = p_AST.TEAM_NAME_HOME AND rs_AST.TEAM_NAME_AWAY = p_AST.TEAM_NAME_AWAY;



/*			TOV STAT			*/		


-- JOIN data to get total averages of every team for regular season 
SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_TOV_HOME_rs, t2_away.TEAM_NAME_AWAY, t2_away.AVG_TOV_AWAY_rs, 
		(AVG_TOV_HOME_rs+AVG_TOV_AWAY_rs)/2 TOTAL_AVG_TOV_rs
FROM (
	-- get average TOV for all home games in regular season for every team 
	SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(TOV_HOME) AVG_TOV_HOME_rs
	FROM season_and_playoffs_data
	WHERE GAME_TYPE = "Regular Season"
	GROUP BY GAME_TYPE, TEAM_NAME_HOME
	ORDER BY TEAM_NAME_HOME) t1_home
JOIN 
	-- get average TOV for all away games in regular season for every team 
	(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(TOV_AWAY) AVG_TOV_AWAY_rs
	FROM season_and_playoffs_data
	WHERE GAME_TYPE = "Regular Season"
	GROUP BY GAME_TYPE, TEAM_NAME_AWAY
	ORDER BY TEAM_NAME_AWAY) t2_away
ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY;



-- JOIN data to get total averages of every team for playoffs
SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_TOV_HOME_p, t2_away.TEAM_NAME_AWAY, t2_away.AVG_TOV_AWAY_p, 
		(AVG_TOV_HOME_p+AVG_TOV_AWAY_p)/2 TOTAL_AVG_TOV_p
FROM (
	-- get average TOV for all home games in playoffs for every team 
	SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(TOV_HOME) AVG_TOV_HOME_p
	FROM season_and_playoffs_data
	WHERE GAME_TYPE = "Playoffs"
	GROUP BY GAME_TYPE,TEAM_NAME_HOME
	ORDER BY TEAM_NAME_HOME) t1_home
JOIN 
	-- get average TOV for all away games in playoffs for every team 
	(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(TOV_AWAY) AVG_TOV_AWAY_p
	FROM season_and_playoffs_data
	WHERE GAME_TYPE = "Playoffs"
	GROUP BY GAME_TYPE, TEAM_NAME_AWAY
	ORDER BY TEAM_NAME_AWAY) t2_away
ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY;


-- JOIN previous two queries to create a single table which compares TOV stat between regular season and playoffs for each team 
WITH	regular_season_TOV  AS (SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_TOV_HOME_rs, t2_away.TEAM_NAME_AWAY, 
								t2_away.AVG_TOV_AWAY_rs, (AVG_TOV_HOME_rs+AVG_TOV_AWAY_rs)/2 TOTAL_AVG_TOV_rs
								FROM (
									SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(TOV_HOME) AVG_TOV_HOME_rs
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Regular Season"
									GROUP BY GAME_TYPE, TEAM_NAME_HOME
									ORDER BY TEAM_NAME_HOME) t1_home
								JOIN 
									(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(TOV_AWAY) AVG_TOV_AWAY_rs
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Regular Season"
									GROUP BY GAME_TYPE, TEAM_NAME_AWAY
									ORDER BY TEAM_NAME_AWAY) t2_away
								ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY), 
		playoffs_TOV 	AS 		(SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_TOV_HOME_p, t2_away.TEAM_NAME_AWAY, 
								t2_away.AVG_TOV_AWAY_p, (AVG_TOV_HOME_p+AVG_TOV_AWAY_p)/2 TOTAL_AVG_TOV_p
								FROM (
									SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(TOV_HOME) AVG_TOV_HOME_p
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Playoffs"
									GROUP BY GAME_TYPE,TEAM_NAME_HOME
									ORDER BY TEAM_NAME_HOME) t1_home
								JOIN 
									(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(TOV_AWAY) AVG_TOV_AWAY_p
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Playoffs"
									GROUP BY GAME_TYPE, TEAM_NAME_AWAY
									ORDER BY TEAM_NAME_AWAY) t2_away
								ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY)
                                
                                
SELECT	rs_TOV.TEAM_NAME_HOME AS TEAM_NAME, rs_TOV.TOTAL_AVG_TOV_rs AS TOTAL_AVG_TOV_RS, p_TOV.TOTAL_AVG_TOV_p AS TOTAL_AVG_TOV_P
FROM 	regular_season_TOV rs_TOV
LEFT JOIN playoffs_TOV p_TOV
ON rs_TOV.TEAM_NAME_HOME = p_TOV.TEAM_NAME_HOME AND rs_TOV.TEAM_NAME_AWAY = p_TOV.TEAM_NAME_AWAY;


/*			PF STAT			*/		


-- JOIN data to get total averages of every team for regular season 
SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_PF_HOME_rs, t2_away.TEAM_NAME_AWAY, t2_away.AVG_PF_AWAY_rs, 
		(AVG_PF_HOME_rs+AVG_PF_AWAY_rs)/2 TOTAL_AVG_PF_rs
FROM (
	-- get average PF for all home games in regular season for every team 
	SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(PF_HOME) AVG_PF_HOME_rs
	FROM season_and_playoffs_data
	WHERE GAME_TYPE = "Regular Season"
	GROUP BY GAME_TYPE, TEAM_NAME_HOME
	ORDER BY TEAM_NAME_HOME) t1_home
JOIN 
	-- get average PF for all away games in regular season for every team 
	(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(PF_AWAY) AVG_PF_AWAY_rs
	FROM season_and_playoffs_data
	WHERE GAME_TYPE = "Regular Season"
	GROUP BY GAME_TYPE, TEAM_NAME_AWAY
	ORDER BY TEAM_NAME_AWAY) t2_away
ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY;


-- JOIN data to get total averages of every team for playoffs
SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_PF_HOME_p, t2_away.TEAM_NAME_AWAY, t2_away.AVG_PF_AWAY_p, 
		(AVG_PF_HOME_p+AVG_PF_AWAY_p)/2 TOTAL_AVG_PF_p
FROM (
	-- get average PF for all home games in playoffs for every team 
	SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(PF_HOME) AVG_PF_HOME_p
	FROM season_and_playoffs_data
	WHERE GAME_TYPE = "Playoffs"
	GROUP BY GAME_TYPE,TEAM_NAME_HOME
	ORDER BY TEAM_NAME_HOME) t1_home
JOIN 
	-- get average PF for all away games in playoffs for every team 
	(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(PF_AWAY) AVG_PF_AWAY_p
	FROM season_and_playoffs_data
	WHERE GAME_TYPE = "Playoffs"
	GROUP BY GAME_TYPE, TEAM_NAME_AWAY
	ORDER BY TEAM_NAME_AWAY) t2_away
ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY;


-- JOIN previous two queries to create a single table which compares PF stat between regular season and playoffs for each team 
WITH	regular_season_PF 	AS 	(SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_PF_HOME_rs, t2_away.TEAM_NAME_AWAY, 
								t2_away.AVG_PF_AWAY_rs, (AVG_PF_HOME_rs+AVG_PF_AWAY_rs)/2 TOTAL_AVG_PF_rs
								FROM ( 
									SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(PF_HOME) AVG_PF_HOME_rs
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Regular Season"
									GROUP BY GAME_TYPE, TEAM_NAME_HOME
									ORDER BY TEAM_NAME_HOME) t1_home
								JOIN 
									(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(PF_AWAY) AVG_PF_AWAY_rs
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Regular Season"
									GROUP BY GAME_TYPE, TEAM_NAME_AWAY
									ORDER BY TEAM_NAME_AWAY) t2_away
								ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY), 
		playoffs_PF 	AS 		(SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_PF_HOME_p, t2_away.TEAM_NAME_AWAY, 
								t2_away.AVG_PF_AWAY_p, (AVG_PF_HOME_p+AVG_PF_AWAY_p)/2 TOTAL_AVG_PF_p
								FROM (
									SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(PF_HOME) AVG_PF_HOME_p
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Playoffs"
									GROUP BY GAME_TYPE,TEAM_NAME_HOME
									ORDER BY TEAM_NAME_HOME) t1_home
								JOIN 
									(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(PF_AWAY) AVG_PF_AWAY_p
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Playoffs"
									GROUP BY GAME_TYPE, TEAM_NAME_AWAY
									ORDER BY TEAM_NAME_AWAY) t2_away
								ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY)


SELECT	rs_PF.TEAM_NAME_HOME AS TEAM_NAME, rs_PF.TOTAL_AVG_PF_rs AS TOTAL_AVG_PF_RS, p_PF.TOTAL_AVG_PF_p AS TOTAL_AVG_PF_P
FROM 	regular_season_PF rs_PF
LEFT JOIN playoffs_PF p_PF
ON rs_PF.TEAM_NAME_HOME = p_PF.TEAM_NAME_HOME AND rs_PF.TEAM_NAME_AWAY = p_PF.TEAM_NAME_AWAY;


/*			PTS STAT			*/		


-- JOIN data to get total averages of every team for regular season 
SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_PTS_HOME_rs, t2_away.TEAM_NAME_AWAY, t2_away.AVG_PTS_AWAY_rs, 
		(AVG_PTS_HOME_rs+AVG_PTS_AWAY_rs)/2 TOTAL_AVG_PTS_rs
FROM (
	-- get average PTS for all home games in regular season for every team 
	SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(PTS_HOME) AVG_PTS_HOME_rs
	FROM season_and_playoffs_data
	WHERE GAME_TYPE = "Regular Season"
	GROUP BY GAME_TYPE, TEAM_NAME_HOME
	ORDER BY TEAM_NAME_HOME) t1_home
JOIN 
	-- get average PTS for all away games in regular season for every team 
	(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(PTS_AWAY) AVG_PTS_AWAY_rs
	FROM season_and_playoffs_data
	WHERE GAME_TYPE = "Regular Season"
	GROUP BY GAME_TYPE, TEAM_NAME_AWAY
	ORDER BY TEAM_NAME_AWAY) t2_away
ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY;



-- JOIN data to get total averages of every team for playoffs
SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_PTS_HOME_p, t2_away.TEAM_NAME_AWAY, t2_away.AVG_PTS_AWAY_p, 
		(AVG_PTS_HOME_p+AVG_PTS_AWAY_p)/2 TOTAL_AVG_PTS_p
FROM (
	-- get average PTS for all home games in playoffs for every team 
	SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(PTS_HOME) AVG_PTS_HOME_p
	FROM season_and_playoffs_data
	WHERE GAME_TYPE = "Playoffs"
	GROUP BY GAME_TYPE,TEAM_NAME_HOME
	ORDER BY TEAM_NAME_HOME) t1_home
JOIN 
	-- get average PTS for all away games in playoffs for every team 
	(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(PTS_AWAY) AVG_PTS_AWAY_p
	FROM season_and_playoffs_data
	WHERE GAME_TYPE = "Playoffs"
	GROUP BY GAME_TYPE, TEAM_NAME_AWAY
	ORDER BY TEAM_NAME_AWAY) t2_away
ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY;


-- JOIN previous two queries to create a single table which compares PTS stat between regular season and playoffs for each team 
WITH	regular_season_PTS 	AS 	(SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_PTS_HOME_rs, t2_away.TEAM_NAME_AWAY, 
								t2_away.AVG_PTS_AWAY_rs, (AVG_PTS_HOME_rs+AVG_PTS_AWAY_rs)/2 TOTAL_AVG_PTS_rs
								FROM ( 
									SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(PTS_HOME) AVG_PTS_HOME_rs
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Regular Season"
									GROUP BY GAME_TYPE, TEAM_NAME_HOME
									ORDER BY TEAM_NAME_HOME) t1_home
								JOIN  
									(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(PTS_AWAY) AVG_PTS_AWAY_rs
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Regular Season"
									GROUP BY GAME_TYPE, TEAM_NAME_AWAY
									ORDER BY TEAM_NAME_AWAY) t2_away
								ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY), 
		playoffs_PTS 	AS 		(SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_PTS_HOME_p, t2_away.TEAM_NAME_AWAY,
								t2_away.AVG_PTS_AWAY_p, (AVG_PTS_HOME_p+AVG_PTS_AWAY_p)/2 TOTAL_AVG_PTS_p
								FROM (
									SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(PTS_HOME) AVG_PTS_HOME_p
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Playoffs"
									GROUP BY GAME_TYPE,TEAM_NAME_HOME
									ORDER BY TEAM_NAME_HOME) t1_home
								JOIN 
									(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(PTS_AWAY) AVG_PTS_AWAY_p
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Playoffs"
									GROUP BY GAME_TYPE, TEAM_NAME_AWAY
									ORDER BY TEAM_NAME_AWAY) t2_away
								ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY)


SELECT	rs_PTS.TEAM_NAME_HOME AS TEAM_NAME, rs_PTS.TOTAL_AVG_PTS_rs AS TOTAL_AVG_PTS_RS, p_PTS.TOTAL_AVG_PTS_p AS TOTAL_AVG_PTS_P
FROM 	regular_season_PTS rs_PTS
LEFT JOIN playoffs_PTS p_PTS
ON rs_PTS.TEAM_NAME_HOME = p_PTS.TEAM_NAME_HOME AND rs_PTS.TEAM_NAME_AWAY = p_PTS.TEAM_NAME_AWAY;


/*			PTS_PAINT STAT			*/		


-- JOIN data to get total averages of every team for regular season 
SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_PTS_PAINT_HOME_rs, t2_away.TEAM_NAME_AWAY, t2_away.AVG_PTS_PAINT_AWAY_rs, 
		(AVG_PTS_PAINT_HOME_rs+AVG_PTS_PAINT_AWAY_rs)/2 TOTAL_AVG_PTS_PAINT_rs
FROM (
	-- get average PTS_PAINT for all home games in regular season for every team 
	SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(PTS_PAINT_HOME) AVG_PTS_PAINT_HOME_rs
	FROM season_and_playoffs_data
	WHERE GAME_TYPE = "Regular Season"
	GROUP BY GAME_TYPE, TEAM_NAME_HOME
	ORDER BY TEAM_NAME_HOME) t1_home
JOIN 
	-- get average PTS_PAINT for all away games in regular season for every team 
	(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(PTS_PAINT_AWAY) AVG_PTS_PAINT_AWAY_rs
	FROM season_and_playoffs_data
	WHERE GAME_TYPE = "Regular Season"
	GROUP BY GAME_TYPE, TEAM_NAME_AWAY
	ORDER BY TEAM_NAME_AWAY) t2_away
ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY;


-- JOIN data to get total averages of every team for playoffs
SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_PTS_PAINT_HOME_p, t2_away.TEAM_NAME_AWAY, t2_away.AVG_PTS_PAINT_AWAY_p, 
		(AVG_PTS_PAINT_HOME_p+AVG_PTS_PAINT_AWAY_p)/2 TOTAL_AVG_PTS_PAINT_p
FROM (
	-- get average PTS_PAINT for all home games in playoffs for every team 
	SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(PTS_PAINT_HOME) AVG_PTS_PAINT_HOME_p
	FROM season_and_playoffs_data
	WHERE GAME_TYPE = "Playoffs"
	GROUP BY GAME_TYPE,TEAM_NAME_HOME
	ORDER BY TEAM_NAME_HOME) t1_home
JOIN 
	-- get average PTS_PAINT for all away games in playoffs for every team 
	(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(PTS_PAINT_AWAY) AVG_PTS_PAINT_AWAY_p
	FROM season_and_playoffs_data
	WHERE GAME_TYPE = "Playoffs"
	GROUP BY GAME_TYPE, TEAM_NAME_AWAY
	ORDER BY TEAM_NAME_AWAY) t2_away
ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY;


-- JOIN previous two queries to create a single table which compares PTS_PAINT stat between regular season and playoffs for each team 
WITH	regular_season_PTS_PAINT AS (SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_PTS_PAINT_HOME_rs, 
									t2_away.TEAM_NAME_AWAY, t2_away.AVG_PTS_PAINT_AWAY_rs, 
                                    (AVG_PTS_PAINT_HOME_rs+AVG_PTS_PAINT_AWAY_rs)/2 TOTAL_AVG_PTS_PAINT_rs
									FROM (
										SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(PTS_PAINT_HOME) AVG_PTS_PAINT_HOME_rs
										FROM season_and_playoffs_data
										WHERE GAME_TYPE = "Regular Season"
										GROUP BY GAME_TYPE, TEAM_NAME_HOME
										ORDER BY TEAM_NAME_HOME) t1_home
									JOIN 
										(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(PTS_PAINT_AWAY) AVG_PTS_PAINT_AWAY_rs
										FROM season_and_playoffs_data
										WHERE GAME_TYPE = "Regular Season"
										GROUP BY GAME_TYPE, TEAM_NAME_AWAY
										ORDER BY TEAM_NAME_AWAY) t2_away
									ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY),
		playoffs_PTS_PAINT 	  AS 	(SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_PTS_PAINT_HOME_p, 
									t2_away.TEAM_NAME_AWAY, t2_away.AVG_PTS_PAINT_AWAY_p, 
                                    (AVG_PTS_PAINT_HOME_p+AVG_PTS_PAINT_AWAY_p)/2 TOTAL_AVG_PTS_PAINT_p
									FROM ( 
										SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(PTS_PAINT_HOME) AVG_PTS_PAINT_HOME_p
										FROM season_and_playoffs_data
										WHERE GAME_TYPE = "Playoffs"
										GROUP BY GAME_TYPE,TEAM_NAME_HOME
										ORDER BY TEAM_NAME_HOME) t1_home
									JOIN 
										(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(PTS_PAINT_AWAY) AVG_PTS_PAINT_AWAY_p
										FROM season_and_playoffs_data
										WHERE GAME_TYPE = "Playoffs"
										GROUP BY GAME_TYPE, TEAM_NAME_AWAY
										ORDER BY TEAM_NAME_AWAY) t2_away
										ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY)


SELECT	rs_PTS_PAINT.TEAM_NAME_HOME AS TEAM_NAME, rs_PTS_PAINT.TOTAL_AVG_PTS_PAINT_rs AS TOTAL_AVG_PTS_PAINT_RS, 
		p_PTS_PAINT.TOTAL_AVG_PTS_PAINT_p AS TOTAL_AVG_PTS_PAINT_P
FROM 	regular_season_PTS_PAINT rs_PTS_PAINT
LEFT JOIN playoffs_PTS_PAINT p_PTS_PAINT
ON rs_PTS_PAINT.TEAM_NAME_HOME = p_PTS_PAINT.TEAM_NAME_HOME AND rs_PTS_PAINT.TEAM_NAME_AWAY = p_PTS_PAINT.TEAM_NAME_AWAY;


/*			OREB STAT			*/		


-- JOIN data to get total averages of every team for regular season 
SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_OREB_HOME_rs, t2_away.TEAM_NAME_AWAY, t2_away.AVG_OREB_AWAY_rs, 
		(AVG_OREB_HOME_rs+AVG_OREB_AWAY_rs)/2 TOTAL_AVG_OREB_rs
FROM (
	-- get average OREB for all home games in regular season for every team 
	SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(OREB_HOME) AVG_OREB_HOME_rs
	FROM season_and_playoffs_data
	WHERE GAME_TYPE = "Regular Season"
	GROUP BY GAME_TYPE, TEAM_NAME_HOME
	ORDER BY TEAM_NAME_HOME) t1_home
JOIN 
	-- get average OREB for all away games in regular season for every team 
	(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(OREB_AWAY) AVG_OREB_AWAY_rs
	FROM season_and_playoffs_data
	WHERE GAME_TYPE = "Regular Season"
	GROUP BY GAME_TYPE, TEAM_NAME_AWAY
	ORDER BY TEAM_NAME_AWAY) t2_away
ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY;


-- JOIN data to get total averages of every team for playoffs
SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_OREB_HOME_p, t2_away.TEAM_NAME_AWAY, t2_away.AVG_OREB_AWAY_p, 
		(AVG_OREB_HOME_p+AVG_OREB_AWAY_p)/2 TOTAL_AVG_OREB_p
FROM (
	-- get average OREB for all home games in playoffs for every team 
	SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(OREB_HOME) AVG_OREB_HOME_p
	FROM season_and_playoffs_data
	WHERE GAME_TYPE = "Playoffs"
	GROUP BY GAME_TYPE,TEAM_NAME_HOME
	ORDER BY TEAM_NAME_HOME) t1_home
JOIN 
	-- get average OREB for all away games in playoffs for every team 
	(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(OREB_AWAY) AVG_OREB_AWAY_p
	FROM season_and_playoffs_data
	WHERE GAME_TYPE = "Playoffs"
	GROUP BY GAME_TYPE, TEAM_NAME_AWAY
	ORDER BY TEAM_NAME_AWAY) t2_away
ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY;


-- JOIN previous two queries to create a single table which compares OREB stat between regular season and playoffs for each team 
WITH	regular_season_OREB  AS (SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_OREB_HOME_rs, t2_away.TEAM_NAME_AWAY, 
								t2_away.AVG_OREB_AWAY_rs, (AVG_OREB_HOME_rs+AVG_OREB_AWAY_rs)/2 TOTAL_AVG_OREB_rs
								FROM (
									SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(OREB_HOME) AVG_OREB_HOME_rs
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Regular Season"
									GROUP BY GAME_TYPE, TEAM_NAME_HOME
									ORDER BY TEAM_NAME_HOME) t1_home
								JOIN 
									(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(OREB_AWAY) AVG_OREB_AWAY_rs
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Regular Season"
									GROUP BY GAME_TYPE, TEAM_NAME_AWAY
									ORDER BY TEAM_NAME_AWAY) t2_away
								ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY), 
		playoffs_OREB 	 AS 	(SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_OREB_HOME_p, t2_away.TEAM_NAME_AWAY, 
								t2_away.AVG_OREB_AWAY_p, (AVG_OREB_HOME_p+AVG_OREB_AWAY_p)/2 TOTAL_AVG_OREB_p
								FROM (
									SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(OREB_HOME) AVG_OREB_HOME_p
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Playoffs"
									GROUP BY GAME_TYPE,TEAM_NAME_HOME
									ORDER BY TEAM_NAME_HOME) t1_home
								JOIN 
									(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(OREB_AWAY) AVG_OREB_AWAY_p
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Playoffs"
									GROUP BY GAME_TYPE, TEAM_NAME_AWAY
									ORDER BY TEAM_NAME_AWAY) t2_away
								ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY)


SELECT	rs_OREB.TEAM_NAME_HOME AS TEAM_NAME, rs_OREB.TOTAL_AVG_OREB_rs AS TOTAL_AVG_OREB_RS, p_OREB.TOTAL_AVG_OREB_p AS TOTAL_AVG_OREB_P
FROM 	regular_season_OREB rs_OREB
LEFT JOIN playoffs_OREB p_OREB
ON rs_OREB.TEAM_NAME_HOME = p_OREB.TEAM_NAME_HOME AND rs_OREB.TEAM_NAME_AWAY = p_OREB.TEAM_NAME_AWAY;


/* Create Views for tables which will be used in visualizations */


-- FGA Stat table  
CREATE VIEW FGA AS 
WITH	regular_season_FGA AS (SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_FGA_HOME_rs, t2_away.TEAM_NAME_AWAY, 
								t2_away.AVG_FGA_AWAY_rs, (AVG_FGA_HOME_rs+AVG_FGA_AWAY_rs)/2 TOTAL_AVG_FGA_rs
								FROM (
									SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(FGA_HOME) AVG_FGA_HOME_rs
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Regular Season"
									GROUP BY GAME_TYPE, TEAM_NAME_HOME
									ORDER BY TEAM_NAME_HOME) t1_home
								JOIN 
									(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(FGA_AWAY) AVG_FGA_AWAY_rs
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Regular Season"
									GROUP BY GAME_TYPE, TEAM_NAME_AWAY
									ORDER BY TEAM_NAME_AWAY) t2_away
								ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY),
		playoffs_FGA	AS 	(SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_FGA_HOME_p, t2_away.TEAM_NAME_AWAY, 
								t2_away.AVG_FGA_AWAY_p, (AVG_FGA_HOME_p+AVG_FGA_AWAY_p)/2 TOTAL_AVG_FGA_p
								FROM (
									SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(FGA_HOME) AVG_FGA_HOME_p
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Playoffs"
									GROUP BY GAME_TYPE,TEAM_NAME_HOME
									ORDER BY TEAM_NAME_HOME) t1_home
								JOIN 
									(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(FGA_AWAY) AVG_FGA_AWAY_p
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Playoffs"
									GROUP BY GAME_TYPE, TEAM_NAME_AWAY
									ORDER BY TEAM_NAME_AWAY) t2_away
								ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY)
        

SELECT	rs_FGA.TEAM_NAME_HOME AS TEAM_NAME, rs_FGA.TOTAL_AVG_FGA_rs AS TOTAL_AVG_FGA_RS, p_FGA.TOTAL_AVG_FGA_p AS TOTAL_AVG_FGA_P
FROM 	regular_season_FGA rs_FGA
LEFT JOIN playoffs_FGA p_FGA 
ON rs_FGA.TEAM_NAME_HOME = p_FGA.TEAM_NAME_HOME AND rs_FGA.TEAM_NAME_AWAY = p_FGA.TEAM_NAME_AWAY;


-- FG3A Stat table  
CREATE VIEW FG3A AS 
WITH	regular_season_FG3A AS (SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_FG3A_HOME_rs, t2_away.TEAM_NAME_AWAY, 
								t2_away.AVG_FG3A_AWAY_rs, (AVG_FG3A_HOME_rs+AVG_FG3A_AWAY_rs)/2 TOTAL_AVG_FG3A_rs
								FROM (
									SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(FG3A_HOME) AVG_FG3A_HOME_rs
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Regular Season"
									GROUP BY GAME_TYPE, TEAM_NAME_HOME
									ORDER BY TEAM_NAME_HOME) t1_home
								JOIN 
									(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(FG3A_AWAY) AVG_FG3A_AWAY_rs
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Regular Season"
									GROUP BY GAME_TYPE, TEAM_NAME_AWAY
									ORDER BY TEAM_NAME_AWAY) t2_away
								ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY), 
		playoffs_FG3A	AS 		(SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_FG3A_HOME_p, t2_away.TEAM_NAME_AWAY, 
								t2_away.AVG_FG3A_AWAY_p, (AVG_FG3A_HOME_p+AVG_FG3A_AWAY_p)/2 TOTAL_AVG_FG3A_p
								FROM (
									SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(FG3A_HOME) AVG_FG3A_HOME_p
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Playoffs"
									GROUP BY GAME_TYPE,TEAM_NAME_HOME
									ORDER BY TEAM_NAME_HOME) t1_home
								JOIN 
									(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(FG3A_AWAY) AVG_FG3A_AWAY_p
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Playoffs"
									GROUP BY GAME_TYPE, TEAM_NAME_AWAY
									ORDER BY TEAM_NAME_AWAY) t2_away
								ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY)


SELECT	rs_FG3A.TEAM_NAME_HOME AS TEAM_NAME, rs_FG3A.TOTAL_AVG_FG3A_rs AS TOTAL_AVG_FG3A_RS, p_FG3A.TOTAL_AVG_FG3A_p AS TOTAL_AVG_FG3A_P
FROM 	regular_season_FG3A rs_FG3A
LEFT JOIN playoffs_FG3A p_FG3A
ON rs_FG3A.TEAM_NAME_HOME = p_FG3A.TEAM_NAME_HOME AND rs_FG3A.TEAM_NAME_AWAY = p_FG3A.TEAM_NAME_AWAY;


-- AST Stat table 
CREATE VIEW AST AS  
WITH	regular_season_AST  AS (SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_AST_HOME_rs, t2_away.TEAM_NAME_AWAY, 
								t2_away.AVG_AST_AWAY_rs, (AVG_AST_HOME_rs+AVG_AST_AWAY_rs)/2 TOTAL_AVG_AST_rs
								FROM (
									SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(AST_HOME) AVG_AST_HOME_rs
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Regular Season"
									GROUP BY GAME_TYPE, TEAM_NAME_HOME
									ORDER BY TEAM_NAME_HOME) t1_home
								JOIN  
									(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(AST_AWAY) AVG_AST_AWAY_rs
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Regular Season"
									GROUP BY GAME_TYPE, TEAM_NAME_AWAY
									ORDER BY TEAM_NAME_AWAY) t2_away
								ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY), 
		playoffs_AST 	AS 	    (SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_AST_HOME_p, t2_away.TEAM_NAME_AWAY, 
								t2_away.AVG_AST_AWAY_p, (AVG_AST_HOME_p+AVG_AST_AWAY_p)/2 TOTAL_AVG_AST_p
								FROM ( 
									SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(AST_HOME) AVG_AST_HOME_p
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Playoffs"
									GROUP BY GAME_TYPE,TEAM_NAME_HOME
									ORDER BY TEAM_NAME_HOME) t1_home
								JOIN 
									(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(AST_AWAY) AVG_AST_AWAY_p
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Playoffs"
									GROUP BY GAME_TYPE, TEAM_NAME_AWAY
									ORDER BY TEAM_NAME_AWAY) t2_away
								ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY)


SELECT	rs_AST.TEAM_NAME_HOME AS TEAM_NAME, rs_AST.TOTAL_AVG_AST_rs AS TOTAL_AVG_AST_RS, p_AST.TOTAL_AVG_AST_p AS TOTAL_AVG_AST_P
FROM 	regular_season_AST rs_AST
LEFT JOIN playoffs_AST p_AST
ON rs_AST.TEAM_NAME_HOME = p_AST.TEAM_NAME_HOME AND rs_AST.TEAM_NAME_AWAY = p_AST.TEAM_NAME_AWAY;


-- TOV Stat table 
CREATE VIEW TOV AS  
WITH	regular_season_TOV  AS (SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_TOV_HOME_rs, t2_away.TEAM_NAME_AWAY, 
								t2_away.AVG_TOV_AWAY_rs, (AVG_TOV_HOME_rs+AVG_TOV_AWAY_rs)/2 TOTAL_AVG_TOV_rs
								FROM (
									SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(TOV_HOME) AVG_TOV_HOME_rs
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Regular Season"
									GROUP BY GAME_TYPE, TEAM_NAME_HOME
									ORDER BY TEAM_NAME_HOME) t1_home
								JOIN 
									(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(TOV_AWAY) AVG_TOV_AWAY_rs
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Regular Season"
									GROUP BY GAME_TYPE, TEAM_NAME_AWAY
									ORDER BY TEAM_NAME_AWAY) t2_away
								ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY), 
		playoffs_TOV 	AS 		(SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_TOV_HOME_p, t2_away.TEAM_NAME_AWAY, 
								t2_away.AVG_TOV_AWAY_p, (AVG_TOV_HOME_p+AVG_TOV_AWAY_p)/2 TOTAL_AVG_TOV_p
								FROM (
									SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(TOV_HOME) AVG_TOV_HOME_p
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Playoffs"
									GROUP BY GAME_TYPE,TEAM_NAME_HOME
									ORDER BY TEAM_NAME_HOME) t1_home
								JOIN 
									(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(TOV_AWAY) AVG_TOV_AWAY_p
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Playoffs"
									GROUP BY GAME_TYPE, TEAM_NAME_AWAY
									ORDER BY TEAM_NAME_AWAY) t2_away
								ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY)
                                
                                
SELECT	rs_TOV.TEAM_NAME_HOME AS TEAM_NAME, rs_TOV.TOTAL_AVG_TOV_rs AS TOTAL_AVG_TOV_RS, p_TOV.TOTAL_AVG_TOV_p AS TOTAL_AVG_TOV_P
FROM 	regular_season_TOV rs_TOV
LEFT JOIN playoffs_TOV p_TOV
ON rs_TOV.TEAM_NAME_HOME = p_TOV.TEAM_NAME_HOME AND rs_TOV.TEAM_NAME_AWAY = p_TOV.TEAM_NAME_AWAY;


-- PF Stat table 
CREATE VIEW PF AS  
WITH	regular_season_PF 	AS 	(SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_PF_HOME_rs, t2_away.TEAM_NAME_AWAY, 
								t2_away.AVG_PF_AWAY_rs, (AVG_PF_HOME_rs+AVG_PF_AWAY_rs)/2 TOTAL_AVG_PF_rs
								FROM ( 
									SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(PF_HOME) AVG_PF_HOME_rs
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Regular Season"
									GROUP BY GAME_TYPE, TEAM_NAME_HOME
									ORDER BY TEAM_NAME_HOME) t1_home
								JOIN 
									(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(PF_AWAY) AVG_PF_AWAY_rs
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Regular Season"
									GROUP BY GAME_TYPE, TEAM_NAME_AWAY
									ORDER BY TEAM_NAME_AWAY) t2_away
								ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY), 
		playoffs_PF 	AS 		(SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_PF_HOME_p, t2_away.TEAM_NAME_AWAY, 
								t2_away.AVG_PF_AWAY_p, (AVG_PF_HOME_p+AVG_PF_AWAY_p)/2 TOTAL_AVG_PF_p
								FROM (
									SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(PF_HOME) AVG_PF_HOME_p
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Playoffs"
									GROUP BY GAME_TYPE,TEAM_NAME_HOME
									ORDER BY TEAM_NAME_HOME) t1_home
								JOIN 
									(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(PF_AWAY) AVG_PF_AWAY_p
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Playoffs"
									GROUP BY GAME_TYPE, TEAM_NAME_AWAY
									ORDER BY TEAM_NAME_AWAY) t2_away
								ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY)


SELECT	rs_PF.TEAM_NAME_HOME AS TEAM_NAME, rs_PF.TOTAL_AVG_PF_rs AS TOTAL_AVG_PF_RS, p_PF.TOTAL_AVG_PF_p AS TOTAL_AVG_PF_P
FROM 	regular_season_PF rs_PF
LEFT JOIN playoffs_PF p_PF
ON rs_PF.TEAM_NAME_HOME = p_PF.TEAM_NAME_HOME AND rs_PF.TEAM_NAME_AWAY = p_PF.TEAM_NAME_AWAY;


-- PTS Stat table 
CREATE VIEW PTS AS  
WITH	regular_season_PTS 	AS 	(SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_PTS_HOME_rs, t2_away.TEAM_NAME_AWAY, 
								t2_away.AVG_PTS_AWAY_rs, (AVG_PTS_HOME_rs+AVG_PTS_AWAY_rs)/2 TOTAL_AVG_PTS_rs
								FROM ( 
									SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(PTS_HOME) AVG_PTS_HOME_rs
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Regular Season"
									GROUP BY GAME_TYPE, TEAM_NAME_HOME
									ORDER BY TEAM_NAME_HOME) t1_home
								JOIN  
									(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(PTS_AWAY) AVG_PTS_AWAY_rs
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Regular Season"
									GROUP BY GAME_TYPE, TEAM_NAME_AWAY
									ORDER BY TEAM_NAME_AWAY) t2_away
								ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY), 
		playoffs_PTS 	AS 		(SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_PTS_HOME_p, t2_away.TEAM_NAME_AWAY,
								t2_away.AVG_PTS_AWAY_p, (AVG_PTS_HOME_p+AVG_PTS_AWAY_p)/2 TOTAL_AVG_PTS_p
								FROM (
									SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(PTS_HOME) AVG_PTS_HOME_p
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Playoffs"
									GROUP BY GAME_TYPE,TEAM_NAME_HOME
									ORDER BY TEAM_NAME_HOME) t1_home
								JOIN 
									(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(PTS_AWAY) AVG_PTS_AWAY_p
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Playoffs"
									GROUP BY GAME_TYPE, TEAM_NAME_AWAY
									ORDER BY TEAM_NAME_AWAY) t2_away
								ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY)


SELECT	rs_PTS.TEAM_NAME_HOME AS TEAM_NAME, rs_PTS.TOTAL_AVG_PTS_rs AS TOTAL_AVG_PTS_RS, p_PTS.TOTAL_AVG_PTS_p AS TOTAL_AVG_PTS_P
FROM 	regular_season_PTS rs_PTS
LEFT JOIN playoffs_PTS p_PTS
ON rs_PTS.TEAM_NAME_HOME = p_PTS.TEAM_NAME_HOME AND rs_PTS.TEAM_NAME_AWAY = p_PTS.TEAM_NAME_AWAY;


-- PTS_PAINT Stat table 
CREATE VIEW PTS_PAINT AS 
WITH	regular_season_PTS_PAINT AS (SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_PTS_PAINT_HOME_rs, 
									t2_away.TEAM_NAME_AWAY, t2_away.AVG_PTS_PAINT_AWAY_rs, 
                                    (AVG_PTS_PAINT_HOME_rs+AVG_PTS_PAINT_AWAY_rs)/2 TOTAL_AVG_PTS_PAINT_rs
									FROM (
										SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(PTS_PAINT_HOME) AVG_PTS_PAINT_HOME_rs
										FROM season_and_playoffs_data
										WHERE GAME_TYPE = "Regular Season"
										GROUP BY GAME_TYPE, TEAM_NAME_HOME
										ORDER BY TEAM_NAME_HOME) t1_home
									JOIN 
										(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(PTS_PAINT_AWAY) AVG_PTS_PAINT_AWAY_rs
										FROM season_and_playoffs_data
										WHERE GAME_TYPE = "Regular Season"
										GROUP BY GAME_TYPE, TEAM_NAME_AWAY
										ORDER BY TEAM_NAME_AWAY) t2_away
									ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY),
		playoffs_PTS_PAINT 	  AS 	(SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_PTS_PAINT_HOME_p, 
									t2_away.TEAM_NAME_AWAY, t2_away.AVG_PTS_PAINT_AWAY_p, 
                                    (AVG_PTS_PAINT_HOME_p+AVG_PTS_PAINT_AWAY_p)/2 TOTAL_AVG_PTS_PAINT_p
									FROM ( 
										SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(PTS_PAINT_HOME) AVG_PTS_PAINT_HOME_p
										FROM season_and_playoffs_data
										WHERE GAME_TYPE = "Playoffs"
										GROUP BY GAME_TYPE,TEAM_NAME_HOME
										ORDER BY TEAM_NAME_HOME) t1_home
									JOIN 
										(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(PTS_PAINT_AWAY) AVG_PTS_PAINT_AWAY_p
										FROM season_and_playoffs_data
										WHERE GAME_TYPE = "Playoffs"
										GROUP BY GAME_TYPE, TEAM_NAME_AWAY
										ORDER BY TEAM_NAME_AWAY) t2_away
										ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY)


SELECT	rs_PTS_PAINT.TEAM_NAME_HOME AS TEAM_NAME, rs_PTS_PAINT.TOTAL_AVG_PTS_PAINT_rs AS TOTAL_AVG_PTS_PAINT_RS, 
		p_PTS_PAINT.TOTAL_AVG_PTS_PAINT_p AS TOTAL_AVG_PTS_PAINT_P
FROM 	regular_season_PTS_PAINT rs_PTS_PAINT
LEFT JOIN playoffs_PTS_PAINT p_PTS_PAINT
ON rs_PTS_PAINT.TEAM_NAME_HOME = p_PTS_PAINT.TEAM_NAME_HOME AND rs_PTS_PAINT.TEAM_NAME_AWAY = p_PTS_PAINT.TEAM_NAME_AWAY;


-- OREB Stat table 
CREATE VIEW OREB AS 
WITH	regular_season_OREB  AS (SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_OREB_HOME_rs, t2_away.TEAM_NAME_AWAY, 
								t2_away.AVG_OREB_AWAY_rs, (AVG_OREB_HOME_rs+AVG_OREB_AWAY_rs)/2 TOTAL_AVG_OREB_rs
								FROM (
									SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(OREB_HOME) AVG_OREB_HOME_rs
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Regular Season"
									GROUP BY GAME_TYPE, TEAM_NAME_HOME
									ORDER BY TEAM_NAME_HOME) t1_home
								JOIN 
									(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(OREB_AWAY) AVG_OREB_AWAY_rs
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Regular Season"
									GROUP BY GAME_TYPE, TEAM_NAME_AWAY
									ORDER BY TEAM_NAME_AWAY) t2_away
								ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY), 
		playoffs_OREB 	 AS 	(SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_OREB_HOME_p, t2_away.TEAM_NAME_AWAY, 
								t2_away.AVG_OREB_AWAY_p, (AVG_OREB_HOME_p+AVG_OREB_AWAY_p)/2 TOTAL_AVG_OREB_p
								FROM (
									SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(OREB_HOME) AVG_OREB_HOME_p
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Playoffs"
									GROUP BY GAME_TYPE,TEAM_NAME_HOME
									ORDER BY TEAM_NAME_HOME) t1_home
								JOIN 
									(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(OREB_AWAY) AVG_OREB_AWAY_p
									FROM season_and_playoffs_data
									WHERE GAME_TYPE = "Playoffs"
									GROUP BY GAME_TYPE, TEAM_NAME_AWAY
									ORDER BY TEAM_NAME_AWAY) t2_away
								ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY)


SELECT	rs_OREB.TEAM_NAME_HOME AS TEAM_NAME, rs_OREB.TOTAL_AVG_OREB_rs AS TOTAL_AVG_OREB_RS, p_OREB.TOTAL_AVG_OREB_p AS TOTAL_AVG_OREB_P
FROM 	regular_season_OREB rs_OREB
LEFT JOIN playoffs_OREB p_OREB
ON rs_OREB.TEAM_NAME_HOME = p_OREB.TEAM_NAME_HOME AND rs_OREB.TEAM_NAME_AWAY = p_OREB.TEAM_NAME_AWAY;


-- Select all created views for export into Excel 
SELECT*
FROM AST;

SELECT*
FROM FG3A;

SELECT*
FROM FGA;

SELECT*
FROM OREB;

SELECT*
FROM PF;

SELECT*
FROM PTS;

SELECT*
FROM PTS_PAINT;

SELECT*
FROM TOV;



-- Select data to export as CSV to help switch order of home team and away team in number_of_possessions_data file 
SELECT game_id, season, game_type, team_city_home, TEAM_NICKNAME_HOME, team_city_away, TEAM_NICKNAME_AWAY
FROM season_and_playoffs_data
ORDER BY GAME_ID;

SELECT*
FROM num_of_possessions;
SELECT*
FROM time_of_possessions;


-- Turn OFF safe mode to update missing number of possessions single record for Hornets and Wizards matchup
SHOW VARIABLES LIKE '%safe%';
SET sql_safe_updates = 0;


/* The following queries update the only missing PACE and POSS stats in the num_of_possessions table */


START TRANSACTION;
-- UPDATE PACE_HOME stat for Hornets team
UPDATE num_of_possessions
SET 
    PACE_HOME = (
	SELECT ROUND((PACE_HOME_avg+PACE_AWAY_avg)/2)
	FROM (
		SELECT TEAM_NAME_HOME, AVG(PACE_HOME) PACE_HOME_avg
		FROM (
			SELECT SEASON, GAME_TYPE, TEAM_CITY_HOME, TEAM_NAME_HOME, PACE_HOME
			FROM num_of_possessions
			WHERE SEASON = 2003 AND GAME_TYPE = 'Regular Season' AND TEAM_CITY_HOME = 'New Orleans' AND TEAM_NAME_HOME = 'Hornets' AND PACE_HOME != 0) t1) PACE_H
		JOIN (
		SELECT TEAM_NAME_AWAY, AVG(PACE_AWAY) PACE_AWAY_avg
		FROM (
			SELECT SEASON, GAME_TYPE, TEAM_CITY_AWAY, TEAM_NAME_AWAY, PACE_AWAY
			FROM num_of_possessions
			WHERE SEASON = 2003 AND GAME_TYPE = 'Regular Season' AND TEAM_CITY_AWAY = 'New Orleans' AND TEAM_NAME_AWAY = 'Hornets' AND PACE_AWAY != 0) t2) PACE_A)
WHERE GAME_ID = 20300778;


-- UPDATE POSS_HOME stat for Hornets team
UPDATE num_of_possessions
SET 
	POSS_HOME = (
	SELECT ROUND((POSS_HOME_avg+POSS_AWAY_avg)/2)
	FROM (
		SELECT TEAM_NAME_HOME, AVG(POSS_HOME) POSS_HOME_avg
		FROM (
			SELECT SEASON, GAME_TYPE, TEAM_CITY_HOME, TEAM_NAME_HOME, POSS_HOME
			FROM num_of_possessions
			WHERE SEASON = 2003 AND GAME_TYPE = 'Regular Season' AND TEAM_CITY_HOME = 'New Orleans' AND TEAM_NAME_HOME = 'Hornets' AND POSS_HOME != 0) t1) POSS_H
		JOIN (
		SELECT TEAM_NAME_AWAY, AVG(POSS_AWAY) POSS_AWAY_avg
		FROM (
			SELECT SEASON, GAME_TYPE, TEAM_CITY_AWAY, TEAM_NAME_AWAY, POSS_AWAY
			FROM num_of_possessions
			WHERE SEASON = 2003 AND GAME_TYPE = 'Regular Season' AND TEAM_CITY_AWAY = 'New Orleans' AND TEAM_NAME_AWAY = 'Hornets' AND POSS_AWAY != 0) t2) POSS_A)
WHERE GAME_ID = 20300778;


-- UPDATE PACE_AWAY stat for Wizards team
UPDATE num_of_possessions
SET 
	PACE_AWAY = (
	SELECT ROUND((PACE_HOME_avg+PACE_AWAY_avg)/2)
	FROM (
		SELECT TEAM_NAME_HOME, AVG(PACE_HOME) PACE_HOME_avg
		FROM (
			SELECT SEASON, GAME_TYPE, TEAM_CITY_HOME, TEAM_NAME_HOME, PACE_HOME
			FROM num_of_possessions
			WHERE SEASON = 2003 AND GAME_TYPE = 'Regular Season' AND TEAM_CITY_HOME = 'Washington' AND TEAM_NAME_HOME = 'Wizards' AND PACE_HOME != 0) t1) PACE_H
		JOIN (
		SELECT TEAM_NAME_AWAY, AVG(PACE_AWAY) PACE_AWAY_avg
		FROM (
			SELECT SEASON, GAME_TYPE, TEAM_CITY_AWAY, TEAM_NAME_AWAY, PACE_AWAY
			FROM num_of_possessions
			WHERE SEASON = 2003 AND GAME_TYPE = 'Regular Season' AND TEAM_CITY_AWAY = 'Washington' AND TEAM_NAME_AWAY = 'Wizards' AND PACE_AWAY != 0) t2) PACE_A)
WHERE GAME_ID = 20300778;

-- UPDATE POSS_AWAY stat for Wizards team
UPDATE num_of_possessions
SET 
	POSS_AWAY = (
	SELECT ROUND((POSS_HOME_avg+POSS_AWAY_avg)/2)
	FROM (
		SELECT TEAM_NAME_HOME, AVG(POSS_HOME) POSS_HOME_avg
		FROM (
			SELECT SEASON, GAME_TYPE, TEAM_CITY_HOME, TEAM_NAME_HOME, POSS_HOME
			FROM num_of_possessions
			WHERE SEASON = 2003 AND GAME_TYPE = 'Regular Season' AND TEAM_CITY_HOME = 'Washington' AND TEAM_NAME_HOME = 'Wizards' AND POSS_HOME != 0) t1) POSS_H
		JOIN (
		SELECT TEAM_NAME_AWAY, AVG(POSS_AWAY) POSS_AWAY_avg
		FROM (
			SELECT SEASON, GAME_TYPE, TEAM_CITY_AWAY, TEAM_NAME_AWAY, POSS_AWAY
			FROM num_of_possessions
			WHERE SEASON = 2003 AND GAME_TYPE = 'Regular Season' AND TEAM_CITY_AWAY = 'Washington' AND TEAM_NAME_AWAY = 'Wizards' AND POSS_AWAY != 0) t2) POSS_A)
WHERE GAME_ID = 20300778;

-- COMMIT UPDATE changes to server, or ROLLBACK 
COMMIT;
ROLLBACK;



-- Calculate derived time per possession stat for all HOME teams 
SELECT GAME_ID, GAME_TYPE, TEAM_CITY_HOME, TEAM_NAME_HOME, (TIME_OF_POSS*60)/POSS_HOME TIME_per_POSS_HOME
FROM (
	-- JOIN data for side-by-side calculation of time per possession stat for HOME teams
	SELECT 	num_pos.GAME_ID, num_pos.SEASON SEASON_num, num_pos.GAME_TYPE, num_pos.TEAM_CITY_HOME, num_pos.TEAM_NAME_HOME, num_pos.POSS_HOME, 
			t_pos.SEASON SEASON_t,t_pos.TEAM_CITY, t_pos.TEAM_NAME, t_pos.TIME_OF_POSS
	FROM num_of_possessions num_pos
	JOIN time_of_possessions t_pos
		ON num_pos.season = t_pos.season AND num_pos.GAME_TYPE = t_pos.GAME_TYPE AND num_pos.TEAM_NAME_HOME = t_pos.TEAM_NAME
) HOME_TOP;


-- Calculate derived time per possession stat for all AWAY teams 
SELECT GAME_ID, GAME_TYPE, TEAM_CITY_AWAY, TEAM_NAME_AWAY, (TIME_OF_POSS*60)/POSS_AWAY TIME_per_POSS_AWAY
FROM (
	-- JOIN data for side-by-side calculation of time per possession stat for AWAY teams
	SELECT 	num_pos.GAME_ID, num_pos.SEASON SEASON_num, num_pos.GAME_TYPE, num_pos.TEAM_CITY_AWAY, num_pos.TEAM_NAME_AWAY, num_pos.POSS_AWAY, 
			t_pos.SEASON SEASON_t,t_pos.TEAM_CITY, t_pos.TEAM_NAME, t_pos.TIME_OF_POSS
	FROM num_of_possessions num_pos
	JOIN time_of_possessions t_pos
		ON num_pos.season = t_pos.season AND num_pos.GAME_TYPE = t_pos.GAME_TYPE AND num_pos.TEAM_NAME_AWAY = t_pos.TEAM_NAME
) AWAY_TOP;



-- Create temporary table for time per possession HOME data to be used in cross table UPDATE JOIN to fill TIME_per_POSS_HOME column in 
-- season_and_playoffs_data table 
CREATE TEMPORARY TABLE fill_TIME_per_POSS_HOME 
SELECT GAME_ID, GAME_TYPE, TEAM_CITY_HOME, TEAM_NAME_HOME, (TIME_OF_POSS*60)/POSS_HOME TIME_per_POSS_HOME
FROM (
	SELECT 	num_pos.GAME_ID, num_pos.SEASON SEASON_num, num_pos.GAME_TYPE, num_pos.TEAM_CITY_HOME, num_pos.TEAM_NAME_HOME, num_pos.POSS_HOME, 
			t_pos.SEASON SEASON_t,t_pos.TEAM_CITY, t_pos.TEAM_NAME, t_pos.TIME_OF_POSS
	FROM num_of_possessions num_pos
	JOIN time_of_possessions t_pos
		ON num_pos.season = t_pos.season AND num_pos.GAME_TYPE = t_pos.GAME_TYPE AND num_pos.TEAM_NAME_HOME = t_pos.TEAM_NAME
) HOME_TOP;



-- Create temporary table for time per possession AWAY data to be used in cross table UPDATE JOIN to fill TIME_per_POSS_AWAY column in 
-- season_and_playoffs_data table
CREATE TEMPORARY TABLE fill_TIME_per_POSS_AWAY
SELECT GAME_ID, GAME_TYPE, TEAM_CITY_AWAY, TEAM_NAME_AWAY, (TIME_OF_POSS*60)/POSS_AWAY TIME_per_POSS_AWAY
FROM (
	SELECT 	num_pos.GAME_ID, num_pos.SEASON SEASON_num, num_pos.GAME_TYPE, num_pos.TEAM_CITY_AWAY, num_pos.TEAM_NAME_AWAY, num_pos.POSS_AWAY, 
			t_pos.SEASON SEASON_t,t_pos.TEAM_CITY, t_pos.TEAM_NAME, t_pos.TIME_OF_POSS
	FROM num_of_possessions num_pos
	JOIN time_of_possessions t_pos
		ON num_pos.season = t_pos.season AND num_pos.GAME_TYPE = t_pos.GAME_TYPE AND num_pos.TEAM_NAME_AWAY = t_pos.TEAM_NAME
) AWAY_TOP;



-- JOIN data to get total averages of every team for regular season 
SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_TIME_per_POSS_HOME_rs, t2_away.TEAM_NAME_AWAY, 
		t2_away.AVG_TIME_per_POSS_AWAY_rs, (AVG_TIME_per_POSS_HOME_rs+AVG_TIME_per_POSS_AWAY_rs)/2 TOTAL_AVG_TIME_per_POSS_rs
FROM (
	-- get average TIME_per_POSS for all home games in regular season for every team 
	SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(TIME_per_POSS_HOME) AVG_TIME_per_POSS_HOME_rs
	FROM season_and_playoffs_data
	WHERE GAME_TYPE = "Regular Season" AND TIME_per_POSS_HOME IS NOT NULL
	GROUP BY GAME_TYPE, TEAM_NAME_HOME
	ORDER BY TEAM_NAME_HOME) t1_home
JOIN 
	-- get average TIME_per_POSS for all away games in regular season for every team 
	(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(TIME_per_POSS_AWAY) AVG_TIME_per_POSS_AWAY_rs
	FROM season_and_playoffs_data
	WHERE GAME_TYPE = "Regular Season" AND TIME_per_POSS_AWAY IS NOT NULL
	GROUP BY GAME_TYPE, TEAM_NAME_AWAY
	ORDER BY TEAM_NAME_AWAY) t2_away
ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY;


-- JOIN data to get total averages of every team for playoffs
SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_TIME_per_POSS_HOME_p, t2_away.TEAM_NAME_AWAY, t2_away.AVG_TIME_per_POSS_AWAY_p, 
		(AVG_TIME_per_POSS_HOME_p+AVG_TIME_per_POSS_AWAY_p)/2 TOTAL_AVG_TIME_per_POSS_p
FROM (
	-- get average TIME_per_POSS for all home games in playoffs for every team 
	SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(TIME_per_POSS_HOME) AVG_TIME_per_POSS_HOME_p
	FROM season_and_playoffs_data
	WHERE GAME_TYPE = "Playoffs" AND TIME_per_POSS_HOME IS NOT NULL
	GROUP BY GAME_TYPE,TEAM_NAME_HOME
	ORDER BY TEAM_NAME_HOME) t1_home
JOIN 
	-- get average TIME_per_POSS for all away games in playoffs for every team 
	(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(TIME_per_POSS_AWAY) AVG_TIME_per_POSS_AWAY_p
	FROM season_and_playoffs_data
	WHERE GAME_TYPE = "Playoffs" AND TIME_per_POSS_AWAY IS NOT NULL
	GROUP BY GAME_TYPE, TEAM_NAME_AWAY
	ORDER BY TEAM_NAME_AWAY) t2_away
ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY;


-- JOIN previous two queries to create a single table which compares TIME_per_POSS stat between regular season and playoffs for each team 
WITH	regular_season_TIME_per_POSS AS (SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_TIME_per_POSS_HOME_rs, 
												t2_away.TEAM_NAME_AWAY, t2_away.AVG_TIME_per_POSS_AWAY_rs, 
												(AVG_TIME_per_POSS_HOME_rs+AVG_TIME_per_POSS_AWAY_rs)/2 TOTAL_AVG_TIME_per_POSS_rs
										FROM (
											SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(TIME_per_POSS_HOME) AVG_TIME_per_POSS_HOME_rs
											FROM season_and_playoffs_data
											WHERE GAME_TYPE = "Regular Season" AND TIME_per_POSS_HOME IS NOT NULL
											GROUP BY GAME_TYPE, TEAM_NAME_HOME
											ORDER BY TEAM_NAME_HOME) t1_home
										JOIN 
											(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(TIME_per_POSS_AWAY) AVG_TIME_per_POSS_AWAY_rs
											FROM season_and_playoffs_data
											WHERE GAME_TYPE = "Regular Season" AND TIME_per_POSS_AWAY IS NOT NULL
											GROUP BY GAME_TYPE, TEAM_NAME_AWAY
											ORDER BY TEAM_NAME_AWAY) t2_away
										ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY),
		playoffs_TIME_per_POSS	 AS 	(SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_TIME_per_POSS_HOME_p, t2_away.TEAM_NAME_AWAY, 
											t2_away.AVG_TIME_per_POSS_AWAY_p, (AVG_TIME_per_POSS_HOME_p+AVG_TIME_per_POSS_AWAY_p)/2 TOTAL_AVG_TIME_per_POSS_p
										FROM (
											SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(TIME_per_POSS_HOME) AVG_TIME_per_POSS_HOME_p
											FROM season_and_playoffs_data
											WHERE GAME_TYPE = "Playoffs" AND TIME_per_POSS_HOME IS NOT NULL
											GROUP BY GAME_TYPE,TEAM_NAME_HOME
											ORDER BY TEAM_NAME_HOME) t1_home
										JOIN 
											(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(TIME_per_POSS_AWAY) AVG_TIME_per_POSS_AWAY_p
											FROM season_and_playoffs_data
											WHERE GAME_TYPE = "Playoffs" AND TIME_per_POSS_AWAY IS NOT NULL
											GROUP BY GAME_TYPE, TEAM_NAME_AWAY
											ORDER BY TEAM_NAME_AWAY) t2_away
										ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY)
        

SELECT	rs_TIME_per_POSS.TEAM_NAME_HOME AS TEAM_NAME, rs_TIME_per_POSS.TOTAL_AVG_TIME_per_POSS_rs AS TOTAL_AVG_TIME_per_POSS_RS, 
		p_TIME_per_POSS.TOTAL_AVG_TIME_per_POSS_p AS TOTAL_AVG_TIME_per_POSS_P
FROM 	regular_season_TIME_per_POSS rs_TIME_per_POSS
LEFT JOIN playoffs_TIME_per_POSS p_TIME_per_POSS
ON rs_TIME_per_POSS.TEAM_NAME_HOME = p_TIME_per_POSS.TEAM_NAME_HOME AND rs_TIME_per_POSS.TEAM_NAME_AWAY = p_TIME_per_POSS.TEAM_NAME_AWAY;


/* Create view for new TIME_per_POSS stat to be included in visualizations */


-- TIME_per_POSS Stat table 
CREATE VIEW TIME_per_POSS AS 
WITH	regular_season_TIME_per_POSS AS (SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_TIME_per_POSS_HOME_rs, 
												t2_away.TEAM_NAME_AWAY, t2_away.AVG_TIME_per_POSS_AWAY_rs, 
												(AVG_TIME_per_POSS_HOME_rs+AVG_TIME_per_POSS_AWAY_rs)/2 TOTAL_AVG_TIME_per_POSS_rs
										FROM (
											SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(TIME_per_POSS_HOME) AVG_TIME_per_POSS_HOME_rs
											FROM season_and_playoffs_data
											WHERE GAME_TYPE = "Regular Season" AND TIME_per_POSS_HOME IS NOT NULL
											GROUP BY GAME_TYPE, TEAM_NAME_HOME
											ORDER BY TEAM_NAME_HOME) t1_home
										JOIN 
											(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(TIME_per_POSS_AWAY) AVG_TIME_per_POSS_AWAY_rs
											FROM season_and_playoffs_data
											WHERE GAME_TYPE = "Regular Season" AND TIME_per_POSS_AWAY IS NOT NULL
											GROUP BY GAME_TYPE, TEAM_NAME_AWAY
											ORDER BY TEAM_NAME_AWAY) t2_away
										ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY),
		playoffs_TIME_per_POSS	 AS 	(SELECT t1_home.GAME_TYPE, t1_home.TEAM_NAME_HOME, t1_home.AVG_TIME_per_POSS_HOME_p, t2_away.TEAM_NAME_AWAY, 
											t2_away.AVG_TIME_per_POSS_AWAY_p, (AVG_TIME_per_POSS_HOME_p+AVG_TIME_per_POSS_AWAY_p)/2 TOTAL_AVG_TIME_per_POSS_p
										FROM (
											SELECT GAME_TYPE, TEAM_NAME_HOME, AVG(TIME_per_POSS_HOME) AVG_TIME_per_POSS_HOME_p
											FROM season_and_playoffs_data
											WHERE GAME_TYPE = "Playoffs" AND TIME_per_POSS_HOME IS NOT NULL
											GROUP BY GAME_TYPE,TEAM_NAME_HOME
											ORDER BY TEAM_NAME_HOME) t1_home
										JOIN 
											(SELECT GAME_TYPE, TEAM_NAME_AWAY, AVG(TIME_per_POSS_AWAY) AVG_TIME_per_POSS_AWAY_p
											FROM season_and_playoffs_data
											WHERE GAME_TYPE = "Playoffs" AND TIME_per_POSS_AWAY IS NOT NULL
											GROUP BY GAME_TYPE, TEAM_NAME_AWAY
											ORDER BY TEAM_NAME_AWAY) t2_away
										ON t1_home.TEAM_NAME_HOME = t2_away.TEAM_NAME_AWAY)
        

SELECT	rs_TIME_per_POSS.TEAM_NAME_HOME AS TEAM_NAME, rs_TIME_per_POSS.TOTAL_AVG_TIME_per_POSS_rs AS TOTAL_AVG_TIME_per_POSS_RS, 
		p_TIME_per_POSS.TOTAL_AVG_TIME_per_POSS_p AS TOTAL_AVG_TIME_per_POSS_P
FROM 	regular_season_TIME_per_POSS rs_TIME_per_POSS
LEFT JOIN playoffs_TIME_per_POSS p_TIME_per_POSS
ON rs_TIME_per_POSS.TEAM_NAME_HOME = p_TIME_per_POSS.TEAM_NAME_HOME AND rs_TIME_per_POSS.TEAM_NAME_AWAY = p_TIME_per_POSS.TEAM_NAME_AWAY;


SELECT*
FROM TIME_per_POSS;












