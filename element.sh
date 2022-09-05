#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT=$($PSQL "SELECT * FROM elements LEFT JOIN properties USING (atomic_number) LEFT JOIN types USING (type_id) WHERE atomic_number = $1;")
  else
    ELEMENT=$($PSQL "SELECT * FROM elements LEFT JOIN properties USING (atomic_number) LEFT JOIN types USING (type_id) WHERE symbol = '$1' OR name = '$1';")
  fi

  if [[ -z $ELEMENT ]]
  then
    echo I could not find that element in the database.
  else
    IFS=" | "
    read -a strarr <<< "$ELEMENT"

    ATOMIC_NUMBER=${strarr[1]}
    SYMBOL=${strarr[2]}
    NAME=${strarr[3]}
    TYPE=${strarr[7]}
    MASS=${strarr[4]}
    MELTING_POINT=${strarr[5]}
    BOILING_POINT=${strarr[6]}
    echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi
fi
