--/////////////////////////////////////////////////////////////////////////////
--// Filename		: isp_CheckStkLocHistory.sql
--// Author		: Nilesh Desai 
--// Date		: 3 July 2008
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to add isp_CheckStkLocHistory stored procedure.
--//                  This SP will clear all details for a given stock from 
--//               		History record (Delete all records) and MLocStock (Update 
--//                  balances as Zero to all relative fields)
--// Usage : EXEC @ReturnValue = [common].[isp_CheckStkLocHistory] 'ZZZZ01','ALARMSYS-DOM-1', 'M', 313
--//		     EXEC [common].[isp_CheckStkLocHistory] 'ZZZZ01','ALARMSYS-DOM-1', 'M', 313
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: 3 July 2008 : File Creation
--//  2 : 21 June 2010 : Updated for database normalisation
--//  3 : 23 September 2011 : Amended to allow single quotes in stock codes
--//
--/////////////////////////////////////////////////////////////////////////////

IF EXISTS ( SELECT	TOP 1 1
		    FROM    dbo.sysobjects 
		    WHERE	id = OBJECT_ID(N'[common].[isp_CheckStkLocHistory]') 
			AND		OBJECTPROPERTY(id,N'IsProcedure') = 1
  )

DROP PROCEDURE [common].[isp_CheckStkLocHistory]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [common].[isp_CheckStkLocHistory]	(
	@iv_CompanyCode			VARCHAR(6)
  ,	@iv_StockCode			VARCHAR(20)
  , @iv_stType				CHAR(1)
  ,	@iv_StockFolioNum		INT
  )
AS
BEGIN
	DECLARE    @CRLF					NVARCHAR(5)	
			 , @ReturnCode				INT
			 , @UpdateScript			VARCHAR(MAX)
			 , @DeleteScript			VARCHAR(MAX)
			 , @c_HistoryLocationFilter	VARCHAR(1)
			 , @c_HistoryClassOffSet	INT		

	-- Declare CONSTANTS
	SELECT    @c_HistoryLocationFilter = 'L'			
			, @c_HistoryClassOffSet	= 159
			, @ReturnCode = 0	
			, @CRLF = CHAR(13) + CHAR(10)

	-- Replace single quote with double quotes so SQL doesn't fail
	SET		@iv_StockCode = REPLACE(@iv_StockCode, CHAR(39), CHAR(39) + CHAR(39))

	-- Building delete statement from HISTORY table for specific stock
	SELECT @DeleteScript = ''
			+ @CRLF + ' DELETE	'
			+ @CRLF + ' FROM	' + LTRIM(RTRIM(@iv_CompanyCode)) + '.HISTORY '
			+ @CRLF + ' WHERE	hiExClass	= (ASCII(''' + @iv_stType + ''')+' + CONVERT(VARCHAR(3),@c_HistoryClassOffSet) + ')'
			+ @CRLF + ' AND	    CONVERT(VARCHAR(1),SUBSTRING(hiCode, 2, 1)) = ''' + @c_HistoryLocationFilter + ''''
			+ @CRLF + ' AND		CONVERT(INT, CONVERT(BINARY(4),CONVERT(CHAR(4), REVERSE(SUBSTRING(hiCode, 3, 4)))))  = ' + CONVERT(VARCHAR(MAX),@iv_StockFolioNum)

	-- Building update query table MLOCSTK [clearing out values]
	SELECT @UpdateScript = ''
			+ @CRLF + ' UPDATE  MLS '
			+ @CRLF + ' SET			lsQtyInStock = 0 '
			+ @CRLF + '			  , lsQtyAlloc = 0 '
			+ @CRLF + '			  , lsQtyOnOrder = 0 '
			+ @CRLF + '			  , lsQtyPicked = 0 '
			+ @CRLF + '			  , lsQtyAllocWOR = 0 '
			+ @CRLF + '			  , lsQtyIssueWOR = 0 '
			+ @CRLF + '			  , lsQtyReturn = 0 '
			+ @CRLF + '			  , lsQtyPReturn = 0 '
			+ @CRLF + ' FROM		' + LTRIM(RTRIM(@iv_CompanyCode)) + '.StockLocation MLS '	 
			+ @CRLF + '	WHERE		MLS.lsStkCode = ''' + @iv_StockCode + '''' 

	BEGIN TRY
		EXEC ( @DeleteScript )
		EXEC ( @UpdateScript )
	END TRY
	BEGIN CATCH
     	-- Execute error logging routine
	    EXEC common.isp_RaiseError   @iv_IRISExchequerErrorMessage = 'Procedure [common].[isp_CheckStkLocHistory]' -- Include optional message...?
		-- SP failed - error raised
		SET @ReturnCode = -1	
    END CATCH

	SET NOCOUNT OFF
	RETURN @ReturnCode
END
GO
