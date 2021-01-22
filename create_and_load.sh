#!/bin/bash

host=$1
port=$2
user=$3
pass=$4
ssl=$5

if [ -z $host ] && [ -z $port ] && [ -z $user ] && [ -z $pass ]
then
  mariadb="mariadb" 
elif [ -z $ssl ]
then 
  mariadb="mariadb --host ${host} --port ${port} --user ${user} -p${pass}"
else 
  mariadb="mariadb --host ${host} --port ${port} --user ${user} -p${pass} --ssl-ca ${ssl}"
fi

# Create travel database including airlines, airports, and flights tables
echo "Creating schema..."
${mariadb} < schema.sql
echo "Schema created."

echo "Loading data..."

# Load airlines into flights.airlines
${mariadb} -e "LOAD DATA LOCAL INFILE 'data/airlines.csv' INTO TABLE airlines FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' LINES TERMINATED BY '\n'" travel

echo "- airlines.csv loaded into travel.airlines"

# Load airports into flights.airlines
${mariadb} -e "LOAD DATA LOCAL INFILE 'data/airports.csv' INTO TABLE airports FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' LINES TERMINATED BY '\n'" travel
echo "- airports.csv loaded into travel.airports"

echo "- travel.flights"
#!/bin/bash
# Check for argument, if so use as wildcard for file load match, otherwise load everything
filematch="*"
if [ $# -eq 1 ]
then
  filematch="*$1*"
fi
# Load the specified files under the data directory with the file pattern match
for f in flight_data/$filematch.csv; do
  echo "  - $f"
  #cpimport "travel" "flights" "flight_data/${f}" -s "," -E '"'
  ${mariadb} -e "LOAD DATA LOCAL INFILE '"$f"' INTO TABLE flights FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' LINES TERMINATED BY '\n'" travel
done
echo "Done!"