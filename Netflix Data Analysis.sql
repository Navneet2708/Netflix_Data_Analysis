---- Netflix Project
CREATE Table Netflix
(
show_id	VARCHAR(6),
type VARCHAR(10),
title VARCHAR(150),
director VARCHAR(250),	
castS VARCHAR(1000),
country	VARCHAR(150),
date_added	VARCHAR(50),
release_year INT,
rating	VARCHAR(10),
duration	VARCHAR(15),
listed_in	VARCHAR(100),
description VARCHAR(300)
);

SELECT * FROM netflix;


SELECT
	COUNT(*) as total_content
FROM netflix;


SELECT 
	DISTINCT type
FROM netflix;


---- 15 Business Problems:
---Q1: Count the Number of Movies vs TV Shows

SELECT
type,
COUNT(*) as total_content
FROM Netflix
GROUP BY type;

---Q2: Find the Most Common Rating for Movies and TV Shows.
SELECT 
type,
rating
FROM (
	SELECT
		type,
		rating,
		RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as ranking
	FROM netflix
	Group by 1,2
) as t1
WHERE 
ranking = 1;

---Q3: List All Movies Released in a Specific Year (e.g., 2020)
SELECT 
*
FROM netflix
WHERE 
type = 'Movie'
AND
release_year = 2020;

---Q4: Find the Top 5 Countries with the Most Content on Netflix
SELECT 
unnest(STRING_TO_ARRAY(country,',')) as new_country,
COUNT(show_id) as total_content
FROM netflix
GROUP by 1
ORDER BY 2 DESC
LIMIT 5

---Q5: Identify the Longest Movie
SELECT * FROM netflix
WHERE 
type= 'Movie'
AND
duration = (SELECT MAX(duration) FROM netflix);

---Q6: Find the content added in the last 5 years
SELECT *
FROM netflix
WHERE
TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

---Q7: Find all the movies/ TV shows by director 'Rajiv Chilaka'!
SELECT * 
FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%'

--- Q8: List all TV shows with more than 5 seasons
SELECT
*
FROM netflix
WHERE 
type = 'TV Show'
AND
SPLIT_PART(duration, ' ',1)::numeric > 5;

---Q9: Count the Number of Content Items in Each Genre:
SELECT 
UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
COUNT(show_id) as total_content
FROM netflix
GROUP BY 1;

---Q10: Find each year and the average numbers of content release in India on netflix.
SELECT
EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as year,
COUNT (*) as yearly_content,
ROUND(COUNT(*) :: numeric/(SELECT COUNT(*) FROM netflix WHERE country = 'India')::numeric *100,2) as avg_content_per_year
FROm netflix
WHERE country = 'India'
GROUP BY 1

--Q11: List All Movies that are Documentaries
SELECT * FROM netflix
WHERE listed_in ILIKE '%Documentaries%';

---Q12: Find All Content Without a Director
SELECT * FROM netflix
WHERE director is NULL;

---Q13: Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
SELECT * FROM netflix
WHERE casts ILIKE '%salman Khan%'
AND 
release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;

---Q14: Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
select 
UNNEST(STRING_TO_ARRAY(casts, ',')) as actors,
COUNT(*) as total_content
FROM netflix
WHERE country ILIKE '%India%'
Group by 1
ORDER BY 2 DESC
LIMIT 10;

---Q15: Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
--- Objective: Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.
with new_table
AS(
SELECT *, CASE
WHEN
description ILIKE '%kill%' OR
description ILIKE '%violence%' THEN 'Bad_Content'
ELSE 'Good_Content'
END category
FROM netflix
) 
SELECT
category,
COUNT(*) as total_content
FROM new_table
GROUP by 1
ORDER BY 2 DESC;

--------END PROJECT-----




