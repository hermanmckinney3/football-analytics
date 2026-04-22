-------- Best 3rd Down in FBS
SELECT
    team,
    SUM(thirdDownConv) AS total_conversions,
    SUM(thirdDowns) AS total_attempts,
    ROUND(SUM(thirdDownConv)::numeric / SUM(thirdDowns),3) AS conversion_rate
FROM cfb.team_game_stats
WHERE week <= 14
GROUP BY team
HAVING SUM(thirdDowns) >= 50
ORDER BY conversion_rate DESC
LIMIT 200;

------ Best 3rd Down Conv in the ACC
SELECT  
    team,  
    SUM(thirdDownConv) AS total_conversions,  
    SUM(thirdDowns) AS total_attempts,  
    ROUND(SUM(thirdDownConv)::numeric / SUM(thirdDowns),3) AS conversion_rate  
FROM cfb.team_game_stats  
WHERE week <= 14  
AND conference = 'ACC'
GROUP BY team  
HAVING SUM(thirdDowns) >= 50  
ORDER BY conversion_rate DESC;

------- 3rd Down Conv By Conference
SELECT
    conference,
    SUM(thirdDownConv) AS total_conversions,
    SUM(thirdDowns) AS total_attempts,
    ROUND(SUM(thirdDownConv)::numeric / SUM(thirdDowns), 3) AS conversion_rate
FROM cfb.team_game_stats
WHERE week <= 14
AND conference IN ('ACC','Big Ten','SEC')
GROUP BY conference
ORDER BY conversion_rate DESC;

------- 3rd Down From Popular Schools
SELECT
    team,
    SUM(thirdDownConv) AS total_conversions,
    SUM(thirdDowns) AS total_attempts,
    ROUND(SUM(thirdDownConv)::numeric / SUM(thirdDowns),3) AS conversion_rate
FROM cfb.team_game_stats
WHERE week <= 14
AND team IN ('Iowa', 'Notre Dame','Alabama','BYU','Indiana','Texas')
GROUP BY team
ORDER BY conversion_rate DESC;
------- Most Interceptions (Power 4)
SELECT
    player_name,
    team,
    SUM(CASE 
        WHEN stat_type = 'INT' THEN stat::int
        ELSE 0
    END) AS interceptions,
    SUM(CASE 
        WHEN stat_type = 'PD' THEN stat::int
        ELSE 0
    END) AS passes_defended
FROM cfb.player_game_stats
WHERE season = 2025
AND (
        (stat_category = 'interceptions' AND stat_type = 'INT')
     OR (stat_category = 'defensive' AND stat_type = 'PD')
)
GROUP BY player_name, team
ORDER BY interceptions DESC
LIMIT 10;

---------- Highest Rush to Pass Ratio Reg Season
SELECT
    team,
    SUM(rushingAttempts) AS total_rush_attempts,
    SUM(passAttempts) AS total_pass_attempts,
    ROUND(
        SUM(rushingAttempts)::numeric /
        (SUM(rushingAttempts) + SUM(passAttempts)),
        3
    ) AS rush_percentage,
    SUM(rushingYards) AS total_rushing_yards
FROM cfb.team_game_stats
WHERE week <= 14
GROUP BY team
ORDER BY rush_percentage DESC
LIMIT 5;

------- Iowa
SELECT
    t1.week,
    t1.rushingYards,
	t1.rushingAttempts,
	t1.netPassingYards,
	t1.passAttempts,
    t1.rushingTDs,
    t2.team AS opponent
FROM cfb.team_game_stats t1
JOIN cfb.team_game_stats t2
ON t1.game_id = t2.game_id
AND t1.team <> t2.team
WHERE t1.team = 'Iowa'
AND t1.week <= 14
ORDER BY t1.week ASC;

------ Iowa Average rushing Yards Per Game
SELECT
    team,
    ROUND(AVG(rushingyards),1) AS avg_rush_yards_per_game
FROM cfb.team_game_stats
WHERE team = 'Iowa'
AND week <= 14
GROUP BY team;

------ Conference Average Rushing Yards per Game
SELECT
    conference,
    ROUND(AVG(rushingyards),1) AS avg_rush_yards_per_game
FROM cfb.team_game_stats
WHERE week <= 14
AND conference IN ('SEC','Big Ten','ACC')
GROUP BY conference
ORDER BY avg_rush_yards_per_game DESC;


-----Rush yards Per Attempt

SELECT
    team,
    ROUND(
        SUM(rushingyards)::numeric / SUM(rushingattempts),
        2) AS avg_yards_per_rush
FROM cfb.team_game_stats
WHERE team = 'Iowa'
AND week <= 14
GROUP BY team;

------------- Rush Per Attempt - Conferences
SELECT
    conference,
    ROUND(
        SUM(rushingyards)::numeric / SUM(rushingattempts),2) AS avg_yards_per_rush
