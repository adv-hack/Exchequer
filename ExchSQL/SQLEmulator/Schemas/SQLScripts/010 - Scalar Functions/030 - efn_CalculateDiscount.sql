
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[common].[efn_CalculateDiscount]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [common].[efn_CalculateDiscount]
GO

CREATE FUNCTION common.efn_CalculateDiscount
     (
        @iv_FullAmount    FLOAT
      , @iv_Discount      FLOAT
      , @iv_DiscountFlag  VARCHAR(1)
      , @iv_Discount2     FLOAT
      , @iv_DiscountFlag2 VARCHAR(1)
      , @iv_Discount3     FLOAT
      , @iv_DiscountFlag3 VARCHAR(1)
     )
RETURNS FLOAT
AS
BEGIN

  DECLARE @NewDiscountBasis FLOAT
        , @Result           FLOAT

  -- Convert input variables to Real48's
  SET @iv_FullAmount = common.efn_ConvertToReal48(@iv_FullAmount)
  SET @iv_Discount   = common.efn_ConvertToReal48(@iv_Discount)
  SET @iv_Discount2  = common.efn_ConvertToReal48(@iv_Discount2)
  SET @iv_Discount3  = common.efn_ConvertToReal48(@iv_Discount3)
  
  SET @Result        = common.efn_ConvertToReal48(CASE
                                                  WHEN @iv_DiscountFlag = '%' THEN @iv_FullAmount * @iv_Discount
                                                  ELSE @iv_Discount
                                                  END
                                                  )

  IF @iv_Discount2 <> 0
  BEGIN
    SET @NewDiscountBasis = common.efn_ConvertToReal48(@iv_FullAmount - @Result)
    
    SET @Result = common.efn_ConvertToReal48( @Result 
                                            + common.efn_ConvertToReal48(CASE
                                                                         WHEN @iv_DiscountFlag2 = '%' THEN @NewDiscountBasis * @iv_Discount2
                                                                         ELSE @iv_Discount2
                                                                         END)
                                            )
    
  END
  
  IF @iv_Discount3 <> 0
  BEGIN
    SET @NewDiscountBasis = common.efn_ConvertToReal48(@iv_FullAmount - @Result)
    
    SET @Result = common.efn_ConvertToReal48( @Result 
                                            + common.efn_ConvertToReal48(CASE
                                                                         WHEN @iv_DiscountFlag3 = '%' THEN @NewDiscountBasis * @iv_Discount3
                                                                         ELSE @iv_Discount3
                                                                         END)
                                            )
    
  END
  
  RETURN common.efn_ConvertToReal48(@Result)
  
END
GO