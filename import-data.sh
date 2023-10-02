#!/bin/bash

# Configuration
DB_USER="postgresml"
DB_PASSWORD="postgresml"
DB_NAME="postgres"

# Check if hostname and port arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <DB_HOST> <DB_PORT>"
    exit 1
fi
DB_HOST="$1"
DB_PORT="$2"

# Print input params in the console
echo "DB_HOST: $DB_HOST"
echo "DB_PORT: $DB_PORT"
echo "DB_USER: $DB_USER"
echo "DB_PASSWORD: $DB_PASSWORD"
echo "DB_NAME: $DB_NAME"


# List of CSV files for solar plant data and weather data
SOLAR_CSVS=("Plant_1_Generation_Data.csv" "Plant_2_Generation_Data.csv")
WEATHER_CSVS=("Plant_1_Weather_Sensor_Data.csv" "Plant_2_Weather_Sensor_Data.csv")

# Connect to the DB and create tables
PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME <<EOF
-- Create table for solar plant data
CREATE TABLE IF NOT EXISTS solar_plant_generation (
    DATE_TIME TIMESTAMP,
    PLANT_ID INT,
    SOURCE_KEY VARCHAR(255),
    DC_POWER FLOAT,
    AC_POWER FLOAT,
    DAILY_YIELD FLOAT,
    TOTAL_YIELD FLOAT
);

-- Create table for weather data
CREATE TABLE IF NOT EXISTS weather (
    DATE_TIME TIMESTAMP,
    PLANT_ID INT,
    SOURCE_KEY VARCHAR(255),
    AMBIENT_TEMPERATURE FLOAT,
    MODULE_TEMPERATURE FLOAT,
    IRRADIATION FLOAT
);

-- Create view for solar plant data with weather data
CREATE VIEW VW_SOLAR_PLANT_GENERATION
AS
SELECT
    CAST(EXTRACT(YEAR FROM SPG.DATE_TIME) AS INTEGER) AS YEAR,
    CAST(EXTRACT(MONTH FROM SPG.DATE_TIME) AS INTEGER) AS MONTH,
    CAST(EXTRACT(DAY FROM SPG.DATE_TIME) AS INTEGER) AS DAY,
    CAST(EXTRACT(HOUR FROM SPG.DATE_TIME) AS INTEGER) AS HOUR,
    CAST(EXTRACT(MINUTE FROM SPG.DATE_TIME) AS INTEGER) AS MINUTE,
    CAST(SPG.PLANT_ID AS TEXT),
    CAST(SPG.SOURCE_KEY AS TEXT) AS PANEL_ID,
    CAST(W.SOURCE_KEY AS TEXT) AS SENSOR_ID,
    CAST(W.AMBIENT_TEMPERATURE AS FLOAT),
    CAST(W.MODULE_TEMPERATURE AS FLOAT),
    CAST((W.IRRADIATION * 1000) AS FLOAT) as IRRADIATION,
    CAST(SPG.AC_POWER AS FLOAT)
FROM
    SOLAR_PLANT_GENERATION SPG
JOIN WEATHER W ON
    SPG.DATE_TIME = W.DATE_TIME
    AND SPG.PLANT_ID = W.PLANT_ID;

\q
EOF

# Check if table creation was successful
if [ $? -ne 0 ]; then
    echo "Error creating tables in PostgreSQL"
    exit 1
fi

# Import solar plant data from CSVs
for csv in "${SOLAR_CSVS[@]}"; do
    PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME <<EOF
    SET datestyle = 'DMY';
    \COPY solar_plant_generation FROM '$csv' DELIMITER ',' CSV HEADER;
    \q
EOF

    if [ $? -ne 0 ]; then
        echo "Error importing solar plant data from $csv"
        exit 1
    fi
    echo "Imported solar plant data from $csv"
done

# Import weather data from CSVs
for csv in "${WEATHER_CSVS[@]}"; do
    PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME <<EOF
    SET datestyle = 'DMY';
    \COPY weather FROM '$csv' DELIMITER ',' CSV HEADER;
    \q
EOF

    if [ $? -ne 0 ]; then
        echo "Error importing weather data from $csv"
        exit 1
    fi
    echo "Imported weather data from $csv"
done

echo "Data imported successfully!"
