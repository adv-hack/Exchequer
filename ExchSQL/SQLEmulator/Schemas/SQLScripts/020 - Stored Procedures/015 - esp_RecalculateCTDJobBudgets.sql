/****** Object:  StoredProcedure [!ActiveSchema!].[esp_RecalculateCTDJobBudgets]    Script Date: 21/01/2015 08:46:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_RecalculateCTDJobBudgets]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].[esp_RecalculateCTDJobBudgets]
GO

-- Recalculates the Current to Date Value (255) for Job Budgets

-- USAGE: EXEC !ActiveSchema!.esp_RecalculateCTDJobBudgets

CREATE PROC !ActiveSchema!.esp_RecalculateCTDJobBudgets
AS
BEGIN

  SET NOCOUNT ON;

MERGE !ActiveSchema!.HISTORY H
USING
(
SELECT JH.HistoryPositionId
     , JH.HistoryCode
     , JH.JobCode
     , JH.AnalysisHistoryId
     , JH.CurrencyId
     , JH.HistoryYear
     , JH.HistoryPeriod
     , OriginalBudgetAmount      = ROUND(JH.OriginalBudgetAmount, 2)
     , NewOriginalBudgetamount   = ROUND(CTDValues.OriginalBudgetAmount, 2)
     , OriginalBudgetQuantity    = ROUND(JH.OriginalBudgetQuantity, 2)
     , NewOriginalBudgetQuantity = ROUND(CTDValues.OriginalBudgetQuantity, 2)
     , RevisedBudgetAmount1      = ROUND(JH.RevisedBudgetAmount1, 2)
     , NewRevisedBudgetAmount1   = ROUND(CTDValues.RevisedBudgetAmount1, 2)
     , RevisedBudgetAmount2      = ROUND(JH.RevisedBudgetAmount2, 2)
     , NewRevisedBudgetAmount2   = ROUND(CTDValues.RevisedBudgetAmount2, 2)
     , RevisedBudgetAmount3      = ROUND(JH.RevisedBudgetAmount3, 2)
     , NewRevisedBudgetAmount3   = ROUND(CTDValues.RevisedBudgetAmount3, 2)
     , RevisedBudgetAmount4      = ROUND(JH.RevisedBudgetAmount4, 2)
     , NewRevisedBudgetAmount4   = ROUND(CTDValues.RevisedBudgetAmount4, 2)
     , RevisedBudgetAmount5      = ROUND(JH.RevisedBudgetAmount5, 2)
     , NewRevisedBudgetAmount5   = ROUND(CTDValues.RevisedBudgetAmount5, 2)
     , RevisedBudgetQuantity     = ROUND(JH.RevisedBudgetQuantity, 2)
     , NewRevisedBudgetQuantity  = ROUND(CTDValues.RevisedBudgetQuantity, 2)

FROM !ActiveSchema!.evw_JobHistory JH

CROSS APPLY ( SELECT OriginalBudgetAmount   = SUM(CSH.OriginalBudgetAmount)
                   , RevisedBudgetAmount1   = SUM(CSH.RevisedBudgetAmount1)
                   , RevisedBudgetAmount2   = SUM(CSH.RevisedBudgetAmount2)
                   , RevisedBudgetAmount3   = SUM(CSH.RevisedBudgetAmount3)
                   , RevisedBudgetAmount4   = SUM(CSH.RevisedBudgetAmount4)
                   , RevisedBudgetAmount5   = SUM(CSH.RevisedBudgetAmount5)
                   , OriginalBudgetQuantity = SUM(OriginalBudgetQuantity)
                   , RevisedBudgetQuantity  = SUM(RevisedBudgetQuantity)
 
              FROM !ActiveSchema!.evw_JobHistory CSH
              WHERE JH.HistoryClassificationId = CSH.HistoryClassificationId
              AND   JH.HistoryCode             = CSH.HistoryCode
              AND   JH.CurrencyId              = CSH.CurrencyId
              AND   JH.HistoryYear            >= CSH.HistoryYear
              AND   CSH.HistoryPeriod         < 250
              
            ) CTDValues ( OriginalBudgetAmount
                        , RevisedBudgetAmount1
                        , RevisedBudgetAmount2
                        , RevisedBudgetAmount3
                        , RevisedBudgetAmount4
                        , RevisedBudgetAmount5
                        , OriginalBudgetQuantity
                        , RevisedBudgetQuantity
                        )

WHERE 1 = 1
AND   JH.HistoryPeriod = 255
AND   ( ROUND(JH.OriginalBudgetAmount, 2)   <> ROUND(CTDValues.OriginalBudgetAmount, 2)
   OR   ROUND(JH.RevisedBudgetAmount1, 2)   <> ROUND(CTDValues.RevisedBudgetAmount1, 2)
   OR   ROUND(JH.RevisedBudgetAmount2, 2)   <> ROUND(CTDValues.RevisedBudgetAmount2, 2)
   OR   ROUND(JH.RevisedBudgetAmount3, 2)   <> ROUND(CTDValues.RevisedBudgetAmount3, 2)
   OR   ROUND(JH.RevisedBudgetAmount4, 2)   <> ROUND(CTDValues.RevisedBudgetAmount4, 2)
   OR   ROUND(JH.RevisedBudgetAmount5, 2)   <> ROUND(CTDValues.RevisedBudgetAmount5, 2)
   OR   ROUND(JH.OriginalBudgetQuantity, 2) <> ROUND(CTDValues.OriginalBudgetQuantity, 2)
   OR   ROUND(JH.RevisedBudgetQuantity, 2)  <> ROUND(CTDValues.RevisedBudgetQuantity, 2)
      )
) AS HistSumm ON HistSumm.HistoryPositionId = H.PositionId

WHEN MATCHED THEN

     UPDATE
        SET hiBudget         = HistSumm.NewOriginalBudgetAmount
          , hiRevisedBudget1 = HistSumm.NewRevisedBudgetAmount1
          , hiRevisedBudget2 = HistSumm.NewRevisedBudgetAmount2
          , hiRevisedBudget3 = HistSumm.NewRevisedBudgetAmount3
          , hiRevisedBudget4 = HistSumm.NewRevisedBudgetAmount4
          , hiRevisedBudget5 = HistSumm.NewRevisedBudgetAmount5
          , hiValue1         = HistSumm.NewOriginalBudgetQuantity
          , hiValue2         = HistSumm.NewRevisedBudgetQuantity
     ;

END
GO