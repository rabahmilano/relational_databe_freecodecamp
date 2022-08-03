#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
else
  RE='^[0-9]+$'
	
	if  [[ $1 =~ $RE ]]
	then
    CONDITION="atomic_number=$1"
	else
		LEN=${#1}
    CAP=${1^}
		if [[ $LEN -gt 2 ]]
		then
			CONDITION="name='$CAP'"
		else
			CONDITION="symbol='$CAP'"
		fi
	fi
  SEARCH_ELEMENT=$($PSQL " SELECT atomic_number, name, symbol, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE $CONDITION ")
  if [[ -z $SEARCH_ELEMENT ]]
  then
    echo -e "I could not find that element in the database."
  else
    echo "$SEARCH_ELEMENT" | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE
    do
      echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
fi
