/****** Object:  StoredProcedure [!ActiveSchema!].[esp_RecalculateCTDEmployeeActuals]    Script Date: 01/30/2015 14:44:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_RecalculateCTDEmployeeActuals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].[esp_RecalculateCTDEmployeeActuals]
GO

-- Recalculates the Current to Date Value (255) for Employee Actuals

-- USAGE: EXEC !ActiveSchema!.esp_RecalculateCTDEmployeeActuals

CREATE PROC [!ActiveSchema!].[esp_RecalculateCTDEmployeeActuals]
AS
BEGIN

  SET NOCOUNT ON;

MERGE !ActiveSchema!.HISTORY H
USING
(
SELECT EH.HistoryPositionId
     , EH.HistoryCode
     , EH.EmployeeCode
     , EH.CurrencyId
     , EH.HistoryYear
     , EH.HistoryPeriod
     , SalesAmount       = ROUND(EH.SalesAmount, 2)
     , NewSalesAmount    = ROUND(CTDValues.SalesAmount, 2)
     , PurchaseAmount    = ROUND(EH.PurchaseAmount, 2)
     , NewPurchaseAmount = ROUND(CTDValues.PurchaseAmount, 2)
     , BalanceAmount     = ROUND(EH.BalanceAmount, 2)
     , NewBalanceAmount  = ROUND(CTDValues.BalanceAmount, 2)

FROM !ActiveSchema!.evw_EmployeeHistory EH

CROSS APPLY ( SELECT SalesAmount    = SUM(CSH.SalesAmount) 
                   , PurchaseAmount = SUM(CSH.PurchaseAmount) 
                   , BalanceAmount  = SUM(CSH.BalanceAmount) 
 
              FROM !ActiveSchema!.evw_EmployeeHistory CSH
              WHERE EH.HistoryClassificationId = CSH.HistoryClassificationId
              AND   EH.HistoryCode             = CSH.HistoryCode
              AND   EH.CurrencyId              = CSH.CurrencyId
              AND   EH.HistoryYear            >= CSH.HistoryYear
              AND   CSH.HistoryPeriod         < 250
              
            ) CTDValues ( SalesAmount
                        , PurchaseAmount
                        , BalanceAmount
                        )

WHERE 1 = 1
AND   EH.HistoryPeriod = 255
AND   ( ROUND(EH.SalesAmount, 2)    <> ROUND(CTDValues.SalesAmount, 2)
   OR   ROUND(EH.PurchaseAmount, 2) <> ROUND(CTDValues.PurchaseAmount, 2)
   OR   ROUND(EH.BalanceAmount, 2)  <> ROUND(CTDValues.BalanceAmount, 2)
      )
) AS HistSumm ON HistSumm.HistoryPositionId = H.PositionId

WHEN MATCHED THEN

     UPDATE
        SET hiSales     = HistSumm.NewSalesAmount
          , hiPurchases = HistSumm.NewPurchaseAmount
     ;

END

GO
