-- Copilot-provided exercises for basic select queries


-- Show the first ten rows
SELECT TOP 10 *
FROM dbo.yellow_tripdata


-- list all unique payment types
SELECT DISTINCT payment_type
from dbo.yellow_tripdata


-- Average cost per ride per payment type (exercise by me)
SELECT payment_type, AVG(total_amount) AS avg_cost
FROM dbo.yellow_tripdata
GROUP BY payment_type


-- Select rows where location ID is 264 or 265 (used for cleaning, written by copilot)
SELECT *
FROM dbo.yellow_tripdata
WHERE PULocationID IN (264, 265) OR DOLocationID IN (264, 265)


-- Count the number of rides per passenger count
SELECT passenger_count, COUNT(*) AS num_rides
FROM dbo.yellow_tripdata
GROUP BY passenger_count
ORDER BY passenger_count;


-- More advanced queries

-- Write a query to find the top 3 most common pickup/dropoff zone pairs (by name), their total number of trips, and the average fare for each pair. (Hint: You'll need to join the trip data to the zone lookup table twice.)
SELECT TOP 3 tz1.ZONE, tz2.ZONE, COUNT(*) as num_rides, AVG(fare_amount) as avg_fare
FROM dbo.yellow_tripdata td
LEFT JOIN dbo.taxi_zone_lookup tz1 ON td.PULocationID = tz1.LocationID
LEFT JOIN dbo.taxi_zone_lookup tz2 ON td.DOLocationID = tz2.LocationID
GROUP BY tz1.ZONE, tz2.ZONE
ORDER BY num_rides DESC


-- This query retrieves the top 5 hours of the day with the highest number of taxi rides.
SELECT TOP 5 DATEPART(hour, tpep_pickup_datetime) AS pickup_hour, COUNT(*) as num_rides
FROM dbo.yellow_tripdata
GROUP BY DATEPART(hour, tpep_pickup_datetime)
ORDER BY num_rides DESC;





