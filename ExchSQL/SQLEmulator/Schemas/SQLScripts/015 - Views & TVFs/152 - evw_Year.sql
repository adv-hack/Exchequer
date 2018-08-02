IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_Year]'))
DROP VIEW [!ActiveSchema!].[evw_Year]
GO

CREATE VIEW [!ActiveSchema!].evw_Year WITH VIEW_METADATA
AS
SELECT DISTINCT
       PeriodYear
     , ExchequerYear
     , YearStartDate
     , YearEndDate
FROM [!ActiveSchema!].evw_Period P
CROSS JOIN (SELECT SystemStartDate FROM [!ActiveSchema!].evw_SystemSettings) SS
CROSS APPLY ( SELECT YearStartDate = CONVERT(VARCHAR(8), PeriodYear)
                                   + RIGHT(CONVERT(VARCHAR(8), SystemStartDate, 112), 4)
            ) YSD
CROSS APPLY ( SELECT YearEndDate   = CONVERT(VARCHAR(8), DATEADD(DD, -1, DATEADD(YY, 1, CONVERT(DATE, YearStartDate))), 112)
            ) YED


GO

