#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
# Read the CSV file and process it
tail -n +2 games.csv | while IFS=',' read year round winner opponent winner_goals opponent_goals
do
  # Insert winner team if not exists
  winner_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$winner'")
  if [[ -z $winner_id ]]
  then
    insert_result=$($PSQL "INSERT INTO teams(name) VALUES('$winner')")
    winner_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$winner'")
  fi

  # Insert opponent team if not exists
  opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$opponent'")
  if [[ -z $opponent_id ]]
  then
    insert_result=$($PSQL "INSERT INTO teams(name) VALUES('$opponent')")
    opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$opponent'")
  fi

  # Insert the game
  $PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($year, '$round', $winner_id, $opponent_id, $winner_goals, $opponent_goals)"
done
