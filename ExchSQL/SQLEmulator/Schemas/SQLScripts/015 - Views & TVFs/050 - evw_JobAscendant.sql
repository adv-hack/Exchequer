/****** Object:  View [!ActiveSchema!].[evw_JobAscendant]    Script Date: 01/22/2015 13:45:48 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_JobAscendant]'))
DROP VIEW [!ActiveSchema!].[evw_JobAscendant]
GO

/****** Object:  View [!ActiveSchema!].[evw_JobAscendant]    Script Date: 01/22/2015 13:45:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [!ActiveSchema!].[evw_JobAscendant]
AS
SELECT JH.JobCode
     , AscendantJobCode = JobHier.JobCode
     , JobHier.HierarchyLevel

FROM !ActiveSchema!.efn_JobHierarchy() JH
CROSS APPLY ( SELECT JobCode = Level0JobCode
                   , HierarchyLevel = 0
              UNION
              SELECT JobCode = Level1JobCode
                   , HierarchyLevel = 1
              UNION
              SELECT JobCode = Level2JobCode
                   , HierarchyLevel = 2
              UNION
              SELECT JobCode = Level3JobCode
                   , HierarchyLevel = 3
              UNION
              SELECT JobCode = Level4JobCode
                   , HierarchyLevel = 4
              UNION
              SELECT JobCode = Level5JobCode
                   , HierarchyLevel = 5
              UNION
              SELECT JobCode = Level6JobCode
                   , HierarchyLevel = 6
              UNION
              SELECT JobCode = Level7JobCode
                   , HierarchyLevel = 7
              UNION
              SELECT JobCode = Level8JobCode
                   , HierarchyLevel = 8
              UNION
              SELECT JobCode = Level9JobCode
                   , HierarchyLevel = 9
            ) JobHier ( JobCode
                      , HierarchyLevel )

WHERE JobHier.JobCode IS NOT NULL


GO


