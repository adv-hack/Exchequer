IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_CheckJobIntegrity]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].[esp_CheckJobIntegrity]
GO

CREATE PROCEDURE !ActiveSchema!.esp_CheckJobIntegrity
AS
BEGIN

DECLARE @IntegrityErrorTable  TABLE
      ( IntegrityErrorNo      INT
      , IntegrityErrorCode    VARCHAR(50)
      , IntegrityErrorMessage VARCHAR(max)
      , TableName             VARCHAR(100) NULL
      )

DECLARE @ErrorRowCount INT

-- Check for <blank> JobCode as this can cause circular hierarchies

INSERT INTO @IntegrityErrorTable
SELECT IntegrityErrorNo      = -50001
     , IntegrityErrorCode    = 'E_JOBINT001'
     , IntegrityErrorMessage = '<blank> Job Code exist.'
     , TableName             = '!ActiveSchema!.JOBHEAD'
FROM !ActiveSchema!.evw_Job
WHERE JobCode = ''

-- Check for lowercase Job Codes in DETAILS, JOBDET, JOBCTRL, AnalysisCodeBudget, JobHistory and JobCostingHistory

SELECT @ErrorRowCount = COUNT(*)
FROM   !ActiveSchema!.DETAILS
WHERE tlJobCode LIKE '%[abcdefghijklmnopqrstuvwqxyz]%' COLLATE LATIN1_General_CS_AS

IF @ErrorRowCount > 0
BEGIN
  INSERT INTO @IntegrityErrorTable
  SELECT IntegrityErrorNo      = -50002
       , IntegrityErrorCode    = 'E_JOBINT002'
       , IntegrityErrorMessage = CONVERT(VARCHAR, @ErrorRowCount) + ' Lowercase Job Code(s) exist in DETAILS.'
       , TableName             = '!ActiveSchema!.DETAILS'
  SET @ErrorRowCount = 0
END

SELECT @ErrorRowCount = COUNT(*)
FROM   !ActiveSchema!.evw_JobActual
WHERE  JobCode LIKE '%[abcdefghijklmnopqrstuvwqxyz]%' COLLATE LATIN1_General_CS_AS

IF @ErrorRowCount > 0
BEGIN
  INSERT INTO @IntegrityErrorTable
  SELECT IntegrityErrorNo      = -50003
       , IntegrityErrorCode    = 'E_JOBINT003'
       , IntegrityErrorMessage = CONVERT(VARCHAR, @ErrorRowCount) + ' Lowercase Job Code(s) exist in JOBDET.'
       , TableName             = '!ActiveSchema!.JOBDET'
  SET @ErrorRowCount = 0
END

SELECT @ErrorRowCount = COUNT(*)
FROM   !ActiveSchema!.AnalysisCodeBudget
WHERE  JobCode LIKE '%[abcdefghijklmnopqrstuvwqxyz]%' COLLATE LATIN1_General_CS_AS

IF @ErrorRowCount > 0
BEGIN
  INSERT INTO @IntegrityErrorTable
  SELECT IntegrityErrorNo      = -50004
       , IntegrityErrorCode    = 'E_JOBINT004'
       , IntegrityErrorMessage = CONVERT(VARCHAR, @ErrorRowCount) + ' Lowercase Job Code(s) exist in AnalysisCodeBudget.'
       , TableName             = '!ActiveSchema!.AnalysisCodeBudget'
  SET @ErrorRowCount = 0
END

SELECT @ErrorRowCount = COUNT(*)
FROM   !ActiveSchema!.evw_JobHistory
WHERE  JobCode LIKE '%[abcdefghijklmnopqrstuvwqxyz]%' COLLATE LATIN1_General_CS_AS

IF @ErrorRowCount > 0
BEGIN
  INSERT INTO @IntegrityErrorTable
  SELECT IntegrityErrorNo      = -50005
       , IntegrityErrorCode    = 'E_JOBINT005'
       , IntegrityErrorMessage = CONVERT(VARCHAR, @ErrorRowCount) + ' Lowercase Job Code(s) exist in JobHistory.'
       , TableName             = '!ActiveSchema!.HISTORY'
  SET @ErrorRowCount = 0
