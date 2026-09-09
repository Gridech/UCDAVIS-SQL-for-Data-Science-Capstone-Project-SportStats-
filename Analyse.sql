CREATE TABLE game_info AS
    SELECT DISTINCT Games, Sport, Event, YEAR(Year) AS Year, Season, City
    FROM athlete_events;

CREATE TABLE athlete_info AS
    SELECT DISTINCT ID, Age, Sex, Name, Height, Weight, Team, Medal
    FROM athlete_events;

CREATE TABLE event_table AS
    SELECT ID, Games, NOC
    FROM athlete_events;

SELECT
    Sex,
    COUNT(*) AS num_athletes,
    ROUND(AVG(Height), 2) AS avg_height,
    ROUND(AVG(Weight), 2) AS avg_weight
FROM athlete_info
GROUP BY Sex;

SELECT
    n.region AS Country,
    COUNT(CASE WHEN a.Medal = 'Gold' THEN 1 END) AS Gold,
    COUNT(CASE WHEN a.Medal = 'Silver' THEN 1 END) AS Silver,
    COUNT(CASE WHEN a.Medal = 'Bronze' THEN 1 END) AS Bronze,
    COUNT(a.Medal) AS Total_Medals
FROM event_table AS e
    INNER JOIN noc_regions AS n ON e.NOC = n.NOC
    INNER JOIN athlete_info AS a ON a.ID =  e.ID
WHERE a.Medal IS NOT NULL
GROUP BY n.region
ORDER BY Total_Medals DESC
LIMIT 10;

SELECT
    gi.Year,
    gi.Season,
    gi.City,
    COUNT(DISTINCT e.ID) AS num_athletes,
    COUNT(DISTINCT e.NOC) AS num_countries
FROM event_table AS e
JOIN game_info AS gi ON e.Games = gi.Games
GROUP BY gi.Year, gi.Season, gi.City
ORDER BY gi.Year DESC ;


SELECT
    Sport,
    Event,
    COUNT(*) AS num_competitors
FROM game_info
GROUP BY Sport, Event
ORDER BY num_competitors DESC
LIMIT 15;



/*                        Part 2                   */


SELECT Sex,
       MIN(Age) AS minimal_age,
       MAX(Age) AS maximum_age,
       ROUND((MIN(Age)+MAX(Age))/2 , 2) AS median_age,
       AVG(Age) AS average_age,
       ROUND(STDDEV(Age), 2) AS standerd_deviation_age
FROM athlete_info
GROUP BY Sex;

SELECT g.Sport,
       MIN(a.Age) AS minimal_age,
       MAX(a.Age) AS maximum_age,
       ROUND((MIN(a.Age)+MAX(a.Age))/2 , 2) AS median_age,
       AVG(a.Age) AS average_age,
       ROUND(STDDEV(a.Age), 2) AS standerd_deviation_age
FROM athlete_info AS a INNER JOIN event_table AS e ON a.ID = e.ID INNER JOIN game_info AS g ON e.Games = g.Games
GROUP BY g.Sport;

SELECT Sex,
       MIN(Height) AS minimal_height,
       MAX(Height) AS maximum_height,
       ROUND((MIN(Height)+MAX(Height))/2 , 2) AS median_height,
       AVG(Height) AS average_height,
       ROUND(STDDEV(Height), 2) AS standerd_deviation_height
FROM athlete_info
GROUP BY Sex;

SELECT g.Sport,
       MIN(a.Height) AS minimal_height,
       MAX(a.Height) AS maximum_height,
       ROUND((MIN(a.Height)+MAX(a.Height))/2 , 2) AS median_height,
       AVG(a.Height) AS average_height,
       ROUND(STDDEV(a.Height), 2) AS standerd_deviation_height
FROM athlete_info AS a INNER JOIN event_table AS e ON a.ID = e.ID INNER JOIN game_info AS g ON e.Games = g.Games
GROUP BY g.Sport;

SELECT Sex,
       MIN(Weight) AS minimal_weight,
       MAX(Weight) AS maximum_weight,
       ROUND((MIN(Weight)+MAX(Weight))/2 , 2) AS median_weight,
       AVG(Weight) AS average_weight,
       ROUND(STDDEV(Weight), 2) AS standerd_deviation_weight
FROM athlete_info
GROUP BY Sex;

SELECT g.Sport,
       MIN(a.Weight) AS minimal_weight,
       MAX(a.Weight) AS maximum_weight,
       ROUND((MIN(a.Weight)+MAX(a.Weight))/2 , 2) AS median_weight,
       AVG(a.Weight) AS average_weight,
       ROUND(STDDEV(a.Weight), 2) AS standerd_deviation_weight
FROM athlete_info AS a INNER JOIN event_table AS e ON a.ID = e.ID INNER JOIN game_info AS g ON e.Games = g.Games
GROUP BY g.Sport;


