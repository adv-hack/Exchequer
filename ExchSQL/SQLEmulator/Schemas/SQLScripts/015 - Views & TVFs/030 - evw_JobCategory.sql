
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_JobCategory]'))
DROP VIEW [!ActiveSchema!].[evw_JobCategory]
GO

CREATE VIEW !ActiveSchema!.evw_JobCategory
AS
SELECT JobCategoryId
     , JobCategoryCode = UPPER(CASE
                               WHEN JobCategoryDescription LIKE '[A-z]% %[0-z]% %[0-z]' THEN SUBSTRING(JobCategoryDescription, 1, 1)
                                                                                           + SUBSTRING(JobCategoryDescription, CHARINDEX(' ', JobCategoryDescription) + 1, 1)
                                                                                           + SUBSTRING(SUBSTRING(JobCategoryDescription, CHARINDEX(' ', JobCategoryDescription) + 1, 50), CHARINDEX(' ', SUBSTRING(JobCategoryDescription, CHARINDEX(' ', JobCategoryDescription) + 1, 50)) + 1, 1)
                               WHEN JobCategoryDescription LIKE '[A-z]% %[0-z]%'
                                AND JobCategoryDescription NOT LIKE '%(%'        THEN SUBSTRING(JobCategoryDescription, 1, 2) 
                                                                                    + SUBSTRING(JobCategoryDescription, CHARINDEX(' ', JobCategoryDescription) + 1, 1) 
                               ELSE SUBSTRING(JobCategoryDescription, 1, 3)
                               END)
     , JobCategoryDescription
     , CategoryHistoryId = CASE
                           WHEN JobCategoryId = 0 THEN 99
                           WHEN JobCategoryId BETWEEN 1 AND 6 THEN JobCategoryId * 10
                           WHEN JobCategoryId BETWEEN 7 AND 10 THEN (150 + ((JobCategoryId - 6) * 10))
                           WHEN JobCategoryId = 11 THEN 23
                           WHEN JobCategoryId = 12 THEN 53
                           WHEN JobCategoryId = 13 THEN 63
                           WHEN JobCategoryId = 14 THEN 14
                           WHEN JobCategoryId = 15 THEN 5
                           WHEN JobCategoryId = 16 THEN 173
                           WHEN JobCategoryId = 17 THEN 67
                           ELSE JobCategoryId
                           END
                           

FROM
(SELECT  ISNULL((rank() OVER (ORDER BY ColumnName)), 0) AS JobCategoryId
     ,  JobCategoryDescription   
FROM (  SELECT SummDesc01, SummDesc02, SummDesc03, SummDesc04, SummDesc05, SummDesc06,
			   SummDesc07, SummDesc08, SummDesc09, SummDesc10, SummDesc11, SummDesc12, SummDesc13,
			   SummDesc14, SummDesc15, SummDesc16, SummDesc17, SummDesc18, SummDesc19, SummDesc20
		FROM !ActiveSchema!.EXCHQSS
		WHERE SUBSTRING(CAST([IDCode] AS VARCHAR),2,4) = 'JOB'
		) AS p
		UNPIVOT
		(
			JobCategoryDescription FOR ColumnName IN 
			(
				SummDesc01, SummDesc02, SummDesc03, SummDesc04, SummDesc05, SummDesc06,
				SummDesc07, SummDesc08, SummDesc09, SummDesc10, SummDesc11, SummDesc12, SummDesc13,
				SummDesc14, SummDesc15, SummDesc16, SummDesc17, SummDesc18, SummDesc19, SummDesc20
			)
		)
	AS unpvt
WHERE JobCategoryDescription IS NOT NULL 
AND   JobCategoryDescription <> ''
UNION
SELECT JobCategoryId = 99
     , JobCategoryDesciption = SummDesc00
FROM !ActiveSchema!.EXCHQSS
WHERE SUBSTRING(CAST([IDCode] AS VARCHAR),2,4) = 'JOB') AS InitialCategory

GO