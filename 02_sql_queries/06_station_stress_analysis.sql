==========================================================================
Station_Stress_Analysis
==========================================================================
-- Best Customer Experience Stations
/*    Logic:
    Ideal station profile:
    1.Below-average wait time
    2.Healthy utilization (40–70%)
    3.Balanced traffic  */
--------------------------------------------------------------------

WITH customer_experience AS (
    SELECT
        station_name,
        city,
        AVG(estimated_wait_time_mins) AS avg_wait_time,
        AVG(utilization_rate) AS avg_utilization
    FROM ev_charging_station_data
    GROUP BY station_name, city
)

SELECT
    station_name,
    city,
    ROUND(avg_wait_time,1) AS avg_wait_time,
    ROUND(avg_utilization,2) AS avg_utilization
FROM customer_experience
WHERE avg_wait_time <
      (SELECT AVG(estimated_wait_time_mins)
       FROM ev_charging_station_data)
AND avg_utilization BETWEEN 0.4 AND 0.7
ORDER BY avg_wait_time ASC;

--------------------------------------------------------------

--Worst Customer Experience Stations       
   /* Logic:
    High wait time + high utilization = congestion pressure.*/
-------------------------------------------------------------

WITH customer_experience AS (
    SELECT
        station_name,
        city,
        AVG(estimated_wait_time_mins) AS avg_wait_time,
        AVG(utilization_rate) AS avg_utilization
    FROM ev_charging_station_data
    GROUP BY station_name, city
)

SELECT
    station_name,
    city,
    ROUND(avg_wait_time,1) AS avg_wait_time,
    ROUND(avg_utilization,2) AS avg_utilization,
    RANK() OVER (ORDER BY avg_wait_time DESC) AS wait_time_rank,
    RANK() OVER (ORDER BY avg_utilization DESC) AS utilization_rank
FROM customer_experience
ORDER BY wait_time_rank 
-----------------------------------------------------
  
--Impact of Local Events on Customer Experience 
-----------------------------------------------------
  
SELECT
    Local_event, 
    ROUND(AVG(utilization_rate),3) AS avg_utilization,
    ROUND(AVG(estimated_wait_time_mins),2) as avg_wait_time,
    ROUND(AVG(avg_session_duration_mins),2) AS avg_session_duration
FROM ev_charging_station_data
GROUP BY local_event
ORDER BY avg_utilization desc

------------------------------------------------------

--Customer Stress Index During Local Events
 /*    Logic:
    Create a stress classification model based on:
    1.Wait time
    2.Utilization
  
    Critical Stress
    Wait Time > 100 mins
    Utilization > 85%
 
     High Stress
    Wait Time 50–99 mins
    Utilization 70–84%

     Moderate Stress
    Wait Time 20–49 mins
    Utilization 50–69%

    Low Stress
    Wait Time 8-19 mins
    Utilization 30-49%

    No stress
    wait time 1-7 min
    Utilization < 30
    */
------------------------------------------------------

create View Stress_chart as 
SELECT
    local_event,
    CASE
        WHEN estimated_wait_time_mins > 100  
         AND utilization_rate >= 0.85 THEN 'Critical Stress'
        WHEN estimated_wait_time_mins BETWEEN 50 AND 99
         AND utilization_rate BETWEEN 0.70 AND 0.84 THEN 'High Stress'
        WHEN estimated_wait_time_mins BETWEEN 20 AND 49
         AND utilization_rate BETWEEN 0.50 AND 0.69 THEN 'Moderate Stress'
        ELSE 'Low/No Stress'
    END AS stress_level,
    COUNT(*) AS occurrence_count
FROM ev_charging_station_data
GROUP BY local_event,
    CASE
        WHEN estimated_wait_time_mins > 100  
         AND utilization_rate >= 0.85 THEN 'Critical Stress'
        WHEN estimated_wait_time_mins BETWEEN 50 AND 99
         AND utilization_rate BETWEEN 0.70 AND 0.84 THEN 'High Stress'
        WHEN estimated_wait_time_mins BETWEEN 20 AND 49
         AND utilization_rate BETWEEN 0.50 AND 0.69 THEN 'Moderate Stress'
        ELSE 'Low/No Stress'
    END;


select * from Stress_chart
ORDER BY local_event, occurrence_count DESC;
-----------------------------------------------------------------------------------------------------------
