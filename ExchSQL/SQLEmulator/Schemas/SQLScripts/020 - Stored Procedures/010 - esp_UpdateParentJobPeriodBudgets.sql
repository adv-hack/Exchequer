IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_UpdateParentJobPeriodBudgets]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].[esp_UpdateParentJobPeriodBudgets]
GO

CREATE PROCEDURE !ActiveSchema!.esp_UpdateParentJobPeriodBudgets
AS
BEGIN

  SET NOCOUNT ON;

  -- Period Budgets Rollup

  -- 1st Pass - zero out Contract Budget Values

  UPDATE H
     SET hiBudget         = 0
       , hiRevisedBudget1 = 0
       , hiRevisedBudget2 = 0
       , hiRevisedBudget3 = 0
       , hiRevisedBudget4 = 0
       , hiRevisedBudget5 = 0
       , hiValue1         = 0
       , hiValue2         = 0

  FROM !ActiveSchema!.HISTORY H
  WHERE CHAR(hiExClass) = 'K'
  AND  (hiBudget         <> 0
   OR   hiRevisedBudget1 <> 0
   OR   hiRevisedBudget2 <> 0
   OR   hiRevisedBudget3 <> 0
   OR   hiRevisedBudget4 <> 0
   OR   hiRevisedBudget5 <> 0
   OR   hiValue1         <> 0
   OR   hiValue2         <> 0
       )

  IF OBJECT_ID('tempdb..#JobBudgets') IS NOT NULL
     DROP TABLE #JobBudgets

  CREATE TABLE #JobBudgets
             ( JobCode                VARCHAR(10)
             , JobLevel               INT
             , CurrencyId             INT
             , AnalysisHistoryId      INT         NULL
             , AnalysisCode           VARCHAR(50) NULL
             , ExchequerYear          INT
             , HistoryPeriod          INT
             , OriginalBudgetAmount   FLOAT
             , RevisedBudgetAmount1   FLOAT
             , RevisedBudgetAmount2   FLOAT
             , RevisedBudgetAmount3   FLOAT
             , RevisedBudgetAmount4   FLOAT
             , RevisedBudgetAmount5   FLOAT

             , OriginalBudgetQuantity FLOAT
             , RevisedBudgetQuantity  FLOAT

             , HistoryPositionId      INT           NULL
             , HistoryCode            VARBINARY(21) NULL
             )

  -- Need Analysis Code as the parent record may not necessarily have the same AnalysisHistoryId as child for that Code.

  INSERT INTO #JobBudgets
  SELECT JH.JobCode
       , JobLevel = 0
       , JH.CurrencyId
       , JH.AnalysisHistoryId
       , JCA.AnalysisCode
       , JH.ExchequerYear
       , JH.HistoryPeriod

       , OriginalBudgetAmount  
       , RevisedBudgetAmount1    
       , RevisedBudgetAmount2 
       , RevisedBudgetAmount3 
       , RevisedBudgetAmount4 
       , RevisedBudgetAmount5 

       , OriginalBudgetQuantity  
       , RevisedBudgetQuantity

       , HistoryPositionId
       , HistoryCode

  FROM   !ActiveSchema!.evw_JobHistory JH
  LEFT JOIN !ActiveSchema!.evw_JobCategoryAnalysis JCA ON JH.JobCode           = JCA.JobCode
                                                      AND JH.AnalysisHistoryId = JCA.AnalysisHistoryId
  WHERE HistoryClassificationCode = 'J'
  AND   JH.HistoryPeriod < 250
  AND ( OriginalBudgetAmount   <> 0
    OR  RevisedBudgetAmount1   <> 0
    OR  RevisedBudgetAmount2   <> 0
    OR  RevisedBudgetAmount3   <> 0
    OR  RevisedBudgetAmount4   <> 0
    OR  RevisedBudgetAmount5   <> 0
    OR  OriginalBudgetQuantity <> 0
    OR  RevisedBudgetQuantity  <> 0)

  CREATE NONCLUSTERED INDEX idx_jobBudgets ON #JobBudgets(JobCode, JobLevel) 
         INCLUDE ( CurrencyId
                 , AnalysisHistoryId
                 , AnalysisCode
                 , ExchequerYear
                 , HistoryPeriod
                 , OriginalBudgetAmount
                 , RevisedBudgetAmount1
                 , RevisedBudgetAmount2
                 , RevisedBudgetAmount3
                 , RevisedBudgetAmount4
                 , RevisedBudgetAmount5
                 , OriginalBudgetQuantity  
                 , RevisedBudgetQuantity 
                 );

  DECLARE @rcount   INT = 1
        , @JobLevel INT = 1

  WHILE @rcount > 0
  BEGIN

    INSERT INTO #JobBudgets
    SELECT JobCode = JA.ParentJobCode
            , JobLevel = @JobLevel
            , JPB.CurrencyId
            , AnalysisHistoryId     = CASE
                                      WHEN JPB.AnalysisHistoryId >= 1000 THEN NULL
                                      ELSE JPB.AnalysisHistoryId
                                      END
            , JPB.AnalysisCode
            , JPB.ExchequerYear
            , JPB.HistoryPeriod
     
            , OriginalBudget         = SUM(JPB.OriginalBudgetAmount)
            , RevisedBudget1         = SUM(JPB.RevisedBudgetAmount1)
            , RevisedBudget2         = SUM(JPB.RevisedBudgetAmount2)
            , RevisedBudget3         = SUM(JPB.RevisedBudgetAmount3)
            , RevisedBudget4         = SUM(JPB.RevisedBudgetAmount4)
            , RevisedBudget5         = SUM(JPB.RevisedBudgetAmount5)

            , OriginalBudgetQuantity = SUM(JPB.OriginalBudgetQuantity)
            , RevisedBudgetQuantity  = SUM(JPB.RevisedBudgetQuantity)

            , HistoryPositionId      = NULL
            , HistoryCode            = NULL
            --, HistoryCode = CAST(0x14 + CONVERT(VARBINARY(21), JA.ParentJobCode + SPACE(10 - LEN(JA.ParentJobCode)) ) 
            --                          + CONVERT(VARBINARY(21), REVERSE(CONVERT(VARBINARY(4), JCA.AnalysisHistoryId)))
            --                          + CONVERT(VARBINARY(21), SPACE(6) ) AS VARBINARY(21))

       FROM #JobBudgets JPB
       JOIN !ActiveSchema!.evw_JobHierarchy JA ON JPB.JobCode = JA.JobCode COLLATE Latin1_General_CI_AS

       WHERE JPB.JobLevel       = @JobLevel - 1
       AND   JA.ParentJobCode <> ''
       GROUP BY JA.ParentJobCode
              , CASE
                WHEN JPB.AnalysisHistoryId >= 1000 THEN NULL
                ELSE JPB.AnalysisHistoryId
                END
              , JPB.AnalysisCode
              , JPB.CurrencyId
              , JPB.ExchequerYear
              , JPB.HistoryPeriod

    SET @rcount = @@ROWCOUNT
    SET @JobLevel = @JobLevel + 1

  END

  -- Add AnalysisCodeBudget records for parents/analysiscode combination
  INSERT INTO !ActiveSchema!.AnalysisCodeBudget
          ( AnalCode
          , HistFolio
          , JobCode
          , StockCode
          , BType
          , ReCharge
          , OverCost
          , UnitPrice
          , BoQty
          , BRQty
          , BoValue
          , BRValue
          , CurrBudg
          , PayRMode
          , CurrPType
          , AnalHed
          , OrigValuation
          , RevValuation
          , JBUpliftP
          , JAPcntApp
          , JABBasis
          , JBudgetCurr
          )
  SELECT AnalysisCode
     , HistFolio = ROW_NUMBER () OVER (PARTITION BY JobCode ORDER BY AnalysisCode)
                 + ISNULL((SELECT MAX(HistFolio)
                          FROM   !ActiveSchema!.AnalysisCodeBudget ACB 
                          WHERE  ACBData.JobCode = ACB.JobCode COLLATE Latin1_General_CI_AS), 1000)
     , JobCode
     , StockCode  = ''
     , BType
     , ReCharge   = 1
     , OverCost   = 0
     , UnitPrice  = 0
     , BoQty      = 0
     , BRQty      = 0
     , BoValue    = 0
     , BRValue    = 0
     , CurrBudg   = 0
     , PayRMode   = 0
     , CurrPType  = 0
     , AnalHed
     , OrigValuation = 0
     , RevValuation  = 0
     , JBUpliftP     = 0
     , JAPcntApp     = 0
     , JABBasis      = 0
     , JBudgetCurr   = 0
  FROM (SELECT DISTINCT 
               JobCode
             , AnalysisCode
             , BType        = JobAnalysisTypeId
             , AnalHed      = JobAnalysisCategoryId

        FROM #JobBudgets JB
        LEFT JOIN !ActiveSchema!.evw_JobAnalysis JA ON JA.JobAnalysisCode = JB.AnalysisCode COLLATE Latin1_General_CI_AS
        WHERE AnalysisHistoryId is null
        AND   AnalysisCode is not null ) ACBData
  WHERE NOT EXISTS (SELECT TOP 1 1
                    FROM   !ActiveSchema!.AnalysisCodeBudget A
                    WHERE  A.JobCode  = ACBData.JobCode      COLLATE Latin1_General_CI_AS
                    AND    A.AnalCode = ACBData.AnalysisCode COLLATE Latin1_General_CI_AS)
  ORDER BY JobCode
         , AnalysisCode

  -- Set the History Id for that JobCode/AnalysisCode combination

  UPDATE JBH
     SET AnalysisHistoryId = JCA.AnalysisHistoryId
  FROM #JobBudgets JBH
  JOIN !ActiveSchema!.evw_JobCategoryAnalysis JCA ON JCA.JobCode      = JBH.JobCode      COLLATE Latin1_General_CI_AS
                                         AND JCA.AnalysisCode = JBH.AnalysisCode COLLATE Latin1_General_CI_AS
  WHERE JBH.AnalysisHistoryId IS NULL

  -- Remove unnecessary Budgets 
  DELETE
  FROM #JobBudgets
  WHERE AnalysisHistoryId is null

  -- Update Position Id/History Codes if they exist

  UPDATE JB
     SET HistoryPositionId = JH.HistoryPositionId
       , HistoryCode = CAST(0x14 + CONVERT(VARBINARY(21), JB.JobCode + SPACE(10 - LEN(JB.JobCode)) ) 
                                 + CONVERT(VARBINARY(21), REVERSE(CONVERT(VARBINARY(4), JB.AnalysisHistoryId)))
                                 + CONVERT(VARBINARY(21), SPACE(6) ) AS VARBINARY(21))
  FROM #JobBudgets JB
  LEFT JOIN !ActiveSchema!.evw_JobHistory JH ON JH.JobCode           = JB.JobCode COLLATE Latin1_General_CI_AS
                                    AND JH.AnalysisHistoryId = JB.AnalysisHistoryId
                                    AND JH.CurrencyId        = JB.CurrencyId
                                    AND JH.HistoryPeriod     = JB.HistoryPeriod
                                    AND JH.ExchequerYear     = JB.ExchequerYear

  WHERE JB.JobLevel > 0

  -- Update Parent Level Budgets if they exist

  UPDATE H
     SET hiBudget         = ISNULL(OriginalBudgetAmount, 0.0)
       , hiRevisedBudget1 = ISNULL(RevisedBudgetAmount1, 0.0)
       , hiRevisedBudget2 = ISNULL(RevisedBudgetAmount2, 0.0)
       , hiRevisedBudget3 = ISNULL(RevisedBudgetAmount3, 0.0)
       , hiRevisedBudget4 = ISNULL(RevisedBudgetAmount4, 0.0)
       , hiRevisedBudget5 = ISNULL(RevisedBudgetAmount5, 0.0)
       , hiValue1         = ISNULL(OriginalBudgetQuantity, 0.0)
       , hiValue2         = ISNULL(RevisedBudgetQuantity, 0.0)

  FROM   !ActiveSchema!.HISTORY H 
  LEFT JOIN (SELECT HistoryPositionId
                  , OriginalBudgetAmount   = SUM(ISNULL(OriginalBudgetAmount, 0.0))
                  , RevisedBudgetAmount1   = SUM(ISNULL(RevisedBudgetAmount1, 0.0))
                  , RevisedBudgetAmount2   = SUM(ISNULL(RevisedBudgetAmount2, 0.0))
                  , RevisedBudgetAmount3   = SUM(ISNULL(RevisedBudgetAmount3, 0.0))
                  , RevisedBudgetAmount4   = SUM(ISNULL(RevisedBudgetAmount4, 0.0))
                  , RevisedBudgetAmount5   = SUM(ISNULL(RevisedBudgetAmount5, 0.0))
                  , OriginalBudgetQuantity = SUM(ISNULL(OriginalBudgetQuantity, 0.0))
                  , RevisedBudgetQuantity  = SUM(ISNULL(RevisedBudgetQuantity, 0.0))
             FROM #JobBudgets
             WHERE JobLevel > 0
             GROUP BY HistoryPositionId) JB ON H.PositionId = JB.HistoryPositionId
  WHERE H.hiExCLass = ASCII('K')
    AND H.hiPeriod < 250
    AND ( ROUND(H.hiBudget         - ISNULL(JB.OriginalBudgetAmount, 0), 6)   <> 0.0
     OR   ROUND(H.hiRevisedBudget1 - ISNULL(JB.RevisedBudgetAmount1, 0), 6)   <> 0.0
     OR   ROUND(H.hiRevisedBudget2 - ISNULL(JB.RevisedBudgetAmount2, 0), 6)   <> 0.0
     OR   ROUND(H.hiRevisedBudget3 - ISNULL(JB.RevisedBudgetAmount3, 0), 6)   <> 0.0
     OR   ROUND(H.hiRevisedBudget4 - ISNULL(JB.RevisedBudgetAmount4, 0), 6)   <> 0.0
     OR   ROUND(H.hiRevisedBudget5 - ISNULL(JB.RevisedBudgetAmount5, 0), 6)   <> 0.0
     OR   ROUND(H.hiValue1         - ISNULL(JB.OriginalBudgetQuantity, 0), 6) <> 0.0
     OR   ROUND(H.hiValue2         - ISNULL(JB.RevisedBudgetQuantity, 0), 6)  <> 0.0
        )

  -- Insert Parent budgets if they don't exist

  INSERT INTO !ActiveSchema!.HISTORY
            ( hiCode
            , hiExclass
            , hicurrency
            , hiYear
            , hiPeriod
            , hiSales
            , hiPurchases
            , hiBudget
            , hiCleared
            , hiRevisedBudget1
            , hiValue1
            , hiValue2
            , hiValue3
            , hiRevisedBudget2
            , hiRevisedBudget3
            , hiRevisedBudget4
            , hiRevisedBudget5
            , hiSpareV

            )
  SELECT JB.HistoryCode
       , hiExClass = ASCII('K')
       , JB.CurrencyId
       , JB.ExchequerYear
       , JB.HistoryPeriod
       ,  0
       , 0
       , SUM(ISNULL(JB.OriginalBudgetAmount, 0.0))
       , 0
       , SUM(ISNULL(JB.RevisedBudgetAmount1, 0.0))
       , SUM(ISNULL(JB.OriginalBudgetQuantity, 0.0))
       , SUM(ISNULL(JB.RevisedBudgetQuantity, 0.0))
       , 0
       , SUM(ISNULL(JB.RevisedBudgetAmount2, 0.0))
       , SUM(ISNULL(JB.RevisedBudgetAmount3, 0.0))
       , SUM(ISNULL(JB.RevisedBudgetAmount4, 0.0))
       , SUM(ISNULL(JB.RevisedBudgetAmount5, 0.0))
       , 0

  FROM   #JobBudgets JB
  WHERE NOT EXISTS (SELECT TOP 1 1
                    FROM   !ActiveSchema!.HISTORY H
                    WHERE  H.hiCode = JB.HistoryCode
                    AND    H.hiCurrency = JB.CurrencyId
                    AND    H.hiYear     = JB.ExchequerYear
                    AND    H.hiPeriod   = JB.HistoryPeriod
                    AND    H.hiExCLass  = ASCII('K')
                    AND    H.hiPeriod   < 250
                   )
  AND JB.JobLevel > 0
  GROUP BY JB.HistoryCode
         , JB.CurrencyId
         , JB.ExchequerYear
         , JB.HistoryPeriod

END

GO