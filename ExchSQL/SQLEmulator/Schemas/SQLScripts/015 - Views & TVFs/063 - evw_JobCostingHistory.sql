
IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_JobCostingHistory]'))
DROP VIEW !ActiveSchema!.evw_JobCostingHistory
GO

EXEC dbo.sp_executesql @statement = N'CREATE VIEW [!ActiveSchema!].[evw_JobCostingHistory]
AS
SELECT HistoryPositionId
     , HistoryClassificationId
     , HistoryClassificationCode 
     , HistoryCode
     , JobCode
     , AnalysisHistoryId
     , ExchequerYear
     , HistoryYear
     , HistoryPeriod
     , HistoryPeriodKey
     , CurrencyId
     
     , SalesAmount
     , PurchaseAmount
     , BalanceAmount

     , OriginalBudgetAmount
     , RevisedBudgetAmount1
     , RevisedBudgetAmount2
     , RevisedbudgetAmount3
     , RevisedBudgetAmount4
     , RevisedBudgetAmount5

     , OriginalBudgetQuantity    = Value1Amount
     , RevisedBudgetQuantity     = Value2Amount

FROM !ActiveSchema!.evw_History H
WHERE HistoryClassificationId in (91)' 
GO


