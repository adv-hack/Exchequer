--/////////////////////////////////////////////////////////////////////////////
--// Filename			: ifn_GetNominalValue.sql
--// Author				: James Waygood 
--// Date				: 28th July 2008 
--// Copyright Notice	: (c) 2016 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description		: SQL Script to add ifn_GetNominalValue function to retrieve Nominal History Details 
--// Execute			: SELECT [ZZZZ01].[ifn_GetNominalValue] (1, 2008, 0, 0, 2010, '', '', '', 0)
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1   : File Creation
--//	2   : 18th July 2014  - James Waygood - Amended for the 7.0.11 release
--//	3   : 25th March 2015 - James Waygood - Correct issue when using Period 101-199 on P&L GL Headings
--//    4   : 14th May 2015   - James Waygood - Added initial lookups for Current Period, Year & P&L Start
--//    5   : 03rd May 2016	  - Glen Jones    - amended to use new Revised Budget value from ifn_TotalProfitToDateRange
--//    6   : 12th May 2016   - James Waygood - added revised budgets 2 - 5
--//
--/////////////////////////////////////////////////////////////////////////////

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[ifn_GetNominalValue]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [!ActiveSchema!].[ifn_GetNominalValue]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [!ActiveSchema!].[ifn_GetNominalValue] 
(
	@ValueReq		int,		-- 1=Debit 2=Credit 3=Actual (balance, 2-1) 4=Budget 5=RevisedBudget1 6=Cleared 7=RBudget2 8=RBudget3 9=RBudget4 10=RBudget5
	@TheYear		int,		-- Year to retrieve value for 
	@ThePeriod		int,		-- Period to retrieve value for
	@TheCcy			int,		-- Currency
	@NomCode		int,		-- GL Code
	@NomCC			char(3),	-- Cost Centre
	@NomDept		char(3),	-- Department
	@NomCDType		char(1),
	@Commited		smallint
)
RETURNS float
AS
BEGIN
	-- Declare the return variable here
	DECLARE @NomValue		float
	DECLARE @In_PandL		smallint
	DECLARE @BaseOffset		float
	DECLARE @NYear			int
	DECLARE @NPeriod		int
	DECLARE @CCDept_BOff	char(3)
	DECLARE @CCDept_BOn		char(3)
	DECLARE @YTD			int
	DECLARE @ChkNomCode		int
	DECLARE @ChkCCDept		char(3)
	DECLARE @HistCode		char(1)
	DECLARE @CommitKey		varchar(6)
	DECLARE @Key			binary(20)
	DECLARE @CalcCCKeyHistP binary(12)
	DECLARE @NomBIN			binary(4)
	DECLARE @NomBINRev		binary(4)
	DECLARE @CDFlag			char(1)
	DECLARE @CalcCCDepKey	char(7)
	DECLARE @DCr			int
	DECLARE @DPr			int
	DECLARE @DYr			int
	DECLARE @AcPr			int
	DECLARE @PrYrMode		smallint
	DECLARE @Range			smallint
	DECLARE @PLHeadCheck	int
	DECLARE @CurrentPeriod	int
	DECLARE @CurrentYear	int
	DECLARE @PLStartGL		int
	
	SET		@NomValue		= 0
	SET		@In_PandL		= 0
	SET		@BaseOffset		= 0
	SET		@NYear			= 0
	SET		@NPeriod		= 0
	SET		@CCDept_BOff	= '   '
	SET		@CCDept_BOn		= '   '
	SET		@YTD			= 255
	SET		@ChkCCDept		= '   '
	SET		@HistCode		= ''
	SET		@Key			= 0x2020202020202020202020202020202020202020
	SET		@CalcCCKeyHistP = 0x00
	SELECT	@CommitKey		= 'CMT' + REPLICATE(CHAR(2), 2) + CHAR(33)
	SET		@NOMBin			= 0x00000000
	SET		@NOMBinRev		= 0x00000000
	SET		@ChkNOMCode		= 0
	SET		@CDFlag			= ' '
	SET		@CalcCCDepKey	= '       '
	SET		@DCr			= 0
	SET		@DPr			= 0
	SET		@DYr			= 0
	SET		@AcPr			= 0
	SET		@PrYrMode		= 0
	SET		@Range			= 0
	SET		@PLHeadCheck	= 0
	
	-- Lookup Current Period, Year & P&L Start GL 
	SELECT @CurrentPeriod	= [CPr]
	     , @CurrentYear		= [CYr]
	     , @PLStartGL		= [NomCtrlPLStart] FROM [!ActiveSchema!].[EXCHQSS]
											   WHERE IDCode = 0x03535953
	
	-- Check if valid NOM & if in P+L
	SELECT @ChkNomCode	=	glCode
							FROM [!ActiveSchema!].[NOMINAL]
							WHERE @NomCode = glCode
	
	IF @ChkNomCode <> @NomCode
	BEGIN
		SET @NomValue	=	100000511		-- Invalid Nominal Code
	END
	ELSE
	BEGIN
		-- Check if in P+L
		SELECT @HistCode	=	glType
								FROM [!ActiveSchema!].[NOMINAL]
								WHERE @NomCode = glCode
		IF @HistCode = 'P'
		BEGIN
			SET @In_PandL = 1
		END

		IF @HistCode = 'H'
		BEGIN
			WITH GLTree(GLParent, glCode, TreeLevel) AS 
					(
						SELECT GLParent, glCode, 0 AS TreeLevel
						FROM [!ActiveSchema!].NOMINAL 
						WHERE GLCODE = @NomCode
						UNION ALL
						SELECT e.GLParent, e.glCode, TreeLevel + 1
						FROM [!ActiveSchema!].NOMINAL e
							INNER JOIN GLTree d
							ON e.glCode = d.glparent 
					)
			SELECT @PLHeadCheck = glCode FROM GLTree WHERE glCode = @PLStartGL
			
			IF @PLHeadCheck <> 0 
			BEGIN
				SET @In_PandL = 1
			END
		END
	END	
	
	SET @CCDept_BOff = UPPER(@NomDept) + SPACE (3 - Len(RTrim(@NomDept)))
	SET @CCDept_BOn = UPPER(@NomCC) + SPACE (3 - Len(RTrim(@NomCC)))
	
	-- Check Cost Centre is valid (if specified)
	IF @NomValue = 0
	BEGIN
		IF RTrim(@CCDept_BOn) <> ''
		BEGIN
			SELECT @ChkCCDept =	EXCHQCHKcode1Trans1
								FROM [!ActiveSchema!].[EXCHQCHK]
								WHERE RecPfix = 'C' AND SubType = 67 AND EXCHQCHKcode1Trans1 = @CCDept_BOn
			IF @ChkCCDept <> @CCDept_BOn
			BEGIN
				SET @NomValue	=	100000519		-- Invalid Cost Centre
			END
		END
		IF RTrim(@CCDept_BOff) <> ''
		BEGIN
			SELECT @ChkCCDept =	EXCHQCHKcode1Trans1
								FROM [!ActiveSchema!].[EXCHQCHK]
								WHERE RecPfix = 'C' AND SubType = 68 AND EXCHQCHKcode1Trans1 = @CCDept_BOff
			IF @ChkCCDept <> @CCDept_BOff
			BEGIN
				SET @NomValue	=	100000520		-- Invalid Department
			END
		END
	END
	
	IF @NomValue = 0
	BEGIN
		IF (@ThePeriod >= 101 AND @ThePeriod <=199) AND	 @HistCode <> 'P' 
		BEGIN
			IF (@HistCode IN ('B', 'C')) OR (@HistCode = 'H' AND @In_PandL <> 1)
			BEGIN
				SET @NYear = @TheYear - 1
				SET @NPeriod = 0
				SELECT @BaseOffset = [!ActiveSchema!].ifn_getNominalValue(@ValueReq,
																		  @NYear,
																	      @NPeriod,
																		  @TheCcy,
																		  @NomCode,
																		  @NomCC,
																		  @NomDept,
																		  @NomCDType,
																		  @Commited) 
			END
		END
	END 
	
	-- Build Search Key
	IF @NomValue = 0
	BEGIN
		-- CalcCCDepKey
		IF @NOMCDType = 'D' AND len(rtrim(@CCDept_BOn )) = 0
		BEGIN
			SET @CalcCCDepKey = @CCDept_BOff
			SET @CDFlag = 'D'
		END
		ELSE IF @NOMCDType = 'C' AND LEN(RTRIM(@CCDept_BOff)) = 0
		BEGIN
			SET @CalcCCDepKey = @CCDept_BOn
			SET @CDFlag = 'C'
		END
		ELSE IF @NOMCDType = 'C'   AND LEN(RTRIM(@CCDept_BOff)) <> 0 AND LEN(RTRIM(@CCDept_BOn)) <> 0
		BEGIN
			SET @CalcCCDepKey = (@CCDept_BOn) + CHAR(2) + (@CCDept_BOff)
			SET @CDFlag = 'C'
		END
		ELSE
		BEGIN
			SET @CalcCCDepKey = '       '
		END
		
		-- Build @CalcCCKeyHistP -- NomCode, IsCC, NomCCDep
		SET @NOMBin = CAST(@NomCode AS BINARY(4))
		
		SET @NomBinRev = 0x + (SUBSTRING(@NOMBin, 4, 1) + SUBSTRING(@NOMBin, 3, 1) + 
						   SUBSTRING(@NOMBin, 2, 1) + SUBSTRING(@NOMBin, 1, 1))
		
		IF @CDFlag = ' '
		BEGIN
			SET @CalcCCKeyHistP = 0x + @NomBinRev +
									CAST(@CalcCCDepKey AS BINARY(7)) + 
									CAST(' ' AS BINARY(1))
		END
		ELSE
		BEGIN
			SET @CalcCCKeyHistP = 0x + CAST(@CDFlag AS BINARY(1)) + @NomBinRev +
									CAST(@CalcCCDepKey AS BINARY(7))
		END
		
		IF @Commited <> 0
		BEGIN
			SET @Key = CAST(@CommitKey as BINARY(6)) + @CalcCCKeyHistP + 
						CAST(SPACE(20 - LEN(CAST(@CommitKey as BINARY(6)) + @CalcCCKeyHistP)) AS VARBINARY(10))
		END
		ELSE
		BEGIN
			SET @Key = @CalcCCKeyHistP + 
						CAST(SPACE(20 - LEN(RTRIM(@CalcCCKeyHistP))) AS VARBINARY(10))
		END
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
			SELECT @DPr	= @CurrentPeriod
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
			SELECT @DYr	= @CurrentYear		
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
    5 = RBudget1
    6 = Cleared
    7 = RBudget2
    8 = RBudget3
    9 = RBudget4
    10 = RBudget5
