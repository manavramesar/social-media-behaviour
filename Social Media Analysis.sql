SELECT * FROM social_media_usage.user_activty;

UPDATE user_activty
SET Profession = "Driver"
WHERE Profession = "driver";

-- Most used platform--
SELECT Platform
FROM
	(SELECT Platform, COUNT(Platform)
	FROM social_media_usage.user_activty
	GROUP BY 1
    order by 2 desc)
AS subquery;

-- Most common video category

SELECT Video_Category, COUNT(*)
	FROM social_media_usage.user_activty
	GROUP BY 1
    order by 2 desc;

-- Procrastination Triggers--
WITH reason_count AS (
    SELECT Profession, Watch_Reason, COUNT(Watch_Reason) AS wr, ROW_NUMBER() OVER (PARTITION BY Profession ORDER BY COUNT(Watch_Reason) DESC) AS rnk
    FROM user_activty
    GROUP BY 1,2
)
SELECT Profession, Watch_Reason
FROM reason_count
WHERE rnk = 1;

-- Most Productivity Loss by Profession--

SELECT Profession, SUM(Total_Time_Spent) AS "Total Time Spent Watching Videos"
FROM user_activty
GROUP BY 1
ORDER BY 2 DESC;

-- User breakdown--
SELECT Gender, count(*) 
FROM social_media_usage.user_activty
group by 1;

-- Avg Income by Demoographic --
select Demographics, avg(Income)
from social_media_usage.user_activty
GROUP BY 1;

-- Count of Satisfaction by Gender --

SELECT gender, AVG(Satisfaction)
FROM social_media_usage.user_activty
GROUP BY 1;

-- Correlation between total time spent on social media platform and productivity loss
SELECT 
    (SUM((Age - (SELECT AVG(Age) FROM social_media_usage.user_activty)) * (Income - (SELECT AVG(Income) FROM social_media_usage.user_activty))) / 
    (SQRT(SUM(POW(Age - (SELECT AVG(Age) FROM social_media_usage.user_activty), 2)) * SUM(POW(Income - (SELECT AVG(Income) FROM social_media_usage.user_activty), 2))))) AS correlation_value
FROM social_media_usage.user_activty;

-- Peak Watch Time --

SELECT Time as "Peak Time"
FROM(
	SELECT DATE_FORMAT(Watch_TIME, '%H:%i') AS "Time", COUNT(*)
	FROM user_activty
	GROUP BY 1
	ORDER BY 2 DESC)
AS subquery    
LIMIT 1;

-- Pivot Table Hourly usage--

SELECT
    SUM(CASE WHEN HOUR(Watch_TIME) = 0 THEN 1 ELSE 0 END) AS "00:00",
    SUM(CASE WHEN HOUR(Watch_TIME) = 1 THEN 1 ELSE 0 END) AS "01:00",
    SUM(CASE WHEN HOUR(Watch_TIME) = 2 THEN 1 ELSE 0 END) AS "02:00",
    SUM(CASE WHEN HOUR(Watch_TIME) = 3 THEN 1 ELSE 0 END) AS "03:00",
    SUM(CASE WHEN HOUR(Watch_TIME) = 4 THEN 1 ELSE 0 END) AS "04:00",
    SUM(CASE WHEN HOUR(Watch_TIME) = 5 THEN 1 ELSE 0 END) AS "05:00",
    SUM(CASE WHEN HOUR(Watch_TIME) = 6 THEN 1 ELSE 0 END) AS "06:00",
    SUM(CASE WHEN HOUR(Watch_TIME) = 7 THEN 1 ELSE 0 END) AS "07:00",
    SUM(CASE WHEN HOUR(Watch_TIME) = 8 THEN 1 ELSE 0 END) AS "08:00",
    SUM(CASE WHEN HOUR(Watch_TIME) = 9 THEN 1 ELSE 0 END) AS "09:00",
    SUM(CASE WHEN HOUR(Watch_TIME) = 10 THEN 1 ELSE 0 END) AS "10:00",
    SUM(CASE WHEN HOUR(Watch_TIME) = 11 THEN 1 ELSE 0 END) AS "11:00",
    SUM(CASE WHEN HOUR(Watch_TIME) = 12 THEN 1 ELSE 0 END) AS "12:00",
    SUM(CASE WHEN HOUR(Watch_TIME) = 13 THEN 1 ELSE 0 END) AS "13:00",
    SUM(CASE WHEN HOUR(Watch_TIME) = 14 THEN 1 ELSE 0 END) AS "14:00",
    SUM(CASE WHEN HOUR(Watch_TIME) = 15 THEN 1 ELSE 0 END) AS "15:00",
    SUM(CASE WHEN HOUR(Watch_TIME) = 16 THEN 1 ELSE 0 END) AS "16:00",
    SUM(CASE WHEN HOUR(Watch_TIME) = 17 THEN 1 ELSE 0 END) AS "17:00",
    SUM(CASE WHEN HOUR(Watch_TIME) = 18 THEN 1 ELSE 0 END) AS "18:00",
    SUM(CASE WHEN HOUR(Watch_TIME) = 19 THEN 1 ELSE 0 END) AS "19:00",
    SUM(CASE WHEN HOUR(Watch_TIME) = 20 THEN 1 ELSE 0 END) AS "20:00",
    SUM(CASE WHEN HOUR(Watch_TIME) = 21 THEN 1 ELSE 0 END) AS "21:00",
    SUM(CASE WHEN HOUR(Watch_TIME) = 22 THEN 1 ELSE 0 END) AS "22:00",
    SUM(CASE WHEN HOUR(Watch_TIME) = 23 THEN 1 ELSE 0 END) AS "23:00"
FROM user_activty;

-- Addiction Level by profession

WITH addiction_level AS (
    SELECT Profession,Addiction_Level,COUNT(Addiction_Level), ROW_NUMBER() OVER (PARTITION BY Profession ORDER BY COUNT(Addiction_Level) DESC) AS rnk
    FROM user_activty
    GROUP BY 1,2
)
SELECT Profession, Addiction_Level
FROM addiction_level
WHERE rnk = 1
ORDER BY 2 DESC;