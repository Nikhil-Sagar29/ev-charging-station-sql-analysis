==============================================================================
Local Event Impact on Charging Demand
==============================================================================

--Charging Demand by Event Type
  Logic:
 Analyze how different local event types influence:
 1.Utilization rate
 2.Wait time
 3.Infrastructure demand
 ---------------------------------

SELECT
    local_event,
    ROUND(AVG(utilization_rate),3) AS avg_utilization,
    ROUND(AVG(estimated_wait_time_mins),2) AS avg_wait_time,
    SUM(ports_occupied) AS total_ports_occupied
FROM ev_charging_station_data
GROUP BY local_event
ORDER BY avg_utilization DESC;

----------------------------------------

-- Event vs Non-Event Demand
 Logic:
 Compare charging demand during event periods vs normal periods.
 --------------------------------

SELECT
    CASE
        WHEN local_event = 'none' THEN 'No Event'
        ELSE 'Event Period'
    END AS event_category,
    ROUND(AVG(utilization_rate),3) AS avg_utilization,
    ROUND(AVG(estimated_wait_time_mins),2) AS avg_wait_time
FROM ev_charging_station_data
GROUP BY
    CASE
        WHEN local_event = 'none' THEN 'No Event'
        ELSE 'Event Period'
    END;
-------------------------------------------------------------

--- Event Congestion Ranking
 Logic:
 Identify which events generate the highest charging demand pressure.
 --------------------------------

WITH event_congestion AS (
    SELECT
        local_event,
        ROUND(AVG(utilization_rate),3) AS avg_utilization,
        AVG(estimated_wait_time_mins) AS avg_wait_time
    FROM ev_charging_station_data
    WHERE local_event <> 'none'
    GROUP BY local_event
)

SELECT *,
       RANK() OVER (ORDER BY avg_utilization DESC) AS demand_rank
FROM event_congestion;

----------------------------------------
