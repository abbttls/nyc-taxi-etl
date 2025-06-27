import os
import requests
import pandas as pd

# This script downloads NYC Yellow Taxi trip data for January 2024


def download_file(url, filename, folder="data"):
    """
    Downloads a file from the specified URL and saves it to a local folder.

    Args:
        url (str): The URL of the file to download.
        filename (str): The name to use when saving the file locally.
        folder (str, optional): The folder where the file will be saved. Defaults to "data".

    Raises:
        requests.HTTPError: If the HTTP request returned an unsuccessful status code.

    Side Effects:
        Creates the specified folder if it does not exist.
        Writes the downloaded file to disk.
        Prints the local path of the downloaded file.
    """
    os.makedirs(folder, exist_ok=True)
    local_path = os.path.join(folder, filename)
    with requests.get(url, stream=True, verify=False) as r:
        r.raise_for_status()
        with open(local_path, "wb") as f:
            for chunk in r.iter_content(chunk_size=8192):
                f.write(chunk)
    print(f"Downloaded to {local_path}")

def parquet_to_csv(parquet_filename, folder="data"):
    """
    Converts a Parquet file to CSV format in the specified folder.
    The CSV file will have the same name as the Parquet file, but with a .csv extension.

    Args:
        parquet_filename (str): The name of the Parquet file (e.g., 'yellow_tripdata_2024-01.parquet').
        folder (str, optional): The folder where the files are located. Defaults to "data".

    Side Effects:
        Writes the converted CSV file to disk in the same folder.
        Prints the path of the converted CSV file.
    """
    parquet_path = os.path.join(folder, parquet_filename)
    csv_filename = os.path.splitext(parquet_filename)[0] + ".csv"
    csv_path = os.path.join(folder, csv_filename)
    df = pd.read_parquet(parquet_path)
    df.to_csv(csv_path, index=False)
    print(f"Converted {parquet_path} to {csv_path}")


# Example usage:
# download_file("https://.../yellow_tripdata_2024-01.parquet", "yellow_tripdata_2024-01.parquet")
# parquet_to_csv("data/yellow_tripdata_2024-01.parquet", "data/yellow_tripdata_2024-01.csv")


# Download and convert NYC Yellow Taxi trip data for January 2024
# Also downloads the taxi zone lookup file
ytaxi_01_24_url = "https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-01.parquet"
loc_lookup_url = "https://d37ci6vzurychx.cloudfront.net/misc/taxi_zone_lookup.csv"

#download_file(ytaxi_01_24_url, "yellow_tripdata_2024-01.parquet")
download_file(loc_lookup_url, "taxi_zone_lookup.csv")
#parquet_to_csv("yellow_tripdata_2024-01.parquet", "data")

