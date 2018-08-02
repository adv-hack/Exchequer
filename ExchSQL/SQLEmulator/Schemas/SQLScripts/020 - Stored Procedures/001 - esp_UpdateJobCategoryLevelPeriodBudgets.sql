/****** Object:  StoredProcedure [!ActiveSchema!].[esp_UpdateJobCategoryLevelPeriodBudgets]    Script Date: 04/25/2016 13:40:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_UpdateJobCategoryLevelPeriodBudgets]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].[esp_UpdateJobCategoryLevelPeriodBudgets]
GO

/****** Object:  StoredProcedure [!ActiveSchema!].[esp_UpdateJobCategoryLevelPeriodBudgets]    Script Date: 04/25/2016 13:40:17 ******/

CREATE PROCEDURE [!ActiveSchema!].[esp_UpdateJobCategoryLevelPeriodBudgets] ( @iv_JobCode VARCHAR(10) = NULL )
AS
BEGIN

  SET NOCOUNT ON;

  IF OBJECT_ID('tempdb..#JobAnalysisBudgets') IS NOT NULL
     DROP TABLE #JobAnalysisBudgets

  CREATE TABLE #JobAnalysisBudgets
             ( JobCode                VARCHAR(10)
             , CurrencyId             INT
             , CategoryHistoryId      INT           NULL
             , HistoryCode            VARBINARY(21)
             , HistoryPeriodKey       INT

             , OriginalBudgetAmount   FLOAT
             , RevisedBudgetAmount1   FLOAT
             , RevisedBudgetAmount2   FLOAT
             , RevisedBudgetAmount3   FLOAT
             , RevisedBudgetAmount4   FLOAT
             , RevisedBudgetAmount5   FLOAT

             , OriginalBudgetQuantity FLOAT
             , RevisedBudgetQuantity  FLOAT
             )

  INSERT INTO #JobAnalysisBudgets
  SELECT JCA.JobCode
       , JH.CurrencyId
       , CategoryHistoryId = JCA.CategoryHistoryId
       , HistoryCode = CAST(0x14 + CONVERT(VARBINARY(21), RTRIM(JCA.JobCode) + SPACE(10 - LEN(RTRIM(JCA.JobCode))) ) 
                                 + CONVERT(VARBINARY(21), REVERSE(CONVERT(VARBINARY(4), JCA.CategoryHistoryId)))
                                 + CONVERT(VARBINARY(21), SPACE(6) ) AS VARBINARY(21))
       , JH.HistoryPeriodKey

       , OriginalBudgetAmount    = SUM(ISNULL(JH.OriginalBudgetAmount, 0))
       , RevisedBudgetAmount1    = SUM(ISNULL(JH.RevisedBudgetAmount1, 0))
       , RevisedBudgetAmount2    = SUM(ISNULL(JH.RevisedBudgetAmount2, 0))
       , RevisedBudgetAmount3    = SUM(ISNULL(JH.RevisedBudgetAmount3, 0))
       , RevisedBudgetAmount4    = SUM(ISNULL(JH.RevisedBudgetAmount4, 0))
       , RevisedBudgetAmount5    = SUM(ISNULL(JH.RevisedBudgetAmount5, 0))

       , OriginalBudgetQuantity  = SUM(ISNULL(JH.OriginalBudgetQuantity, 0))
       , RevisedBudgetQuantity   = SUM(ISNULL(JH.RevisedBudgetQuantity, 0))

  FROM   !ActiveSchema!.evw_JobCategoryAnalysis JCA 
  LEFT JOIN !ActiveSchema!.evw_JobHistory JH ON JH.JobCode           = JCA.JobCode
                                    AND JH.AnalysisHistoryId = JCA.AnalysisHistoryId
  WHERE JH.HistoryClassificationCode = 'J'
  AND   JH.HistoryPeriod < 250
  AND   JH.AnalysisHistoryId >= 1000

  AND   (JH.JobCode = @iv_JobCode OR ISNULL(@iv_jobCode, '') = '')

  GROUP BY JCA.JobCode
         , JH.CurrencyId
         , JCA.CategoryHistoryId
         , JH.HistoryPeriodKey

  -- Update the Category Totals where there is a difference

  UPDATE H
     SET hiBudget         = ISNULL(ChildTotals.OriginalBudgetAmount, hiBudget)
       , hiRevisedBudget1 = ISNULL(ChildTotals.RevisedBudgetAmount1, hiRevisedBudget1)
       , hiRevisedBudget2 = ISNULL(ChildTotals.RevisedBudgetAmount2, hiRevisedBudget2)
       , hiRevisedBudget3 = ISNULL(ChildTotals.RevisedBudgetAmount3, hiRevisedBudget3)
       , hiRevisedBudget4 = ISNULL(ChildTotals.RevisedBudgetAmount4, hiRevisedBudget4)
       , hiRevisedBudget5 = ISNULL(ChildTotals.RevisedBudgetAmount5, hiRevisedBudget5)
       , hiValue1         = ISNULL(ChildTotals.OriginalBudgetQuantity, hiValue1)
       , hiValue2         = ISNULL(ChildTotals.RevisedBudgetQuantity, hiValue2)

  FROM !ActiveSchema!.HISTORY H
  JOIN  #JobAnalysisBudgets ChildTotals ON H.hiCode     = ChildTotals.HistoryCode
                                       AND H.hiCurrency = ChildTotals.CurrencyId
                                       AND ((H.hiYear + 1900) * 1000) + H.hiPeriod = ChildTotals.HistoryPeriodKey
  WHERE 1 = 1

  AND ( ROUND(H.hiBudget         - ChildTotals.OriginalBudgetAmount, 6)   <> 0
   OR   ROUND(H.hiRevisedBudget1 - ChildTotals.RevisedBudgetAmount1, 6)   <> 0
   OR   ROUND(H.hiRevisedBudget2 - ChildTotals.RevisedBudgetAmount2, 6)   <> 0
   OR   ROUND(H.hiRevisedBudget3 - ChildTotals.RevisedBudgetAmount3, 6)   <> 0
   OR   ROUND(H.hiRevisedBudget4 - ChildTotals.RevisedBudgetAmount4, 6)   <> 0
   OR   ROUND(H.hiRevisedBudget5 - ChildTotals.RevisedBudgetAmount5, 6)   <> 0
   OR   ROUND(H.hiValue1         - ChildTotals.OriginalBudgetQuantity, 6) <> 0
   OR   ROUND(H.hiValue2         - ChildTotals.RevisedBudgetQuantity, 6)  <> 0
      )

  -- Insert any missing category rows

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
  SELECT DISTINCT
         HistoryCode
       , hiExClass   = ASCII('J')
       , CurrencyId
       , hiYear      = FLOOR(HistoryPeriodKey/1000) - 1900
       , hiPeriod    = (HistoryPeriodKey % 1000)
       , 0
       , 0
       , OriginalBudgetAmount
       , 0
       , RevisedBudgetAmount1
       , OriginalBudgetQuantity
       , RevisedBudgetQuantity
       , 0
       , RevisedBudgetAmount2
       , RevisedBudgetAmount3
       , RevisedBudgetAmount4
       , RevisedBudgetAmount5
       , 0

  FROM   #JobAnalysisBudgets JABC
  WHERE  1 = 1
  AND  ( OriginalBudgetAmount   <> 0
  OR     RevisedBudgetAmount1   <> 0
  OR     RevisedBudgetAmount2   <> 0
  OR     RevisedBudgetAmount3   <> 0
  OR     RevisedBudgetAmount4   <> 0
  OR     RevisedBudgetAmount5   <> 0
  OR     OriginalBudgetQuantity <> 0
  OR     RevisedBudgetQuantity  <> 0
       )
  AND NOT EXISTS ( SELECT TOP 1 1
                   FROM  !ActiveSchema!.evw_JobHistory JH
                   WHERE JABC.JobCode           = JH.JobCode           COLLATE Latin1_General_CI_AS
                   AND   JABC.CurrencyId        = JH.CurrencyId
                   AND   JABC.CategoryHistoryId = JH.AnalysisHistoryId
                   AND   JABC.HistoryPeriodKey  = JH.HistoryPeriodKey
                   AND   JH.HistoryPeriod       < 250
                 )

END


GO


