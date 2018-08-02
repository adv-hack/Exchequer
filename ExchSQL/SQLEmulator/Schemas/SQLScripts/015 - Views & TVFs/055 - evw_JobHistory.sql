
IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_JobHistory]'))
DROP VIEW !ActiveSchema!.evw_JobHistory
GO

EXEC dbo.sp_executesql @statement = N'CREATE VIEW [!ActiveSchema!].[evw_JobHistory]
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
WHERE HistoryClassificationId in (74, 75)' 
GO


