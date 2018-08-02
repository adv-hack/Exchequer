--/////////////////////////////////////////////////////////////////////////////
--// Filename		: ifn_GetHistoryPositionId.sql
--// Author		: 
--// Date		: 
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to add ifn_GetHistoryPositionId function
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: File Creation
--//
--/////////////////////////////////////////////////////////////////////////////

-- STATUS 
-- TODO Add structured exception handling

IF  EXISTS (
  SELECT 
    * 
  FROM 
    dbo.sysobjects 
  WHERE 
        id = OBJECT_ID(N'[!ActiveSchema!].ifn_GetHistoryPositionId') 
    AND xtype in (N'FN', N'IF', N'TF'))
  DROP FUNCTION [!ActiveSchema!].ifn_GetHistoryPositionId

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [!ActiveSchema!].ifn_GetHistoryPositionId(
    @iv_Type      INT
  , @iv_Code      VARBINARY(21)
  , @iv_Currency  INT
  , @iv_Year      INT
  , @iv_Period    INT
  )
RETURNS INT
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result INT

  -- Declare other variables
  DECLARE @ComputedCode VARBINARY(20)

  -- Initialise the variables
  SELECT
      @Result       = 0
    , @ComputedCode = CONVERT(VARBINARY(20), SUBSTRING(@iv_Code, 2, 20), 0)

	-- Add the T-SQL statements to compute the return value here
	SELECT 
    @Result = COALESCE(PositionId, 0)
  FROM 
    [!ActiveSchema!].[HISTORY]
  WHERE
        hiExCLass       = @iv_Type
    AND hiCodeComputed  = @ComputedCode 
    AND hiCurrency      = @iv_Currency
    AND hiYear          = @iv_Year
    AND hiPeriod        = @iv_Period
     
	-- Return the result of the function
	RETURN @Result

END
GO

