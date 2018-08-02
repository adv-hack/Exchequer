IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_JobPeriodBudgets]'))
DROP VIEW [!ActiveSchema!].[evw_JobPeriodBudgets]
GO

CREATE VIEW !ActiveSchema!.evw_JobPeriodBudgets
AS
SELECT HistoryPositionId
     , HistoryClassificationId
     , HistoryClassificationCode 
     , HistoryCode
     , JobCode = RTRIM(JobCode)
     , AnalysisHistoryId
     , ExchequerYear
     , HistoryYear
     , HistoryPeriod
     , HistoryPeriodKey
     , CurrencyId
   
     , OriginalBudgetAmount
     , RevisedBudgetAmount1
     , RevisedBudgetAmount2
     , RevisedBudgetAmount3
     , RevisedBudgetAmount4
     , RevisedBudgetAmount5

     , OriginalBudgetQuantity
     , RevisedBudgetQuantity

FROM !ActiveSchema!.evw_JobHistory H
WHERE HistoryClassificationId = 74
AND (OriginalBudgetAmount   <> 0
OR   RevisedBudgetAmount1   <> 0
OR   RevisedBudgetAmount2   <> 0
OR   RevisedBudgetAmount3   <> 0
OR   RevisedBudgetAmount4   <> 0
OR   RevisedBudgetAmount5   <> 0
OR   OriginalBudgetQuantity <> 0
OR   RevisedBudgetQuantity    <> 0)

GO


