import os
import pandas as pd
import sqlalchemy

from dotenv import load_dotenv
load_dotenv()

# Load environment variables for Azure SQL connection
db_server = os.getenv('SERVER')
db_database = os.getenv('DATABASE')
db_username = os.getenv('UID')
db_password = os.getenv('PWD')

print("Server info: ", db_server, db_database, db_username)

# 1. Load the Parquet data into a DataFrame
parquet_path = 'data/yellow_tripdata_2024-01.parquet'
df = pd.read_parquet(parquet_path)

# 2. Inspect the data
# print(df.head())
# print(df.info())
# print(df.describe())

# 3. Clean the data
df = df.dropna(subset=[
    'tpep_pickup_datetime',
    'tpep_dropoff_datetime',
    'PULocationID',
    'DOLocationID',
    'fare_amount',
    'total_amount'
])

# 4. Connect to Azure SQL Database using SQLAlchemy and pymssql
connection_url = sqlalchemy.engine.url.URL.create(
    drivername='mssql+pymssql',
    username=db_username,
    password=db_password,
    host=db_server,
    database=db_database
)
engine = sqlalchemy.create_engine(connection_url)

# 5. Create table if not exists (optional, can use raw SQL or let pandas handle it)
# with open('sql/create_trip_table.sql', 'r') as f:
#     create_table_sql = f.read()
# with engine.connect() as conn:
#     conn.execute(sqlalchemy.text(create_table_sql))

# 6. Load only the first 200,000 rows into the table using pandas to_sql in chunks (bulk insert)
max_rows = 200_000
sample_df = df.iloc[:max_rows]
chunk_size = 20000  # You can adjust this value based on your memory/network
for i, chunk in enumerate(range(0, len(sample_df), chunk_size)):
    print(f"Uploading rows {chunk} to {min(chunk + chunk_size, len(sample_df))}...")
    sample_df.iloc[chunk:chunk + chunk_size].to_sql('yellow_tripdata', engine, if_exists='append', index=False)
    print(f"Chunk {i+1} uploaded.")

# # 7. Close the connection (SQLAlchemy handles this automatically)
# engine.dispose()

# # ---
# # Fill in the blanks above as an exercise. Try running each section step by step and inspect the results
