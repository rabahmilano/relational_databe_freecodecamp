#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t  --no-align -c"

SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))
echo -e "\nEnter your username:"

read USERNAME

USER=$($PSQL " SELECT name FROM players  WHERE name='$USERNAME' ")

if [[ -z $USER ]]
then
	echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
	
	INSERT_PLAYER=$($PSQL " INSERT INTO players (name) VALUES ('$USERNAME') ")
else
	USER_ID=$($PSQL " SELECT player_id FROM players  WHERE name='$USERNAME' ")
	
	GAME_PLAYED=$($PSQL " SELECT COUNT(*) FROM games WHERE player_id=$USER_ID ")
	
	BEST_GAME=$($PSQL " SELECT MIN(number_guess) FROM games WHERE player_id=$USER_ID")
	
	echo -e "\nWelcome back, $USER! You have played $GAME_PLAYED games, and your best game took $BEST_GAME guesses."
fi

echo -e "\nGuess the secret number between 1 and 1000:"

read GUESSED_NUMBER

NUMBER_ATTEMP=0

IS_IT_A_NUMBER() {
	RE='^[0-9]+$'
	until [[ $GUESSED_NUMBER =~ $RE ]]
	do
		NUMBER_ATTEMP=$(( NUMBER_ATTEMP + 1))
		echo -e "\nThat is not an integer, guess again:"
		read GUESSED_NUMBER
	done
}

until [[ $GUESSED_NUMBER == $SECRET_NUMBER ]]
do
	IS_IT_A_NUMBER
	if [[ $GUESSED_NUMBER -gt $SECRET_NUMBER ]]
	then
		NUMBER_ATTEMP=$(( NUMBER_ATTEMP + 1))
		echo -e "\nIt's lower than that, guess again:\n"
		read GUESSED_NUMBER
	elif [[ $GUESSED_NUMBER -lt $SECRET_NUMBER ]]
	then
		NUMBER_ATTEMP=$(( NUMBER_ATTEMP + 1))
		echo -e "\nIt's higher than that, guess again:\n"
		read GUESSED_NUMBER
	fi
done

NUMBER_ATTEMP=$(( NUMBER_ATTEMP + 1))

USER_ID=$($PSQL " SELECT player_id FROM players  WHERE name='$USERNAME' ")

GAME_PLAYED=$($PSQL " SELECT COUNT(*) FROM games WHERE player_id=$USER_ID ")

GAME_PLAYED=$(( $GAME_PLAYED + 1 ))

INSERT_GAME_INFO=$($PSQL " INSERT INTO games VALUES($USER_ID, $GAME_PLAYED, $NUMBER_ATTEMP) ")

echo -e "\nYou guessed it in $NUMBER_ATTEMP tries. The secret number was $SECRET_NUMBER. Nice job!"
