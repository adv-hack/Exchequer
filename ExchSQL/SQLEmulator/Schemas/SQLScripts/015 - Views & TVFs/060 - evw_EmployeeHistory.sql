
IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_EmployeeHistory]'))
DROP VIEW !ActiveSchema!.evw_EmployeeHistory
GO

EXEC dbo.sp_executesql @statement = N'CREATE VIEW [!ActiveSchema!].[evw_EmployeeHistory]
AS
SELECT HistoryPositionId
     , HistoryClassificationId
     , HistoryClassificationCode 
     , HistoryCode
     , EmployeeCode
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
WHERE HistoryClassificationId in (92)' 
GO