FROM cfb.team_game_stats
WHERE week <= 14
AND conference IN ('SEC','Big Ten','ACC')
GROUP BY conference
ORDER BY avg_yards_per_rush DESC;

------------- Weekly 3rd Down Conversions ACC
SELECT
    week,
    team,
    SUM(thirdDownConv) AS conversions,
    SUM(thirdDowns) AS attempts,
    ROUND(
        SUM(thirdDownConv)::numeric / SUM(thirdDowns),
        3
    ) AS conversion_rate
FROM cfb.team_game_stats
WHERE week <= 14
AND team IN (
    'Florida State',
    'Virginia',
    'Miami',
    'Georgia Tech',
    'NC State'
)
GROUP BY week, team
ORDER BY team, week;

------------- Weekly 3rd Down Conversions some Top Teams

SELECT
    week,
    team,
    SUM(thirdDownConv) AS conversions,
    SUM(thirdDowns) AS attempts,
    ROUND(
        SUM(thirdDownConv)::numeric / SUM(thirdDowns),
        3
    ) AS conversion_rate
FROM cfb.team_game_stats
WHERE week <= 14
AND team IN (
    'Indiana',
    'BYU',
    'Alabama',
    'Iowa',
    'Texas'
)
GROUP BY week, team
ORDER BY team, week;

---------- Best on 4th Down
SELECT
    team,
    SUM(fourthDownConv) AS fourth_down_conversions,
    SUM(fourthDowns) AS fourth_down_attempts,
    ROUND(
        SUM(fourthDownConv)::numeric / SUM(fourthDowns),
        3) AS fourth_down_conversion_rate,
    ROUND(
        AVG(
            (rushingTDs * 6) +
            (passingTDs * 6) +
            kickingPoints),2) AS avg_offense_ppg
FROM cfb.team_game_stats
WHERE week <= 14
GROUP BY team
ORDER BY fourth_down_conversion_rate DESC;

--------------- Avg 4th Down (Power4)
SELECT
    conference,
    ROUND(
        SUM(fourthDownConv)::numeric / COUNT(*),
        2
    ) AS avg_fourth_down_conversions_per_game,
    ROUND(
        SUM(fourthDowns)::numeric / COUNT(*),
        2
    ) AS avg_fourth_down_attempts_per_game,
    ROUND(
        SUM(fourthDownConv)::numeric / SUM(fourthDowns),
        3
    ) AS fourth_down_conversion_rate,
    ROUND(
        AVG((rushingTDs * 3) + (passingTDs * 3) + kickingPoints),
        2
    ) AS avg_offense_ppg
FROM cfb.team_game_stats
WHERE week <= 14
AND conference IN ('SEC','ACC','Big Ten','Big 12')
GROUP BY conference
ORDER BY fourth_down_conversion_rate DESC;

--------------- Avg Conv per game
SELECT
    team,
    SUM(fourthDownConv) AS fourth_down_conversions,
    SUM(fourthDowns) AS fourth_down_attempts,
    ROUND(
        SUM(fourthDownConv)::numeric / SUM(fourthDowns),
        3
    ) AS fourth_down_conversion_rate,
    ROUND(
        SUM(fourthDownConv)::numeric / COUNT(*),
        2
    ) AS avg_fourth_down_conversions_per_game,
    ROUND(
        AVG((rushingTDs * 6) + (passingTDs * 6) + kickingPoints),
        2
    ) AS avg_offense_ppg
FROM cfb.team_game_stats
WHERE week <= 14
GROUP BY team
HAVING SUM(fourthDowns) >= 14
ORDER BY avg_offense_ppg DESC;

-----------Penalties in the ACC
SELECT
    team,
    SUM(penalties) AS total_penalties,
    SUM(penaltyyards) AS total_penalty_yards,
    ROUND(AVG(penalties),2) AS penalties_per_game
FROM cfb.team_game_stats
WHERE conference = 'ACC'
AND week <= 14
GROUP BY team
ORDER BY total_penalties DESC
LIMIT 5;

------------ Penalties to First Downs
SELECT
    team,
    SUM(penalties) AS penalties,
    SUM(firstdowns) AS first_downs
FROM cfb.team_game_stats
WHERE conference = 'ACC'
AND week <= 14
GROUP BY team
ORDER BY first_downs DESC;

------------ penalties and off points
SELECT
    team,
    SUM(penalties) AS total_penalties,
    ROUND(
        AVG((rushingTDs * 6) + (passingTDs * 6) + kickingPoints),
        2
    ) AS avg_off_ppg
FROM cfb.team_game_stats
WHERE conference = 'ACC'
AND week <= 14
GROUP BY team
ORDER BY avg_off_ppg DESC;

