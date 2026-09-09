/* Cleaning the data */

SELECT COUNT(ID) AS events_rows
FROM athlete_events;
/* NB of rows 2066 in the event table */

SELECT COUNT(NOC) AS regions_rows
FROM noc_regions;
/* NB of rows 230 in the region table */

SELECT COUNT(DISTINCT ID, Name, Sex, Age, Height, Weight, Team, NOC, Games, Year, Season, City, Sport, Event, Medal) AS events_rows_unique
FROM athlete_events;
/* No duplicate in the events table */

SELECT COUNT(DISTINCT NOC, region, notes)
FROM noc_regions
/* No duplicate in the regions' table */

