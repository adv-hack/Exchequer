
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[common].[efn_RandomNumberString]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [common].[efn_RandomNumberString]
GO

CREATE FUNCTION [common].[efn_RandomNumberString](@iv_StringLength INT )
RETURNS VARCHAR(max)
BEGIN
  DECLARE @RandomNoString VARCHAR(max) = ''
  DECLARE @StringCtr  int = 0
  DECLARE @RandomNumber float
  DECLARE @RandomInteger int
  DECLARE @MaxValue int
  DECLARE @MinValue int

  SET @MaxValue = 57
  SET @MinValue = 48

  WHILE @StringCtr < @iv_StringLength
  BEGIN

    SELECT @RandomInteger = ABS(CHECKSUM(NewId))%(@MaxValue-@MinValue+1)+@MinValue
    FROM evw_NewId
    
    SELECT @RandomNoString  = @RandomNoString + CHAR(@RandomInteger)
  
    SELECT @StringCtr = @StringCtr + 1
  END

RETURN @RandomNoString
END
GO