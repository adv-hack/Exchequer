--/////////////////////////////////////////////////////////////////////////////
--// Filename		: ifn_GetJCValue.sql
--// Author		: James Waygood
--// Date		: 24th May 2010
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description : Gets a specified Job Budget History value 
--// Execute     : SELECT [ZZZZ01].[ifn_GetJCValue] (6, 'B', 10, 'P', 2007, 0, 0, 'BATH01', '')
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: File Creation
--//
--/////////////////////////////////////////////////////////////////////////////

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[ifn_GetJCValue]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [!ActiveSchema!].[ifn_GetJCValue]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*
{********************************************************************************}
{* GetJCValue: Returns a value for the specified job budget record in the       *}
{*             specified companies data. ValueReq indicates which of the		    *}
{*             of the history values is required:								                *}
{*                      1 Budget Qty											                      *}
{*                      2 Budget Value											                    *}
{*                      3 Revised Budget Qty									                  *}
{*                      4 Revised Budget Value									                *}
{*                      5 Actual Qty											                      *}
{*                      6 Actual Value											                    *}
{*                      7 Valuation To Date			(currently not supported)	      *}
{*                      8 Next Valuation Amount		(currently not supported)	    *}
{*                      9 Next Valuation Percentage	(currently not supported)	  *}
{********************************************************************************}
*/

CREATE FUNCTION [!ActiveSchema!].[ifn_GetJCValue] 
(
	@ValueReq		int,
	@BT				char(1),	-- Budget Type
	@TType			int,		-- Total Type
	@PCChar			char(1),	-- Posted/Committed
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
	DECLARE @DblVal			float
	DECLARE @NomValue		float
	
		
	SET		@ChkJobCode		= ''
	SET		@ChkStkCode		= ''
	SET		@Commit			= 0
	SET		@DblVal			= 0
	SET		@NomValue		= 0
	
	-- Check if valid Job Code
	SELECT @ChkJobCode	=	JobCode
							FROM [!ActiveSchema!].[JOBHEAD]
							WHERE @JobCode = JobCode
	
	IF @ChkJobCode <> @JobCode
	BEGIN
		SET @NomValue	=	100000521		-- Invalid Job Code
	END
	
	-- Check if valid Analysis Code
	IF Len(@StockCode) > 0 
	BEGIN
		SELECT @ChkStkCode	=	var_code1Trans1
								FROM [!ActiveSchema!].JOBMISC
								WHERE RecPfix = 'J' AND SubType = 'A' AND var_code1Trans1 = @StockCode
								
		IF @ChkStkCode <> @StockCode
		BEGIN
			SET @NomValue	=	100000522	-- Invalid Job Analysis Code
		END
	END
	
	IF @PCChar = 'P'
	BEGIN
		SET @Commit = 0
	END
	ELSE IF @PCChar = 'C'
	BEGIN
		SET @Commit = 1
	END
	ELSE 
	BEGIN
		SET @NomValue = 100000533	-- Invalid Posted/Committed Flag
	END
	
	IF @NomValue = 0 
	BEGIN
		SELECT @NomValue = [!ActiveSchema!].[ifn_GetJCBudgetValue] (@ValueReq
															,@BT
															,@TType
															,@Commit
															,@TheYear
															,@ThePeriod
															,@TheCcy
															,@JobCode
															,@StockCode)

		IF @NomValue IS NULL
		BEGIN
			SET @NomValue = 0
		END
	END
	-- Return the result of the function
	RETURN @NomValue

END

GO


