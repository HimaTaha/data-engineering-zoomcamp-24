-- Creating external table referring to gcs path
CREATE OR REPLACE EXTERNAL TABLE `tokyo-comfort-411321.week3_DWH_EU.external_green_tripdata`
OPTIONS (
  format = 'parquet',
  uris = ['gs://mage-zoomcamp-ibrahim/week3/green_tripdata_2022-*.parquet']
);

CREATE OR REPLACE TABLE tokyo-comfort-411321.week3_DWH_EU.BQ_green_tripdata
as
SELECT 
  VendorID,	
  TIMESTAMP_MICROS(DIV(lpep_pickup_datetime,1000)) as lpep_pickup_datetime,	
  TIMESTAMP_MICROS(DIV(lpep_dropoff_datetime,1000)) as lpep_dropoff_datetime,	
  store_and_fwd_flag,	
  RatecodeID,	
  PULocationID,	
  DOLocationID,	
  passenger_count,	
  trip_distance,	
  fare_amount,	
  extra,	
  mta_tax,	
  tip_amount,	
  tolls_amount,	
  ehail_fee,	
  improvement_surcharge,	
  total_amount,	
  payment_type,	
  trip_type,	
  congestion_surcharge
FROM tokyo-comfort-411321.week3_DWH_EU.external_green_tripdata;

 
-- Question 1: What is count of records for the 2022 Green Taxi Data
-- ANSWER: 840402
select count(1) from tokyo-comfort-411321.week3_DWH_EU.BQ_green_tripdata

-- Question 2: Write a query to count the distinct number of PULocationIDs for the entire dataset on both the tables.
-- What is the estimated amount of data that will be read when this query is executed on the External Table and the Table? 
-- ANSWER: 258 , 0 MB for external table  and 6.41MB for BQ table.

select count(distinct PULocationID) from tokyo-comfort-411321.week3_DWH_EU.BQ_green_tripdata;

-- QUESTION3: How many records have a fare_amount of 0?
-- ANSWER: 1622
select count(1) 
from tokyo-comfort-411321.week3_DWH_EU.BQ_green_tripdata
where fare_amount = 0;

-- QUESTION 4: What is the best strategy to make an optimized table in Big Query if your query will always order the results by PUlocationID and filter based on lpep_pickup_datetime? (Create a new table with this strategy)
-- ASNWER : Partition by lpep_pickup_datetime Cluster on PUlocationID

CREATE OR REPLACE TABLE tokyo-comfort-411321.week3_DWH_EU.BQ_green_tripdata_partitoned_clustered
PARTITION BY DATE(lpep_pickup_datetime)
CLUSTER BY PUlocationID AS
SELECT  * FROM tokyo-comfort-411321.week3_DWH_EU.BQ_green_tripdata;

-- QUESTION 5: Write a query to retrieve the distinct PULocationID between lpep_pickup_datetime 06/01/2022 and 06/30/2022 (inclusive)
-- Use the materialized table you created earlier in your from clause and note the estimated bytes. Now change the table in the from clause to the partitioned table you created for question 4 and note the estimated bytes processed. What are these values?
-- Choose the answer which most closely matches.
-- ANSWER: 12.82 MBfor non_partitioned and 1.12 MB for partitioned table
select distinct PULocationID
FROM tokyo-comfort-411321.week3_DWH_EU.BQ_green_tripdata
WHERE DATE(lpep_pickup_datetime) BETWEEN '2022-06-01' AND '2022-06-30';

select distinct PULocationID
FROM tokyo-comfort-411321.week3_DWH_EU.BQ_green_tripdata_partitoned_clustered
WHERE DATE(lpep_pickup_datetime) BETWEEN '2022-06-01' AND '2022-06-30';

-- QUESTION 6: Where is the data stored in the External Table you created?
-- ANSWER: GCP Bucket

-- QUESTION 7: It is best practice in Big Query to always cluster your data?
-- ANSWER: FALSE, if table is small we don't need to parition it 

-- No Points: Write a SELECT count(*) query FROM the materialized table you created. How many bytes does it estimate will be read? Why?
-- SELECT count(*) FROM tokyo-comfort-411321.week3_DWH_EU.external_green_tripdata
-- ANSWER: 0B as BQ already runs statistics on the table 



 