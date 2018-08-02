/****** Object:  UserDefinedFunction [common].[efn_ExchequerCurrencyConvert]    Script Date: 23/03/2015 08:51:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[common].[efn_ExchequerCurrencyConvert]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [common].[efn_ExchequerCurrencyConvert]
GO

CREATE FUNCTION common.efn_ExchequerCurrencyConvert 
              ( @iv_Amount            FLOAT --NUMERIC(38, 13)
              , @iv_Rate              FLOAT
              , @iv_Currency          INT
              , @iv_UseOriginalRates  BIT = 0
              , @iv_ConvertToCurrency BIT = 0
              , @iv_TriRate           FLOAT = NULL
              , @iv_TriInverted       BIT   = NULL
              , @iv_TriCurrencyCode   INT   = NULL
              , @iv_IsFloating        BIT   = NULL
              )
RETURNS FLOAT --NUMERIC(38, 13)
AS
BEGIN
  DECLARE @ConvertedAmount FLOAT --NUMERIC(38, 13)

  --SET @iv_Amount = common.efn_ConvertToReal48(@iv_Amount)
  --SET @iv_Rate = common.efn_ConvertToReal48(@iv_Rate)

  IF @iv_Rate = 0 SET @iv_Rate = 1
      
  IF @iv_Currency IN (0, 1)
  OR @iv_UseOriginalRates = 1
  OR (ISNULL(@iv_TriCurrencyCode, 0) = 0 AND @iv_IsFloating = 0)
  BEGIN
    IF @iv_TriInverted = 1 AND @iv_UseOriginalRates = 0 SET @iv_ConvertToCurrency = ~(@iv_ConvertToCurrency)
    
    IF @iv_ConvertToCurrency = 0
         SET @ConvertedAmount = common.efn_ConvertToReal48(common.efn_SafeDivide(@iv_Amount, @iv_Rate))
    ELSE SET @ConvertedAmount = @iv_Amount * @iv_Rate
  END
  ELSE
  BEGIN
    IF @iv_IsFloating = 1
    BEGIN
      IF @iv_ConvertToCurrency = 1
      BEGIN
        SET @ConvertedAmount = common.efn_ConvertToReal48(common.efn_SafeDivide(@iv_Amount, @iv_TriRate))
        
        IF @iv_TriInverted = 0
           SET @ConvertedAmount = @ConvertedAmount * @iv_Rate
        ELSE
           SET @ConvertedAmount = common.efn_ConvertToReal48(common.efn_SafeDivide(@ConvertedAmount, @iv_Rate))
        
      END -- Convert to Currency = True
      ELSE
      BEGIN
      
        IF @iv_TriInverted = 0
           SET @ConvertedAmount = @iv_Amount * @iv_Rate
        ELSE
           SET @ConvertedAmount = common.efn_ConvertToReal48(common.efn_SafeDivide(@iv_Amount, @iv_Rate))
        
        SET @ConvertedAmount = @ConvertedAmount * @iv_TriRate
      END -- Convert To Currency = False
    END -- Is Floating = True
    ELSE
    BEGIN -- Is Floating = False
      IF @iv_ConvertToCurrency = 1
      BEGIN
        IF @iv_TriInverted = 0
           SET @ConvertedAmount = @iv_Amount * @iv_Rate
        ELSE
           SET @ConvertedAmount = common.efn_ConvertToReal48(common.efn_SafeDivide(@iv_Amount, @iv_Rate))
           
        SET @ConvertedAmount = @ConvertedAmount * @iv_TriRate
      END -- ConvertToCurrency = True
      ELSE
      BEGIN
        
        SET @ConvertedAmount = common.efn_ConvertToReal48(common.efn_SafeDivide(@iv_Amount, @iv_TriRate))
        
        IF @iv_TriInverted = 1
           SET @ConvertedAmount = @ConvertedAmount * @iv_Rate
        ELSE
           SET @ConvertedAmount = common.efn_ConvertToReal48(common.efn_SafeDivide(@ConvertedAmount , @iv_Rate))
        
      END -- Convert To Currency = False
    END -- Is Floating = False
  END
  
  RETURN @ConvertedAmount
  --RETURN common.efn_ConvertToReal48(@ConvertedAmount);
END

GO

