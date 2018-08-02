
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_TraderStockHistory]'))
DROP VIEW [!ActiveSchema!].[evw_TraderStockHistory]
GO

CREATE VIEW !ActiveSchema!.evw_TraderStockHistory
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
     , CostCentreDepartmentFlag
     , CostCentreCode
     , DepartmentCode
     , TraderCode
     , StockFolioNumber
     , LocationCode
     , SalesAmount
     , PurchaseAmount
     , BalanceAmount
     , OriginalBudgetAmount
     , ClearedBalance
     , RevisedBudgetAmount1
     , RevisedBudgetAmount2
     , RevisedBudgetAmount3
     , RevisedBudgetAmount4
     , RevisedBudgetAmount5
     , Value1Amount
     , Value2Amount
     , Value3Amount

  FROM [!ActiveSchema!].[evw_History]
  WHERE HistoryClassificationId = 69

GO


