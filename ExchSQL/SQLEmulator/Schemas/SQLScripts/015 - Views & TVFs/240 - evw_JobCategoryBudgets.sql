
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_JobCategoryBudgets]'))
DROP VIEW [!ActiveSchema!].evw_JobCategoryBudgets
GO

CREATE VIEW !ActiveSchema!.evw_JobCategoryBudgets
AS
SELECT JobCategoryBudgetId        = JTB.PositionId
     , JTB.JobCode
     , JobCategoryId              = JTB.HistFolio
     , JC.JobCategoryDescription
     , AnalysisCode               = JTB.AnalCode
     , BudgetType                 = JTB.BType
     , BudgetTypeDescription
     , BudgetCurrencyId           = JTB.JBudgetCurr
     , CurrencyDescription        = C.Description
     , OriginalBudgetQuantity     = JTB.BoQty
     , RevisedBudgetQuantity      = JTB.BRQty
     , OriginalBudgetAmount       = JTB.BoValue
     , RevisedBudgetAmount        = JTB.BRValue
     
     , OriginalBudgetAmountInBase = common.efn_ExchequerRoundUp(common.efn_ExchequerCurrencyConvert( JTB.BoValue
                                                                                                   , C.ConversionRate
                                                                                                   , JTB.JBudgetCurr
                                                                                                   , 0
                                                                                                   , 0
                                                                                                   , C.TriRate
                                                                                                   , C.TriInverted
                                                                                                   , C.TriCurrencyCode
                                                                                                   , C.IsFloating) , 2)
     , RevisedBudgetAmountInBase  = common.efn_ExchequerRoundUp(common.efn_ExchequerCurrencyConvert( JTB.BRValue
                                                                                                   , C.ConversionRate
                                                                                                   , JTB.JBudgetCurr
                                                                                                   , 0
                                                                                                   , 0
                                                                                                   , C.TriRate
                                                                                                   , C.TriInverted
                                                                                                   , C.TriCurrencyCode
                                                                                                   , C.IsFloating) , 2)
     
     , JTB.StockCode
     , ValuationBasis             = JTB.JABBasis
     , ReCharge                   = JTB.ReCharge
     , UnitPrice                  = JTB.UnitPrice
     , PayRateCurrency            = JTB.CurrPType
     , PayRateFlag                = JTB.PayRMode
     , OriginalValuation          = JTB.OrigValuation
     , RevisedValuation           = JTB.RevValuation
     , UpliftPercentage           = JTB.JBUpliftP
     , UpliftPercentageApplied    = JTB.JAPcntApp

FROM   !ActiveSchema!.JobTotalsBudget JTB

JOIN   !ActiveSchema!.evw_JobCategory JC ON JC.CategoryHistoryId = JTB.HistFolio
JOIN   common.evw_BudgetType  BT ON JTB.BType            = BT.BudgetTypeId

JOIN   !ActiveSchema!.evw_Currency     C ON C.CurrencyCode      = JTB.JBudgetCurr

GO
