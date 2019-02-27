
DECLARE @StartDate DATE = '20190201', @NumberOfMonths INT =1;

-- prevent set or regional settings from interfering with 
-- interpretation of dates / literals

SET DATEFIRST 1;
SET DATEFORMAT mdy;
SET LANGUAGE US_ENGLISH;

DECLARE @CutoffDate DATE = DATEADD(MONTH, @NumberOfMonths, @StartDate);

Create Table #Calendar(
  [date]       DATE PRIMARY KEY, 
  [day]        AS DATEPART(DAY,      [date]),
  [dayName]    AS DATENAME(WEEKDAY,		 [date]),
  [month]      AS DATEPART(MONTH,    [date]),
  [MonthName]  AS DATENAME(MONTH,    [date]),
  [week]       AS DATEPART(WEEK,     [date]),
  [ISOweek]    AS DATEPART(ISO_WEEK, [date]),
  [DayOfWeek]  AS DATEPART(WEEKDAY,  [date]),
  [quarter]    AS DATEPART(QUARTER,  [date]),
  [year]       AS DATEPART(YEAR,     [date]),
  FirstOfMonth AS CONVERT(DATE, DATEADD(MONTH, DATEDIFF(MONTH, 0, [date]), 0)),

)

INSERT #Calendar([date]) 
SELECT d
FROM
(
  SELECT d = DATEADD(DAY, rn - 1, @StartDate)
  FROM 
  (
    SELECT TOP (DATEDIFF(DAY, @StartDate, @CutoffDate)) 
      rn = ROW_NUMBER() OVER (ORDER BY s1.[object_id])
    FROM sys.all_objects AS s1
    CROSS JOIN sys.all_objects AS s2
    -- on my system this would support > 5 million days
    ORDER BY s1.[object_id]
  ) AS x
) AS y;

select * from
(select [MonthName], [week],[day],[dayName],[FirstOfMonth] 
from #Calendar) as C
pivot(
	Max([day]) for [dayName] in ([Monday],[Tuesday],[Wednesday],[Thursday],[Friday],[Saturday],[Sunday]) 
) as p

order by FirstOfMonth asc
drop table #Calendar