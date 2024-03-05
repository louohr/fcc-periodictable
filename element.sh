PSQL="psql --username=freecodecamp --dbname=periodic_table -t --tuples-only -c"

if [[ -z $1 ]]; then
  echo -e "Please provide an element as an argument."
  exit
fi

if [[ $1 =~ ^[1-9]+$ ]]; then
  ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements JOIN properties using(atomic_number) JOIN types using(type_id) where atomic_number = $1")
else
  ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements JOIN properties using(atomic_number) JOIN types using(type_id) where name = '$1' or symbol = '$1'")
fi

if [[ -z $ELEMENT ]]; then
  echo -e "I could not find that element in the database."
  exit
fi

echo "$ELEMENT" | while IFS="|" read NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT; do
  echo -e "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
done
