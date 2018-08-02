--/////////////////////////////////////////////////////////////////////////////
--// Filename		: isp_ResetAuditHistory.sql
--// Author		: Nilesh Desai
--// Date		: 4 July 2008
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to add isp_ResetAuditHistory stored procedure.
--//                  This SP will clear all details for a given account from the History table
--// Usage : EXEC @ReturnValue = [common].[isp_ResetAuditHistory] 'ZZZZ01','WABAP01', 1, 104, 7
--//         EXEC [common].[isp_ResetAuditHistory] 'ZZZZ01','WABAP01', 1, 104
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: File Creation
--//    2   : Deals with Account Codes of 6 chars that include an apostrophe - GRJ - 5/5/15
--//
--/////////////////////////////////////////////////////////////////////////////

IF EXISTS ( SELECT	TOP 1 1
		    FROM    dbo.sysobjects 
		    WHERE	id = OBJECT_ID(N'[common].[isp_ResetAuditHistory]') 
			AND		OBJECTPROPERTY(id,N'IsProcedure') = 1
		  )

DROP PROCEDURE [common].[isp_ResetAuditHistory]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [common].[isp_ResetAuditHistory]	(
	    @iv_CompanyCode			VARCHAR(6)
	  ,	@iv_AccountCode			VARCHAR(10)
	  ,	@iv_DelCCDeptHist		BIT
	  ,	@iv_AfterPurgeYear		INT
	  , @iv_KeyLength			INT
  )
AS
BEGIN
	-- Constants
	DECLARE	   @c_AccountLengthWithChar INT

	SELECT	   @c_AccountLengthWithChar = 7

	DECLARE    @CRLF			NVARCHAR(5)	
			 , @ReturnCode		INT
			 , @UpdateScript	VARCHAR(MAX)
			 , @hiExClass		INT
			 , @AccountCode		VARCHAR(10)			
			 , @AccountCd		VARCHAR(10)
			 , @CharValue		VARCHAR(1)

	SELECT    @ReturnCode = 0	
			, @AccountCode = LTRIM(RTRIM(REPLACE(@iv_AccountCode, CHAR(39), CHAR(39) + CHAR(39))))

	SELECT	  @hiExClass = ASCII(LEFT(@AccountCode, 1))
	        , @AccountCd = CASE 
								WHEN @iv_KeyLength <> @c_AccountLengthWithChar THEN 
									SUBSTRING(@AccountCode, 3, LEN(@AccountCode))
								ELSE 
									SUBSTRING(@AccountCode, 2, LEN(@AccountCode))
							END
			, @CharValue = CASE 
								WHEN @iv_KeyLength <> @c_AccountLengthWithChar THEN 
									SUBSTRING(@AccountCode, 2, 1)
								ELSE
									' '
							END
			, @CRLF = CHAR(13) + CHAR(10)

	-- Building update query for table HISTORY [clearing out values]
	SELECT @UpdateScript = ''
			-- Update hiSales, hiPurchase, hiCleared 
			+ @CRLF + ' UPDATE		HST '
			+ @CRLF + ' SET			hiSales = 0 '
			+ @CRLF + '			  , hiPurchases = 0 '
			+ @CRLF + '			  , hiCleared = 0 '
			+ @CRLF + ' FROM		' + LTRIM(RTRIM(@iv_CompanyCode)) + '.HISTORY HST '	 
			+ @CRLF + ' WHERE		hiExClass = ' + CONVERT(VARCHAR(MAX), @hiExClass)

	IF LEN(@CharValue) > 0
		SELECT @UpdateScript = @UpdateScript + ''
			+ @CRLF + ' AND			SUBSTRING(hiCode, 2, 1) = CHAR(' + CONVERT(VARCHAR(MAX),ASCII(@CharValue)) + ')'
	
	SELECT @UpdateScript = @UpdateScript + ''			
			+ @CRLF + ' AND			CONVERT(VARCHAR(6),SUBSTRING(hiCode, ' + CONVERT(VARCHAR(1),2+LEN(@CharValue)) + ', ' + '6' + ')) = '''  + @AccountCd + CASE WHEN LEN (@AccountCd) < 6 THEN SPACE(6-LEN(@AccountCd))
			                                                                                                                                                ELSE ''
			                                                                                                                                                END + ''''
			+ @CRLF + ' AND			hiYear > ' + CONVERT(VARCHAR(MAX), @iv_AfterPurgeYear)

	IF @iv_DelCCDeptHist = 1 
	BEGIN
		SELECT @UpdateScript = @UpdateScript + ''
				+ @CRLF + ' AND ( '
				+ @CRLF + '       (ASCII(CONVERT(VARCHAR(1),SUBSTRING(hiCode, ' + CONVERT(VARCHAR(MAX),LEN(@AccountCd)+1) + ' , 1))) > 32) '
				+ @CRLF + ' OR    (ASCII(CONVERT(VARCHAR(1),SUBSTRING(hiCode, ' + CONVERT(VARCHAR(MAX),LEN(@AccountCd)+2) + ', 1))) > 32) '
				+ @CRLF + ' OR    (ASCII(CONVERT(VARCHAR(1),SUBSTRING(hiCode, ' + CONVERT(VARCHAR(MAX),LEN(@AccountCd)+3)  + ', 1))) > 32) '
				+ @CRLF + '     ) '
	END
			
	BEGIN TRY
		-- PRINT @UpdateScript
		EXEC ( @UpdateScript )
	END TRY
	BEGIN CATCH
       	-- Execute error logging routine
	    EXEC common.isp_RaiseError   @iv_IRISExchequerErrorMessage = 'Procedure [common].[isp_ResetAuditHistory]' -- Include optional message...?
		-- SP failed - error raised
		SET @ReturnCode = -1	
    END CATCH

	SET NOCOUNT OFF
	RETURN @ReturnCode
END
GO