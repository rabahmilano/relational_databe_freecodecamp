#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS="," read YR RN WIN OPO WING OPOG
do
	if [[ $YR != year ]]
	then
		# get win_team_id
		WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WIN'")
		
		#if not found
		if [[ -z $WIN_ID ]]
		then
			# insert team
			INSERT_WIN=$($PSQL "INSERT INTO teams (name) VALUES ('$WIN')")
		fi
		
		# get opo_team_id
		OPO_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPO'")
		
		# if not found
		if [[ -z $OPO_ID ]]
		then
			INSERT_OPO=$($PSQL "INSERT INTO teams (name) VALUES ('$OPO')")
		fi
	fi
done

cat games.csv | while IFS="," read YR RN WIN OPO WING OPOG
do
	if [[ $YR != year ]]
	then
		WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WIN'")
		OPO_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPO'")
		
		INSERT_LINE=$($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ('$YR', '$RN', '$WIN_ID', '$OPO_ID', '$WING', '$OPOG')")
	fi
done
