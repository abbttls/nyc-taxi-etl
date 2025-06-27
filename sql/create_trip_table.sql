IF OBJECT_ID('dbo.yellow_tripdata', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.yellow_tripdata (
        trip_id INT IDENTITY(1,1) PRIMARY KEY,
        VendorID INT,
        tpep_pickup_datetime DATETIME2,
        tpep_dropoff_datetime DATETIME2,
        passenger_count FLOAT,
        trip_distance FLOAT,
        RatecodeID FLOAT,
        store_and_fwd_flag VARCHAR(1),
        PULocationID INT,
        DOLocationID INT,
        payment_type INT,
        fare_amount FLOAT,
        extra FLOAT,
        mta_tax FLOAT,
        tip_amount FLOAT,
        tolls_amount FLOAT,
        improvement_surcharge FLOAT,
        total_amount FLOAT,
        congestion_surcharge FLOAT,
        Airport_fee FLOAT
    );
END