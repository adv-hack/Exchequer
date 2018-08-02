IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[efn_JobTree]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [!ActiveSchema!].[efn_JobTree]
GO

CREATE FUNCTION [!ActiveSchema!].[efn_JobTree] ()
RETURNS @JobTree TABLE 
               ( JobCode                VARCHAR(10)
               , CategoryHistoryId      INT          NULL
               , JobCategoryCode        VARCHAR(10)  NULL
               , JobCategoryDescription VARCHAR(50)  NULL
               , AnalysisHistoryId      INT          NULL
			   , JobAnalysisCode        VARCHAR(10)  NULL
			   , JobAnalysisDescription VARCHAR(50)  NULL
			   , IsRevenue              BIT
			     UNIQUE CLUSTERED (JobCode, CategoryHistoryId, AnalysisHistoryId)
               )
AS
BEGIN

INSERT INTO @JobTree
SELECT JCAT.JobCode
     , JCAT.CategoryHistoryId
     , JC.JobCategoryCode
     , JC.JobCategoryDescription
     
     , JCAT.AnalysisHistoryId
     , JA.JobAnalysisCode
     , JA.JobAnalysisDescription

     , IsRevenue = CASE
                   WHEN JC.JobCategoryId = 1 THEN CONVERT(BIT, 1)
                   ELSE CONVERT(BIT, 0)
                   END

FROM (
SELECT JCA.JobCode
     , JCA.CategoryHistoryId
     , JCA.AnalysisHistoryId
FROM !ActiveSchema!.evw_JobCategoryAnalysis JCA

UNION
SELECT DISTINCT
       J.JobCode
	 , CH.CategoryHistoryId
	 , AnalysisHistoryId = CH.CategoryHistoryId
FROM !ActiveSchema!.evw_Job J
CROSS JOIN (SELECT *
            FROM ( VALUES  (5)
                         , (99)
                         , (170)
                         , (173)
                  ) CH (CategoryHistoryId)
           ) CH
--SELECT DISTINCT
--       JobCode
--	 , CategoryHistoryId = AnalysisHistoryId
--	 , AnalysisHistoryId
--FROM !ActiveSchema!.evw_JobHistory
--WHERE AnalysisHistoryId < 1000

) JCAT
LEFT JOIN !ActiveSchema!.evw_JobCategory JC ON JCAT.CategoryHistoryId = JC.CategoryHistoryId
LEFT JOIN !ActiveSchema!.evw_JobCategoryAnalysis JCAN ON JCAT.JobCode           = JCAN.JobCode
                                             AND JCAT.AnalysisHistoryId = JCAN.AnalysisHistoryId
LEFT JOIN !ActiveSchema!.evw_JobAnalysis JA ON JCAN.AnalysisCode = JA.JobAnalysisCode

RETURN

END
GO