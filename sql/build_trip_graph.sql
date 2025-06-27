-- Build a permanent TripGraph table with average distance and time between locations

-- Create the table if it doesn't exist
IF OBJECT_ID('dbo.TripGraph', 'U') IS NOT NULL
    DROP TABLE dbo.TripGraph;
GO
CREATE TABLE dbo.TripGraph (
    start_node INT,
    end_node INT,
    trip_count INT,
    avg_dist FLOAT,
    avg_time FLOAT
);

-- Insert all possible pairs of locations
INSERT INTO dbo.TripGraph (start_node, end_node, trip_count, avg_dist, avg_time)
SELECT 
    tz1.LocationID AS start_node, 
    tz2.LocationID AS end_node,
    NULL,
    NULL,
    NULL
FROM dbo.taxi_zone_lookup tz1
CROSS JOIN dbo.taxi_zone_lookup tz2;

-- Update trip_count for each pair
UPDATE tg
SET tg.trip_count = ISNULL(yt.cnt, 0)
FROM dbo.TripGraph tg
OUTER APPLY (
    SELECT COUNT(*) AS cnt
    FROM dbo.yellow_tripdata yt
    WHERE yt.PULocationID = tg.start_node
      AND yt.DOLocationID = tg.end_node
) yt;

-- Update avg_dist for each pair (if there are trips)
UPDATE tg
SET tg.avg_dist = yt.avg_dist
FROM dbo.TripGraph tg
OUTER APPLY (
    SELECT AVG(CAST(trip_distance AS FLOAT)) AS avg_dist
    FROM dbo.yellow_tripdata yt
    WHERE yt.PULocationID = tg.start_node
      AND yt.DOLocationID = tg.end_node
) yt;

-- Update avg_time for each pair (if there are trips)
UPDATE tg
SET tg.avg_time = yt.avg_time
FROM dbo.TripGraph tg
OUTER APPLY (
    SELECT AVG(CAST(DATEDIFF(MINUTE, tpep_pickup_datetime, tpep_dropoff_datetime) AS FLOAT)) AS avg_time
    FROM dbo.yellow_tripdata yt
    WHERE yt.PULocationID = tg.start_node
      AND yt.DOLocationID = tg.end_node
) yt;

DELETE
FROM TripGraph
WHERE trip_count = 0;

-- View the results
SELECT * FROM dbo.TripGraph




