--/////////////////////////////////////////////////////////////////////////////
--// Filename		: ifn_GetCustValue.sql
--// Author		: James Waygood
--// Date		: 28th July 2008 
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description : Used to retrieve Customer and Supplier History Details 
--// Execute     : SELECT [!ActiveSchema!].[ifn_GetCustValue] (0, 2008, 0, 'ABAP01')
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: File Creation
--//
--/////////////////////////////////////////////////////////////////////////////

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[ifn_GetCustValue]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [!ActiveSchema!].[ifn_GetCustValue]
GO

/****** Object:  UserDefinedFunction [!ActiveSchema!].[ifn_GetCustValue]    Script Date: 07/28/2008 09:47:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [!ActiveSchema!].[ifn_GetCustValue] 
(
	@ValueReq		int,		-- 0=Balance 1=NetSales 2=Costs 3=Margin 4=Debit 5=Credit 6=Budget
	@TheYear		int,		-- Year to retrieve value for 
	@ThePeriod		int,		-- Period to retrieve value for
	@CustCode		varchar(10)	-- Customer/Supplier Code
)
RETURNS float
AS
BEGIN
	-- Declare the return variable here
	DECLARE @CustValue		float
	DECLARE @ChkCustCode	varchar(10)
	DECLARE @DPr			int
	DECLARE @AcPr			int
	DECLARE @DYr			int
	DECLARE @YTD			int
	DECLARE @DCr			int
	DECLARE @PrYrMode		int
	DECLARE @ChkCr			tinyint
	DECLARE @Range			tinyint
	DECLARE @RC				int
	DECLARE @iv_NType		char(1)
	DECLARE @iv_NCode		binary(20)
	DECLARE @iv_PCr			bit
	DECLARE @iv_PYr			int
	DECLARE @iv_PPr			int
	DECLARE @iv_PPr2		int
	DECLARE @iv_Range		bit
	DECLARE @iv_SetACHist	bit
	DECLARE @HistCode       char(1)

	SET @CustValue		= 0
	SET @ChkCustCode	= '      '
	SET @DPr			= 0
	SET @iv_PPr2		= 0
	SET @DYr			= 0
	SET @YTD			= 255
	SET @PrYrMode		= 0
	SET @DCr			= 0
	SET @ChkCr			= 0
	SET @Range			= 0
	SET @AcPr			= 0

	-- Check Periods to return value for
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
		SET @CustValue = 100000513		-- Invalid Period
	
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
			SET @CustValue = 100000512	-- Invalid Year
		END
	END

	-- Check valid Account Code
	SELECT @ChkCustCode =	acCode
							FROM [!ActiveSchema!].[CUSTSUPP]
							WHERE @CustCode = acCode
	
	IF @ChkCustCode <> @CustCode
	BEGIN
		SET @CustValue = 100000515		-- Invalid Account Code
	END
	ELSE
	BEGIN
		-- Check if Customer or Supplier
		SELECT @ChkCustCode =	acCustSupp
								FROM [!ActiveSchema!].[CUSTSUPP]
								WHERE @CustCode = acCode
		IF @ChkCustCode = 'S'
		BEGIN
			SET @ChkCr = 1
		END
	END
-- ------------------------------------------------
/*  0 = Balance
    1 = Net Sales
    2 = Costs
    3 = Margin
    4 = Acc Debit
    5 = Acc Credit
    6 = Budget

    ChkCr = Off for Customers Debit details, On for Suppliers Credit Details.
*/
	IF @ValueReq >= 1 AND @ValueReq <= 3
	BEGIN
		SET @HistCode = 'W'
	END
	ELSE
	BEGIN
		SET @HistCode = 'U'
	END
	
	IF (@DPr = 255 OR @DPr = 254) OR @PrYrMode = 1
	BEGIN
		SET @Range = 1
	END
	
	IF (@iv_NType IN ('G', 'P', 'D', 'M', 'X', 'A')) AND @DYr = @YTD
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
	
	IF @CustValue = 0 
	BEGIN
	
		SET @iv_NType		= @HistCode
		SET @iv_NCode		= CAST((@CustCode + SPACE(20-LEN(@CustCode))) AS BINARY(20))
		SET @iv_PCr			= @DCr
		SET @iv_PYr			= @DYr
		SET @iv_PPr			= @AcPr
		SET @iv_Range		= @Range
		SET @iv_SetACHist	= 0

		IF @ValueReq = 0
		BEGIN
			SELECT @CustValue = Balance FROM [!ActiveSchema!].[ifn_TotalProfitToDateRange] (@iv_NType
														,@iv_NCode
														,@iv_PCr
														,@iv_PYr
														,@iv_PPr
														,@iv_PPr2
														,@iv_Range
														,@iv_SetACHist)
		END
		ELSE IF @ValueReq = 1
		BEGIN
			SELECT @CustValue = PSales FROM [!ActiveSchema!].[ifn_TotalProfitToDateRange] (@iv_NType
														,@iv_NCode
														,@iv_PCr
														,@iv_PYr
														,@iv_PPr
														,@iv_PPr2
														,@iv_Range
														,@iv_SetACHist)
		END
		ELSE IF @ValueReq = 2
		BEGIN
			SELECT @CustValue = Purch FROM [!ActiveSchema!].[ifn_TotalProfitToDateRange] (@iv_NType
														,@iv_NCode
														,@iv_PCr
														,@iv_PYr
														,@iv_PPr
														,@iv_PPr2
														,@iv_Range
														,@iv_SetACHist)
		END
		ELSE IF @ValueReq = 3
		BEGIN
			SELECT @CustValue = Purch - PSales FROM [!ActiveSchema!].[ifn_TotalProfitToDateRange] (@iv_NType
														,@iv_NCode
														,@iv_PCr
														,@iv_PYr
														,@iv_PPr
														,@iv_PPr2
														,@iv_Range
														,@iv_SetACHist)
		END
		ELSE IF @ValueReq = 4
		BEGIN
			SELECT @CustValue = Purch FROM [!ActiveSchema!].[ifn_TotalProfitToDateRange] (@iv_NType
														,@iv_NCode
														,@iv_PCr
														,@iv_PYr
														,@iv_PPr
														,@iv_PPr2
														,@iv_Range
														,@iv_SetACHist)
		END
		ELSE IF @ValueReq = 5
		BEGIN
			SELECT @CustValue = PSales FROM [!ActiveSchema!].[ifn_TotalProfitToDateRange] (@iv_NType
														,@iv_NCode
														,@iv_PCr
														,@iv_PYr
														,@iv_PPr
														,@iv_PPr2
														,@iv_Range
														,@iv_SetACHist)
		END
		ELSE IF @ValueReq = 6
		BEGIN
			SELECT @CustValue = PBudget FROM [!ActiveSchema!].[ifn_TotalProfitToDateRange] (@iv_NType
														,@iv_NCode
														,@iv_PCr
														,@iv_PYr
														,@iv_PPr
														,@iv_PPr2
														,@iv_Range
														,@iv_SetACHist)
		END
		
	END

	IF @CustValue IS NULL
	BEGIN
		SET @CustValue = 0
	END
	
	-- Return the result of the function
	RETURN @CustValue

END