--/////////////////////////////////////////////////////////////////////////////
--// Filename		: ifn_GetJobBudgetValue.sql
--// Author		: James Waygood
--// Date		: 21st May 2010
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description 	: Used to retrieve JobBudget History Details 
--// Execute     	: SELECT [ZZZZ01].[ifn_GetJobBudgetValue] (6, 2007, 0, 0, 'BATH01', 10, 0)
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: File Creation
--//    2   : 18/07/14 - James Waygood - Amended for 7.0.11 release
--//    3   : 22/07/14 - James Waygood - Amended to use JobTotalBudgets when Split by Periods is disabled
--//    4   : 03/05/16 - Glen Jones - amended to use new Revised Budget value from ifn_TotalProfitToDateRange
--//
--/////////////////////////////////////////////////////////////////////////////

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[ifn_GetJobBudgetValue]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [!ActiveSchema!].[ifn_GetJobBudgetValue]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*
{***********************************************************************}
{* GetJobBudgetValue: Returns a value for the specified budget in      *}
{*                    the specified companies data. ValueReq indicates *}
{*                    which of the history values is required:         *}
{*                      1 Budget Qty                                   *}
{*                      2 Budget Value                                 *}
{*                      3 Revised Budget Qty                           *}
{*                      4 Revised Budget Value                         *}
{*                      5 Actual Qty                                   *}
{*                      6 Actual Value                                 *}
{*                    If Committed is set then the Committed history   *}
{*                    values are used instead of the posted values     *}
{***********************************************************************}
*/

CREATE FUNCTION [!ActiveSchema!].[ifn_GetJobBudgetValue] 
(
	@ValueReq		int,		
	@TheYear		int,		-- Year to retrieve value for 
	@ThePeriod		int,		-- Period to retrieve value for
	@TheCcy			int,		-- Currency
	@JobCode		char(10),	-- GL Code
	@HistFolio		int,		-- Category
	@Commited		smallint
)
RETURNS float
AS
BEGIN
	-- Declare the return variable here
	DECLARE @NomValue		float
	DECLARE @BaseOffset		float
	DECLARE @NYear			int
	DECLARE @NPeriod		int
	DECLARE @YTD			int
	DECLARE @ChkJobCode		varchar(10)
	DECLARE @HistCode		char(1)
	DECLARE @CommitKey		varchar(6)
	DECLARE @Key			binary(20)
	DECLARE @DCr			int
	DECLARE @DPr			int
	DECLARE @DYr			int
	DECLARE @AcPr			int
	DECLARE @PrYrMode		smallint
	DECLARE @Range			smallint
	DECLARE @FullJDHistKey	binary(20)
	DECLARE @HistFolBin		binary(4)
	
	SET		@NomValue		= 0
	SET		@BaseOffset		= 0
	SET		@NYear			= 0
	SET		@NPeriod		= 0
	SET		@YTD			= 255
	SET		@HistCode		= ''
	SET		@Key			= 0x2020202020202020202020202020202020202020
	SELECT	@CommitKey		= 'CMT' + REPLICATE(CHAR(2), 2) + CHAR(33)
	SET		@ChkJobCode		= 0
	SET		@DCr			= 0
	SET		@DPr			= 0
	SET		@DYr			= 0
	SET		@AcPr			= 0
	SET		@PrYrMode		= 0
	SET		@Range			= 0
	SET		@FullJDHistKey	= 0x2020202020202020202020202020202020202020
	SET		@HistFolBin		= 0x00000000
	
	-- Check if valid Job Code
	SELECT @ChkJobCode	=	JobCode
							FROM [!ActiveSchema!].[JOBHEAD]
							WHERE @JobCode = JobCode
	
	IF @ChkJobCode <> @JobCode
	BEGIN
		SET @NomValue	=	100000521		-- Invalid Job Code
	END
	
	-- FullJDHistKey
	IF @NomValue = 0
	BEGIN
		IF @Commited <> 0
		BEGIN
			SET @HistCode = '['
		END
		ELSE
		BEGIN
			SELECT @HistCode = JobType 
							FROM [!ActiveSchema!].[JOBHEAD]
							WHERE @JobCode = JobCode
		END
		
		SET @HistFolBin = CAST(@HistFolio as binary(4))
		
		SET @FullJDHistKey = CAST(RTRIM(@JobCode) + SPACE(10 - LEN(@JobCode)) as BINARY(10)) + SUBSTRING(@HistFolBin, 4,1) + SUBSTRING(@HistFolBin, 3,1) + SUBSTRING(@HistFolBin, 2,1) + SUBSTRING(@HistFolBin, 1,1) + 0x202020202020
	END

	-- Build Search Key
	IF @NomValue = 0
	BEGIN
		
