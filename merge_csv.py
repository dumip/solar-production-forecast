import csv
import os
import sys
import pandas as pd
from datetime import datetime

input_folder = './ro-data/one_year/'
output_file = './ro-data/combined_data_one_year.csv'

# An empty list to store individual dataframes
dataframes = []

for filename in os.listdir(input_folder):
    if filename.endswith('.csv'):
        print("Processing " + filename)
        file_path = os.path.join(input_folder, filename)

        with open(file_path, 'r') as file:
            reader = csv.reader(file, delimiter='\t')
            date_line = next(reader)
            date_str = date_line[0].split(' ')[1]
            print("date_str: " + date_str)
            date = datetime.strptime(date_str, '%d/%m/%Y')

            print("Current date is: " + date.strftime("%Y-%m-%d %H:%M:%S"))

            # Skip the empty line
            next(reader)
            # Skip the header line
            next(reader)

            # Temporary list to store data for each file
            temp_data = []

            for row in reader:
                print("Processing row: " + ', '.join(row))
                time_str, power, irradiance = row
                if "x" in power:
                    print("We have a problem Houston, unreliable power data. Skip the current data set" + power)
                    continue
                if "x" in irradiance:
                    print("We have a problem Houston, unreliable irradiance data" + irradiance)
                    continue

                timestamp = datetime.strptime(f'{date_str} {time_str}', '%d/%m/%Y %H:%M')
                temp_data.append({'Timestamp': timestamp, 'Irradiance(W/m2)': irradiance, 'Power(KW)': power})

            # Create a DataFrame from the temp_data and append it to the list
            dataframes.append(pd.DataFrame(temp_data))

# Concatenate all dataframes in the list
combined_data = pd.concat(dataframes, ignore_index=True)
# Convert columns to appropriate types

combined_data['Irradiance(W/m2)'] = combined_data['Irradiance(W/m2)'].astype(float)
combined_data['Power(KW)'] = combined_data['Power(KW)'].astype(float)

# Save the combined data to a CSV file
combined_data.to_csv(output_file, index=False)
