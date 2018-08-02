/****** Object:  UserDefinedFunction [common].[efn_ExchequerRoundUp]    Script Date: 15/04/2015 11:47:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[common].[efn_ExchequerRoundUp]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [common].[efn_ExchequerRoundUp]
GO

/****** Object:  UserDefinedFunction [common].[efn_ExchequerRoundUp]    Script Date: 15/04/2015 11:47:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [common].[efn_ExchequerRoundUp] ( @iv_Number        FLOAT
                                                , @iv_DecimalPlaces INT = 0)
RETURNS FLOAT 
AS
BEGIN
  RETURN (SELECT RoundedNumber FROM common.efn_NewRoundUp(@iv_Number, @iv_DecimalPlaces))
END
GO

