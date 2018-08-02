/****** Object:  UserDefinedFunction [common].[efn_ExchequerCurrencyConvert]    Script Date: 23/03/2015 08:51:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[common].[efn_SafeDivide]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [common].[efn_SafeDivide]
GO

CREATE FUNCTION common.efn_SafeDivide( @iv_Divide FLOAT
                                     , @iv_Divisor FLOAT
                                     )
RETURNS FLOAT
AS
BEGIN

  DECLARE @SafeDivide FLOAT

  SET @iv_Divide = common.efn_ConvertToReal48(@iv_Divide)
  SET @iv_Divisor = common.efn_ConvertToReal48(@iv_Divisor)

  IF @iv_Divisor = 0 
  BEGIN
    SET @SafeDivide = 0;
  END
  ELSE
    SET @SafeDivide = @iv_Divide / @iv_Divisor
    
  RETURN common.efn_ConvertToReal48(@SafeDivide)

END

GO
