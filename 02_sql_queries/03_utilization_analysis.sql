====================================================================================
UTILIZATION_ANALYSIS
====================================================================================
--1.Operational Stability Index
--LOGIC: Compute operational_ratio = operational records / total records.
  -----------------------------------------
SELECT
    station_name,
    CAST(
        COUNT(CASE WHEN station_status = 'operational' THEN 1 END)*1.0
        / COUNT(*)
    AS DECIMAL(10,4)) AS operational_ratio
FROM ev_charging_station_data
GROUP BY station_name
ORDER BY operational_ratio;

--2.Utilization by Status
/* Logic: This analysis evaluates how efficiently charging infrastructure is being used across 
different station operational statuses (e.g., Active, Maintenance, Limited Service). */
  ------------------------------------

SELECT
    station_status,
    COUNT(*) AS total_records,
    ROUND(AVG(utilization_rate),3) AS avg_utilization,
    ROUND(AVG(estimated_wait_time_mins),1) AS avg_wait_time
FROM ev_charging_station_data
GROUP BY station_status;

--3. Average Session Duration & Wait Time by Status 
/*  Logic:
  This analysis evaluates operational efficiency by comparing:
  1.Average charging session duration
  2.Average customer wait time
  3.Grouped by station operational status
  This helps determine whether certain statuses (Active, Maintenance, Limited, etc.) 
  negatively impact customer flow and congestion. */
  ---------------------------------------------

SELECT
    station_status,
    ROUND(AVG(avg_session_duration_mins), 1) AS avg_session_duration,
    ROUND(AVG(estimated_wait_time_mins), 2) AS avg_wait_time
FROM ev_charging_station_data
GROUP BY station_status;



