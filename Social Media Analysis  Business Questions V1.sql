SELECT * FROM social_media_usage.user_activty;

UPDATE user_activty
SET Profession = "Driver"
WHERE Profession = "driver";

-- 1. Target Audience Identification:

	-- How does income level correlate with social media usage and platform preference?
			SELECT 
				(SUM((Total_Time_Spent - (SELECT AVG(Total_Time_Spent) FROM social_media_usage.user_activty)) * (Income - (SELECT AVG(Income) FROM social_media_usage.user_activty))) / 
				(SQRT(SUM(POW(Total_Time_Spent - (SELECT AVG(Total_Time_Spent) FROM social_media_usage.user_activty), 2)) * SUM(POW(Income - (SELECT AVG(Income) FROM social_media_usage.user_activty), 2))))) AS correlation_value
			FROM social_media_usage.user_activty;

	-- Most used platform--
		SELECT Platform
		FROM
			(SELECT Platform, COUNT(Platform)
			FROM social_media_usage.user_activty
			GROUP BY 1
			order by 2 desc)
		AS subquery;

-- 2. Content Strategy:
		-- What are the most common reasons users engage with social media content (e.g., procrastination, boredom, entertainment)?
		SELECT Watch_Reason, COUNT(Watch_Reason)
		FROM user_activty
		GROUP BY 1
        ORDER BY 2 DESC;
	 

		-- What time of day are users most active on different platforms? --

		SELECT Platform, Time as "Peak Time", users
		FROM(
			SELECT Platform, DATE_FORMAT(Watch_TIME, '%H:%i') AS "Time", COUNT(*) as users, ROW_NUMBER() OVER (PARTITION BY Platform ORDER BY COUNT(*) DESC) AS rnk
			FROM user_activty
			GROUP BY 1,2
			ORDER BY 3 DESC, 1 ASC)
		AS subquery
       
        
	-- Which device types (smartphone, tablet, computer) and operating systems are most popular among users on specific platforms?

		SELECT Device_Type, COUNT(*)
        FROM social_media_usage.user_activty
        GROUP BY 1
        ORDER BY 2 DESC;

		SELECT OS, COUNT(*)
        FROM social_media_usage.user_activty
        GROUP BY 1
        ORDER BY 2 DESC;
        
       -- How does the level of satisfaction with content vary across different platforms?
		SELECT Platform, AVG(Satisfaction)
        FROM social_media_usage.user_activty
        GROUP BY 1
        ORDER BY 2 DESC;

-- Addiction Level by profession

WITH addiction_level AS (
    SELECT Profession,Addiction_Level,COUNT(Addiction_Level), ROW_NUMBER() OVER (PARTITION BY Profession ORDER BY COUNT(Addiction_Level) DESC) AS rnk
    FROM user_activty
    GROUP BY 1,2
)
SELECT Profession, Addiction_Level
FROM addiction_level
-- WHERE rnk = 1
ORDER BY 2 DESC;