*/
	IF @NomValue = 0 
	BEGIN
		IF (@DPr = 255 OR @DPr = 254) OR @PrYrMode = 1
		BEGIN
			SET @Range = 1
		END
		
		IF (@HistCode IN ('G', 'P', 'D', 'M', 'X', 'A')) AND @DYr = @YTD
		BEGIN
			SELECT @DYr = @CurrentYear
		END
		
		IF @Range = 1 AND @PrYrMode <> 1
		BEGIN
			IF @DPr = @YTD
			BEGIN
				SET @AcPr = 253
			END				  		
			ELSE
			BEGIN
				SELECT @AcPr = @CurrentPeriod
			END
		END
		ELSE
		BEGIN
			SET @AcPr = @DPr
		END
		
		IF @NomValue = 0 
		BEGIN

			DECLARE @iv_PPr2		int
			SET		@iv_PPr2		= 0

			IF @ValueReq = 1
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
			ELSE IF @ValueReq = 2
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
			ELSE IF @ValueReq = 3
			BEGIN
				SELECT @NomValue = (Purch - PSales) - @BaseOffset FROM [!ActiveSchema!].[ifn_TotalProfitToDateRange] (@HistCode
															,@Key
															,@DCr
															,@DYr
															,@AcPr
															,@iv_PPr2
															,@Range
															,0)
			END
			ELSE IF @ValueReq = 4
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
			ELSE IF @ValueReq = 5
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
			ELSE IF @ValueReq = 6
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
			ELSE IF @ValueReq = 7
			BEGIN
				SELECT @NomValue = PRBudget2 - @BaseOffset FROM [!ActiveSchema!].[ifn_TotalProfitToDateRange] (@HistCode
															,@Key
															,@DCr
															,@DYr
															,@AcPr
															,@iv_PPr2
															,@Range
															,0)
			END
			ELSE IF @ValueReq = 8
			BEGIN
				SELECT @NomValue = PRBudget3 - @BaseOffset FROM [!ActiveSchema!].[ifn_TotalProfitToDateRange] (@HistCode
															,@Key
															,@DCr
															,@DYr
															,@AcPr
															,@iv_PPr2
															,@Range
															,0)
			END
			ELSE IF @ValueReq = 9
			BEGIN
				SELECT @NomValue = PRBudget4 - @BaseOffset FROM [!ActiveSchema!].[ifn_TotalProfitToDateRange] (@HistCode
															,@Key
															,@DCr
															,@DYr
															,@AcPr
															,@iv_PPr2
															,@Range
															,0)
			END
			ELSE IF @ValueReq = 10
			BEGIN
				SELECT @NomValue = PRBudget5 - @BaseOffset FROM [!ActiveSchema!].[ifn_TotalProfitToDateRange] (@HistCode
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


