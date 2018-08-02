--/////////////////////////////////////////////////////////////////////////////
--// Filename		: isp_StkLocORReplaceInter.sql
--// Author		: Nilesh Desai
--// Date		: 18 June 2008
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to add isp_StkLocORReplaceInter stored procedure
--//                  This SP will update the Stock table based on the location 
--//                  filter from the Stock List screen/form. In this Stock List
--//                  screen there are 3 different tabs and based on the tab 
--//                  selected changes the parameter for "Mode".  
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: 18 June 2008 - Nilesh Desai - File Creation
--//    2       : 21 June 2010 - Updated for database normalisation
--//    3       : 06 August 2015 - Fix for ABSEXCH-16416
--//
--/////////////////////////////////////////////////////////////////////////////

IF EXISTS ( SELECT	TOP 1 1
		    FROM    dbo.sysobjects 
		    WHERE	id = OBJECT_ID(N'[common].[isp_StkLocORReplaceInter]') 
			AND		OBJECTPROPERTY(id,N'IsProcedure') = 1
  )

DROP PROCEDURE [common].[isp_StkLocORReplaceInter]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [common].[isp_StkLocORReplaceInter]	(
	@iv_CompanyCode			VARCHAR(6)
  , @iv_LocationCode		VARCHAR(10)
  , @iv_Mode				INT
  )
AS
BEGIN
	DECLARE    @CRLF			NVARCHAR(5)	
			 , @ReturnCode      INT
			 , @UpdateScript	VARCHAR(MAX)
			 , @c_stType		CHAR(1)
	
	-- Declare CONSTANTS
	SELECT    @c_stType = 'G'
			, @CRLF = CHAR(13) + CHAR(10)
			, @ReturnCode = 0	

	-- Replace single quote with double quotes so SQL doesn't fail
	SET		@iv_LocationCode = REPLACE(@iv_LocationCode, CHAR(39), CHAR(39) + CHAR(39))
	
	-- Building update stock table query based input parameter passed [location and mode] 
	SELECT @UpdateScript = ''
			+ @CRLF + ' UPDATE  STK '
	
	IF @iv_Mode = 0 
			-- Even if "stSuppTemp" length is 10 but in Betrieve padding it to 6 digit only
			SELECT @UpdateScript = @UpdateScript + ' SET STK.stSuppTemp = LEFT(CAST(MLS.lsSupplier as VARCHAR(6)) + SPACE(6), 6) ' 
	IF @iv_Mode = 2 			
			SELECT @UpdateScript = @UpdateScript + ' SET STK.stBinLocation = LEFT(CAST(MLS.lsBinLoc as VARCHAR(10)) + SPACE(10), 10) '
	IF @iv_Mode = 3 			
			SELECT @UpdateScript = @UpdateScript + ' SET STK.stSuppTemp = STK.stSupplier '
	IF @iv_Mode = 5 			
			SELECT @UpdateScript = @UpdateScript + ' SET STK.stBinLocation = STK.stTempBLoc '
		
	SELECT @UpdateScript = @UpdateScript + ' '
	    + @CRLF + ' FROM        ' + LTRIM(RTRIM(@iv_CompanyCode)) + '.StockLocation MLS '
		+ @CRLF + ' JOIN        ' + LTRIM(RTRIM(@iv_CompanyCode)) + '.STOCK   STK ON MLS.LsStkCode = STK.stCode  COLLATE Latin1_General_CI_AS '
		+ @CRLF + '	WHERE       STK.stType   <> ''' + @c_stType + ''''
	
	-- No Location is passed update while stock table and getting back to original status 
	IF LEN(@iv_LocationCode) > 0
		SELECT @UpdateScript = @UpdateScript + ' AND MLS.LsLocCode = ''' + @iv_LocationCode + ''''

	BEGIN TRY
		EXEC (
				--PRINT
			    @UpdateScript
			 )
	END TRY
	BEGIN CATCH
       	-- Execute error logging routine
	    EXEC common.isp_RaiseError   @iv_IRISExchequerErrorMessage = 'Procedure [common].[isp_StkLocORReplaceInter]' -- Include optional message...?
		-- SP failed - error raised
		SET @ReturnCode = -1	

    END CATCH

	SET NOCOUNT OFF
	RETURN @ReturnCode
END
GO
