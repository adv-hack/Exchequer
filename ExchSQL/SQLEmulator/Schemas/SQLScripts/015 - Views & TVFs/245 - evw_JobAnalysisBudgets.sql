
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_JobAnalysisBudgets]'))
DROP VIEW [!ActiveSchema!].[evw_JobAnalysisBudgets]
GO

CREATE VIEW !ActiveSchema!.evw_JobAnalysisBudgets
AS
SELECT JobCategoryBudgetId        = ACB.PositionId
     , ACB.JobCode
     , CategoryHistoryId 
     , JobCategoryDescription
     , AnalysisHistoryId
     , AnalysisCode               = ACB.AnalCode
     , JobAnalysisDescription
     , BudgetType                 = ACB.BType
     , BudgetTypeDescription
     , BudgetCurrencyId           = ACB.JBudgetCurr
     , CurrencyDescription        = C.Description
     , OriginalBudgetQuantity     = ACB.BoQty
     , RevisedBudgetQuantity      = ACB.BRQty
     , OriginalBudgetAmount       = ACB.BoValue
     , RevisedBudgetAmount        = ACB.BRValue
     
     , OriginalBudgetAmountInBase = common.efn_ExchequerRoundUp(common.efn_ExchequerCurrencyConvert( ACB.BoValue
                                                                                                   , C.ConversionRate
                                                                                                   , ACB.JBudgetCurr
                                                                                                   , 0
                                                                                                   , 0
                                                                                                   , C.TriRate
                                                                                                   , C.TriInverted
                                                                                                   , C.TriCurrencyCode
                                                                                                   , C.IsFloating) , 2)
     , RevisedBudgetAmountInBase  = common.efn_ExchequerRoundUp(common.efn_ExchequerCurrencyConvert( ACB.BRValue
                                                                                                   , C.ConversionRate
                                                                                                   , ACB.JBudgetCurr
                                                                                                   , 0
                                                                                                   , 0
                                                                                                   , C.TriRate
                                                                                                   , C.TriInverted
                                                                                                   , C.TriCurrencyCode
                                                                                                   , C.IsFloating) , 2)
     
     , ACB.StockCode
     , ValuationBasis             = ACB.JABBasis
     , ReCharge                   = ACB.ReCharge
     , UnitPrice                  = ACB.UnitPrice
     , PayRateCurrency            = ACB.CurrPType
     , PayRateFlag                = ACB.PayRMode
     , OriginalValuation          = ACB.OrigValuation
     , RevisedValuation           = ACB.RevValuation
     , UpliftPercentage           = ACB.JBUpliftP
     , UpliftPercentageApplied    = ACB.JAPcntApp

FROM   !ActiveSchema!.AnalysisCodeBudget ACB

JOIN   !ActiveSchema!.evw_JobCategoryAnalysis JCA ON JCA.AnalysisHistoryId = ACB.HistFolio
                                                 AND JCA.JobCode           = ACB.JobCode

JOIN   !ActiveSchema!.evw_JobAnalysis         JA  ON JA.JobAnalysisCode    = JCA.AnalysisCode
               
JOIN   common.evw_BudgetType           BT ON ACB.BType             = BT.BudgetTypeId

JOIN   !ActiveSchema!.evw_Currency     C ON C.CurrencyCode      = ACB.JBudgetCurr


GO