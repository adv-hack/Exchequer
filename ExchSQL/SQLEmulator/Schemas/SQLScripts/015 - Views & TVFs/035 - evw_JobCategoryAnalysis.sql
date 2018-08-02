IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_JobCategoryAnalysis]'))
DROP VIEW [!ActiveSchema!].[evw_JobCategoryAnalysis]
GO

CREATE VIEW !ActiveSchema!.evw_JobCategoryAnalysis
AS
SELECT JobCode           = RTRIM(JobCode)

     , JC.CategoryHistoryId
     , JC.JobCategoryCode
     , JC.JobCategoryDescription

     , JobCategoryId     = AnalHed
     , AnalysisCode      = AnalCode
     , AnalysisHistoryId = HistFolio

     , IsRevenue         = CASE
                           WHEN JC.JobCategoryId = 1 THEN CONVERT(BIT, 1)
                           ELSE CONVERT(BIT, 0)
                           END

FROM   !ActiveSchema!.AnalysisCodeBudget
JOIN   !ActiveSchema!.evw_JobCategory JC ON AnalHed = JobCategoryId

GO

