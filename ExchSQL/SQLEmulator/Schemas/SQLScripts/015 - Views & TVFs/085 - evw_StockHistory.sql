IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_StockHistory]'))
DROP VIEW [!ActiveSchema!].[evw_StockHistory]
GO

CREATE VIEW !ActiveSchema!.evw_StockHistory
AS
SELECT HistoryPositionId
     , HistoryClassificationId
     , HistoryClassificationCode
     , HistoryCode
     , CurrencyId
     , CurrencyCode
     , ExchequerYear
     , ExchequerPeriod
     , HistoryYear
     , HistoryPeriod
     , HistoryPeriodKey
     , IsTotal
     , IsCommitment
     , StockFolioNumber
     , StockCode        = S.stCode
     , StockType        = S.stType
     , LocationCode
     , SalesAmount
     , PurchaseAmount
     , BalanceAmount
     , OriginalBudgetAmount
     , QuantityInStock = ClearedBalance
     , RevisedBudgetAmount1
     , RevisedBudgetAmount2
     , RevisedBudgetAmount3
     , RevisedBudgetAmount4
     , RevisedBudgetAmount5
     , Value1Amount
     , Value2Amount
     , Value3Amount

  FROM [!ActiveSchema!].[evw_History] H
  LEFT JOIN [!ActiveSchema!].STOCK S ON H.StockFolioNumber = S.stFolioNum
  WHERE HistoryClassificationId IN (68, 71, 80, 88, 227, 230, 236, 239, 247, 248)
  OR  ( HistoryClassificationId = 77 AND IsCommitment = 0)
GO


