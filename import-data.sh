#!/bin/bash

# Configuration
DB_HOST="localhost"
DB_USER="postgresml"
DB_PASSWORD="postgresml"
DB_NAME="postgres"

# List of CSV files for solar plant data and weather data
SOLAR_CSVS=("Plant_1_Generation_Data.csv" "Plant_2_Generation_Data.csv")
WEATHER_CSVS=("Plant_1_Weather_Sensor_Data.csv" "Plant_1_Weather_Sensor_Data.csv")

# Connect to the DB and create tables
PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -U $DB_USER -d $DB_NAME <<EOF
-- Create table for solar plant data
CREATE TABLE IF NOT EXISTS solar_plant_data (
    DATE_TIME TIMESTAMP,
    PLANT_ID INT,
    SOURCE_KEY VARCHAR(255),
    DC_POWER FLOAT,
    AC_POWER FLOAT,
    DAILY_YIELD FLOAT,
    TOTAL_YIELD FLOAT
);

-- Create table for weather data
CREATE TABLE IF NOT EXISTS weather_data (
    DATE_TIME TIMESTAMP,
    PLANT_ID INT,
    SOURCE_KEY VARCHAR(255),
    AMBIENT_TEMPERATURE FLOAT,
    MODULE_TEMPERATURE FLOAT,
    IRRADIATION FLOAT
);
EOF

# Check if table creation was successful
if [ $? -ne 0 ]; then
    echo "Error creating tables in PostgreSQL"
    exit 1
fi

# Import solar plant data from CSVs
for csv in "${SOLAR_CSVS[@]}"; do
    PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -U $DB_USER -d $DB_NAME -c "\COPY solar_plant_data FROM '$csv' DELIMITER ',' CSV HEADER;"
    if [ $? -ne 0 ]; then
        echo "Error importing solar plant data from $csv"
        exit 1
    fi
    echo "Imported solar plant data from $csv"
done

# Import weather data from CSVs
for csv in "${WEATHER_CSVS[@]}"; do
    PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -U $DB_USER -d $DB_NAME -c "\COPY weather_data FROM '$csv' DELIMITER ',' CSV HEADER;"
    if [ $? -ne 0 ]; then
        echo "Error importing weather data from $csv"
        exit 1
    fi
    echo "Imported weather data from $csv"
done

echo "Data imported successfully!"