#!/bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Create the worldcup database
$PSQL "CREATE DATABASE worldcup;"

# Connect to the worldcup database and create the teams table
$PSQL "CREATE TABLE teams (
  team_id SERIAL PRIMARY KEY,
  name VARCHAR(255) UNIQUE NOT NULL
);"

# Create the games table with foreign key constraints
$PSQL "CREATE TABLE games (
  game_id SERIAL PRIMARY KEY,
  year INT NOT NULL,
  round VARCHAR NOT NULL,
  winner_id INT NOT NULL,
  opponent_id INT NOT NULL,
  winner_goals INT NOT NULL,
  opponent_goals INT NOT NULL,
  FOREIGN KEY (winner_id) REFERENCES teams(team_id),
  FOREIGN KEY (opponent_id) REFERENCES teams(team_id)
);"

# Insert the provided data into the teams and games tables
# Use a temporary file to load data
TMPFILE=$(mktemp)
cat << EOF > $TMPFILE
COPY teams (name) FROM stdin;
France
Croatia
Belgium
England
Sweden
Switzerland
Brazil
Mexico
Denmark
Russia
Spain
Uruguay
Portugal
Argentina
Germany
Netherlands
Costa Rica
Nigeria
Algeria
Greece
United States
\.
COPY games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) FROM stdin;
2018	Final	1	2	4	2
2018	Third Place	3	4	2	0
2018	Semi-Final	2	4	2	1
2018	Semi-Final	1	3	1	0
2018	Quarter-Final	2	10	3	2
2018	Quarter-Final	4	5	2	0
2018	Quarter-Final	3	9	2	1
2018	Quarter-Final	1	6	2	0
2018	Eighth-Final	5	11	2	1
2018	Eighth-Final	12	7	1	0
2018	Eighth-Final	3	13	3	2
2018	Eighth-Final	9	14	2	0
2018	Eighth-Final	2	15	2	1
2018	Eighth-Final	10	16	2	1
2018	Eighth-Final	4	17	2	1
2018	Eighth-Final	1	18	4	3
2014	Final	14	19	1	0
2014	Third Place	15	20	3	0
2014	Semi-Final	19	15	1	0
2014	Semi-Final	14	20	7	1
2014	Quarter-Final	15	21	1	0
2014	Quarter-Final	19	18	1	0
2014	Quarter-Final	20	22	2	1
2014	Quarter-Final	14	23	1	0
2014	Eighth-Final	22	24	2	1
2014	Eighth-Final	22	25	2	0
2014	Eighth-Final	18	26	2	0
2014	Eighth-Final	14	27	2	1
2014	Eighth-Final	15	28	2	1
2014	Eighth-Final	21	29	2	1
2014	Eighth-Final	19	30	1	0
2014	Eighth-Final	20	31	2	1
\.
EOF

# Load the data into the tables
$PSQL -c "COPY teams (name) FROM stdin;" < $TMPFILE
$PSQL -c "COPY games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) FROM stdin;" < $TMPFILE

# Clean up the temporary file
rm $TMPFILE
