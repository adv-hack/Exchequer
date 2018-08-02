IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[efn_JobHierarchy]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [!ActiveSchema!].[efn_JobHierarchy]
GO

CREATE FUNCTION !ActiveSchema!.efn_JobHierarchy ()
RETURNS @JobHierarchy TABLE 
                    ( JobId          INT PRIMARY KEY
                    , JobCode        VARCHAR(10)
                    , ParentJobId    INT         NULL
                    , ParentJobCode  VARCHAR(10) NULL
                    , JobHierarchy   VARCHAR(500)
                    , HierarchyLevel INT
                    , Level0JobCode  VARCHAR(10) NULL
                    , Level1JobCode  VARCHAR(10) NULL
                    , Level2JobCode  VARCHAR(10) NULL
                    , Level3JobCode  VARCHAR(10) NULL
                    , Level4JobCode  VARCHAR(10) NULL
                    , Level5JobCode  VARCHAR(10) NULL
                    , Level6JobCode  VARCHAR(10) NULL
                    , Level7JobCode  VARCHAR(10) NULL
                    , Level8JobCode  VARCHAR(10) NULL
                    , Level9JobCode  VARCHAR(10) NULL
                    )
AS
BEGIN

DECLARE @ThisLevel INT = 0
      , @Rows      INT = 1

-- Insert TOP Level Jobs

INSERT INTO @JobHierarchy
          ( JobId
          , JobCode
          , ParentJobId
          , ParentJobCode
          , JobHierarchy
          , HierarchyLevel
          , Level0JobCode
          )
SELECT JobId
     , JobCode
     , ParentJobId
     , ParentJobCode  = CONVERT(VARCHAR(50), '')
     , JobHierarchy   = CONVERT(VARCHAR(max), '~' + JobCode + '~')
     , HierarchyLevel = 0
     , Level0JobCode  = JobCode
FROM   !ActiveSchema!.evw_Job J
WHERE  ISNULL(J.ParentJobId, 0) = 0

SELECT @Rows = @@ROWCOUNT

WHILE @ThisLevel < 10 AND @Rows > 0
BEGIN

  SET @ThisLevel = @ThisLevel + 1

  INSERT INTO @JobHierarchy
  SELECT J.JobId
       , J.JobCode
       , J.ParentJobId
       , ParentJobCode  = CONVERT(VARCHAR(50), JH.JobCode)
       , JobHierarchy   = JH.JobHierarchy + CONVERT(VARCHAR(max), J.JobCode + '~')
       , HierarchyLevel = @ThisLevel
       , Level0JobCode  = JH.Level0JobCode
       , Level1JobCode  = CASE 
                          WHEN @ThisLevel = 1 THEN J.JobCode
                          ELSE JH.Level1JobCode
                          END
       , Level2JobCode  = CASE 
                          WHEN @ThisLevel = 2 THEN J.JobCode
                          ELSE JH.Level2JobCode
                          END
       , Level3JobCode  = CASE 
                          WHEN @ThisLevel = 3 THEN J.JobCode
                          ELSE JH.Level3JobCode
                          END
       , Level4JobCode  = CASE 
                          WHEN @ThisLevel = 4 THEN J.JobCode
                          ELSE JH.Level4JobCode
                          END
       , Level5JobCode  = CASE 
                          WHEN @ThisLevel = 5 THEN J.JobCode
                          ELSE JH.Level5JobCode
                          END
       , Level6JobCode  = CASE 
                          WHEN @ThisLevel = 6 THEN J.JobCode
                          ELSE JH.Level6JobCode
                          END
       , Level7JobCode  = CASE 
                          WHEN @ThisLevel = 7 THEN J.JobCode
                          ELSE JH.Level7JobCode
                          END
       , Level8JobCode  = CASE 
                          WHEN @ThisLevel = 8 THEN J.JobCode
                          ELSE JH.Level8JobCode
                          END
       , Level9JobCode  = CASE 
                          WHEN @ThisLevel = 9 THEN J.JobCode
                          ELSE JH.Level9JobCode
                          END
       
  FROM   !ActiveSchema!.evw_Job J
  JOIN   @JobHierarchy JH ON JH.JobId = J.ParentJobId
  WHERE  JH.HierarchyLevel = @ThisLevel - 1

  SET @Rows = @@ROWCOUNT

END

RETURN

END

GO