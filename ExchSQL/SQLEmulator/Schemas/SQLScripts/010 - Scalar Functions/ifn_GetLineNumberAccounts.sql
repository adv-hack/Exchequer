--/////////////////////////////////////////////////////////////////////////////
--// Filename		: ifn_GetLineNumberAccounts.sql
--// Author		: Nilesh Desai
--// Date		: 4th July 2008 
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to add ifn_GetLineNumberAccounts function
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: File Creation
--//
--/////////////////////////////////////////////////////////////////////////////

IF  EXISTS ( SELECT TOP 1 1  
			 FROM	dbo.sysobjects 
			 WHERE	id = OBJECT_ID(N'[!ActiveSchema!].[ifn_GetLineNumberAccounts]') 
			 AND xtype in (N'FN', N'IF', N'TF')
			)

	DROP FUNCTION [!ActiveSchema!].[ifn_GetLineNumberAccounts]

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

CREATE FUNCTION [!ActiveSchema!].[ifn_GetLineNumberAccounts]
(
	-- Add the parameters for the function here
	   @iv_AccountCode	VARCHAR(MAX) 
)
RETURNS INT
AS
BEGIN
	-- DECLARE Constants
	DECLARE		@c_RecPFix			VARCHAR(1)
			  , @c_SubType_Accounts	INT
			  , @CRLF				NVARCHAR(5)
			  
	SELECT		@c_RecPFix = 'N'
			  , @c_SubType_Accounts = 65
			  , @CRLF = CHAR(13) + CHAR(10)

	-- Declare the return variable here
	DECLARE    @ov_ResultValue	INT	
			 , @SQLScript VARCHAR(MAX) 

	SELECT		@ov_ResultValue	= -1

	IF @iv_AccountCode IS NOT NULL 
	BEGIN
		SELECT	@ov_ResultValue = (ISNULL(Max(LineNumber),0) + 1) 
		FROM	[!ActiveSchema!].ExchqChk 
		WHERE	RecPFix = @c_RecPFix
		AND		SubType = @c_SubType_Accounts
		AND		Cast(SubString(ExchqChkCode1, 2, 6) As VarChar(MAX)) = @iv_AccountCode
	END

	RETURN (@ov_ResultValue)
	
END

