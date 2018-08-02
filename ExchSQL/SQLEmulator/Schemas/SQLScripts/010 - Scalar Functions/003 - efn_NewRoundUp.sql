/****** Object:  UserDefinedFunction [common].[efn_ExchequerRoundUp]    Script Date: 06/15/2016 15:16:05 ******/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[common].[efn_NewRoundUp]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION common.efn_NewRoundUp
GO

CREATE FUNCTION [common].[efn_NewRoundUp] ( @iv_Number        FLOAT
                                          , @iv_DecimalPlaces INT = 0)
RETURNS TABLE
AS RETURN 
   SELECT RoundedNumber
FROM ( SELECT MinimumConstant = CASE
                                WHEN @iv_Number >= 0 THEN 1
                                ELSE -1
                                END ) AS DummyTable
CROSS APPLY (SELECT IsNegative = CASE
                                 WHEN @iv_Number < 0 THEN 1
                                 ELSE 0
                                 END
            ) Pass1
CROSS APPLY (SELECT FractionalNumber = CASE
                                       WHEN IsNegative = 1 THEN ROUND(@iv_Number - CEILING(@iv_Number), 10)
                                       ELSE ROUND(@iv_Number - FLOOR(@iv_Number), 10)
                                       END
            ) Pass2
CROSS APPLY (SELECT NumberString = CONVERT(VARCHAR(50), LTRIM(RTRIM(STR(FractionalNumber, 50, 11))) )
            ) Pass3
CROSS APPLY (SELECT iv_Number = CASE
                                WHEN SUBSTRING(NumberString, @iv_DecimalPlaces + (3+IsNegative), 1) <> '5' THEN @iv_Number
                                ELSE @iv_Number + (common.efn_SafeDivide(0.1, POWER(10, @iv_DecimalPlaces)) * MinimumConstant)
                                END
            ) Pass4
CROSS APPLY (SELECT RoundedNumber = CONVERT(FLOAT, LTRIM(RTRIM(STR(iv_Number, 38, @iv_DecimalPlaces))))
            ) Results
            
GO