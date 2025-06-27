drop table if exists dbo.taxi_zone_lookup;

-- Create a lookup table for NYC Taxi Zones
CREATE TABLE dbo.taxi_zone_lookup (
    LocationID INT PRIMARY KEY,
    Borough VARCHAR(32),
    [Zone] VARCHAR(64),
    service_zone VARCHAR(32)
);