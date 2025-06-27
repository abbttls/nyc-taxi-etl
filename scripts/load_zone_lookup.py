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

connection_url = sqlalchemy.engine.url.URL.create(
    drivername='mssql+pymssql',
    username=db_username,
    password=db_password,
    host=db_server,
    database=db_database
)
engine = sqlalchemy.create_engine(connection_url)

# Load the data into a DataFrame (update the file path as needed)
df = pd.read_csv('data/taxi_zone_lookup.csv')

# Remove any leading/trailing whitespace from column names
# and ensure they match the SQL table definition
columns_expected = ['LocationID', 'Borough', 'Zone', 'service_zone']
df.columns = [col.strip().replace('"', '') for col in df.columns]
df = df[columns_expected]

# 5. Create table if not exists (optional, can use raw SQL or let pandas handle it)
# with open('sql/create_taxi_zone_lookup.sql', 'r') as f:
#     create_table_sql = f.read()
# with engine.connect() as conn:
#     conn.execute(sqlalchemy.text(create_table_sql))

df.to_sql('taxi_zone_lookup', engine, if_exists='append', index=False)
print("Taxi zone lookup data loaded successfully.")