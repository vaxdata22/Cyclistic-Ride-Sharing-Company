---------------------------------------------
-- PREPARATION OF THE DATA:
---------------------------------------------

/*
First, a database named "cyclistic" was created in SQL Server.
Then each of the 12 tables (prepared CSV files) were imported as "Flat Files" into the database.
When importing each file, set to allow null values, and use the following datatypes:
ride_id - varchar(50)
rideable_type - varchar(50)
started_at - datetime2(7)
ended_at - datetime2(7)
start_station_name - varchar(MAX)
start_station_id - varchar(50)
end_station_name - varchar(MAX)
end_station_id - varchar(50)
start_lat - float
start_lng - float
end_lat - float
end_lng - float
member_casual - varchar(50)
ride_length - float
day_of_week - varchar(50)
ride_hour - tinyint
month_of_year - varchar(7)
*/

-- Union of all the 12 tables into a single data table
SELECT 
	ride_id,
	rideable_type,
	started_at,
	ended_at,
	start_station_name,
	start_station_id,
	end_station_name,
	end_station_id,
	start_lat,
	start_lng,
	end_lat,
	end_lng,
	member_casual,
	ride_length,
	day_of_week,
	ride_hour,
	month_of_year
INTO trips FROM 
	(
	SELECT * FROM trip01
	UNION 
	SELECT * FROM trip02
	UNION 
	SELECT * FROM trip03
	UNION 
	SELECT * FROM trip04
	UNION 
	SELECT * FROM trip05
	UNION 
	SELECT * FROM trip06
	UNION 
	SELECT * FROM trip07
	UNION 
	SELECT * FROM trip08
	UNION 
	SELECT * FROM trip09
	UNION 
	SELECT * FROM trip10
	UNION 
	SELECT * FROM trip11
	UNION 
	SELECT * FROM trip12
	) U;

-- Preview the table
SELECT TOP 10 * FROM trips;

-- To get the total number of trip records and check for distinct Ride IDs (returned 5470672 trip records)
SELECT COUNT(ride_id) AS total_trips 
FROM trips; 

SELECT COUNT(DISTINCT ride_id) AS distinct_trips
FROM trips; -- returned 5468815 trip records

---------------------------------------------
-- CHECKING THE QUALITY OF THE DATA:
---------------------------------------------

-- See if anything other than "member" or "casual" is present in "member_casual" field 
SELECT DISTINCT member_casual from trips; -- returned only "member" and "casual" 

-- Check the ranges of latitudes and longitudes
SELECT MIN(end_lng) AS min_end_lng,
	MAX(end_lng) AS max_end_lng,
       MIN(end_lat) AS min_end_lat,
	MAX(end_lat) AS max_end_lat, 
       MIN(start_lng) AS min_start_lng,
	MAX(start_lng) AS max_start_lng,
       MIN(start_lat) AS min_start_lat,
	MAX(start_lat) AS max_start_lat
FROM trips; -- returned min_end_lng (-88.970), max_end_lng (-87.300), min_end_lat (41.389), max_end_lat (42.369), 
		-- min_start_lng (-87.839), max_start_lng (-73.796), min_start_lat (41.639), max_start_lat (45.635)

-- Check for Ride IDs that are duplicated (returned 769 Ride IDs that are duplicated)
SELECT ride_id, COUNT(*) AS number_of_trips
FROM trips
GROUP BY ride_id
HAVING COUNT(*) > 1; 

-- Checking for nulls in rows (returned no nulls)
SELECT *
FROM trips
WHERE started_at IS NULL OR ended_at IS NULL; 

-- Counting rides ending at each docking station (revealed 860968 nulls)
SELECT end_station_id, end_station_name, COUNT(*) AS number_of_trips
FROM trips
GROUP BY end_station_id, end_station_name
ORDER BY COUNT(*) DESC; 

-- Counting rides starting at each docking station (revealed 825142 nulls)
SELECT start_station_name, COUNT(*) AS number_of_trips
FROM trips
GROUP BY start_station_name
ORDER BY COUNT(*) DESC; 

