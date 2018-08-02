/****** Object:  StoredProcedure [!ActiveSchema!].[esp_RecalculateCTDJobCostingActuals]    Script Date: 21/01/2015 08:46:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_RecalculateCTDJobCostingActuals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].[esp_RecalculateCTDJobCostingActuals]
GO

-- Recalculates the Current to Date Value (255) for Job Costing Actuals

-- USAGE: EXEC !ActiveSchema!.esp_RecalculateCTDJobCostingActuals

CREATE PROC !ActiveSchema!.esp_RecalculateCTDJobCostingActuals
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
     , SalesAmount       = ROUND(JH.SalesAmount, 2)
     , NewSalesAmount    = ROUND(CTDValues.SalesAmount, 2)
     , PurchaseAmount    = ROUND(JH.PurchaseAmount, 2)
     , NewPurchaseAmount = ROUND(CTDValues.PurchaseAmount, 2)
     , BalanceAmount     = ROUND(JH.BalanceAmount, 2)
     , NewBalanceAmount  = ROUND(CTDValues.BalanceAmount, 2)

FROM !ActiveSchema!.evw_JobCostingHistory JH

CROSS APPLY ( SELECT SalesAmount    = SUM(CSH.SalesAmount) 
                   , PurchaseAmount = SUM(CSH.PurchaseAmount) 
                   , BalanceAmount  = SUM(CSH.BalanceAmount) 
 
              FROM !ActiveSchema!.evw_JobCostingHistory CSH
              WHERE JH.HistoryClassificationId = CSH.HistoryClassificationId
              AND   JH.HistoryCode             = CSH.HistoryCode
              AND   JH.CurrencyId              = CSH.CurrencyId
              AND   JH.HistoryYear            >= CSH.HistoryYear
              AND   CSH.HistoryPeriod         < 250
              
            ) CTDValues ( SalesAmount
                        , PurchaseAmount
                        , BalanceAmount
                        )

WHERE 1 = 1
AND   JH.HistoryPeriod = 255
AND   ( ROUND(JH.SalesAmount, 2)    <> ROUND(CTDValues.SalesAmount, 2)
   OR   ROUND(JH.PurchaseAmount, 2) <> ROUND(CTDValues.PurchaseAmount, 2)
   OR   ROUND(JH.BalanceAmount, 2)  <> ROUND(CTDValues.BalanceAmount, 2)
      )
) AS HistSumm ON HistSumm.HistoryPositionId = H.PositionId

WHEN MATCHED THEN

     UPDATE
        SET hiSales     = HistSumm.NewSalesAmount
          , hiPurchases = HistSumm.NewPurchaseAmount
     ;

END
GO