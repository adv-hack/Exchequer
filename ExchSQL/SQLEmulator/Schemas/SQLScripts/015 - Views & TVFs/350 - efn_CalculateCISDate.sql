IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[efn_CalculateCISDate]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [!ActiveSchema!].[efn_CalculateCISDate]
GO

CREATE FUNCTION [!ActiveSchema!].[efn_CalculateCISDate]
              ( @iv_ThisDate DATE )
RETURNS VARCHAR(8)
AS
BEGIN

  SET @iv_ThisDate = ISNULL(@iv_ThisDate, GETDATE())

  DECLARE @CISDate DATE
        , @CISInterval INT 

  SELECT @CISDate     = CONVERT(DATE, CISCurrentDate)
       , @CISInterval = CISInterval
  FROM   [!ActiveSchema!].evw_CISSystemSettings

  SET @CISDate = ISNULL(NULLIF(@CISDate, '1900-01-01'), GETDATE())

  WHILE @iv_ThisDate > @CISDate
  BEGIN
    SET @CISDate = DATEADD(MM, @CISInterval, @CISDate)
  END

  RETURN CONVERT(VARCHAR(8), @CISDate, 112)

END

GO