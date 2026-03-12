create database internshala;
use internshala;
show tables;
select * from orders;
select order_id, count(*)
from shipment_tracking_table
group by order_id
having count(*)>1;
DESC orders;
SHOW COLUMNS FROM Orders;


											-- TASK 1 -- 
-- Identify and delete duplicate Order_ID records.-- 
-- Query to identify the duplicate records-- 
SELECT Order_ID, COUNT(*) AS cnt
FROM Orders
GROUP BY Order_ID
HAVING COUNT(*) > 1;

 -- Replace null Traffic_Delay_Min with the average delay for that route.-- 
 SELECT COUNT(*) AS Null_Count
FROM Orders
WHERE Traffic_Delay_Min IS NULL;

SELECT COUNT(*) AS Null_Count
FROM Routes
WHERE Traffic_Delay_Min IS NULL;

-- Convert all date columns into YYYY-MM-DD format using SQL functions.-- 
SET SQL_SAFE_UPDATES = 0;
ALTER TABLE Orders
MODIFY Order_Date DATE,
MODIFY Expected_Delivery_Date DATE,
MODIFY Actual_Delivery_Date DATE;

select Order_Date, Expected_Delivery_Date, Actual_Delivery_Date from Orders  LIMIT 5;

SELECT *
FROM Orders
WHERE Actual_Delivery_Date < Order_Date;

								-- Task 2: Delivery Delay Analysis-- 
                                
-- Calculate delivery delay (in days) for each order--                                 
select * from orders;
select DATEDIFF(Actual_Delivery_Date, Expected_Delivery_Date) AS Delivery_Delay_Days
FROM Orders;
select order_id, Actual_Delivery_Date, Expected_Delivery_Date,
DATEDIFF(Actual_Delivery_Date,Expected_Delivery_Date) as DELIVERY_DELAY_DAYS
from Orders;

 -- Find Top 10 delayed routes based on average delay days-- 
 select * from orders;
 SELECT 
    Route_ID,
    AVG(DATEDIFF(Actual_Delivery_Date, Expected_Delivery_Date)) AS Avg_Delay_Days
FROM Orders
WHERE Actual_Delivery_Date IS NOT NULL
GROUP BY Route_ID
ORDER BY Avg_Delay_Days DESC
LIMIT 10;

SELECT 
    Order_ID,
    Warehouse_ID,
    DATEDIFF(Actual_Delivery_Date, Expected_Delivery_Date) AS Delay_Days,
    RANK() OVER (
        PARTITION BY Warehouse_ID
        ORDER BY DATEDIFF(Actual_Delivery_Date, Expected_Delivery_Date) DESC
    ) AS Delay_Rank
FROM Orders
WHERE Actual_Delivery_Date IS NOT NULL;

									-- Task 3 Route Optimization Insights-- 
                                    
-- Average delivery time (in days)-- 
select * from orders;
select Route_id, Actual_Delivery_Date,Order_Date  from orders;
select Route_ID, 
avg(datediff(Actual_Delivery_Date,Order_Date)) as Diff from orders 
where actual_delivery_date is not null 
group by Route_id;

-- Average traffic delay -- 
select * from routes;
show tables;
select Route_id, 
Avg(Traffic_Delay_Min) as 'Average Traffic Delay' 
from routes 
group by Route_id;

-- Distance-to-time efficiency ratio: Distance_KM / Average_Travel_Time_Min-- 
select * from Routes;
select Route_ID, 
Distance_KM, 
Average_Travel_Time_Min, 
(Distance_KM/Average_Travel_Time_Min)as 'Distance-to-time efficiency ratio'
from Routes;

-- Identify 3 routes with the worst efficiency ratio-- 
select * from routes;
select Route_ID, 
Distance_KM, 
Average_Travel_Time_Min,
(Distance_KM/Average_travel_Time_Min) as Average
from routes
order by 'Worst Efficiency ratio' 
Asc Limit 3; 

-- Find routes with >20% delayed shipments-- 
SELECT 
    Route_ID,
    COUNT(CASE WHEN Delivery_Status = 'Delayed' THEN 1 END) AS Delayed_Count,
    COUNT(*) AS Total_Count,
    (COUNT(CASE WHEN Delivery_Status = 'Delayed' THEN 1 END) * 100.0 / COUNT(*)) AS Delay_Percentage
FROM Orders
GROUP BY Route_ID
HAVING Delay_Percentage > 20;

									-- Task 4: Warehouse Performance-- 
                                    
 -- Find the top 3 warehouses with the highest average processing time-- 
SELECT 
    o.Warehouse_ID,
    AVG(DATEDIFF(s.Checkpoint_Time, o.Order_Date)) AS Avg_Processing_Time_Days
FROM Orders o
JOIN Shipment_Tracking_Table s
    ON o.Order_ID = s.Order_ID
WHERE s.Checkpoint = 'Checkpoint 1'
GROUP BY o.Warehouse_ID
ORDER BY Avg_Processing_Time_Days DESC
LIMIT 3;

-- Calculate total vs. delayed shipments for each warehouse.-- 
SELECT o.Warehouse_ID,
       COUNT(o.Order_ID) AS total_shipments,
       SUM(CASE WHEN o.Delivery_Status = 'Delayed' THEN 1 ELSE 0 END) AS delayed_shipments
