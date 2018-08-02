--/////////////////////////////////////////////////////////////////////////////
--// Filename		: ifn_GetLineNumberStock.sql
--// Author		: Nilesh Desai
--// Date		: 4th July 2008
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to add ifn_GetLineNumberStock function
--// Execute     : SELECT [ZZZZ01].[ifn_GetLineNumberStock] (313)
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: File Creation
--//
--/////////////////////////////////////////////////////////////////////////////

IF  EXISTS ( SELECT TOP 1 1  
			 FROM	dbo.sysobjects 
			 WHERE	id = OBJECT_ID(N'[!ActiveSchema!].[ifn_GetLineNumberStock]') 
			 AND xtype in (N'FN', N'IF', N'TF')
			)

	DROP FUNCTION [!ActiveSchema!].[ifn_GetLineNumberStock]

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

CREATE FUNCTION [!ActiveSchema!].[ifn_GetLineNumberStock]
(
	  @iv_StockFolioNumber	INT		  = NULL 
)
RETURNS INT
AS
BEGIN
	-- DECLARE Constants
	DECLARE		@c_RecPFix			VARCHAR(1)
			  , @c_SubType_Stock	INT
			  , @CRLF				NVARCHAR(5)
			  
	SELECT		@c_RecPFix = 'N'
			  , @c_SubType_Stock = 83
			  , @CRLF = CHAR(13) + CHAR(10)

	-- Declare the return variable here
	DECLARE    @ov_ResultValue	INT	
			 , @SQLScript VARCHAR(MAX) 

	SELECT		@ov_ResultValue	= -1

	IF @iv_StockFolioNumber IS NOT NULL 
	BEGIN
		--PRINT 'Stock'
		SELECT	@ov_ResultValue = (ISNULL(Max(LineNumber),0) + 1) 
		FROM	[!ActiveSchema!].ExchqChk 
		WHERE	RecPFix = @c_RecPFix
		AND		SubType = @c_SubType_Stock
		AND		Cast(Cast(Cast(Reverse(SubString(ExchqChkCode1, 2, 4)) As Char(4)) As Binary(4)) As int) = @iv_StockFolioNumber
	END

	RETURN (@ov_ResultValue)
	
END

