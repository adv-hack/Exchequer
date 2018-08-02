
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[common].[efn_RandomText]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [common].[efn_RandomText]
GO

CREATE FUNCTION [common].[efn_RandomText] (@iv_String VARCHAR(max))
RETURNS varchar(max)
BEGIN
  DECLARE @FoundChar VARCHAR(max)
  DECLARE @NewString VARCHAR(max) = ''
  DECLARE @Counter   INT
  
  SET @Counter = 1
  
  WHILE @Counter <= LEN(@iv_String)
  BEGIN

    IF ASCII(SUBSTRING(@iv_String, @Counter, 1)) between ASCII('A') and ASCII('Z')
    BEGIN
      SELECT @NewString = @NewString + char((cast(rand*1000 as int)%26) + 65)
	  FROM common.evw_rand
    END

    ELSE IF ASCII(SUBSTRING(@iv_String, @Counter, 1)) between ASCII('a') and ASCII('z')
    BEGIN
      SELECT @NewString = @NewString + char((cast(rand*1000 as int)%26) + 97)
	  FROM common.evw_rand
    END


    ELSE IF PATINDEX('%[0-9]%', SUBSTRING(@iv_String, @Counter, 1)) > 0
    BEGIN
      SET @NewString = @NewString + common.efn_RandomNumberString(1)
    END
    
	ELSE 
		SET @NewString = @NewString + SUBSTRING(@iv_String, @Counter, 1)

    SET @Counter = @Counter + 1
  END
  
  RETURN @NewString
END
GO