


IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_JobDescendant]'))
DROP VIEW [!ActiveSchema!].[evw_JobDescendant]
GO

CREATE VIEW !ActiveSchema!.evw_JobDescendant 
AS
SELECT JH.JobCode
     , DescendantJobCode = JHC.JobCode
	 , JHC.HierarchyLevel
FROM !ActiveSchema!.evw_JobHierarchy JH
LEFT JOIN !ActiveSchema!.evw_JobHierarchy JHC ON JHC.JobHierarchy LIKE (JH.JobHierarchy + '%')
--ORDER BY JH.JobCode
--       , JHC.HierarchyLevel
--	   , DescendentJobCode

GO



