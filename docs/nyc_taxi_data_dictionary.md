# NYC Taxi Data Dictionary

## trips table

| Field Name | Description |
|------------|-------------|
| VendorID | A code indicating the TPEP provider that provided the record (1 = Creative Mobile Technologies, 2 = Curb Mobility, 6 = Myle Technologies Inc, 7 = Helix) |
| tpep_pickup_datetime | The date and time when the meter was engaged |
| tpep_dropoff_datetime | The date and time when the meter was disengaged |
| passenger_count | The number of passengers in the vehicle |
| trip_distance | The elapsed trip distance in miles reported by the taximeter |
| RatecodeID | Final rate code in effect at the end of the trip (1=Standard, 2=JFK, 3=Newark, 4=Nassau/Westchester, 5=Negotiated, 6=Group ride, 99=Unknown) |
| store_and_fwd_flag | Y = stored in vehicle memory before sending, N = sent immediately |
| PULocationID | TLC Taxi Zone where the meter was engaged |
| DOLocationID | TLC Taxi Zone where the meter was disengaged |
| payment_type | Payment method code (1=Credit card, 2=Cash, 3=No charge, 4=Dispute, 5=Unknown, 6=Voided trip) |
| fare_amount | Time-and-distance fare calculated by meter |
| extra | Miscellaneous extras and surcharges |
| mta_tax | Tax automatically triggered based on metered rate |
| tip_amount | Tip amount (only credit card tips included) |
| tolls_amount | Total tolls paid during trip |
| improvement_surcharge | Fixed surcharge applied per trip |
| total_amount | Total charged to passenger (excluding cash tips) |
| congestion_surcharge | NYC congestion surcharge |
| airport_fee | Fee for trips to/from JFK or LaGuardia |
| cbd_congestion_fee | Per-trip congestion relief charge (starting 2025) |