-- Checking for rows where column value is null (returned 825142 trip records)
SELECT COUNT(*) AS number_of_trips
FROM trips
WHERE start_station_id IS NULL OR start_station_name IS NULL; 

SELECT COUNT(*) AS number_of_trips 
FROM trips 
WHERE end_station_id IS NULL OR end_station_name IS NULL; -- returned 860968 trip records

SELECT COUNT(*) AS number_of_trips
FROM trips
WHERE start_lat IS NULL OR end_lat IS NULL; -- returned 11429 trip records

SELECT COUNT(*) AS number_of_trips 
FROM trips
WHERE start_lng IS NULL OR end_lng IS NULL; -- returned 5371 trip records

SELECT COUNT(*) AS number_of_trips 
FROM trips
WHERE member_casual IS NULL; -- returned 0 trip records

SELECT COUNT(*) AS number_of_trips 
FROM trips
WHERE rideable_type IS NULL; -- returned 0 trip records

---------------------------------------------
-- CLEANING THE DATA:
---------------------------------------------

-- Delete all rows where any field is null
-- The query below deletes 1240275 rows
DELETE
FROM trips
WHERE ride_id IS NULL
OR rideable_type IS NULL
OR started_at IS NULL
OR ended_at IS NULL
OR start_station_name IS NULL
OR start_station_id IS NULL
OR end_station_name IS NULL
OR end_station_id IS NULL
OR start_lat IS NULL
OR start_lng IS NULL
OR end_lat IS NULL
OR end_lng IS NULL
OR member_casual IS NULL;

-- To remove records that have trip duration of less than 3 minutes (deleted 278031 rows)
DELETE FROM trips
WHERE ride_length < 3; 

-- Identify and exclude data with anomalies
-- 72 rows deleted.
DELETE
FROM trips
WHERE started_at >= ended_at;

-- Checking if Ride IDs are still duplicated (returned 592 Ride IDs that had duplicates)
SELECT ride_id, COUNT(*) AS number_of_trips
FROM trips
GROUP BY ride_id
HAVING COUNT(*) > 1; 

-- Check again for any nulls (returned 0 nulls)
SELECT COUNT(*) AS number_of_trips
FROM trips
WHERE start_station_id IS NULL OR start_station_name IS NULL
OR end_station_id IS NULL OR end_station_name IS NULL
OR start_lat IS NULL OR end_lat IS NULL
OR start_lng IS NULL OR end_lng IS NULL
OR member_casual IS NULL
OR rideable_type IS NULL; 

---------------------------------------------
-- EXPLORATION OF THE DATA:
---------------------------------------------

-- To get the total number of trip records and check for distinct Ride IDs after data clean up (returned 3952294 trip records)
SELECT COUNT(ride_id) AS total_trips 
FROM trips; 

SELECT COUNT(DISTINCT ride_id) AS distinct_trips
FROM trips; -- returned 3951147 trip records

-- Find the number of rides by casual-members and rides by annual-members (returned 2314237 members and 1638057 casuals)
SELECT member_casual, COUNT(*) AS number_of_trips
FROM trips
GROUP BY member_casual; 

-- Counting number of rideable types (returned 1368358 electric, 2409512 classic, and 174424 docked bikes)
SELECT rideable_type, COUNT(*) AS number_of_trips
FROM trips
GROUP BY rideable_type; 

-- To count the number of round trips (returned 183686 round trip records)
SELECT COUNT(*) AS number_of_trips_round
FROM trips
WHERE start_station_id = end_station_id; 

-- To survey the round trips data
SELECT start_station_id, end_station_id, rideable_type, member_casual
FROM trips
WHERE start_station_id = end_station_id;

-- To count the distinct round trips (returned 183680 round trip records)
SELECT COUNT(DISTINCT ride_id) AS number_of_trips_round
FROM trips
WHERE start_station_id = end_station_id;

---------------------------------------------
-- TABLES FOR VISUALIZATION:
---------------------------------------------

