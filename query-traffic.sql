CREATE TABLE traffic.webtraffic_staging LIKE traffic.traffic;

INSERT traffic.webtraffic_staging
SELECT *
FROM traffic.traffic;

-- Check the data type of each column
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'webtraffic_staging';

SELECT *
FROM webtraffic_staging
LIMIT 10;

-- Explore data and check data consistency
SELECT DISTINCT device_category
FROM traffic.webtraffic_staging;

SELECT DISTINCT browser
FROM traffic.webtraffic_staging
ORDER BY browser; -- Noticed potential inconsistencies for manual review or cleaning

-- These values usually correspond to the same browsers.
SELECT DISTINCT browser
FROM traffic.webtraffic_staging
WHERE browser LIKE '%Firefox%'
OR browser LIKE '%Mozilla%';

-- Identify the devices using Mozilla to distinguish them from Firefox.
SELECT DISTINCT device_category
FROM traffic.webtraffic_staging
WHERE browser LIKE '%Mozilla%';

SELECT DISTINCT device_category
FROM traffic.webtraffic_staging
WHERE browser LIKE '%Firefox%';

-- Mozilla and Firefox are generally considered the same browser. I would first confirm whether they should be treated as such; for now, let's keep them separate and address only clear formatting inconsistencies in this column.

SELECT DISTINCT browser
FROM traffic.webtraffic_staging
WHERE browser LIKE '%Mozilla%';

/* According to research, Mozilla Compatible Agent is not officially categorized as Mozilla.

(I would verify with the project lead before consolidating Mozilla/Firefox or other related values 
such as Opera/Opera Mini, PlayStation 3/PlayStation 4, and Safari/Safari (in-app).)

For now, we will leave them as separate entries and only resolve explicit formatting inconsistencies, 
like leading quotation marks.
*/

UPDATE traffic.webtraffic_staging
SET browser = 'Mozilla'
WHERE browser LIKE '%Mozilla';

-- Handle undefined values
UPDATE traffic.webtraffic_staging
SET browser = NULL
WHERE browser = '(not set)'
;

-- Counting null values in key columns to verify data quality.
SELECT COUNT(*) AS null_count
FROM traffic.webtraffic_staging
WHERE
	`date` IS NULL OR
	device_category IS NULL OR
	unique_visitors IS NULL OR
	sessions IS NULL OR
	bounce_rate IS NULL;

-- Review changes
SELECT DISTINCT browser
FROM traffic.webtraffic_staging
ORDER BY browser;

-- Final data check before analysis or reporting.
SELECT
	MIN(`date`) AS start_date,
	MAX(`date`) AS end_date,
	COUNT(DISTINCT device_category) AS device_count,
	count(DISTINCT browser) AS browser_count,
	MIN(unique_visitors) AS min_visitors,
	MAX(unique_visitors) AS max_visitors,
	MIN(sessions) AS min_sessions,
	MAX(sessions) AS max_sessions,
	MIN(bounce_rate) AS min_bounce,
	MAX(bounce_rate) AS max_bounce
FROM traffic.webtraffic_staging;

SELECT *
FROM traffic.webtraffic_staging;

-- Ready for exploration and visualization
