--/////////////////////////////////////////////////////////////////////////////
--// Filename		: isp_ExchequerUpper.sql
--// Author		: Irfan Shariff
--// Date		: 26 June 2007
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to add isp_ExchequerUpper function.
--//                  Performs an upper on chars 'a' to 'z' without affecting other characters.
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: File Creation
--//
--/////////////////////////////////////////////////////////////////////////////

IF  EXISTS ( SELECT TOP 1 1  
			 FROM	dbo.sysobjects 
			 WHERE	id = OBJECT_ID(N'[!ActiveSchema!].[isp_ExchequerUpper]') 
			 AND xtype in (N'FN', N'IF', N'TF')
			)

	DROP FUNCTION [!ActiveSchema!].[isp_ExchequerUpper]

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

CREATE FUNCTION [!ActiveSchema!].[isp_ExchequerUpper]
(
	-- Add the parameters for the function here
	@iv_InputString VARBINARY(4000)
)
RETURNS VARBINARY(4000)
WITH SCHEMABINDING
AS
BEGIN
	-- Declare the return variable here
	DECLARE @ov_ResultString	VARBINARY(4000)

	-- Locals
	DECLARE @InputLength	INT
	DECLARE @Count			INT
	DECLARE @InputChar		BINARY(1)

	-- Initial values
	SET @Count = 1
	SET @InputLength = DATALENGTH(@iv_InputString)
	SET @ov_ResultString = 0;
	
	WHILE (@Count < @InputLength + 1)
	BEGIN

		SET @InputChar = SUBSTRING(@iv_InputString, @Count, 1);
		if (@InputChar >= 97 AND @InputChar <= 122)
		BEGIN
			SET @InputChar = @InputChar - 32;
		END
		
		IF (@Count = 1)
			SET @ov_ResultString = @InputChar;			
		ELSE
			SET @ov_ResultString = @ov_ResultString + @InputChar;

		SET @Count = @Count + 1
	END

	-- Return the result of the function
	RETURN @ov_ResultString

END
