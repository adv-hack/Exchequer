--/////////////////////////////////////////////////////////////////////////////
--// Filename		: ifn_EntGL.sql
--// Author		: James Waygood
--// Date		: 30th July 2008
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description : Get General Ledger Actual value for the specified Currency, Year, Period and GLCode. 
--// Execute     : SELECT [!ActiveSchema!].[EntGLActual] (2005, 0, 0, 2010)
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: File Creation
--//
--/////////////////////////////////////////////////////////////////////////////

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[EntGLActual]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [!ActiveSchema!].[EntGLActual]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [!ActiveSchema!].[EntGLActual] 
(
	@TheYear		int,		-- Year to retrieve value for 
	@ThePeriod		int,		-- Period to retrieve value for
	@Currency		int,		-- Currency
	@GLCode			varchar(10)	-- General Ledger Code
)
RETURNS float
AS
BEGIN
	DECLARE @GLValue		float
	
	SELECT @GLValue = ROUND([!ActiveSchema!].[ifn_GetNominalValue] 
								(3,
								 @TheYear,
								 @ThePeriod,
								 @Currency,
								 @GLCode,
								 '',
								 '',
								 '',
								 0), 2)

	-- Return the result of the function
	RETURN @GLValue

END
GO