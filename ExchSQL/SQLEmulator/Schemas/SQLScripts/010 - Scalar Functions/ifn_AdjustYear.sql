--/////////////////////////////////////////////////////////////////////////////
--// Filename		: ifn_AdjustYear.sql
--// Author		: 
--// Date		: 
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to add ifn_AdjustYear function
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
        id = OBJECT_ID(N'[!ActiveSchema!].[ifn_AdjustYear]') 
    AND xtype in (N'FN', N'IF', N'TF'))
  DROP FUNCTION [!ActiveSchema!].[ifn_AdjustYear]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [!ActiveSchema!].[ifn_AdjustYear](
	  @iv_Year      INT
  , @iv_Increment BIT
  )
RETURNS INT
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result INT

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = 
    CASE @iv_Increment
      WHEN 1 THEN @iv_Year + 1
      ELSE @iv_Year - 1
    END

  IF @Result < 0
    SET @Result = 99

	-- Return the result of the function
	RETURN @Result

END
GO

