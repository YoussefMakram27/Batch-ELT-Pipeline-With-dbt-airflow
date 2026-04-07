import pandas as pd
from sqlalchemy import create_engine


DATABASE_URL = "postgresql+psycopg2://warehouse:warehouse@postgres:5432/nyc_taxi"

engine = create_engine(DATABASE_URL, echo=True)

taxi_df = pd.read_parquet('/opt/data/yellow_tripdata_2025-01.parquet')
taxi_df = taxi_df.head(250_000)
zones_df = pd.read_csv('/opt/data/taxi_zone_lookup.csv')

taxi_df.to_sql(
    name='trips',
    schema='raw',
    con=engine,
    if_exists='replace',
    index=False
)

zones_df.to_sql(
    name='zones',
    schema='raw',
    con=engine,
    if_exists='replace',
    index=False
)

print(f"Loaded: {len(taxi_df)} into raw.trips")
print(f"Loaded: {len(zones_df)} into raw.zones")