--/////////////////////////////////////////////////////////////////////////////
--// Filename		: ifn_GetJCBudgetValue.sql
--// Author		: James Waygood
--// Date		: 14th February 2017
--// Copyright Notice	: (c) 2017 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: Gets a specified Job Budget History value 
--// Execute    	: SELECT [ZZZZ01].[ifn_GetJCBudgetValue] (6, 'B', 10, 0, 2007, 0, 0, 'BATH01', 'M-SALES')
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: File Creation
--//    2       : ABSEXCH-18342 - Issue returning Qty & RQty on period budgets
--//
--/////////////////////////////////////////////////////////////////////////////

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[ifn_GetJCBudgetValue]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [!ActiveSchema!].[ifn_GetJCBudgetValue]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*
{********************************************************************************}
{* GetJCValue: Returns a value for the specified job budget record in the       *}
{*             specified companies data. ValueReq indicates which of the        *}
{*             of the history values is required:                               *}
{*                      1 Budget Qty                                            *}
{*                      2 Budget Value                                          *}
{*                      3 Revised Budget Qty                                    *}
{*                      4 Revised Budget Value                                  *}
{*                      5 Actual Qty                                            *}
{*                      6 Actual Value                                          *}
{*                      7 Valuation To Date                                     *}
{*                      8 Next Valuation Amount                                 *}
{*                      9 Next Valuation Percentage                             *}
{********************************************************************************}
*/

