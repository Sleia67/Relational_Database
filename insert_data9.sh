#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"  
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

$PSQL "CREATE TABLE teams (
  team_id SERIAL PRIMARY KEY,
  name VARCHAR(50) UNIQUE NOT NULL
);"

$PSQL "CREATE TABLE games (
  game_id SERIAL PRIMARY KEY,
  year INT NOT NULL,
  round VARCHAR(50) NOT NULL,
  winner VARCHAR(50) NOT NULL,
  opponent VARCHAR(50) NOT NULL, 
  winner_goals INT NOT NULL,
  opponent_goals INT NOT NULL
);"

echo "Starting data insertion..."

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # Debugging output 
  echo "Processing data: YEAR=$YEAR ROUND=$ROUND WINNER=$WINNER OPPONENT=$OPPONENT WINNER_GOALS=$WINNER_GOALS OPPONENT_GOALS=$OPPONENT_GOALS"  

  # Lookup team IDs
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

  # Lookup team IDs 
WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

# Check if teams already exist
if [[ -z $WINNER_ID ]]; then

  TEAM_EXISTS=$($PSQL "SELECT 1 FROM teams WHERE name='$WINNER'")

  if [[ -z $TEAM_EXISTS ]]; then
    # Insert team 
  fi 

fi

if [[ -z $OPPONENT_ID ]]; then

  TEAM_EXISTS=$($PSQL "SELECT 1 FROM teams WHERE name='$OPPONENT'")

  if [[ -z $TEAM_EXISTS ]]; then
    # Insert team
  fi

fi

# Insert game

  # Debugging output
  echo "WINNER_ID=$WINNER_ID OPPONENT_ID=$OPPONENT_ID"

  # Insert if not found
  if [[ -z $WINNER_ID ]]; then
    INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER') RETURNING *;")
    echo "Inserting $WINNER: $INSERT_WINNER"

    if [[ $INSERT_WINNER == "INSERT 0 1" ]]; then
      echo Inserted into teams, $WINNER
    fi

    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  fi

  if [[ -z $OPPONENT_ID ]]; then
    INSERT_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT') RETURNING *;")
    echo "Inserting $OPPONENT: $INSERT_OPPONENT"

    if [[ $INSERT_OPPONENT == "INSERT 0 1" ]]; then
      echo Inserted into teams, $OPPONENT
    fi

    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  fi

  # Insert game
  echo "Inserting game: $YEAR $ROUND $WINNER vs $OPPONENT"
  INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS);")
  
  echo "INSERT_GAME result: $INSERT_GAME"
done
