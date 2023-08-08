#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"

# Total goals won
echo -e "\nTotal number of goals in all games from winning teams:"
echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"

# Total goals both teams
echo -e "\nTotal number of goals in all games from both teams combined:"
echo "$($PSQL "SELECT SUM(winner_goals)+SUM(opponent_goals) FROM games")"

# Average goals won 
echo -e "\nAverage number of goals in all games from the winning teams:"
echo "$($PSQL "SELECT AVG(winner_goals) FROM games")"  

# Average goals won rounded
echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
echo "$($PSQL "SELECT ROUND(AVG(winner_goals),2) FROM games")"

# Average goals both teams
echo -e "\nAverage number of goals in all games from both teams:"
echo "$($PSQL "SELECT AVG(winner_goals + opponent_goals) FROM games")"

# Most goals single game
echo -e "\nMost goals scored in a single game by one team:"
echo "$($PSQL "SELECT MAX(GREATEST(winner_goals, opponent_goals)) FROM games")"

# Count won by 2+ goals
echo -e "\nNumber of games where the winning team scored more than two goals:" 
echo "$($PSQL "SELECT COUNT(*) FROM games WHERE winner_goals > 2")"

# Get 2018 winner
echo -e "\nWinner of the 2018 tournament team name:"
echo "$($PSQL "SELECT name FROM teams INNER JOIN games ON winner_id=team_id WHERE year=2018 AND round='Final'")"

# Get teams in 2014 Eighth-Final  
echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
echo "$($PSQL "SELECT name FROM teams INNER JOIN games ON team_id IN (winner_id, opponent_id) WHERE year=2014 AND round='Eighth-Final' GROUP BY name ORDER BY name")"

# Get unique winners
echo -e "\nList of unique winning team names in the whole data set:"
echo "$($PSQL "SELECT DISTINCT name FROM teams INNER JOIN games ON winner_id=team_id ORDER BY name")"

# Champions by year
echo -e "\nYear and team name of all the champions:" 
echo "$($PSQL "SELECT year, name FROM teams INNER JOIN games ON winner_id=team_id WHERE round='Final' ORDER BY year")"

# Teams starting with Co
echo -e "\nList of teams that start with 'Co':"
echo "$($PSQL "SELECT name FROM teams WHERE name LIKE 'Co%' ORDER BY name")"
