===================================================================================
PEAK HOUR ANALYSIS
===================================================================================
--Peak Hour Congestion
/* Logic:
 1.This analysis focuses only on peak-hour records to:
 2.Measure average utilization rate
 3.Measure average wait time
 4.Identify stations under consistent peak pressure */
 ----------------------------------------------------
 
WITH congestion AS (
    SELECT
        station_name,
        AVG(utilization_rate) AS avg_utilization,
        AVG(estimated_wait_time_mins) AS avg_wait
    FROM ev_charging_station_data
    WHERE is_peak_hour = 1
    GROUP BY station_name
)

SELECT *,
       ROUND(avg_utilization,3) AS avg_utilization,
       ROUND(avg_wait,1) AS avg_wait_time
FROM congestion
ORDER BY avg_wait DESC;

-- Peak vs Off-Peak
    --------------------
    Logic:
    Compare utilization and wait time between peak and non-peak periods.
    ----------------------------------

SELECT
    is_peak_hour,
    ROUND(AVG(utilization_rate),3) AS avg_utilization,
    ROUND(AVG(estimated_wait_time_mins),1) AS avg_wait_time
FROM ev_charging_station_data
GROUP BY is_peak_hour;
-----------------------------------------------

--- Weekend vs Weekday
      ----------------------
       Logic
       Measure behavior differences across weekdays and weekends.
       ----------------------------------------------
SELECT
    is_weekend,
    ROUND(AVG(utilization_rate),3) AS avg_utilization,
    ROUND(AVG(avg_session_duration_mins),1) AS avg_session_duration
FROM ev_charging_station_data
GROUP BY is_weekend;
-------------------------------------------------

--- Hourly Trend
      -------------------------
      Logic:
      Identify demand patterns throughout the day.
      -------------------------
SELECT
    hour_of_day,
    ROUND(AVG(utilization_rate),3) AS avg_utilization
FROM ev_charging_station_data
GROUP BY hour_of_day
ORDER BY hour_of_day;
------------------------------------------------------


