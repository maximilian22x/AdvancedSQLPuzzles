/*********************************************************************
Scott Peters
Seating Chart
https://advancedsqlpuzzles.com
Last Updated: 07/05/2022

This script is written in SQL Server's T-SQL


� This puzzle can be solved by using window functions and LAG/LEAD
� The table #SeatingChart should be considered a numbers table with missing numbers

**********************************************************************/

--------------
--------------
--Tables Used
DROP TABLE IF EXISTS #SeatingChart;
GO

--------------
--------------
--Create and populate #SeatingChart
CREATE TABLE #SeatingChart
(
SeatNumber INTEGER PRIMARY KEY
);
GO

INSERT INTO #SeatingChart VALUES
(7),(13),(14),(15),(27),(28),(29),(30),(31),(32),(33),(34),(35),(52),(53),(54);
GO

--------------
--------------
--Place a value of 0 in the SeatingChart table
INSERT INTO #SeatingChart VALUES (0);
GO

--------------
--------------
--Gap start and gap end
SELECT  GapStart + 1 AS GapStart,
        GapEnd - 1 AS GapEnd
FROM
    (
    SELECT  SeatNumber AS GapStart,
        LEAD(SeatNumber,1,0) OVER (ORDER BY SeatNumber) AS GapEnd,
        LEAD(SeatNumber,1,0) OVER (ORDER BY SeatNumber) - SeatNumber AS Gap
    FROM #SeatingChart
    ) a
WHERE Gap > 1;

--Missing Numbers
WITH cte_Rank
AS
(
SELECT  SeatNumber,
        ROW_NUMBER() OVER (ORDER BY SeatNumber) AS RowNumber,
        SeatNumber - ROW_NUMBER() OVER (ORDER BY SeatNumber) AS Rnk
FROM    #SeatingChart
WHERE   SeatNumber > 0
)
SELECT MAX(Rnk) AS MissingNumbers FROM cte_Rank;

--Odd and even number count
SELECT  (CASE SeatNumber%2 WHEN 1 THEN 'Odd' WHEN 0 THEN 'Even' END) AS Modulus,
        COUNT(*) AS [Count]
FROM    #SeatingChart
GROUP BY (CASE SeatNumber%2 WHEN 1 THEN 'Odd' WHEN 0 THEN 'Even' END);
