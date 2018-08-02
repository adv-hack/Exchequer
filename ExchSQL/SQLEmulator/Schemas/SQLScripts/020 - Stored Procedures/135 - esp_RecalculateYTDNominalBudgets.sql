IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_RecalculateYTDNominalBudgets]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].esp_RecalculateYTDNominalBudgets

GO


-- Recalculates the Year to Date Value (254) for Job Actuals

-- USAGE: EXEC !ActiveSchema!.esp_RecalculateYTDNominalBudgets

CREATE PROC [!ActiveSchema!].[esp_RecalculateYTDNominalBudgets]
AS
BEGIN

  SET NOCOUNT ON;

MERGE !ActiveSchema!.HISTORY H
USING
(
SELECT NH.HistoryPositionId
     , NH.HistoryCode
     , NH.NominalCode
     , NH.CostCentreDepartmentFlag
     , NH.CurrencyId
     , NH.HistoryYear
     , NH.HistoryPeriod
     , NH.CostCentreCode
     , NH.DepartmentCode
     , BudgetAmount      = ROUND(NH.OriginalBudgetAmount, 2)
     , NewBudgetAmount   = ROUND(YTDValues.OriginalBudgetAmount, 2)
     , RevisedAmount1    = ROUND(NH.RevisedBudgetAmount1, 2)
     , NewRevisedAmount1 = ROUND(YTDValues.RevisedBudgetAmount1, 2)
     , RevisedAmount2    = ROUND(NH.RevisedBudgetAmount2, 2)
     , NewRevisedAmount2 = ROUND(YTDValues.RevisedBudgetAmount2, 2)
     , RevisedAmount3    = ROUND(NH.RevisedBudgetAmount3, 2)
     , NewRevisedAmount3 = ROUND(YTDValues.RevisedBudgetAmount3, 2)
     , RevisedAmount4    = ROUND(NH.RevisedBudgetAmount4, 2)
     , NewRevisedAmount4 = ROUND(YTDValues.RevisedBudgetAmount4, 2)
     , RevisedAmount5    = ROUND(NH.RevisedBudgetAmount5, 2)
     , NewRevisedAmount5 = ROUND(YTDValues.RevisedBudgetAmount5, 2)


FROM !ActiveSchema!.evw_NominalHistory NH

CROSS APPLY ( SELECT OriginalBudgetAmount = SUM(CSH.OriginalBudgetAmount) 
                   , RevisedbudgetAmount1 = SUM(CSH.RevisedBudgetAmount1)
                   , RevisedbudgetAmount2 = SUM(CSH.RevisedBudgetAmount2) 
                   , RevisedbudgetAmount3 = SUM(CSH.RevisedBudgetAmount3) 
                   , RevisedbudgetAmount4 = SUM(CSH.RevisedBudgetAmount4) 
                   , RevisedbudgetAmount5 = SUM(CSH.RevisedBudgetAmount5) 
 
              FROM !ActiveSchema!.evw_NominalHistory CSH
              WHERE NH.HistoryClassificationId = CSH.HistoryClassificationId
              AND   NH.HistoryCode             = CSH.HistoryCode
              AND   NH.CurrencyId              = CSH.CurrencyId
              AND   NH.HistoryYear             = CSH.HistoryYear
              AND   ISNULL(NH.CostCentreDepartmentFlag, '') = ISNULL(CSH.CostCentreDepartmentFlag, '')
              AND   ISNULL(NH.CostCentreCode, '')           = ISNULL(CSH.CostCentreCode, '')
              AND   ISNULL(NH.DepartmentCode, '')           = ISNULL(CSH.DepartmentCode, '')
              AND   CSH.HistoryPeriod         < 250
              
            ) YTDValues ( OriginalBudgetAmount
                        , RevisedBudgetAmount1
                        , RevisedBudgetAmount2
                        , RevisedBudgetAmount3
                        , RevisedBudgetAmount4
                        , RevisedBudgetAmount5
                        )

WHERE 1 = 1
AND   NH.HistoryPeriod = 255
AND   ( ROUND(NH.OriginalBudgetAmount, 2) <> ROUND(YTDValues.OriginalBudgetAmount, 2)
   OR   ROUND(NH.RevisedBudgetAmount1, 2) <> ROUND(YTDValues.RevisedBudgetAmount1, 2)
   OR   ROUND(NH.RevisedBudgetAmount2, 2) <> ROUND(YTDValues.RevisedBudgetAmount2, 2)
   OR   ROUND(NH.RevisedBudgetAmount3, 2) <> ROUND(YTDValues.RevisedBudgetAmount3, 2)
   OR   ROUND(NH.RevisedBudgetAmount4, 2) <> ROUND(YTDValues.RevisedBudgetAmount4, 2)
   OR   ROUND(NH.RevisedBudgetAmount5, 2) <> ROUND(YTDValues.RevisedBudgetAmount5, 2)
      )
) AS HistSumm ON HistSumm.HistoryPositionId = H.PositionId

WHEN MATCHED THEN

     UPDATE
        SET hiBudget         = HistSumm.NewBudgetAmount
          , hiRevisedBudget1 = HistSumm.NewRevisedAmount1
          , hiRevisedBudget2 = HistSumm.NewRevisedAmount2
          , hiRevisedBudget3 = HistSumm.NewRevisedAmount3
          , hiRevisedBudget4 = HistSumm.NewRevisedAmount4
          , hiRevisedBudget5 = HistSumm.NewRevisedAmount5
     ;

END

GO