--		IF @Commited <> 0
--		BEGIN
--			SET @Key = CAST(@CommitKey as BINARY(6)) + 
--						CAST(SPACE(20 - LEN(CAST(@CommitKey as BINARY(6)) + @FullJDHistKey)) AS VARBINARY(10))
--		END
--		ELSE
		SET @Key = @FullJDHistKey
	END
	
-- BuildDicLink

	SET @DCr = @TheCcy
	
	-- Check Periods to return value for
	If @NomValue = 0
		BEGIN
		IF @ThePeriod = 0
		BEGIN
			SET @DPr	= @YTD
		END
		ELSE IF @ThePeriod = -99	-- -99 = F6 Period							
		BEGIN
			SELECT @DPr	= [CPr] FROM [!ActiveSchema!].[EXCHQSS]
										WHERE IDCodeComputed = CAST('SYS' AS CHAR(3))
		END
		ELSE IF @ThePeriod = -98	-- -98 = CTD - Total for everything ever							
		BEGIN
			SET @DPr		= @YTD
			SET @DYr		= 255
		END
		ELSE IF @ThePeriod >= 101 AND @ThePeriod <= 199
		BEGIN
			SET @DPr		= @ThePeriod - 100
			SET @PrYrMode	= 1
		END
		ELSE IF @ThePeriod >= 1 AND @ThePeriod <= 99							
		BEGIN
			SET @DPr	= @ThePeriod
		END
		ELSE
			SET @NomValue = 100000513		-- Invalid Period
		
		-- Check Years to return value for
		IF @DYr = 0
		BEGIN
			IF @TheYear = 0
			BEGIN
				SET @DYr = @YTD
			END
			ELSE IF @TheYear = -99
			BEGIN
			SELECT @DYr	= [CYr] FROM [!ActiveSchema!].[EXCHQSS]
										WHERE IDCodeComputed = CAST('SYS' AS CHAR(3))		
			END
			ELSE IF @TheYear > 1900 AND @TheYear < 2100
			BEGIN
				SELECT @DYr = @TheYear - 1900
			END
			ELSE
			BEGIN
				SET @NomValue = 100000512	-- Invalid Year
			END
		END
	END
-- End of BuildDicLink

