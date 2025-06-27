# NYC Taxi ETL & Analytics Platform

This project is a beginner-friendly, end-to-end ETL (Extract, Transform, Load) and analytics pipeline for New York City Yellow Taxi trip data. It is designed to help you learn data engineering concepts using real-world data and Azure SQL.

## Features
- Automated download and conversion of NYC Yellow Taxi data (Parquet to CSV)
- Data cleaning, validation, and enrichment using Python (pandas)
- Bulk loading of cleaned data into Azure SQL Database
- Normalized database schema and lookup tables for efficient querying
- Example SQL queries for data exploration and analysis
- Modular, well-documented scripts and reproducible workflow

## Project Structure
```
├── data/                  # Raw and processed data files
│   ├── yellow_tripdata_2024-01.parquet
│   ├── yellow_tripdata_2024-01.csv
│   └── taxi_zone_lookup.csv
├── scripts/               # Python ETL and loading scripts
│   ├── download_data.py
│   ├── clean_and_load.py
│   └── load_zone_lookup.py
├── sql/                   # SQL schema and query files
│   ├── create_trip_table.sql
│   ├── create_payment_type_lookup.sql
│   ├── create_taxi_zone_lookup.sql
│   └── select_exercises.sql
├── copilot_usage_log.text # Log of Copilot suggestions and project progress
├── project_description.text
└── README.md              # Project overview and instructions
```

## Getting Started
1. **Clone the repository and set up your environment**
   - Install Python (Anaconda/Miniconda recommended)
   - Install required packages: `pandas`, `sqlalchemy`, `pymssql`, `python-dotenv`
   - Set up your `.env` file with Azure SQL credentials

2. **Download and prepare the data**
   - Use `scripts/download_data.py` to fetch the Parquet file
   - (Optional) Convert to CSV if needed

3. **Clean and load the data**
   - Run `scripts/clean_and_load.py` to clean and bulk load trip data into Azure SQL
   - Run `scripts/load_zone_lookup.py` to load the taxi zone lookup table

4. **Set up the database schema**
   - Use the SQL scripts in `sql/` to create tables and lookup tables as needed

5. **Explore and analyze**
   - Use the example queries in `sql/select_exercises.sql` to explore the data and practice SQL

## Learning Goals
- Understand the ETL process with real data
- Practice data cleaning, transformation, and enrichment
- Learn how to design and load normalized database schemas
- Write and optimize SQL queries for analytics
- Track your progress and learning with the Copilot usage log

## Tips
- Start with a small sample of data (e.g., 100,000–200,000 rows) for faster iteration
- Use the Copilot usage log and project description to track your learning and project evolution
- Try the SQL exercises and add your own as you learn

## Credits
- NYC Taxi & Limousine Commission (TLC) for the open data
- Microsoft Azure for cloud database hosting
- GitHub Copilot for code suggestions and learning support

## Shortest Path: FindOptimalTrip Stored Procedure

This project includes a T-SQL stored procedure, `FindOptimalTrip`, which implements a Dijkstra-like algorithm to find the optimal (shortest time) path between two NYC taxi zones using the `TripGraph` table. This enables advanced analytics such as route optimization and network analysis directly in SQL.

### How it Works
- The procedure explores the graph of taxi zones, using average trip times and distances between zones.
- It iteratively selects the next closest unexplored zone, updating the shortest known path.
- Stops when the destination is reached or no path exists.
- Returns the total distance and time for the optimal path.

### Usage Example
To find the optimal trip from zone 34 to zone 52:

```sql
EXEC FindOptimalTrip @StartID = 34, @EndID = 52;
```

**Result:**
| start_zone | end_zone | total_dist | total_time |
|------------|----------|------------|------------|
| 34         | 52       |   ...      |   ...      |

If no path exists, the procedure returns NULL.

### Educational Notes
- The implementation is beginner-friendly and well-commented for learning purposes.
- The approach can be extended to return the full path (sequence of zones) by tracking predecessors.
- See `sql/find_optimal_trip.sql` for the full procedure and comments.

---
Feel free to expand this README as your project grows!
