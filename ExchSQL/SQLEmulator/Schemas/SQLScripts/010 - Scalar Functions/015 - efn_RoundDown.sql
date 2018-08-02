/****** Object:  UserDefinedFunction [common].[efn_RoundDown]    Script Date: 15/04/2015 11:46:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[common].[efn_RoundDown]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [common].[efn_RoundDown]
GO

/****** Object:  UserDefinedFunction [common].[efn_RoundDown]    Script Date: 15/04/2015 11:46:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [common].[efn_RoundDown]( @iv_Value     FLOAT --NUMERIC(38, 13)
                                        , @iv_DecPlaces INT = 0)
RETURNS FLOAT --NUMERIC(38, 13)
AS
BEGIN
  RETURN (FLOOR(@iv_Value * POWER(10, @iv_DecPlaces)) / POWER(10, @iv_DecPlaces))
END
GO

