--/////////////////////////////////////////////////////////////////////////////
--// Filename		: isp_StockAddCustAnal.sql
--// Author		: Nilesh Desai 
--// Date		: 14 July 2008
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to add isp_StockAddCustAnal stored procedure
--//                  This SP will update/insert records to MLocStk based on 
--//                  parameter passed
--// Usage : EXEC @ReturnValue = [!ActiveSchema!].[isp_StockAddCustAnal] 'ABAP01','BAT-9PP3-ALK    ','20080711', -2147478510, 2, 1, 8, 'O', 3.83, 0
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: 14 July 2008 : Nilesh Desai : File Creation
--//
--/////////////////////////////////////////////////////////////////////////////

IF EXISTS ( SELECT	TOP 1 1
		    FROM    dbo.sysobjects 
		    WHERE	id = OBJECT_ID(N'[!ActiveSchema!].[isp_StockAddCustAnal]') 
			AND		OBJECTPROPERTY(id,N'IsProcedure') = 1
  )

DROP PROCEDURE [!ActiveSchema!].[isp_StockAddCustAnal]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [!ActiveSchema!].[isp_StockAddCustAnal]	(
	  @iv_CustCode		VARCHAR(6)	
	, @iv_StockCode		VARCHAR(16)		
	, @iv_PDate			VARCHAR(8)
	, @iv_FolioRef		INT		
	, @iv_AbsLineNo		INT		
	, @iv_Currency		INT		
	, @iv_IdDocHed		INT		
	, @iv_LineType		VARCHAR(1)		
	, @iv_LineTotal		FLOAT		
	, @iv_Mode			BIT		

)
AS
BEGIN
	DECLARE    @ReturnCode			INT
			 , @c_RecPfix			CHAR(1)
			 , @c_SubType			CHAR(1)

	-- Declare CONSTANTS
	SELECT    @c_RecPfix			= 'T'
			, @c_SubType			= 'P'	
			, @ReturnCode			= 0	

	BEGIN TRY

		IF @iv_Mode = 1 
		BEGIN
			-- Checking record existing in DETAILS table for given 
			IF NOT EXISTS  ( SELECT	TOP 1 1
							 FROM	[!ActiveSchema!].[DETAILS]
							 WHERE	tlLineType	= @iv_LineType
							 AND	tlAcCode	= @iv_CustCode
							 AND	CONVERT(VARCHAR(16), SUBSTRING(tlStockCode, 2, LEN(tlStockCode))) = @iv_StockCode
							 AND	(tlFolioNum <> @iv_FolioRef
							 OR		tlAbsLineNo <> @iv_AbsLineNo)
						)	
			BEGIN
				-- if found then delete records from DeTAILS table for given customer code, stockcode, folioref and abslineno 
				DELETE  
				FROM	[!ActiveSchema!].[MLOCSTK]
				WHERE	RecPFix		= @c_RecPfix
				AND		SubType		= @c_SubType
				AND		csCustCode	= @iv_CustCode
				AND		csStockCode = @iv_StockCode
			END
		END
		ELSE
		BEGIN
			DECLARE		@stFolioNum	 INT
				      , @stCalcPack  BIT			

			-- Getting Stock FolioNum and CalcPack from STOCK files for given stockcode
			SELECT		@stFolioNum = stFolioNum
					  , @stCalcPack = stCalcPack
			FROM		[!ActiveSchema!].[STOCK] 
			WHERE		stCode = @iv_StockCode
			 
			-- Check stockcode is exist in MLOCSTK table
			IF EXISTS ( SELECT	TOP 1 1 
						FROM	[!ActiveSchema!].[MLOCSTK] MLS
						WHERE	RecPFix		= @c_RecPfix
						AND		SubType		= @c_SubType
						AND		csCustCode	= @iv_CustCode
						AND		csStockCode = @iv_StockCode	
					  ) 
			BEGIN

				-- Checking for IDDocDed 
				IF (@iv_IdDocHed IN (0, 1, 3, 4, 6, 8, 9))
				BEGIN
					-- If given IdDocHed is exist in constants list then update MLocStk table
					-- for given customercode and stockcode records
					UPDATE	MLS
					SET		csLastDate = @iv_PDate
						  , csLPCurr   = @iv_Currency
						  , csLastPrice = @iv_LineTotal
					FROM	[!ActiveSchema!].[MLOCSTK] MLS
					WHERE	RecPFix		= @c_RecPfix
					AND		SubType		= @c_SubType
					AND		csCustCode	= @iv_CustCode
					AND		csStockCode = @iv_StockCode	
				END
			END
			ELSE
			BEGIN
				DECLARE @LatestLineNo INT

				-- Getting Latest LineNumber for given customer code
				SELECT	@LatestLineNo = ISNULL(MAX(ISNULL(csLineNo, 0)) + 1, 1)
				FROM	[!ActiveSchema!].[MLOCSTK]
				WHERE	RecPFix		= @c_RecPfix
				AND		SubType		= @c_SubType
				AND		csCustCode	= @iv_CustCode

				-- Insert records to MLocStk 
				INSERT INTO [!ActiveSchema!].[MLOCSTK]
				(
					  RecPFix  
					, SubType 
				    , csLineNo 
					, varCode1
					, varCode2
					, varCode3
					, csCustCode
					, csStockCode
					, csStkFolio
					, csLastDate
					, csLPCurr
					, csLastPrice
				)
				VALUES
				(
					  @c_RecPfix
					, @c_SubType
					, @LatestLineNo
					, CONVERT(VARBINARY(1), 14) + 
					    CONVERT(VARBINARY(6), LTRIM(RTRIM(@iv_CustCode))+ SPACE(6-LEN(LTRIM(RTRIM(@iv_CustCode))))) +
					    CONVERT(VARBINARY(4), REPLICATE(CONVERT(VARBINARY(1), 0),4)) +
					    [common].[ifn_IntToHex](@LatestLineNo) +
						CONVERT(VARBINARY(16), REPLICATE(CONVERT(VARBINARY(1), 0), 16))									-- varCode1 [Convert to HexDec [LatestLineNo]]
					, CONVERT(VARBINARY(1), 26) + 
					    CONVERT(VARBINARY(6), LTRIM(RTRIM(@iv_CustCode)) + SPACE(6-LEN(LTRIM(RTRIM(@iv_CustCode))))) + 
					    CONVERT(VARBINARY(4), REPLICATE(CONVERT(VARBINARY(1), 0),4)) + 
					    CONVERT(VARBINARY(16), @iv_StockCode + SPACE(16-LEN(@iv_StockCode))) +							
					    CONVERT(VARBINARY(19), REPLICATE(CONVERT(VARBINARY(1), 0), 19))									-- varCode2
					, CONVERT(VARBINARY(1), 26) + 
					    CONVERT(VARBINARY(16), @iv_StockCode+SPACE(16-LEN(@iv_StockCode))) +
					    CONVERT(VARBINARY(4), REPLICATE(CONVERT(VARBINARY(1), 0),4)) + 
					    CONVERT(VARBINARY(6), LTRIM(RTRIM(@iv_CustCode))+SPACE(6-LEN(LTRIM(RTRIM(@iv_CustCode))))) +
					    CONVERT(VARBINARY(5), REPLICATE(CONVERT(VARBINARY(1), 0), 5))									-- varCode3
				    , @iv_CustCode
					, @iv_StockCode
					, @stFolioNum
					, CASE 
							WHEN @iv_IdDocHed IN (0, 1, 3, 4, 6, 8, 9) THEN
								@iv_PDate
							ELSE
								NULL
					  END														-- csLastDate
					, CASE 
							WHEN @iv_IdDocHed IN (0, 1, 3, 4, 6, 8, 9) THEN
								@iv_Currency
							ELSE
								NULL
					  END														-- csLPCurr
					, CASE 
							WHEN @iv_IdDocHed IN (0, 1, 3, 4, 6, 8, 9) THEN
								@iv_LineTotal
							ELSE
								NULL
					  END														-- csNetValue
				)
			END			
		END		

	END TRY
	BEGIN CATCH
     	-- Execute error logging routine
	    EXEC common.isp_RaiseError   @iv_IRISExchequerErrorMessage = 'Procedure [!ActiveSchema!].[isp_StockAddCustAnal]' -- Include optional message...?
		-- SP failed - error raised
		SET @ReturnCode = -1	
    END CATCH

	SET NOCOUNT OFF
	RETURN @ReturnCode
END
GO
