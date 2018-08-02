
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_JobAnalysis]'))
DROP VIEW [!ActiveSchema!].[evw_JobAnalysis]
GO

CREATE VIEW [!ActiveSchema!].evw_JobAnalysis
AS
SELECT  JobAnalysisId               = J.PositionId
      , JobAnalysisCode             = J.var_code1Trans1
      , JobAnalysisDescription      = J.JAName
      , JobAnalysisCategoryId       = J.AnalHed
      , JobAnalysisTypeId           = J.JAType

FROM [!ActiveSchema!].JOBMISC J

WHERE J.RecPfix = 'J'
AND   J.SubType = 'A'

GO