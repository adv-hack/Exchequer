/****** Object:  UserDefinedFunction [!ActiveSchema!].[efn_GetVATRate]    Script Date: 23/03/2015 08:51:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[efn_GetVATRate]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [!ActiveSchema!].[efn_GetVATRate]
GO

CREATE FUNCTION !ActiveSchema!.efn_GetVATRate ( @iv_VATCode          VARCHAR(1)
                                      , @iv_InclusiveVATCode VARCHAR(1) = NULL
                                      )
RETURNS FLOAT
AS
BEGIN
--  DECLARE @iv_InclusiveVATCode VARCHAR(1)

  DECLARE @VATRate         FLOAT
        , @IncVATCodeValid BIT

  -- Test to see if Inclusive VAT Code is Valid
  IF EXISTS(SELECT TOP 1 1
            FROM   !ActiveSchema!.evw_VATRate
            WHERE  VATRateCode = @iv_InclusiveVATCode
            AND    VATRateId  <> 88)
  BEGIN
    SET @IncVATCodeValid = 1
  END
  ELSE
  BEGIN
    SET @IncVATCodeValid = 0
  END

  IF @iv_VATCode = 'A'
  BEGIN
    SELECT @VATRate = VATRate
    FROM !ActiveSchema!.evw_VATRate 
    WHERE VATRateId = 3
  END
  ELSE -- VAT Code <> 'A'
  BEGIN
    IF @iv_VATCode = 'D'
    BEGIN
      SELECT @VATRate = VATRate
      FROM !ActiveSchema!.evw_VATRate 
      WHERE VATRateId = 4
    END
    ELSE -- VATCode <> 'D'
    BEGIN
      IF @iv_VATCode IN ('M','I')
      BEGIN
        IF @IncVATCodeValid = 1
        BEGIN
          SELECT @VATRate = !ActiveSchema!.efn_GetVATRate(@iv_InclusiveVATCode, NULL)
        END
        ELSE -- @IncVATCodeValid = 0
        BEGIN
          SELECT @VATRate = VATRate
          FROM !ActiveSchema!.evw_VATRate 
          WHERE VATRateCode = 'S'
        END
      END -- VAT Code = 'M' OR 'I'
      ELSE -- VATCode <> 'M' OR 'I'
      BEGIN
        SELECT @VATRate = VATRate
        FROM   !ActiveSchema!.evw_VATRate
        WHERE  VATRateCode = @iv_VATCode  
        AND  VATRateId <> 88
      END -- VATCode <> 'M' OR 'I'
    END -- VAT Code <> 'D'
  END -- VAT Code <> 'A'

  -- VATRate still NULL use VAT Rate 88 (Spare8)

  IF @VATRate IS NULL
  BEGIN
    SELECT @VATRate = VATRate
    FROM   !ActiveSchema!.evw_VATRate
    WHERE  VATRateId = 88
  END

  RETURN @VATRate

END

GO