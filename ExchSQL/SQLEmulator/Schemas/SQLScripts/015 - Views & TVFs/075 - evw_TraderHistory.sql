IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_TraderHistory]'))
DROP VIEW [!ActiveSchema!].[evw_TraderHistory]
GO

CREATE VIEW [!ActiveSchema!].[evw_TraderHistory]
AS
SELECT  HistoryPositionId
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
      , IsCommitment
      , TraderCode
      , ControlGLNominalCode = NominalCode
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
  FROM !ActiveSchema!.[evw_History] H
  WHERE HistoryClassificationId IN (85, 86, 87)

GO
