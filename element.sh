#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

MAIN_MENU(){
  if [[ $1 ]]
  then
    #extract and read element result
    if [[ $1 =~ ^[0-9]+$ ]]
    then
      element_result=$($PSQL "SELECT atomic_number, symbol, name 
                              FROM elements 
                              WHERE atomic_number = $1")
    else
      element_result=$($PSQL "SELECT atomic_number, symbol, name 
                              FROM elements 
                              WHERE name = '$1' OR symbol = '$1'")
    fi
    if [[ -z $element_result ]]
    then 
      echo "I could not find that element in the database."
    else
      IFS="|" read -r atomic_number symbol name <<< "$element_result"
      
      #extract and read properties result
      properties_result=$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius, type_id
                                FROM properties
                                WHERE atomic_number=$atomic_number")
      IFS="|" read -r atomic_mass melting_point_celsius boiling_point_celsius type_id <<< "$properties_result"
      type_result=$($PSQL "SELECT type FROM types WHERE type_id = $type_id")
      IFS='|' read -r type <<< "$type_result"

      #output result
      echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point_celsius celsius and a boiling point of $boiling_point_celsius celsius."
    fi
  else 
    echo "Please provide an element as an argument."
  fi
}

MAIN_MENU "$1"