END

SELECT @ErrorRowCount = COUNT(*)
FROM   !ActiveSchema!.evw_JobActual
WHERE  JobCode LIKE '%[abcdefghijklmnopqrstuvwqxyz]%' COLLATE LATIN1_General_CS_AS

IF @ErrorRowCount > 0
BEGIN
  INSERT INTO @IntegrityErrorTable
  SELECT IntegrityErrorNo      = -50006
       , IntegrityErrorCode    = 'E_JOBINT006'
       , IntegrityErrorMessage = CONVERT(VARCHAR, @ErrorRowCount) + ' Lowercase Job Code(s) exist in JobCostingHistory.'
       , TableName             = '!ActiveSchema!.HISTORY'
  SET @ErrorRowCount = 0
END

SELECT @ErrorRowCount = COUNT(*)
FROM   !ActiveSchema!.evw_JobStockBudget
WHERE  JobCode LIKE '%[abcdefghijklmnopqrstuvwqxyz]%' COLLATE LATIN1_General_CS_AS

IF @ErrorRowCount > 0
BEGIN
  INSERT INTO @IntegrityErrorTable
  SELECT IntegrityErrorNo      = -50008
       , IntegrityErrorCode    = 'E_JOBINT008'
       , IntegrityErrorMessage = CONVERT(VARCHAR, @ErrorRowCount) + ' Lowercase Job Code(s) exist in JobStockBudget.'
       , TableName             = '!ActiveSchema!.JOBCTRL'
  SET @ErrorRowCount = 0
END

-- Check for multiple entries in AnalysisCodeBudget for JobCode/AnalysisCode combination
SELECT @ErrorRowCount = COUNT(*)
FROM (SELECT JobCode
           , AnalCode
           , RowCounter = COUNT(*)
      FROM !ActiveSchema!.AnalysisCodeBudget
      GROUP BY JobCode
            , AnalCode
      HAVING COUNT(*) > 1) ACBData

IF @ErrorRowCount > 0
BEGIN
  INSERT INTO @IntegrityErrorTable
  SELECT IntegrityErrorNo      = -50007
       , IntegrityErrorCode    = 'E_JOBINT007'
       , IntegrityErrorMessage = CONVERT(VARCHAR, @ErrorRowCount) + ' JobCode/AnalysisCode combination that has multiple entries in AnalysisCodeBudget.'
       , TableName             = '!ActiveSchema!.AnalysisCodeBudget'
  SET @ErrorRowCount = 0
END

-- Check for multiple entries in AnalysisCodeBudget for JobCode/HistFolio combination
SELECT @ErrorRowCount = COUNT(*)
FROM (SELECT JobCode
           , HistFolio
           , RowCounter = COUNT(*)
      FROM !ActiveSchema!.AnalysisCodeBudget
      GROUP BY JobCode
            , HistFolio
      HAVING COUNT(*) > 1) ACBData

IF @ErrorRowCount > 0
BEGIN
  INSERT INTO @IntegrityErrorTable
  SELECT IntegrityErrorNo      = -50008
       , IntegrityErrorCode    = 'E_JOBINT008'
       , IntegrityErrorMessage = CONVERT(VARCHAR, @ErrorRowCount) + ' JobCode/HistFolio combination that has multiple entries in AnalysisCodeBudget.'
       , TableName             = '!ActiveSchema!.AnalysisCodeBudget'
  SET @ErrorRowCount = 0
END


IF (SELECT COUNT(*) FROM @IntegrityErrorTable) = 0
BEGIN
  INSERT INTO @IntegrityErrorTable
  SELECT IntegrityErrorNo      = 0
       , IntegrityErrorCode    = 'I_NOERRORS'
       , IntegrityErrorMessage = 'There are no Job data integrity errors.'
       , TableName             = NULL
END

SELECT *
FROM @IntegrityErrorTable

END
GO