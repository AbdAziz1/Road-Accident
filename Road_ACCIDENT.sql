SELECT * FROM road_accident

--CURRENT YEAR TOTAL CASUALTIES BY ROAD CONDITION FILTER
SELECT SUM(number_of_casualties) AS CY_casualties
FROM road_accident
WHERE YEAR(accident_date) = '2022' and road_surface_conditions = 'Dry'

--CURRENT YEAR TOTAL ACCIDNETS 
SELECT COUNT(DISTINCT accident_index) AS CY_Accidents
FROM road_accident
WHERE YEAR(accident_date) = '2022'

--CURRENT YEAR TOTAL FATAL CASUALTIES AND PERCENETAGES
SELECT SUM(number_of_casualties) AS CY_Fatal_Casualties
FROM road_accident
WHERE YEAR(accident_date) = '2022' and accident_severity = 'Fatal'

SELECT CAST(SUM(number_of_casualties) AS decimal(10,2)) *100 / 
(SELECT CAST(SUM(number_of_casualties) AS decimal(10,2)) FROM road_accident)
FROM road_accident
WHERE YEAR(accident_date) = '2022' and accident_severity = 'Fatal'

--CURRENT YEAR TOTAL SERIOUS CASUALTIES AND PERCENTAGES
SELECT SUM(number_of_casualties) AS CY_Fatal_Casualties
FROM road_accident
WHERE YEAR(accident_date) = '2022' and accident_severity = 'Serious'

SELECT CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) *100 / 
(SELECT CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) FROM road_accident)
FROM road_accident
WHERE YEAR(accident_date) = '2022' and accident_severity = 'Serious'

--CURRENT YEAR TOTAL SLIGHT CASUALTIES 
SELECT SUM(number_of_casualties) AS CY_Fatal_Casualties
FROM road_accident
WHERE YEAR(accident_date) = '2022' and accident_severity = 'Slight'

SELECT CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) *100 / 
(SELECT CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) FROM road_accident)
FROM road_accident
WHERE YEAR(accident_date) = '2022' and accident_severity = 'Slight'

--CASUALTIES BY VEHICLE TYPES
SELECT
	CASE 
		WHEN vehicle_type IN ('Agriculture vehicle') THEN 'Agriculture' 
		WHEN vehicle_type IN ('Car','Taxi/Private hire car') THEN 'Cars'
		WHEN vehicle_type IN ('Motorcycle 125cc and under','Motorcyc le 50cc and under','Motorcycle over 125cc up to 500cc','Motorcycle over 500cc','Pedal cycle') THEN 'Bike'
		WHEN vehicle_type IN ('Bus or coach (17 or more pass seats)','Minibus(8 - 16 passengers seats)') THEN 'Bus'
		WHEN vehicle_type IN ('Goods 7.5 tonnes mgw and over','Goods over 3.5t. and under 7.5t','Van / Goods 3.5 tonnes mgw or under') THEN 'Van'
		ELSE 'Other'
	END AS vehicle_group,
	SUM(number_of_casualties) as CY_Casualties
	FROM road_accident
	--WHERE YEAR(accident_date) = '2022'
	GROUP BY
		CASE	
			WHEN vehicle_type IN ('Agriculture vehicle') THEN 'Agriculture' 
			WHEN vehicle_type IN ('Car','Taxi/Private hire car') THEN 'Cars'
			WHEN vehicle_type IN ('Motorcycle 125cc and under','Motorcyc le 50cc and under','Motorcycle over 125cc up to 500cc','Motorcycle over 500cc','Pedal cycle') THEN 'Bike'
			WHEN vehicle_type IN ('Bus or coach (17 or more pass seats)','Minibus(8 - 16 passengers seats)') THEN 'Bus'
			WHEN vehicle_type IN ('Goods 7.5 tonnes mgw and over','Goods over 3.5t. and under 7.5t','Van / Goods 3.5 tonnes mgw or under') THEN 'Van'
			ELSE 'Other'
		END

--CURRENT YEAR CASUALTIES BY MONTHS
SELECT DATENAME(MONTH, accident_date) AS Month_Name, SUM(number_of_casualties)
FROM road_accident
WHERE YEAR(accident_date) = '2022'
GROUP BY DATENAME(MONTH, accident_date) 

--CURRENT YEAR CASUALTIES BY ROAD TYPE
SELECT road_type, SUM(number_of_casualties) FROM road_accident
WHERE YEAR(accident_date) = '2022'
GROUP BY road_type 

--CURRENT YEAR CASUALTIES BY rural or urban areas percentages
SELECT urban_or_rural_area, SUM(number_of_casualties) *100 / (SELECT SUM(number_of_casualties) FROM road_accident WHERE YEAR(accident_date) = '2022') 
FROM road_accident
WHERE YEAR(accident_date) = '2022'
GROUP BY urban_or_rural_area 

--CURRENT YEAR CASUALTIES BY NIGHT AND DAY AND percentages
SELECT
	CASE
		WHEN light_conditions IN ('Daylight') THEN 'Day'
		WHEN light_conditions IN ('Darkness - lighting unknown', 'Darkness - lights lit', 'Darkness - lights unlit','Darkness - no lighting') THEN 'Night'
	END AS Light_Conditions,
	CAST(CAST(SUM(number_of_casualties) AS Decimal(10,2))*100/
	(SELECT CAST(SUM(number_of_casualties) AS Decimal(10,2)) FROM road_accident WHERE YEAR(accident_date) = '2022') AS Decimal(10,2))
	AS CY_Casualties_PCT
FROM road_accident
WHERE YEAR(accident_date) = '2022'
GROUP BY
CASE 
	WHEN light_conditions IN ('Daylight') THEN 'Day'
		WHEN light_conditions IN ('Darkness - lighting unknown', 'Darkness - lights lit', 'Darkness - lights unlit','Darkness - no lighting') THEN 'Night'
	END 

--TOP 10 Casualties PLACES
SELECT TOP 10 local_authority, SUM(number_of_casualties) AS Total_Casualties
FROM road_accident
GROUP BY local_authority
ORDER BY Total_Casualties DESC
