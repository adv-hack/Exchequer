/****** Object:  View [!ActiveSchema!].[evw_JobActual]    Script Date: 12/12/2014 11:10:13 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_JobActual]'))
DROP VIEW [!ActiveSchema!].[evw_JobActual]
GO

CREATE VIEW !ActiveSchema!.evw_JobActual
AS
SELECT JobActualId             = PositionId
     , JobCode                 = RTRIM(JobCode)
     , AnalysisCode            = var_code5
     , TransactionLineFolio    = LineFolio
     , TransactionLineNumber   = LineNumber
     , TransactionOurReference = LineORef
     , TransactionDate         = JDate
     , TransactionYear         = JobTranYear
     , TransactionPeriod       = JobTranPeriod
     , TransactionPeriodKey    = ((JobTranYear + 1900) * 1000) + JobTranPeriod
     , TransactionType         = JDDT
     , TransactionCurrency     = CurrencyId
     , IsPosted                = Posted
     , StockCode               = StockCode
     , Quantity                = Qty
     , Cost                    = Cost
     , Amount                  = Qty * Cost
     , Charge                  = Charge
     , IsInvoiced              = Invoiced
     , InvoiceReference        = InvRef
     , EmployeeCode            = EmplCode
     , JobAnalysisType         = JAType
     , LinePostedStatus        = PostedRun
     , ReverseWIPElement       = Reverse
     , IsReversed              = Reversed
     , ReconciledTimesheet     = ReconTS
     , ChargeCurrency          = CurrCharge
     , OnHold                  = HoldFlg
     , PostedToStock           = Post2Stk
     , PostedCompanyRate       = PCRates1
     , PostedDailyRate         = PCRates2
     , TaggedForInvoicing      = Tagged
     , NominalCode             = OrigNCode
     , ForceNonTriRules        = JUseORate
     , PCTriRates
     , PCTriEuro
     , PCTriInvert
     , PCTriFloat
     , ActualPriceMultiplier   = JPriceMulX
     , UpliftTotal
     , UpliftGL

-- SELECT *
FROM   !ActiveSchema!.JOBDET
WHERE  RecPFix = 'J'
AND    SubType = 'E'

GO

