/****** Object:  View [!ActiveSchema!].[evw_JobStockBudget]    Script Date: 09/02/2015 08:16:58 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_JobStockBudget]'))
DROP VIEW [!ActiveSchema!].[evw_JobStockBudget]
GO

/****** Object:  View [!ActiveSchema!].[evw_JobStockBudget]    Script Date: 09/02/2015 08:16:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [!ActiveSchema!].[evw_JobStockBudget]
AS
SELECT	PositionId ,
		JobAnalysisCode         = CONVERT(VARCHAR(50), AnalCode),
        JobAnalysisCategoryCode = AnalHed,
		AnalysisHistoryId       = HistFolio,
		JobCode                 = CONVERT(VARCHAR(50), RTRIM(JobCode)),
		StockCode               = CONVERT(VARCHAR(50), StockCode),
		JobAnalysisTypeCode     = BType,
		ReCharge,
		OverCost                = CONVERT(NUMERIC(38, 15),OverCost),
		UnitPrice               = CONVERT(NUMERIC(38, 15),UnitPrice),
		OriginalQuantity        = CONVERT(NUMERIC(38, 15),BoQty),	
		RevisedQuantity         = CONVERT(NUMERIC(38, 15),BRQty),
		OriginalBudget          = CONVERT(NUMERIC(38, 15),BoValue),
		RevisedBudget           = CONVERT(NUMERIC(38, 15),BRValue),
		BudgetCurrencyCode      = JBudgetCurr,
		PayRateMode             = PayRMode,
		PayRateCurrencyCode     = CurrPType,
		InitialValuation        = CONVERT(NUMERIC(38, 15),OrigValuation),
		RevisedValaution        = CONVERT(NUMERIC(38, 15),RevValuation),
		UpliftOverride          = CONVERT(NUMERIC(38, 15),JBUpliftP),
		PercentageAppliedForNextValuation = CONVERT(NUMERIC(38, 15),JAPcntApp),
		BasisOfValuation       = JABBasis
FROM !ActiveSchema!.JOBCTRL 
where RecPfix = 'J'
and   SubType = 'S' 

GO


