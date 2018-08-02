--/////////////////////////////////////////////////////////////////////////////
--// Filename		: ifn_CurrencyConversion.sql
--// Author		: 
--// Date		: 
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to add ifn_CurrencyConversion function
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: File Creation
--//
--/////////////////////////////////////////////////////////////////////////////

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[!ActiveSchema!].[ifn_CurrencyConversion]') 
    AND xtype in (N'FN', N'IF', N'TF'))
  DROP FUNCTION [!ActiveSchema!].[ifn_CurrencyConversion]
GO
--
-- Returns a value converted from one currency to another
--
-- Parameters: @InputValue   - Value to be converted
--             @FromCurrency - Currency from which value is to be converted
--             @ToCurrency   - Currency to which value is to be converted
--
-- Execution: SELECT NewValue = [!ActiveSchema!].ifn_CurrencyConversion( 1000.00, 1, 2)

CREATE FUNCTION [!ActiveSchema!].ifn_CurrencyConversion
              ( @InputValue   FLOAT
              , @FromCurrency INT
              , @ToCurrency   INT
              )
RETURNS FLOAT
AS
BEGIN
DECLARE @ConvertedValue FLOAT
      , @CompanyRate    FLOAT
      , @DailyRate      FLOAT
      , @TriInverted    BIT
      , @UseCompanyRate BIT

-- Here for Debug purposes
--SET @FromCurrency = 2
--SET @ToCurrency   = 3
--SET @InputValue   = 1000

SET @ConvertedValue = @InputValue

SELECT @UseCompanyRate = CASE
                         WHEN TotalConv = 'C' THEN 1
                         ELSE 0
                         END
FROM [!ActiveSchema!].EXCHQSS
WHERE IDcode = 0x03535953 -- SYS

IF @FromCurrency > 1
BEGIN
  SELECT @CompanyRate = CompanyRate
       , @DailyRate   = DailyRate
       , @TriInverted = TriInverted
  FROM   [!ActiveSchema!].CURRENCY
  WHERE  CurrencyCode IN (@FromCurrency) --, @ToCurrency)

SELECT @ConvertedValue = CASE
                         WHEN @UseCompanyRate = 1 AND @CompanyRate <> 0 THEN CASE 
                                                                             WHEN @TriInverted = 1 THEN @ConvertedValue * @CompanyRate
						    											     ELSE @ConvertedValue / @CompanyRate
																			 END
						 WHEN @UseCompanyRate = 0 AND @DailyRate <> 0 THEN CASE
													                       WHEN @TriInverted = 1 THEN  @ConvertedValue * @DailyRate 
																		   ELSE @ConvertedValue / @DailyRate 
																		   END
						 ELSE @ConvertedValue
						 END
END

IF @ToCurrency > 1
BEGIN
  SELECT @CompanyRate = CompanyRate
       , @DailyRate   = DailyRate
       , @TriInverted = TriInverted
  FROM   [!ActiveSchema!].CURRENCY
  WHERE  CurrencyCode IN (@ToCurrency) --, @ToCurrency)

SELECT @ConvertedValue = CASE
                         WHEN @UseCompanyRate = 1 AND @CompanyRate <> 0 THEN CASE 
                                                                             WHEN @TriInverted = 0 THEN @ConvertedValue * @CompanyRate
						    											     ELSE @ConvertedValue / @CompanyRate
																			 END
						 WHEN @UseCompanyRate = 0 AND @DailyRate <> 0 THEN CASE
													                       WHEN @TriInverted = 0 THEN  @ConvertedValue * @DailyRate 
																		   ELSE @ConvertedValue / @DailyRate 
																		   END
						 ELSE @ConvertedValue
						 END
END

RETURN @ConvertedValue

END
