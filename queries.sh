#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c" 

# Total goals by winning teams
echo -e "\nTotal number of goals in all games from winning teams:"
echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"

# Total goals both teams 
echo -e "\nTotal number of goals in all games from both teams combined:"  
echo "$($PSQL "SELECT SUM(winner_goals + opponent_goals) FROM games")"

# Avg goals by winning teams
echo -e "\nAverage number of goals in all games from the winning teams:"
echo "$($PSQL "SELECT AVG(winner_goals) FROM games")"

# Avg goals rounded 
echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
echo "$($PSQL "SELECT ROUND(AVG(winner_goals), 2) FROM games")" 

# Avg goals both teams
echo -e "\nAverage number of goals in all games from both teams:" 
echo "$($PSQL "SELECT AVG(winner_goals + opponent_goals) FROM games")"

# Most goals in game
echo -e "\nMost goals scored in a single game by one team:"
echo "$($PSQL "SELECT MAX(GREATEST(winner_goals, opponent_goals)) FROM games")"

# Count games won by 2+ goals
echo -e "\nNumber of games where the winning team scored more than two goals:" 
echo "$($PSQL "SELECT COUNT(*) FROM games WHERE winner_goals > 2")"

# Get 2018 winner
echo -e "\nWinner of the 2018 tournament team name:"
echo "$($PSQL "SELECT name FROM teams INNER JOIN games ON winner_id = team_id WHERE year = 2018 AND round = 'Final'")"

# Get teams in 2014 Eighth-Final
echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
echo "$($PSQL "SELECT name FROM teams INNER JOIN games ON team_id IN (winner_id, opponent_id) WHERE year = 2014 AND round = 'Eighth-Final' GROUP BY name")"

# Get unique winners
echo -e "\nList of unique winning team names in the whole data set:"
echo "$($PSQL "SELECT DISTINCT name FROM teams INNER JOIN games ON winner_id = team_id")"

# Champions by year 
echo -e "\nYear and team name of all the champions:"
echo "$($PSQL "SELECT year, name FROM teams INNER JOIN games ON winner_id = team_id WHERE round = 'Final'")"

# Teams starting with Co
echo -e "\nList of teams that start with 'Co':"
echo "$($PSQL "SELECT name FROM teams WHERE name LIKE 'Co%'")"
