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
  project_name => 'Year Forecast V1', 
  task => 'regression', 
  relation_name => 'vw_year_solar_plant_generation', 
  y_column_name => 'power',
  test_size => 5,
  algorithm => 'xgboost',
  test_sampling => 'random'
);

with all_data as (
SELECT EXTRACT(year FROM spg.measurement_time)::integer AS year,
    EXTRACT(month FROM spg.measurement_time)::integer AS month,
    EXTRACT(day FROM spg.measurement_time)::integer AS day,
    EXTRACT(hour FROM spg.measurement_time)::integer AS hour,
    EXTRACT(minute FROM spg.measurement_time)::integer AS minute,
    spg.irradiance,
    spg.est_irradiance,
    spg.power
   FROM combined_data spg
) select * from all_data; 

with all_data as (
SELECT 
	spg.measurement_time,
	EXTRACT(year FROM spg.measurement_time)::integer AS year,
    EXTRACT(month FROM spg.measurement_time)::integer AS month,
    EXTRACT(day FROM spg.measurement_time)::integer AS day,
    EXTRACT(hour FROM spg.measurement_time)::integer AS hour,
    EXTRACT(minute FROM spg.measurement_time)::integer AS minute,
    spg.irradiance,
    spg.est_irradiance,
    spg.power
   FROM combined_data spg
)

select pg.*,
pgml.predict (
	'Year Forecast V1',
	(
		pg.year,
		pg.month,
		pg.day,
		pg.hour,
		pg.minute,
		pg.irradiance
	)
) as predicted_power_real_irradiance,
pgml.predict (
	'Year Forecast V1',
	(
		pg.year,
		pg.month,
		pg.day,
		pg.hour,
		pg.minute,
		pg.est_irradiance
	)
) as predicted_power_est_irradiance
from all_data pg where pg.irradiance is not null and pg.est_irradiance is not null



select pg.*,
pgml.predict (
	'Year Forecast V1',
	(
		pg.year,
		pg.month,
		pg.day,
		pg.hour,
		pg.minute,
		pg.irradiance
	)
) as predicted_power_real_irradiance,
pgml.predict (
	'Year Forecast V1',
	(
		pg.year,
		pg.month,
		pg.day,
		pg.hour,
		pg.minute,
		pg.est_irradiance
	)
) as predicted_power_real_irradiance,
from combined_data cd
where year = 2023 and month = 11 and day = 26


select * from vw_year_solar_plant_generation

select * from combined_data cd
where cd."year" = 2023 and cd."month" = 11 and cd."day" = 26

select year, month, count(1) from VW_YEAR_SOLAR_PLANT_GENERATION
where hour = 1 and irradiance  > 100
group by year, month
having count(1) > 0

select * from combined_data cd 

select max(irradiance), avg(irradiance) from VW_YEAR_SOLAR_PLANT_GENERATION vspg 
where vspg."month" = 12
and irradiance > 5

and hour between 1 and 5 and irradiance > 100

delete  from combined_data 

where measurement_time between '2022-11-29' and '2022-12-01'

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


select count(1) from combined_data cd 


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
    

select * from combined_data_011223 cd 
    
select count(1) from 
select * from vw_year_solar_plant_generation order by year , month , day , year, hour, minute 


ALTER TABLE public.combined_data
ADD COLUMN est_irradiance float4 NULL;



UPDATE combined_data
SET est_irradiance = (
  SELECT forecast_irradiance
  FROM irradiance_forecast
  WHERE combined_data.measurement_time >= forecast_time::timestamp
  AND combined_data.measurement_time < (forecast_time::timestamp + interval '1 hour')
  AND combined_data."Timestamp"::date = forecast_time::date
  AND extract(hour from combined_data."Timestamp"::timestamp) = forecast_hour
)


select * from irradiance_forecast if2 
 
UPDATE public.irradiance_forecast
SET forecast_timestamp = to_timestamp(
  left(forecast_time, position(' -' in forecast_time) - 1),
  'DD/MM/YYYY HH24:MI'
);

UPDATE combined_data cd
SET est_irradiance = (
    SELECT if.forecast_irradiance
    FROM irradiance_forecast if
    WHERE cd.measurement_time >= if.forecast_timestamp
    AND cd.measurement_time < if.forecast_timestamp + interval '1 hour'
)



select * from combined_data cd where cd.est_irradiance is not  null 

-- public.vw_year_solar_plant_generation source

CREATE OR REPLACE VIEW public.vw_year_solar_plant_generation
AS SELECT EXTRACT(year FROM spg.measurement_time)::integer AS year,
    EXTRACT(month FROM spg.measurement_time)::integer AS month,
    EXTRACT(day FROM spg.measurement_time)::integer AS day,
    EXTRACT(hour FROM spg.measurement_time)::integer AS hour,
    EXTRACT(minute FROM spg.measurement_time)::integer AS minute,
    spg.irradiance,
    spg.power
   FROM combined_data spg;

  
SELECT EXTRACT(year FROM spg.measurement_time)::integer AS year,
    EXTRACT(month FROM spg.measurement_time)::integer AS month,
    EXTRACT(day FROM spg.measurement_time)::integer AS day,
    EXTRACT(hour FROM spg.measurement_time)::integer AS hour,
    EXTRACT(minute FROM spg.measurement_time)::integer AS minute,
    spg.irradiance,
    spg.est_irradiance,
    spg.power
   FROM combined_data spg;