CREATE FUNCTION [!ActiveSchema!].[ifn_GetJCBudgetValue] 
(
	@ValueReq		int,
	@BT				char(1),	-- Budget Type
	@TType			int,		-- Total Type
	@PCChar			int,		-- Posted/Committed
	@TheYear		int,		-- Year to retrieve value for 
	@ThePeriod		int,		-- Period to retrieve value for
	@TheCcy			int,		-- Currency
	@JobCode		char(10),	-- Job Code
	@StockCode		char(16)	-- Stock Code
)
RETURNS float
AS
BEGIN
	-- Declare the return variable here
	DECLARE @ChkJobCode		varchar(10)
	DECLARE @ChkStkCode		varchar(16)
	DECLARE @Commit			bit
	DECLARE @JobContract	char(1)
	DECLARE @JobCount		int
	DECLARE @CurrJobCount	int
	DECLARE @HistVal		float
	DECLARE @HistFolio		int
		
	SET		@ChkJobCode		= ''
	SET		@ChkStkCode		= ''
	SET		@Commit			= @PCChar
	SET		@JobContract	= ''
	SET		@JobCount		= 0
	SET		@CurrJobCount	= 0
	SET		@HistVal		= 0
	SET		@HistFolio		= 0
	
	SELECT @JobContract =	JobType
								FROM [!ActiveSchema!].[JOBHEAD]
								WHERE @JobCode = JobCode
    
    IF @JobContract = 'K'
    BEGIN
		
		-- Recursively run through the Job Tree loading the Jobs for the specified JobContractCode
		WITH ContractJobs(JobCat, JobCode, JobType, TreeLevel) AS 
		(
			SELECT JobCat, JobCode, JobType, 0 AS TreeLevel
			FROM [!ActiveSchema!].JOBHEAD 
			WHERE JobCat = @JobCode
			UNION ALL
			SELECT e.JobCat, e.JobCode, e.JobType, TreeLevel + 1
			FROM [!ActiveSchema!].JOBHEAD e
				INNER JOIN ContractJobs d
				ON e.JobCat = d.JobCode 
		)
		
		SELECT @HistVal = @HistVal + [!ActiveSchema!].ifn_GetJCBudgetValue(@ValueReq, @BT, @TType, @PCChar, @TheYear, 
									  @ThePeriod, @TheCcy, contractjobs.JobCode, @StockCode)
		FROM ContractJobs
		WHERE JobType = 'J'
		
	END
	
	IF @HistVal = 0
	BEGIN
		IF (@ValueReq = 1 AND (SELECT TOP 1 PeriodBud FROM [!ActiveSchema!].EXCHQSS WHERE IDCode = 0x034A4F42) = 0)
		BEGIN
			SELECT @HistVal = BoQty FROM [!ActiveSchema!].AnalysisCodeBudget
									WHERE JobCode = @JobCode AND AnalCode = @StockCode
		END
		ELSE IF (@ValueReq = 2 AND (SELECT TOP 1 PeriodBud FROM [!ActiveSchema!].EXCHQSS WHERE IDCode = 0x034A4F42) = 0)
		BEGIN
			SELECT @HistVal = BoValue FROM [!ActiveSchema!].AnalysisCodeBudget
									  WHERE JobCode = @JobCode AND AnalCode = @StockCode
		END
		ELSE IF (@ValueReq = 3 AND (SELECT TOP 1 PeriodBud FROM [!ActiveSchema!].EXCHQSS WHERE IDCode = 0x034A4F42) = 0)
		BEGIN
			SELECT @HistVal = BRQty FROM [!ActiveSchema!].AnalysisCodeBudget
									WHERE JobCode = @JobCode AND AnalCode = @StockCode
		END
		ELSE IF (@ValueReq = 4 AND (SELECT TOP 1 PeriodBud FROM [!ActiveSchema!].EXCHQSS WHERE IDCode = 0x034A4F42) = 0)
		BEGIN
			SELECT @HistVal = BRValue FROM [!ActiveSchema!].AnalysisCodeBudget
									  WHERE JobCode = @JobCode AND AnalCode = @StockCode
		END
		ELSE IF (@ValueReq IN (1,2,3,4) AND (SELECT TOP 1 PeriodBud FROM [!ActiveSchema!].EXCHQSS WHERE IDCode = 0x034A4F42) = 1)
		BEGIN
			SELECT @HistVal = [!ActiveSchema!].ifn_GetJobBudgetValue(@ValueReq, @TheYear, @ThePeriod, 
														 @TheCcy, @JobCode, (SELECT TOP 1 HistFolio
																			 FROM [!ActiveSchema!].AnalysisCodeBudget
																			 WHERE JobCode = @JobCode 
																			 AND AnalCode = @StockCode),
														 @Commit) 
		END
		ELSE IF @ValueReq = 5 OR @ValueReq = 6
		BEGIN
			SELECT @HistVal = [!ActiveSchema!].ifn_GetJobBudgetValue(@ValueReq, @TheYear, @ThePeriod, 
														 @TheCcy, @JobCode, (SELECT TOP 1 HistFolio
																			 FROM [!ActiveSchema!].AnalysisCodeBudget
																			 WHERE JobCode = @JobCode 
																			 AND AnalCode = @StockCode),
														 @Commit) 
		END
		ELSE IF @ValueReq = 7
		BEGIN
			SELECT @HistVal = OrigValuation FROM [!ActiveSchema!].AnalysisCodeBudget
											WHERE JobCode = @JobCode AND AnalCode = @StockCode
		END
		ELSE IF @ValueReq = 8
		BEGIN
			SELECT @HistVal = RevValuation FROM [!ActiveSchema!].AnalysisCodeBudget
										   WHERE JobCode = @JobCode AND AnalCode = @StockCode	
		END
		ELSE IF @ValueReq = 9
		BEGIN
			SELECT @HistVal = JAPcntApp FROM [!ActiveSchema!].AnalysisCodeBudget
										WHERE JobCode = @JobCode AND AnalCode = @StockCode	
		END
		ELSE IF @ValueReq = 10
		BEGIN
			SELECT @HistVal = OverCost FROM [!ActiveSchema!].AnalysisCodeBudget
									   WHERE JobCode = @JobCode AND AnalCode = @StockCode	
		END
		ELSE IF @ValueReq = 11
		BEGIN
			SELECT @HistVal = Recharge FROM [!ActiveSchema!].AnalysisCodeBudget
									   WHERE JobCode = @JobCode AND AnalCode = @StockCode	
		END
		ELSE IF @ValueReq = 12
		BEGIN
			SELECT @HistVal = JBudgetCurr FROM [!ActiveSchema!].AnalysisCodeBudget
										  WHERE JobCode = @JobCode AND AnalCode = @StockCode	
		END
	END
	
	IF @HistVal IS NULL
	BEGIN
		SET @HistVal = 0
	END

	-- Return the result of the function
	RETURN @HistVal

END

GO


