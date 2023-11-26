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


SELECT * FROM pgml.train(
  project_name => 'Year Forecast', 
  task => 'regression', 
  relation_name => 'vw_year_solar_plant_generation', 
  y_column_name => 'power',
  test_size => 5,
  algorithm => 'xgboost',
  test_sampling => 'random'
);

select pg.*,
pgml.predict (
	'Year Forecast',
	(
		pg.year,
		pg.month,
		pg.day,
		pg.hour,
		pg.minute,
		pg.irradiance
	)
) as predicted_power
from vw_year_solar_plant_generation pg
where year = 2022 and month = 11 and day = 26

select year, month, count(1) from VW_YEAR_SOLAR_PLANT_GENERATION
where hour = 1 and irradiance  > 0
group by year, month
having count(1) > 0

where year = 2022 and month = 11 and day = 26

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
select * from combined_data cd 


select * from VW_YEAR_SOLAR_PLANT_GENERATION
where year = 2022
order by year asc, month, day, hour, minute
select * from combined_data cd where c


select * from combined_data cd  
SELECT *
FROM public.combined_data
WHERE EXTRACT(YEAR FROM measurement_time) = 2022;

UPDATE public.combined_data
SET
    measurement_time = "Timestamp"::timestamp,
    irradiance = "Irradiance(W/m2)"::float4,
    power = "Power(KW)"::float4;

select * from combined_data cd where "Irradiance(W/m2)" is null





CREATE VIEW VW_YEAR_SOLAR_PLANT_GENERATION
AS
SELECT
    CAST(EXTRACT(YEAR FROM SPG.measurement_time) AS INTEGER) AS YEAR,
    CAST(EXTRACT(MONTH FROM SPG.measurement_time) AS INTEGER) AS MONTH,
    CAST(EXTRACT(DAY FROM SPG.measurement_time) AS INTEGER) AS DAY,
    CAST(EXTRACT(HOUR FROM SPG.measurement_time) AS INTEGER) AS HOUR,
    CAST(EXTRACT(MINUTE FROM SPG.measurement_time) AS INTEGER) AS MINUTE,
    irradiance,
    power
FROM
    combined_data SPG
    

    
select count(1) from 
select * from vw_year_solar_plant_generation order by year , month , day , year, hour, minute 

select * from pgml.models m 