WITH Medal_Counts AS (
    SELECT
        n.region AS Country_Name,
        a.NOC AS Country_Code,
        COUNT(a.Medal) AS Total_Medals
    FROM athlete_events a
    JOIN noc_regions n ON a.NOC = n.NOC -- Join to get the full country name
    WHERE a.Medal IS NOT NULL
    GROUP BY n.region, a.NOC
)
SELECT
    Country_Name,
    Country_Code,
    Total_Medals,
    ROUND(
        (Total_Medals / (SUM(Total_Medals) OVER()) * 100),
        2
    ) AS Percentage_of_Total_Medals
FROM Medal_Counts
ORDER BY Total_Medals DESC;

WITH Event_Stats AS (
    SELECT
        Event,
        Sport,
        COUNT(DISTINCT ID) AS Total_Unique_Athletes,
        COUNT(DISTINCT Games) AS Times_Event_Held,
        ROUND(COUNT(DISTINCT ID) / COUNT(DISTINCT Games), 2) AS Avg_Athletes_Per_Appearance
    FROM athlete_events
    GROUP BY Event, Sport
)
SELECT
    Event,
    Sport,
    Total_Unique_Athletes,
    Times_Event_Held,
    Avg_Athletes_Per_Appearance
FROM Event_Stats
WHERE Times_Event_Held > 0
ORDER BY Avg_Athletes_Per_Appearance DESC;


WITH Participation_By_Year AS (
    SELECT
    e.Games,
    Year,
    Season,
    COUNT(DISTINCT a.ID) AS Number_of_Athletes,
    COUNT(DISTINCT NOC) AS Number_of_Countries
FROM athlete_info AS a INNER JOIN event_table AS e ON a.ID = e.ID INNER JOIN game_info AS g ON e.Games = g.Games
GROUP BY
    Games, Year, Season
ORDER BY
    Year
)
SELECT
    Games,
    Year,
    Season,
    Number_of_Athletes,
    -- Use PARTITION BY Season to calculate growth within Summer/Winter separately
    Number_of_Athletes - LAG(Number_of_Athletes) OVER (PARTITION BY Season ORDER BY Year) AS Athlete_Growth,
    Number_of_Countries,
    Number_of_Countries - LAG(Number_of_Countries) OVER (PARTITION BY Season ORDER BY Year) AS Country_Growth
FROM
    Participation_By_Year
ORDER BY
    Season, Year;



--              Part 3 --

SELECT
    g.Sport,
    ROUND(AVG(NULLIF(a.Height, 0)), 2) AS Avg_Height,
    ROUND(MIN(NULLIF(a.Height, 0)), 2) AS Min_Height,
    ROUND(MAX(NULLIF(a.Height, 0)), 2) AS Max_Height,
    COUNT(a.ID) AS Athlete_Count
FROM athlete_info a
INNER JOIN event_table e ON a.ID = e.ID
INNER JOIN game_info g ON e.Games = g.Games
WHERE a.Height IS NOT NULL
  AND a.Height > 0
GROUP BY g.Sport
ORDER BY Avg_Height DESC;

SELECT
    g.Year,
    g.Season,
    COUNT(DISTINCT e.NOC) AS Number_of_Countries,
    -- Calculate growth from previous same-season games
    COUNT(DISTINCT e.NOC) - LAG(COUNT(DISTINCT e.NOC)) OVER (
        PARTITION BY g.Season
        ORDER BY g.Year
    ) AS Country_Growth
FROM event_table e
INNER JOIN game_info g ON e.Games = g.Games
GROUP BY g.Year, g.Season
ORDER BY g.Season, g.Year;


SELECT
    n.region AS Country_Name,
    SUM(CASE WHEN g.Season = 'Summer' THEN 1 ELSE 0 END) AS Summer_Medals,
    SUM(CASE WHEN g.Season = 'Winter' THEN 1 ELSE 0 END) AS Winter_Medals,
    SUM(CASE WHEN g.Season = 'Winter' THEN 1 ELSE 0 END) - SUM(CASE WHEN g.Season = 'Summer' THEN 1 ELSE 0 END) AS Winter_Minus_Summer
FROM athlete_info a
INNER JOIN event_table e ON a.ID = e.ID
INNER JOIN game_info g ON e.Games = g.Games
INNER JOIN noc_regions n ON e.NOC = n.NOC
WHERE a.Medal IS NOT NULL
GROUP BY n.region
HAVING Winter_Medals > 0 OR Summer_Medals > 0
ORDER BY Winter_Minus_Summer DESC;


WITH Event_Stats AS (
    SELECT
        g.Event,
        g.Sport,
        COUNT(DISTINCT e.ID) AS Total_Unique_Athletes,
        COUNT(DISTINCT g.Games) AS Times_Event_Held,
        -- Calculate the Competitive Density Index:
        ROUND(COUNT(DISTINCT e.ID) / COUNT(DISTINCT g.Games), 2) AS Competitive_Density_Index
    FROM event_table e
    INNER JOIN game_info g ON e.Games = g.Games
    GROUP BY g.Event, g.Sport
    HAVING Times_Event_Held >= 3 -- Filter for established events
)
SELECT
    Event,
    Sport,
    Total_Unique_Athletes,
    Times_Event_Held,
    Competitive_Density_Index
FROM Event_Stats
ORDER BY Competitive_Density_Index DESC
LIMIT 20;