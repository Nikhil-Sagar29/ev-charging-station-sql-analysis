===========================================================================================
DATA QUALITY CHECK
===========================================================================================
-- PREVIEW DATASET 
SELECT TOP 10
    station_name,
    city,
    station_status,
    ROUND(utilization_rate,4) AS utilization_rate,
    ports_total,
    estimated_wait_time_mins,
    hour_of_day,
    is_peak_hour
FROM ev_charging_station_data;

-- CHECK FOR NULL VALUES
SELECT * FROM ev_charging_station_data
WHERE 
station_id IS NULL
OR city IS NULL
OR ports_total IS NULL 
OR ports_occupied IS NULL;

-- CHECK DUPLICATE STATION RECORDS
SELECT
station_id,
current_timestamp,
COUNT(*) AS duplicate_count
FROM ev_charging_station_data
GROUP BY station_id, current_timestamp
HAVING COUNT(*) > 1;

-- Validate ports usage does not exceed capacity
SELECT *
FROM ev_charging_station_data
WHERE ports_occupied > ports_total;

-- RESULTS
-- No Duplicate row detected
-- Repeated station IDs are expected because the dataset records hourly operational data.