----------4th down ACC
SELECT
    team,
    SUM(fourthDownConv) AS fourth_down_conversions,
    SUM(fourthDowns) AS fourth_down_attempts,
    ROUND(
        SUM(fourthDownConv)::numeric / SUM(fourthDowns),
        3
    ) AS fourth_down_conversion_rate,
    ROUND(
        SUM(fourthDownConv)::numeric / COUNT(*),
        2
    ) AS avg_fourth_down_conversions_per_game,
    ROUND(
        AVG((rushingTDs * 6) + (passingTDs * 6) + kickingPoints),
        2
    ) AS avg_offense_ppg
FROM cfb.team_game_stats
WHERE week <= 14
AND conference = 'ACC'
GROUP BY team
HAVING SUM(fourthDowns) >= 14
ORDER BY fourth_down_conversion_rate DESC;
----------Tennesee Defense
SELECT
    t1.week,
    t1.team AS defense_team,
    t2.team AS opponent,
    -- calculate points allowed from opponent scoring
    (t2.rushingTDs * 6) +
    (t2.passingTDs * 6) +
    t2.kickingPoints AS points_allowed,
    t2.totalYards AS yards_allowed,
    t2.netPassingYards AS pass_yards_allowed,
    t2.rushingYards AS rush_yards_allowed,
    t2.yardsPerRushAttempt AS ypc_allowed,
    t2.firstDowns AS first_downs_allowed,
    t2.thirdDownConv,
    t2.thirdDowns,
    t2.fourthDownConv,
    t2.fourthDowns,
    (t2.fourthDownConv::numeric / NULLIF(t2.fourthDowns, 0)) AS fourth_percent_allowed,
    (t2.thirdDownConv::numeric / NULLIF(t2.thirdDowns, 0)) AS third_percent_allowed
FROM cfb.team_game_stats t1
JOIN cfb.team_game_stats t2
    ON t1.game_id = t2.game_id
    AND t1.team <> t2.team

WHERE t1.team = 'Tennessee'
ORDER BY t1.week;
------- Most Yards Allowed on season
SELECT
    t1.week,
    t1.team AS defense_team,
    t2.team AS opponent,
    -- calculate points allowed from opponent scoring
    (t2.rushingTDs * 6) +
    (t2.passingTDs * 6) +
    t2.kickingPoints AS points_allowed,
    t2.totalYards AS yards_allowed,
    t2.netPassingYards AS pass_yards_allowed,
    t2.rushingYards AS rush_yards_allowed,
    t2.yardsPerRushAttempt AS ypc_allowed,
    t2.firstDowns AS first_downs_allowed,
    t2.thirdDownConv,
    t2.thirdDowns,
    t2.fourthDownConv,
    t2.fourthDowns,
    (t2.fourthDownConv::numeric / NULLIF(t2.fourthDowns, 0)) AS fourth_percent_allowed,
    (t2.thirdDownConv::numeric / NULLIF(t2.thirdDowns, 0)) AS third_percent_allowed
FROM cfb.team_game_stats t1
JOIN cfb.team_game_stats t2
    ON t1.game_id = t2.game_id
    AND t1.team <> t2.team
WHERE t1.team = 'Tennessee'
  AND t2.team IN ('Georgia', 'Oklahoma', 'Vanderbilt', 'Alabama')
ORDER BY t1.week;
------------ Big Ten Rushing Yards
SELECT
    t1.team,
    SUM(t1.rushingYards) AS total_rushing_yards,
    SUM(t1.rushingAttempts) AS total_rush_attempts,
    ROUND(AVG(t1.rushingYards),1) AS avg_rush_yards_per_game,
    SUM(
        CASE
            WHEN t1.points > t2.points THEN 1
            ELSE 0
        END
    ) AS total_wins,
    SUM(
        CASE
            WHEN t1.points < t2.points THEN 1
            ELSE 0
        END
    ) AS total_losses
FROM cfb.team_game_stats t1
JOIN cfb.team_game_stats t2
    ON t1.game_id = t2.game_id
    AND t1.team <> t2.team
WHERE t1.conference = 'Big Ten'
AND t1.week <= 14
GROUP BY t1.team
ORDER BY total_rushing_yards DESC;

-------------------- Fix Post Seasons
SELECT
    t1.team,
    t1.week,
    t1.game_id,
    t2.team AS opponent,
    t1.rushingYards,
    t1.rushingAttempts,
    t1.points
FROM cfb.team_game_stats t1
JOIN cfb.team_game_stats t2
    ON t1.game_id = t2.game_id
    AND t1.team <> t2.team
WHERE t1.conference = 'Big Ten'
AND t1.week = 1
ORDER BY t1.team;


-- NC Teams | Avg Points Per Game | Total Penalties
SELECT
    team,
    ROUND(AVG(points), 2) AS avg_points_per_game,
    SUM(penalties) AS total_penalties
FROM cfb.team_game_stats
WHERE team IN ('NC State', 'Wake Forest', 'North Carolina', 'Duke')
GROUP BY team
ORDER BY avg_points_per_game DESC;