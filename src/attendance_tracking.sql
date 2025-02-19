-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Attendance Tracking Queries

-- 1. Record a member's gym visit
-- TODO: Write a query to record a member's gym visit
INSERT INTO attendance (member_id, location_id, check_in_time)
VALUES (7, 1, DATETIME('now'));

-- Test
SELECT *
FROM attendance;

-- 2. Retrieve a member's attendance history
-- TODO: Write a query to retrieve a member's attendance history
SELECT DATE(check_in_time) AS visit_date, 
       check_in_time, 
       check_out_time
FROM attendance
WHERE member_id = 5;

-- 3. Find the busiest day of the week based on gym visits
-- TODO: Write a query to find the busiest day of the week based on gym visits
SELECT
    -- Convert day numbers to day names (e.g. 0 = Sunday)
    CASE strftime('%w', check_in_time)
        WHEN '0' THEN 'Sunday'
        WHEN '1' THEN 'Monday'
        WHEN '2' THEN 'Tuesday'
        WHEN '3' THEN 'Wednesday'
        WHEN '4' THEN 'Thursday'
        WHEN '5' THEN 'Friday'
        WHEN '6' THEN 'Saturday'
    END AS day_of_week,
    COUNT(*) AS visit_count
FROM attendance
GROUP BY day_of_week
ORDER BY visit_count DESC
LIMIT 1;

-- 4. Calculate the average daily attendance for each location
-- TODO: Write a query to calculate the average daily attendance for each location
SELECT l.name, 
       COUNT(a.attendance_id) * 1.0 / COUNT(DISTINCT DATE(a.check_in_time)) AS avg_daily_attendance -- For each location (1 or 2), divide the total attendance by number of distinct days when a member has checked in. Note that it does not take into account days with 0 attendance.
FROM attendance a
JOIN locations l ON a.location_id = l.location_id
GROUP BY l.name;