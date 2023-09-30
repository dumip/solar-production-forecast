# Solar Production Forecasting using PostgresML

This project is a proof of concept for using PostgresML to forecast solar production.

## Data
Input data for this project is from this datasource: https://www.kaggle.com/datasets/anikannal/solar-power-generation-data


## Getting Started

1. Install as per the instructions in the [PostgresML documentation](https://postgresml.org/docs/guides/setup/quick_start_with_docker)

2. Install the Postgres client already installed on your PC, if you don't have it already:
```bash
sudo apt install postgresql-client
```

3. Start PostgresML
```bash
#As documented here: https://postgresml.org/docs/guides/setup/quick_start_with_docker
docker run \
    -v postgresml_data:/var/lib/postgresql \
    --gpus all \
    -p 5433:5432 \
    -p 8000:8000 \
    ghcr.io/postgresml/postgresml:2.7.3

```

4. Import the data into PostgresML
```bash
# You need to put the correct host and port for your PostgresML instance
./impor-data.sh localhost 5433
```

5. Train the model
```sql
SELECT * FROM pgml.train(
  project_name => 'Solar Panel Production Forecast', 
  task => 'regression', 
  relation_name => 'vw_solar_plant_generation', 
  y_column_name => 'ac_power',
  test_size => 5,
  test_sampling => 'last'
);
```