The output of each of the following queries were saved as separate CSV files to be imported into Tableau for visualization and analysis:

-- Total trip duration by member (csv filename: total_ride_length_by_member_casual)
SELECT member_casual, ROUND(SUM(ride_length), 0) AS total_trip_duration
FROM trips
GROUP BY member_casual
ORDER BY total_trip_duration DESC; -- returned casual=41347843 mins, member=31167301 mins

-- Average trip duration by member (csv filename: average_ride_length_by_member_casual)
SELECT member_casual, ROUND(AVG(ride_length), 0) AS average_trip_duration
FROM trips
GROUP BY member_casual
ORDER BY average_trip_duration DESC; -- returned casual=25, member=13

-- Number of rides per ride hour by member (csv filename: rides_per_hour_by_member_casual)
SELECT ride_hour, member_casual, COUNT(*) AS number_of_rides
FROM trips
GROUP BY ride_hour, member_casual
ORDER BY ride_hour, member_casual;

-- Total number of rides per weekday by member (csv filename: rides_per_weekday_by_member_casual)
SELECT day_of_week, member_casual, COUNT(*) AS number_of_rides,
	CASE day_of_week
		WHEN 'Sunday' THEN 0
		WHEN 'Monday' THEN 1
		WHEN 'Tuesday' THEN 2
		WHEN 'Wednesday' THEN 3
		WHEN 'Thursday' THEN 4
		WHEN 'Friday' THEN 5
		WHEN 'Saturday' THEN 6
	END AS dd
FROM trips
GROUP BY day_of_week, member_casual
ORDER BY dd, member_casual;

-- Average duration of rides per weekday by member (csv filename: average_ride_length_per_weekday_by_member_casual)
SELECT day_of_week, member_casual, ROUND(AVG(ride_length), 2) AS average_trip_duration,
	CASE day_of_week
		WHEN 'Sunday' THEN 0
		WHEN 'Monday' THEN 1
		WHEN 'Tuesday' THEN 2
		WHEN 'Wednesday' THEN 3
		WHEN 'Thursday' THEN 4
		WHEN 'Friday' THEN 5
		WHEN 'Saturday' THEN 6
	END AS dd
FROM trips
GROUP BY day_of_week, member_casual
ORDER BY dd, member_casual;

-- Number of rides for casual and members (csv filename: rides_by_member_casual)
SELECT member_casual, COUNT(*) AS number_of_rides
    FROM trips
    GROUP BY member_casual
    ORDER BY number_of_rides; -- returns Member=2314237, Casual=1638057

-- Count of rides for each bike type (csv filename: rides_by_rideable_type)
SELECT rideable_type, COUNT(*) AS number_of_rides
    FROM trips
    GROUP BY rideable_type
    ORDER BY number_of_rides; -- returns electric=1368358, classic=2409512, docked=174424

-- Distribution of members and casuals for each bike type (csv filename: rides_by_rideable_type_by_member_casual)
SELECT rideable_type, member_casual, COUNT(*) AS number_of_rides
    FROM trips
    GROUP BY rideable_type, member_casual
    ORDER BY rideable_type ASC, number_of_rides DESC; -- revealed that only casual members use docked bikes

-- Distribution of casual and member rides across the period monthly (csv filename: rides_by_member_casual_by_month)
SELECT month_of_year, member_casual, COUNT(*) AS number_of_rides
    FROM trips
    GROUP BY month_of_year, member_casual
    ORDER BY month_of_year;

-- Distribution of casual rides across the year (csv filename: rides_by_casual_by_month)
SELECT month_of_year, COUNT(*) AS number_of_rides_by_casual
    FROM trips
    WHERE member_casual = 'casual'
    GROUP BY month_of_year
    ORDER BY month_of_year;

-- Distribution of casual rides across the year (csv filename: rides_by_member_by_month)
SELECT month_of_year, COUNT(*) AS number_of_rides_by_member
    FROM trips
    WHERE member_casual = 'member'
    GROUP BY month_of_year
    ORDER BY month_of_year;
