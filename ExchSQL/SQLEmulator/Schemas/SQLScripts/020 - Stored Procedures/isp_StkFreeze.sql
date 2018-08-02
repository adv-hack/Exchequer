--/////////////////////////////////////////////////////////////////////////////
--// Filename		: isp_StkFreeze.sql
--// Author		: Nilesh Desai 
--// Date		: 23 June 2008
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to add isp_StkFreeze stored procedure.
--//                  This SP will update "Stock" and "MLocStk" tables and will 
--//                  freeze the stock take values
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: 23 June 2008 : Nilesh Desai : File Creation
--//  2 : 21 June 2010 : Updated for database normalisation
--//
--/////////////////////////////////////////////////////////////////////////////

IF EXISTS ( SELECT	TOP 1 1
		    FROM    dbo.sysobjects 
		    WHERE	id = OBJECT_ID(N'[common].[isp_StkFreeze]') 
			AND		OBJECTPROPERTY(id,N'IsProcedure') = 1
  )

DROP PROCEDURE [common].[isp_StkFreeze]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [common].[isp_StkFreeze]	(
	  @iv_CompanyCode	VARCHAR(6)	
	, @iv_LocationCode	VARCHAR(10)		
	, @iv_IsUsePostQty	bit
	, @iv_CurrentYear	INT		= NULL
	, @iv_hiPeriod		INT		= NULL
)
AS
BEGIN
	DECLARE    @CRLF				NVARCHAR(5)	
			 , @ReturnCode			INT
			 , @UpdateScriptStock	VARCHAR(MAX)
			 , @UpdateScriptMLocStk	VARCHAR(MAX)
			 , @c_IsFalse			bit
			 , @c_IsTrue			bit
			 , @c_stTypes			VARCHAR(MAX)	

	-- Declare CONSTANTS
	SELECT    @c_IsFalse			= 0
			, @c_IsTrue				= 1
			, @CRLF					= CHAR(13) + CHAR(10)
			, @ReturnCode			= 0	
		    , @UpdateScriptStock	= ''
			, @UpdateScriptMLocStk	= ''
			, @c_stTypes			= '''' + CHAR(56) + ''',' + '''' + CHAR(57) + ''','  + '''' + CHAR(66) + ''',' + '''' + CHAR(67) + ''','  
									  + @CRLF + '''' + CHAR(74) + ''',' + '''' + CHAR(75) + ''',' + '''' + CHAR(90) + ''','  + '''' + CHAR(236) + ''','  
									  + @CRLF + '''' + CHAR(247) + ''',' + '''' + CHAR(72) + ''',' + '''' + CHAR(85) + ''','  + '''' + CHAR(86) + ''','  
									  + @CRLF + '''' + CHAR(91) + ''',' + '''' + CHAR(239) + ''''

	-- Replace single quote with double quotes so SQL doesn't fail
	SET		@iv_LocationCode = REPLACE(@iv_LocationCode, CHAR(39), CHAR(39) + CHAR(39))
	
	-- Building update stock table query based input parameter passed [location] 
	-- If user select dialog "Do you wish to use the current live stock levels"
	IF @iv_IsUsePostQty = @c_IsFalse 	
	BEGIN

		-- Dynamically created updating SQL statement for STOCK values
		SELECT @UpdateScriptStock = ''
				+ @CRLF + ' UPDATE  STK '
				+ @CRLF + ' SET			stQtyFreeze    = ISNULL(MLS.lsQtyInStock, STK.stQtyInStock) '
				+ @CRLF + '			  , stQtyStockTake = ISNULL(MLS.lsQtyInStock, STK.stQtyStockTake) '
			    + @CRLF + '			  , stStockTakeFlag = ' + CONVERT(VARCHAR(1),@c_IsFalse)  
				+ @CRLF + ' FROM	   ' + LTRIM(RTRIM(@iv_CompanyCode)) + '.STOCK	 STK '
				+ @CRLF + ' LEFT JOIN  ' + LTRIM(RTRIM(@iv_CompanyCode)) + '.StockLocation MLS	 ON MLS.lsStkCode = STK.stCode  COLLATE Latin1_General_CI_AS '

		-- No Location is passed update while stock table and getting back to original status 
		IF LEN(@iv_LocationCode) > 0
				SELECT @UpdateScriptStock = @UpdateScriptStock + ' AND MLS.lsLocCode = ''' + @iv_LocationCode + ''' COLLATE SQL_Latin1_General_CP437_BIN'  

	END

	IF @iv_IsUsePostQty = @c_IsTrue 	
	BEGIN
		-- Dynamically created updating SQL statement for STOCK values
		SELECT @UpdateScriptStock = ''			
			+ @CRLF + ' UPDATE		STK '
			+ @CRLF + ' SET			stQtyPosted		= ISNULL(HST.hiCleared, 0) '
			+ @CRLF + '			  , stQtyFreeze		= ISNULL(HST.hiCleared, 0) '
			+ @CRLF + '			  , stQtyStockTake	= ISNULL(HST.hiCleared, 0) '
			+ @CRLF + ' FROM		' + LTRIM(RTRIM(@iv_CompanyCode)) + '.STOCK	STK '
			+ @CRLF + ' JOIN		' + LTRIM(RTRIM(@iv_CompanyCode)) + '.StockLocation  MLS	 ON MLS.lsStkCode = STK.stCode  COLLATE Latin1_General_CI_AS '

			-- No Location is passed update while stock table and getting back to original status 
			IF LEN(@iv_LocationCode) > 0
				SELECT @UpdateScriptStock = @UpdateScriptStock + ' AND MLS.lsLocCode = ''' + @iv_LocationCode + ''' COLLATE SQL_Latin1_General_CP437_BIN'  

		SELECT @UpdateScriptStock = @UpdateScriptStock + ''
			+ @CRLF + ' OUTER APPLY ( SELECT	hiCleared '
			+ @CRLF + '				  FROM		' + LTRIM(RTRIM(@iv_CompanyCode)) + '.[ifn_GetHistoryClearedQty] '
			+ @CRLF + '								(STK.stType, STK.stFolioNum, ''' + @iv_LocationCode + ''', ' + CONVERT(VARCHAR(MAX),@iv_CurrentYear) + ',' + CONVERT(VARCHAR(MAX),@iv_hiPeriod) + ')) as HST '
			+ @CRLF + '	WHERE 		CHAR(ASCII(STK.stType)+159) IN ( ' + @c_stTypes + ' ) '
	END

	-- Dynamically created updating SQL statement for MLocStk (Location wise Stock table) values
	SELECT @UpdateScriptMLocStk = ''
			+ @CRLF + ' UPDATE  MLS '
			+ @CRLF + ' SET			lsQtyFreeze = ISNULL(STK.stQtyFreeze, 0) '
			+ @CRLF + '			  , lsQtyTake   = ISNULL(STK.stQtyStockTake, 0) '
		    + @CRLF + '			  , lsStkFlg     = STK.stStockTakeFlag '
			+ @CRLF + ' FROM		' + LTRIM(RTRIM(@iv_CompanyCode)) + '.StockLocation MLS '
			+ @CRLF + ' JOIN	    ' + LTRIM(RTRIM(@iv_CompanyCode)) + '.STOCK   STK  ON STK.stCode = MLS.lsStkCode COLLATE Latin1_General_CI_AS '

	-- No Location is passed update while stock table and getting back to original status 
	IF LEN(@iv_LocationCode) > 0
			SELECT @UpdateScriptMLocStk = @UpdateScriptMLocStk + ' AND MLS.lsLocCode = ''' + @iv_LocationCode + ''''

	-- Executing dynamically generated "UpdateScript"
	BEGIN TRY
		EXEC ( @UpdateScriptStock )
		EXEC ( @UpdateScriptMLocStk )
	END TRY
	BEGIN CATCH
     	-- Execute error logging routine
	    EXEC common.isp_RaiseError   @iv_IRISExchequerErrorMessage = 'Procedure [common].[isp_StkFreeze]' -- Include optional message...?
		-- SP failed - error raised
		SET @ReturnCode = -1	
    END CATCH

	SET NOCOUNT OFF
	RETURN @ReturnCode
END
GO
