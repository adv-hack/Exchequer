IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_VATHistory]'))
DROP VIEW [!ActiveSchema!].[evw_VATHistory]
GO

CREATE VIEW !ActiveSchema!.evw_VATHistory
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
     , VATRateCode
     , SalesAmount
     , PurchaseAmount
     , BalanceAmount
     , OriginalBudgetAmount
     , ClearedBalance
     , RevisedBudgetAmount1
     , RevisedBudgetAmount2
     , RevisedbudgetAmount3
     , RevisedBudgetAmount4
     , RevisedBudgetAmount5
     , Value1Amount
     , Value2Amount
     , Value3Amount

  FROM [!ActiveSchema!].[evw_History]
  WHERE HistoryClassificationId IN (73, 79)
GO


