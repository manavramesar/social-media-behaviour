-- Data Cleaning --
UPDATE social_media_usage.user_activty
SET Profession = "Driver"
WHERE Profession = "driver";

-- Data Transformation --
-- Age Group Column --
ALTER TABLE social_media_usage.user_activty
ADD Age_Group VARCHAR(10);

-- Creating Age Groups --
UPDATE  social_media_usage.user_activty
SET Age_Group = 
    CASE
        WHEN Age BETWEEN 18 AND 24 THEN '18-24'
        WHEN Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN Age BETWEEN 45 AND 54 THEN '45-54'
        WHEN Age BETWEEN 55 AND 64 THEN '55-64'
        ELSE '65+'
    END;

-- Which age group is the most active on social media? --

SELECT Age_Group as "Age Group", COUNT(*) as "Number of Users"
FROM social_media_usage.user_activty
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- Which platform has the highest number of users? --

SELECT Platform, COUNT(Platform) as "Number of Users"
FROM social_media_usage.user_activty
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- CONTENT STRATEGY --
-- How does the level of satisfaction with content vary across different platforms? --

SELECT Platform, AVG(Satisfaction) as "Average Satisfaction"
FROM social_media_usage.user_activty
GROUP BY 1
ORDER BY 2 DESC;

-- BEHAVIORAL INSIGHTS -- 
-- How does productivity loss vary by platform, and which platforms contribute most to this? --

SELECT Platform, AVG(Productivity_loss) AS "Average Productivity Loss"
FROM social_media_usage.user_activty
GROUP BY 1
ORDER BY 2 DESC;

-- CAMPAIGN OPTIMIZATION --
-- How can campaigns be timed based on the peak hours of platform usage? --

SELECT Platform, Time as "Peak Time"
FROM(
	SELECT Platform, DATE_FORMAT(Watch_TIME, '%H:%i') AS "Time", COUNT(*) as users, ROW_NUMBER() OVER (PARTITION BY Platform ORDER BY COUNT(*) DESC) AS rnk
FROM user_activty
GROUP BY 1,2
ORDER BY 3 DESC, 1 ASC)
AS subquery;

-- Target Age Group, the reason they watch, and the platform they watch on the most --

WITH a AS (
    SELECT Age_Group, COUNT(*)
    FROM social_media_usage.user_activty
    GROUP BY Age_Group
    ORDER BY 2 DESC
    LIMIT 1),
b AS (
    SELECT Watch_Reason, COUNT(*)
    FROM social_media_usage.user_activty
    GROUP BY Watch_Reason
    ORDER BY 2 DESC
    LIMIT 1),
c as(
SELECT Platform, COUNT(*)
FROM social_media_usage.user_activty
WHERE Age_Group = (SELECT Age_Group FROM a) AND Watch_Reason = (SELECT Watch_Reason FROM b)
group by 1
ORDER BY 2 DESC
limit 1)
SELECT a.Age_Group as "Age Group", b.Watch_Reason as "Watch Reason", c.Platform
FROM a,b,c;