FROM Orders o
GROUP BY o.Warehouse_ID
ORDER BY delayed_shipments DESC;

-- Use CTEs to find bottleneck warehouses where processing time > global average.-- 
WITH GlobalAvg AS (
    SELECT AVG(Processing_Time_Min) AS global_avg
    FROM Warehouses
)
SELECT w.Warehouse_ID, w.Location, w.Processing_Time_Min
FROM Warehouses w, GlobalAvg g
WHERE w.Processing_Time_Min > g.global_avg
ORDER BY w.Processing_Time_Min DESC;

-- Rank warehouses based on on-time delivery percentage-- 
SELECT 
    o.Warehouse_ID,
    (SUM(CASE WHEN o.Delivery_Status = 'On Time' THEN 1 ELSE 0 END) * 100.0 / COUNT(o.Order_ID)) AS on_time_percentage,
    RANK() OVER (ORDER BY 
        (SUM(CASE WHEN o.Delivery_Status = 'On Time' THEN 1 ELSE 0 END) * 100.0 / COUNT(o.Order_ID)) DESC
    ) AS warehouse_rank
FROM Orders o
GROUP BY o.Warehouse_ID;

										-- Task 5: Delivery Agent Performanc-- e
-- Rank agents (per route) by on-time delivery percentage-- 
SELECT 
    Route_ID,
    Agent_ID,
    On_Time_Percentage,
    RANK() OVER (PARTITION BY Route_ID ORDER BY On_Time_Percentage DESC) AS agent_rank
FROM DeliveryAgents;

-- Find Agents with On-Time % < 80-- 
SELECT Agent_ID, Route_ID, On_Time_Percentage
FROM DeliveryAgents
WHERE On_Time_Percentage < 80
ORDER BY On_Time_Percentage ASC;

-- Find agents with on-time % < 80%-- 
SELECT Agent_ID, Route_ID, On_Time_Percentage
FROM DeliveryAgents
WHERE On_Time_Percentage < 80
ORDER BY On_Time_Percentage ASC;

-- Compare average speed of top 5 vs bottom 5 agents using subqueries-- 
-- Top 5 agents by On-Time %
SELECT AVG(Avg_Speed_KM_HR) AS avg_speed_top5
FROM (
    SELECT Agent_ID, Avg_Speed_KM_HR
    FROM DeliveryAgents
    ORDER BY On_Time_Percentage DESC
    LIMIT 5
) AS top_agents;

-- Bottom 5 agents by On-Time %
SELECT AVG(Avg_Speed_KM_HR) AS avg_speed_bottom5
FROM (
    SELECT Agent_ID, Avg_Speed_KM_HR
    FROM DeliveryAgents
    ORDER BY On_Time_Percentage ASC
    LIMIT 5
) AS bottom_agents;

-- For each order, list the last checkpoint and time-- 
SELECT 
    Order_ID,
    MAX(Checkpoint) AS last_checkpoint,
    MAX(Checkpoint_Time) AS last_checkpoint_time
FROM shipment_tracking_table
GROUP BY Order_ID;

 -- Find the most common delay reasons (excluding None)-- 
 SELECT 
    Delay_Reason,
    COUNT(*) AS frequency
FROM Shipment_Tracking_Table
WHERE Delay_Reason IS NOT NULL AND Delay_Reason <> 'None'
GROUP BY Delay_Reason
ORDER BY frequency DESC;

-- Identify orders with >2 delayed checkpoints-- 
SELECT 
    Order_ID,
    COUNT(*) AS Delayed_Checkpoints
FROM Shipment_Tracking_Table
WHERE Delay_Reason IS NOT NULL
AND Delay_Reason <> 'None'
GROUP BY Order_ID
HAVING COUNT(*) > 2;

									-- Task 7:Advanced KPI Reporting-- 
                                    -- Calculate KPIs using SQL queries
                                    
-- Average Delivery Delay per Region (Start_Location)
SELECT 
    r.Start_Location,
    AVG(DATEDIFF(o.Actual_Delivery_Date, o.Expected_Delivery_Date)) AS avg_delivery_delay_days
FROM Orders o
JOIN Routes r ON o.Route_ID = r.Route_ID
GROUP BY r.Start_Location
ORDER BY avg_delivery_delay_days DESC;

 -- On-Time Delivery %
 
 SELECT 
    (SUM(CASE WHEN o.Delivery_Status = 'On Time' THEN 1 ELSE 0 END) * 100.0 / COUNT(o.Order_ID)) AS on_time_delivery_percentage
FROM Orders o;

SELECT 
    COUNT(Order_ID) AS total_deliveries,
    SUM(CASE WHEN Delivery_Status = 'On Time' THEN 1 ELSE 0 END) AS on_time_deliveries,
    (SUM(CASE WHEN Delivery_Status = 'On Time' THEN 1 ELSE 0 END) * 100.0 / COUNT(Order_ID)) AS on_time_percentage
FROM Orders;
 
 -- Average Traffic Delay per Route
 SELECT 
    Route_ID,
    Start_Location,
    End_Location,
    AVG(Traffic_Delay_Min) AS avg_traffic_delay
FROM Routes
GROUP BY Route_ID, Start_Location, End_Location
ORDER BY avg_traffic_delay DESC;