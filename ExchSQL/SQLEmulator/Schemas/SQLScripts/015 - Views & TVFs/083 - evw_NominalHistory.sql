IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_NominalHistory]'))
DROP VIEW [!ActiveSchema!].[evw_NominalHistory]
GO

CREATE VIEW !ActiveSchema!.evw_NominalHistory
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
     , NominalCode
     , CostCentreCode
     , DepartmentCode
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
  WHERE HistoryClassificationId IN (65, 66, 67, 70, 72)
  OR  ( HistoryClassificationId = 77 AND IsCommitment = 1)
GO


