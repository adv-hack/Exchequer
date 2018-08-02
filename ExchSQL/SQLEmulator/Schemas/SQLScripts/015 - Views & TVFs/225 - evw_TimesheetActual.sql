IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_TimesheetActual]'))
DROP VIEW [!ActiveSchema!].evw_TimesheetActual
GO

CREATE VIEW !ActiveSchema!.evw_TimesheetActual
AS
SELECT JA.JobActualId

     , JA.EmployeeCode
     , EMP.EmployeeName
     , EMP.CostCentreCode
     , EMP.CostCentreName
     , EMP.DepartmentCode
     , EMP.DepartmentName

     , TimeRateCode = JA.StockCode
     , TR.TimeRateDescription

     , JA.TransactionDate
     , JA.TransactionPeriodKey
     , JA.TransactionYear
     , JA.TransactionPeriod

     , JA.JobCode
     , J.JobDescription
     , JA.AnalysisCode
     , JAN.JobAnalysisDescription
     , JA.JobAnalysisType

     , JC.JobCategoryId
     , JC.JobCategoryDescription
     
     , JA.IsPosted
     , JA.TransactionCurrency
     , JA.TransactionOurReference
     
     , JA.TransactionLineFolio
     , JA.TransactionLineNumber
     
     , [Hours\Quantity] = JA.Quantity
     , JA.Cost
     , JA.Amount
     
     , JA.Charge
     , JA.ChargeCurrency
     , JA.InvoiceReference
     
     
FROM   !ActiveSchema!.evw_JobActual   JA
JOIN   !ActiveSchema!.evw_Job         J   ON JA.JobCode      = J.JobCode           COLLATE SQL_Latin1_General_CP1_CI_AS
JOIN   !ActiveSchema!.evw_JobAnalysis JAN ON JA.AnalysisCode = JAN.JobAnalysisCode COLLATE SQL_Latin1_General_CP1_CI_AS
JOIN   !ActiveSchema!.evw_Employee    EMP ON JA.EmployeeCode = EMP.EmployeeCode    COLLATE SQL_Latin1_General_CP1_CI_AS

LEFT JOIN !ActiveSchema!.evw_TimeRate    TR ON JA.StockCode    = TR.TimeRateCode     COLLATE SQL_Latin1_General_CP1_CI_AS
LEFT JOIN !ActiveSchema!.evw_JobCategory JC ON JAN.JobAnalysisCategoryId = JC.JobCategoryId

WHERE  JA.TransactionType = 41

GO
