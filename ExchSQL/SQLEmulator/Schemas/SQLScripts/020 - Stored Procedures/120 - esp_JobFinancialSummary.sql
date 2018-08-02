IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_JobFinancialSummary]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].[esp_JobFinancialSummary]
GO

CREATE PROCEDURE !ActiveSchema!.esp_JobFinancialSummary (@iv_JobCode VARCHAR(50) = '')
AS
BEGIN

  SET NOCOUNT ON;

  -- Create Temp. Job Table

    IF OBJECT_ID('tempdb..#JobList') IS NOT NULL
  DROP TABLE #JobList

  CREATE TABLE #JobList
             ( JobCode VARCHAR(10) )

  INSERT INTO #JobList
  SELECT DISTINCT DescendantJobCode
  FROM   !ActiveSchema!.evw_JobDescendant JD
  WHERE  JD.JobCode = @iv_jobCode
  OR     ISNULL(@iv_JobCode, '') = ''

  IF OBJECT_ID('tempdb..#JobFinSumm') IS NOT NULL
  DROP TABLE #JobFinSumm

  CREATE TABLE #JobFinSumm
             ( JobCode                    VARCHAR(10) 
             , CategoryHistoryId          INT
             , JobCategoryCode            VARCHAR(10)     NULL
             , JobCategoryDescription     VARCHAR(50)     NULL
             , AnalysisHistoryId          INT
             , JobAnalysisCode            VARCHAR(10)     NULL
             , JobAnalysisDescription     VARCHAR(50)     NULL
             , OriginalBudgetAmountInBase NUMERIC(24, 10) NULL
             , RevisedBudgetAmountInBase  NUMERIC(24, 10) NULL
             , OriginalBudgetQuantity     NUMERIC(24, 10) NULL
             , RevisedBudgetQuantity      NUMERIC(24, 10) NULL
             , ActualAmountInBase         NUMERIC(24, 10) NULL
             , Variance                   NUMERIC(24, 10) NULL
             UNIQUE CLUSTERED (JobCode, CategoryHistoryId, AnalysisHistoryId )
             )

  INSERT INTO #JobFinSumm
            ( JobCode
            , CategoryHistoryId
            , JobCategoryCode
            , JobCategoryDescription
            , AnalysisHistoryId
            , JobAnalysisCode
            , JobAnalysisDescription
            )
     SELECT   JT.JobCode
            , JT.CategoryHistoryId
            , JT.JobCategoryCode
            , JT.JobCategoryDescription
            , JT.AnalysisHistoryId
            , JT.JobAnalysisCode
            , JT.JobAnalysisDescription

     FROM     !ActiveSchema!.evw_JobTree JT
     JOIN   !ActiveSchema!.evw_Job J ON J.JobCode = JT.JobCode
     JOIN   #JobList JL ON JL.JobCode = JT.JobCode COLLATE Latin1_General_CI_AS
     --WHERE  J.JobStat = 2  -- Active Jobs Only


  -- Update Budgets
  UPDATE JFS
     SET OriginalBudgetAmountInBase = COALESCE(JAB.OriginalBudgetAmountInBase, JCB.OriginalBudgetAmountInBase, 0)
       , RevisedBudgetAmountInBase  = COALESCE(JAB.RevisedBudgetAmountInBase, JCB.RevisedBudgetAmountInBase, 0)
       , OriginalBudgetQuantity     = COALESCE(JAB.OriginalBudgetQuantity, JCB.OriginalBudgetQuantity, 0)
       , RevisedBudgetQuantity      = COALESCE(JAB.RevisedBudgetQuantity, JCB.RevisedBudgetQuantity, 0)
       -- SELECT JFS.*
  FROM #JobFinSumm JFS
  LEFT JOIN !ActiveSchema!.evw_JobAnalysisBudgets JAB ON JAB.JobCode           = JFS.JobCode           COLLATE Latin1_General_CI_AS
                                             AND JAB.CategoryHistoryId = JFS.CategoryHistoryId
                                             AND JAB.AnalysisHistoryId = JFS.AnalysisHistoryId
                                             AND (JAB.OriginalBudgetAmount <> 0
                                              OR  JAB.RevisedBudgetAmount  <> 0
                                                 )

  LEFT JOIN !ActiveSchema!.evw_JobCategoryBudgets JCB ON JCB.JobCode           = JFS.JobCode           COLLATE Latin1_General_CI_AS
                                             AND JCB.JobCategoryId     = JFS.CategoryHistoryId
                                             AND NOT EXISTS (SELECT TOP 1 1
                                                             FROM   !ActiveSchema!.evw_JobAnalysisBudgets JAB1
                                                             WHERE JAB1.JobCode           = JCB.JobCode
                                                             AND   JAB1.CategoryHistoryId = JCB.JobCategoryId
                                                            )
                                             AND (JCB.OriginalBudgetAmount <> 0
                                              OR  JCB.RevisedBudgetAmount  <> 0
                                                 )
  -- Update Actuals

  UPDATE JFS
     SET ActualAmountInBase = ISNULL(JH.BalanceAmount, 0)
       , Variance           = ISNULL(JH.BalanceAmount, 0)
                            - CASE
                                WHEN RevisedBudgetAmountInBase = 0 THEN OriginalBudgetAmountInBase
                              ELSE RevisedBudgetAmountInBase
                              END
  FROM   #JobFinSumm JFS
  CROSS JOIN !ActiveSchema!.evw_SystemSettings SS
  JOIN   !ActiveSchema!.evw_JobHistory JH ON JH.JobCode           = JFS.JobCode              COLLATE Latin1_General_CI_AS
                                 AND JH.AnalysisHistoryId = JFS.AnalysisHistoryId
                                 AND JH.CurrencyId        = 0
                                 AND JH.HistoryPeriod     = 255
                                 AND JH.HistoryYear       = SS.CurrentYear
                                 AND   (JFS.AnalysisHistoryId >= 1000 --   IS NOT NULL
                                 OR     JH.AnalysisHistoryId IN (5, 99, 170, 173)
                                       )

  SELECT JFS.JobCode
       , DisplayJobCode = SPACE(JH.HierarchyLevel * 2) + JFS.JobCode
       , JFS.CategoryHistoryId
       , JFS.JobCategoryCode
       , JFS.JobCategoryDescription
       , JFS.AnalysisHistoryId
       , JFS.JobAnalysisCode
       , JFS.JobAnalysisDescription

       , J.JobDescription
       , J.JobManager
       , JH.JobHierarchy

       , JFS.OriginalBudgetAmountInBase
       , JFS.OriginalBudgetQuantity

       , JFS.RevisedBudgetAmountInBase
       , JFS.RevisedBudgetQuantity

       , JFS.ActualAmountInBase

       , JFS.Variance

  FROM #JobFinSumm JFS
  JOIN !ActiveSchema!.evw_Job J           ON JFS.JobCode = J.JobCode  COLLATE Latin1_General_CI_AS
  JOIN !ActiveSchema!.evw_JobHierarchy JH ON JFS.JobCode = JH.JobCode COLLATE Latin1_General_CI_AS

  ORDER BY JH.JobHierarchy
         , JFS.CategoryHistoryId
         , JFS.AnalysisHistoryId

END

GO