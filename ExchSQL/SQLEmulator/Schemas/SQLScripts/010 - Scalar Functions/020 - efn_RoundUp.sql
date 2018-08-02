/****** Object:  UserDefinedFunction [common].[efn_RoundUp]    Script Date: 15/04/2015 11:46:29 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[common].[efn_RoundUp]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [common].[efn_RoundUp]
GO

/****** Object:  UserDefinedFunction [common].[efn_RoundUp]    Script Date: 15/04/2015 11:46:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE FUNCTION [common].[efn_RoundUp]( @iv_Value     FLOAT --NUMERIC(38, 13)
                                      , @iv_DecPlaces INT = 0)
RETURNS FLOAT --NUMERIC(38, 13)
AS
BEGIN
  RETURN (CEILING(@iv_Value * POWER(10, @iv_DecPlaces)) / POWER(10, @iv_DecPlaces))
END
GO

