select distinct date("timestamp") as dateonly from combined_data cd 
order by dateonly asc


select * from combined_data cd 

select * from combined_data cd where 
SELECT * FROM pgml.train(
  project_name => 'RO Solar Panel Production Forecast', 
  task => 'regression', 
  relation_name => 'combined_data', 
  y_column_name => 'power',
  test_size => 10,
  test_sampling => 'last'
);

select * from vw_solar_plant_generation vspg 

select * from combined_data cd 
where "timestamp" is null or
irradiance is null or power is null

select * from pgml.models

ALTER TABLE public.combined_data
RENAME COLUMN "timestamp" TO measurement_time;

ALTER TABLE public.combined_data
ALTER COLUMN "timestamp" TYPE timestamp USING "timestamp"::timestamp;

select * from combined_data cd 

CREATE TABLE public.solar_plant_generation_ro (
    year int,
    month int,
    day int,
    hour int,
    minute int,
    irradiance float4,
    power float4
);

INSERT INTO public.solar_plant_generation_ro (year, month, day, hour, minute, irradiance, power)
SELECT 
    EXTRACT(YEAR FROM measurement_time::timestamp) AS year,
    EXTRACT(MONTH FROM measurement_time::timestamp) AS month,
    EXTRACT(DAY FROM measurement_time::timestamp) AS day,
    EXTRACT(HOUR FROM measurement_time::timestamp) AS hour,
    EXTRACT(MINUTE FROM measurement_time::timestamp) AS minute,
    irradiance,
    power
FROM public.combined_data;

select distinct year, month, day from solar_plant_generation_ro
order by year, month, day

SELECT * FROM pgml.train(
  project_name => 'Ro Solar Production1', 
  task => 'regression', 
  relation_name => 'solar_plant_generation_ro', 
  y_column_name => 'power',
  test_size => 5,
  test_sampling => 'last',
  algorithm => 'xgboost'
);

with est as
(select 
	spg.year,
	spg.month,
	spg.day,
	spg.hour,
	spg.minute,
	spg.irradiance,
	spg.power as real_power,
	pgml.predict (
	'Ro Solar Production',
	(
		spg.year,
		spg.month,
		spg.day,
		spg.hour,
		spg.minute,
		spg.irradiance
	)
	) as estimated_power
from solar_plant_generation_ro spg
where spg.day in (30, 31))
	select e.*, abs((e.real_power -e.estimated_power) / e.real_power) as error
	from est e


WITH est AS (
    SELECT 
        spg.year,
        spg.month,
        spg.day,
        spg.hour,
        spg.minute,
        spg.irradiance,
        spg.power AS real_power,
        pgml.predict(
            'Ro Solar Production1',
            (
                spg.year,
                spg.month,
                spg.day,
                spg.hour,
                spg.minute,
                spg.irradiance
            )
        ) AS estimated_power
    FROM solar_plant_generation_ro spg
    WHERE spg.day IN (30, 31)
)
SELECT 
    AVG(ABS((real_power - estimated_power) / (real_power + 1e-6))) * 100 AS modified_mean_absolute_percentage_error
FROM est;

select pgml.predict (
	'Solar Panel Production Forecast',
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

CREATE OR REPLACE VIEW public.vw_solar_plant_generation_ro
AS SELECT  year,
    month,
    day,
    hour,
    minute,
    irradiance,
    power
from solar_plant_generation_ro spg where spg.day not in (30, 31)


select distinct day from vw_solar_plant_generation_ro order by day

select * from pgml.models m 