-- ------------------------------------------------
/*  1 = CrDr[BOff]
    2 = CrDr[BOn]
    3 = Actual (Balance, 5-4)
    4 = Budget
    5 = Budget2
    6 = Cleared

*/
	IF @NomValue = 0 
	BEGIN
		IF (@DPr = 255 OR @DPr = 254) OR @PrYrMode = 1
		BEGIN
			SET @Range = 1
		END
		
		IF (@HistCode IN ('G', 'P', 'D', 'M', 'X', 'A')) AND @DYr = @YTD
		BEGIN
			SELECT @DYr = [CYr] FROM [!ActiveSchema!].[EXCHQSS]
						 WHERE IDCodeComputed = CAST('SYS' AS CHAR(3))
		END
		
		IF @Range = 1 AND @PrYrMode <> 1
		BEGIN
			IF @DPr = @YTD
			BEGIN
				SET @AcPr = 253
			END				  		
			ELSE
			BEGIN
				SELECT @AcPr = [CPr] FROM [!ActiveSchema!].[EXCHQSS]
								 WHERE IDCodeComputed = CAST('SYS' AS CHAR(3))
			END
		END
		ELSE
		BEGIN
			SET @AcPr = @DPr
		END
		
		IF @NomValue = 0
		BEGIN
			IF (@ThePeriod >= 101 AND @ThePeriod <=199) AND	 @HistCode <> 'P' 
			BEGIN
				SELECT @BaseOffset = [!ActiveSchema!].ifn_GetJobBudgetValue(@ValueReq,
																	@TheYear - 1, 
																    0,
																    @TheCcy,
																    @JobCode,
																    @HistFolio,
																    @Commited) 
			END
		END 
		
		IF @NomValue = 0 
		BEGIN

			DECLARE @iv_PPr2		int
			SET		@iv_PPr2		= 0

			IF (@ValueReq = 1 AND (SELECT TOP 1 PeriodBud FROM [!ActiveSchema!].EXCHQSS WHERE IDCode = 0x034A4F42) = 1)
			BEGIN
				SELECT @NomValue = BValue1 - @BaseOffset FROM [!ActiveSchema!].[ifn_TotalProfitToDateRange] (@HistCode
															,@Key
															,@DCr
															,@DYr
															,@AcPr
															,@iv_PPr2
															,@Range
															,0)
			END
			ELSE IF (@ValueReq = 1 AND (SELECT TOP 1 PeriodBud FROM [!ActiveSchema!].EXCHQSS WHERE IDCode = 0x034A4F42) = 0)
			BEGIN
				SELECT @NomValue = BoQty  FROM [!ActiveSchema!].[JobTotalsBudget] 
										  WHERE (HistFolio = @HistFolio
										  AND JobCode = @JobCode
										  AND JBudgetCurr = @TheCcy)
			END
			ELSE IF (@ValueReq = 2 AND (SELECT TOP 1 PeriodBud FROM [!ActiveSchema!].EXCHQSS WHERE IDCode = 0x034A4F42) = 1)
			BEGIN
				SELECT @NomValue = PBudget - @BaseOffset FROM [!ActiveSchema!].[ifn_TotalProfitToDateRange] (@HistCode
															,@Key
															,@DCr
															,@DYr
															,@AcPr
															,@iv_PPr2
															,@Range
															,0)
			END
			ELSE IF (@ValueReq = 2 AND (SELECT TOP 1 PeriodBud FROM [!ActiveSchema!].EXCHQSS WHERE IDCode = 0x034A4F42) = 0)
			BEGIN
				SELECT @NomValue = BoValue  FROM [!ActiveSchema!].[JobTotalsBudget] 
										  WHERE (HistFolio = @HistFolio
										  AND JobCode = @JobCode
										  AND JBudgetCurr = @TheCcy)
			END
			ELSE IF (@ValueReq = 3 AND (SELECT TOP 1 PeriodBud FROM [!ActiveSchema!].EXCHQSS WHERE IDCode = 0x034A4F42) = 1)
			BEGIN
				SELECT @NomValue = BValue2 - @BaseOffset FROM [!ActiveSchema!].[ifn_TotalProfitToDateRange] (@HistCode
															,@Key
															,@DCr
															,@DYr
															,@AcPr
															,@iv_PPr2
															,@Range
															,0)
			END
			ELSE IF (@ValueReq = 3 AND (SELECT TOP 1 PeriodBud FROM [!ActiveSchema!].EXCHQSS WHERE IDCode = 0x034A4F42) = 0)
			BEGIN
				SELECT @NomValue = BRQty  FROM [!ActiveSchema!].[JobTotalsBudget] 
										  WHERE (HistFolio = @HistFolio
										  AND JobCode = @JobCode
										  AND JBudgetCurr = @TheCcy)
			END
			ELSE IF (@ValueReq = 4 AND (SELECT TOP 1 PeriodBud FROM [!ActiveSchema!].EXCHQSS WHERE IDCode = 0x034A4F42) = 1)
			BEGIN
				SELECT @NomValue = PRBudget1 - @BaseOffset FROM [!ActiveSchema!].[ifn_TotalProfitToDateRange] (@HistCode
															,@Key
															,@DCr
															,@DYr
															,@AcPr
															,@iv_PPr2
															,@Range
															,0)
			END
			ELSE IF (@ValueReq = 4 AND (SELECT TOP 1 PeriodBud FROM [!ActiveSchema!].EXCHQSS WHERE IDCode = 0x034A4F42) = 0)
			BEGIN
				SELECT @NomValue = BRValue  FROM [!ActiveSchema!].[JobTotalsBudget] 
										  WHERE (HistFolio = @HistFolio
										  AND JobCode = @JobCode
										  AND JBudgetCurr = @TheCcy)
			END
			ELSE IF (@ValueReq = 5) 
			BEGIN
				SELECT @NomValue = PCleared - @BaseOffset FROM [!ActiveSchema!].[ifn_TotalProfitToDateRange] (@HistCode
															,@Key
															,@DCr
															,@DYr
															,@AcPr
															,@iv_PPr2
															,@Range
															,0)
			END
			ELSE IF (@ValueReq = 6) 
			BEGIN
				SELECT @NomValue = Balance - @BaseOffset FROM [!ActiveSchema!].[ifn_TotalProfitToDateRange] (@HistCode
															,@Key
															,@DCr
															,@DYr
															,@AcPr
															,@iv_PPr2
															,@Range
															,0)
			END
			ELSE IF (@ValueReq = 7) 
			BEGIN
				SELECT @NomValue = Purch - @BaseOffset FROM [!ActiveSchema!].[ifn_TotalProfitToDateRange] (@HistCode
															,@Key
															,@DCr
															,@DYr
															,@AcPr
															,@iv_PPr2
															,@Range
															,0)
			END
			ELSE IF (@ValueReq = 8) 
			BEGIN
				SELECT @NomValue = PSales - @BaseOffset FROM [!ActiveSchema!].[ifn_TotalProfitToDateRange] (@HistCode
															,@Key
															,@DCr
															,@DYr
															,@AcPr
															,@iv_PPr2
															,@Range
															,0)
			END
		END

		IF @NomValue IS NULL
		BEGIN
			SET @NomValue = 0
		END
	END
	-- Return the result of the function
	RETURN @NomValue

END

GO


