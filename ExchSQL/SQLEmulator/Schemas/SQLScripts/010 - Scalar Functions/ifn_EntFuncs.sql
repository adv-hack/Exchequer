--/////////////////////////////////////////////////////////////////////////////
--// Filename		: ifn_EntFuncs.sql
--// Author		: James Waygood
--// Date		: 30th July 2008
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to add trader balance functions
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: File Creation
--//
--/////////////////////////////////////////////////////////////////////////////

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[EntCustBalance]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [!ActiveSchema!].[EntCustBalance]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[EntSuppBalance]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [!ActiveSchema!].[EntSuppBalance]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ==========================================================================================
-- Create date : 30th July 2008
-- Author	   : James Waygood
-- Description : Get Customer Balance 
-- Execute     : SELECT [!ActiveSchema!].[EntCustBalance] (2008, 0, 'ABAP01')
-- ==========================================================================================

CREATE FUNCTION [!ActiveSchema!].[EntCustBalance] 
(
	@TheYear		int,		-- Year to retrieve value for 
	@ThePeriod		int,		-- Period to retrieve value for
	@CustCode		varchar(10)	-- Customer Code
)
RETURNS float
AS
BEGIN
	DECLARE @CustValue		float
	
	SET @CustValue = 0
	
	IF (SELECT [acCustSupp] FROM [!ActiveSchema!].[CustSupp]
		WHERE [acCode] = @CustCode) = 'C'
	BEGIN
		SELECT @CustValue = ROUND([!ActiveSchema!].[ifn_GetCustValue] 
								(0,
								 @TheYear,
								 @ThePeriod,
								 @CustCode), 2)
	END
	ELSE
	BEGIN
		SET @CustValue = 100000515		-- Invalid Customer Code	
	END

	-- Return the result of the function
	RETURN @CustValue

END
GO

-- ==========================================================================================
-- Create date : 30th July 2008
-- Author	   : James Waygood
-- Description : Get Supplier Balance 
-- Execute     : SELECT [!ActiveSchema!].[EntSuppBalance] (2008, 0, 'ABAP01')
-- ==========================================================================================

CREATE FUNCTION [!ActiveSchema!].[EntSuppBalance] 
(
	@TheYear		int,		-- Year to retrieve value for 
	@ThePeriod		int,		-- Period to retrieve value for
	@CustCode		varchar(10)	-- Supplier Code
)
RETURNS float
AS
BEGIN
	DECLARE @CustValue		float
	
	SET @CustValue = 0
	
	IF (SELECT [acCustSupp] FROM [!ActiveSchema!].[CustSupp]
		WHERE [acCode] = @CustCode) = 'S'
	BEGIN
		SELECT @CustValue = ROUND([!ActiveSchema!].[ifn_GetCustValue] 
								(0,
								 @TheYear,
								 @ThePeriod,
								 @CustCode), 2)
	END
	ELSE
	BEGIN
		SET @CustValue = 100000526		-- Invalid Supplier Code	
	END

	-- Return the result of the function
	RETURN @CustValue

END
GO