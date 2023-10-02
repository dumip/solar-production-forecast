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

5. Enable the pgml extension
```sql
CREATE EXTENSION IF NOT EXISTS pgml;
SELECT pgml.version();
```

6. Train the model
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

7. Run the model
```sql
select pgml.predict (
	'Solar Panel Production Forecast V4',
	(
		2020,
		6,
		17,
		23,
		45,
		cast('4135001' as text),
		cast('adLQvlD726eNBSB' as text),
		cast('HmiyD2TTLFNqkNe' as text),
		cast(21.909287666666668 as float8),
		cast(20.4279724 as float8),
		0
	)
);
```

8. Now, if you want to run the prediction on multiple rows, you have two choices, as described below:
```sql
-- Use the predict function, but with some penalty on larger datasets
select pg.*,
pgml.predict (
	'Solar Panel Production Forecast3',
	(
		pg.year,
		pg.month,
		pg.day,
		pg.hour,
		pg.minute,
		pg.plant_id,
		pg.panel_id,
		pg.sensor_id,
		pg.ambient_temperature,
		pg.module_temperature,
		pg.irradiation
	)
) as predicted_ac_power
from vw_solar_plant_generation pg;

-- Use the predict batch, as described here: https://postgresml.org/docs/guides/predictions/batch
TODO: 
```
