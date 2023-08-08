#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Insert unique teams into the teams table
$PSQL "INSERT INTO teams (name) VALUES ('France') ON CONFLICT DO NOTHING;"
$PSQL "INSERT INTO teams (name) VALUES ('Croatia') ON CONFLICT DO NOTHING;"
$PSQL "INSERT INTO teams (name) VALUES ('Belgium') ON CONFLICT DO NOTHING;"
$PSQL "INSERT INTO teams (name) VALUES ('England') ON CONFLICT DO NOTHING;"
# ... Repeat for the remaining teams

# Insert game data into the games table
$PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals)
       VALUES (2018, 'Final', (SELECT team_id FROM teams WHERE name = 'France'), (SELECT team_id FROM teams WHERE name = 'Croatia'), 4, 2);"
$PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals)
       VALUES (2018, 'Third Place', (SELECT team_id FROM teams WHERE name = 'Belgium'), (SELECT team_id FROM teams WHERE name = 'England'), 2, 0);"
# ... Repeat for the remaining game data

# Continue inserting data for all games

echo "Data insertion completed."
