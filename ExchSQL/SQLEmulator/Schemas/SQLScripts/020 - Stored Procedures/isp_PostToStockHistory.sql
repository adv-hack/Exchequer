--/////////////////////////////////////////////////////////////////////////////
--// Filename		: isp_PostToStockHistory.sql
--// Author		: 
--// Date		: 
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to add isp_PostToStockHistory stored procedure
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: File Creation
--//
--/////////////////////////////////////////////////////////////////////////////

IF  EXISTS (
  SELECT
    *
  FROM
    dbo.sysobjects
  WHERE
    id = OBJECT_ID(N'[!ActiveSchema!].[isp_PostToStockHistory]')
    AND OBJECTPROPERTY(id,N'IsProcedure') = 1
    )
BEGIN
  DROP PROCEDURE [!ActiveSchema!].[isp_PostToStockHistory]
END
GO

CREATE PROCEDURE [!ActiveSchema!].[isp_PostToStockHistory](
    @iv_Type                INT
  , @iv_Code_01             VARBINARY(21)
  , @iv_Code_02             VARBINARY(21)
  , @iv_Code_03             VARBINARY(21)
  , @iv_Code_04             VARBINARY(21)
  , @iv_Purchases_01        FLOAT
  , @iv_Sales_01            FLOAT
  , @iv_Purchases_02        FLOAT
  , @iv_Sales_02            FLOAT
  , @iv_Cleared             FLOAT
  , @iv_Currency_01         INT
  , @iv_Currency_02         INT
  , @iv_Year                INT
  , @iv_Period_01           INT
  , @iv_Period_02           INT
  , @iv_DecimalPlaces       INT
  )
AS
BEGIN
  SET NOCOUNT ON

  DECLARE
      @DecimalPlaces       INT
    , @Value1              FLOAT   -- Dummy value, not actually required by this routine
    , @Value2              FLOAT -- Dummy value, not actually required by this routine
    , @ReturnValue         INT
    , @ov_PreviousBalance  FLOAT
    , @ov_ErrorMessageCode INT
    , @Error               INT
    , @PositionId          INT

  SELECT
        @Value1              = 0
      , @Value2              = 0
      , @DecimalPlaces       = @iv_DecimalPlaces
      , @ReturnValue         = 0
      , @ov_PreviousBalance  = 0.0
      , @ov_ErrorMessageCode = 0
      , @Error               = 0

  -- Execute PostToHistory:
  --  For each NCode_nn:
  --    if NCode_nn <> '' (some parameters omitted for clarity):
  --        Post NType, NCode_nn, Purchases_01, Sales_01, Cleared, HistCr_01, Period_01
  --        Post NType, NCode_nn, Purchases_01, Sales_01, Cleared, HistCr_01, Period_02
  --        Post NType, NCode_nn, Purchases_02, Sales_02, Cleared, HistCr_02, Period_01
  --        Post NType, NCode_nn, Purchases_02, Sales_02, Cleared, HistCr_02, Period_02

  DECLARE @tb_HistoryRecords TABLE
          ( PositionId INT
          , CurrencyNo INT)

  IF NOT (@iv_Code_01 = 0x00)
  BEGIN

    SELECT @PositionId = [!ActiveSchema!].ifn_GetHistoryPositionId ( @iv_Type
                                                           , @iv_Code_01
                                                           , @iv_Currency_01
                                                           , @iv_Year
                                                           , @iv_Period_01 )

    IF @PositionId = 0
    BEGIN
      EXEC @Error = [!ActiveSchema!].[isp_AddHistory] @iv_Type
                                            , @iv_Code_01
                                            , @iv_Currency_01
                                            , @iv_Year
                                            , @iv_Period_01
                                            , @ov_PositionId = @PositionId OUTPUT
    END

    INSERT INTO @tb_HistoryRecords
    SELECT PositionId = @PositionId
         , Currency   =  1

    SET @PositionId = 0

    SELECT @PositionId = [!ActiveSchema!].ifn_GetHistoryPositionId ( @iv_Type
                                                           , @iv_Code_01
                                                           , @iv_Currency_01
                                                           , @iv_Year
                                                           , @iv_Period_02 )
    IF @PositionId = 0
    BEGIN
      EXEC @Error = [!ActiveSchema!].[isp_AddHistory] @iv_Type
                                            , @iv_Code_01
                                            , @iv_Currency_01
                                            , @iv_Year
                                            , @iv_Period_02
                                            , @ov_PositionId = @PositionId OUTPUT
    END

    INSERT INTO @tb_HistoryRecords
    SELECT PositionId = @PositionId
         , Currency   = 1

    SET @PositionId = 0

    -- Now for 2nd Currency
    SELECT @PositionId = [!ActiveSchema!].ifn_GetHistoryPositionId ( @iv_Type
                                                           , @iv_Code_01
                                                           , @iv_Currency_02
                                                           , @iv_Year
                                                           , @iv_Period_01 )

    IF @PositionId = 0
    BEGIN
      EXEC @Error = [!ActiveSchema!].[isp_AddHistory] @iv_Type
                                            , @iv_Code_01
                                            , @iv_Currency_02
                                            , @iv_Year
                                            , @iv_Period_01
                                            , @ov_PositionId = @PositionId OUTPUT
    END

    INSERT INTO @tb_HistoryRecords
    SELECT PositionId = @PositionId
         , Currency   = 2

    SET @PositionId = 0

    SELECT @PositionId = [!ActiveSchema!].ifn_GetHistoryPositionId ( @iv_Type
                                                           , @iv_Code_01
                                                           , @iv_Currency_02
                                                           , @iv_Year
                                                           , @iv_Period_02 )

    IF @PositionId = 0
    BEGIN
      EXEC @Error = [!ActiveSchema!].[isp_AddHistory] @iv_Type
                                            , @iv_Code_01
                                            , @iv_Currency_02
                                            , @iv_Year
                                            , @iv_Period_02
                                            , @ov_PositionId = @PositionId OUTPUT
    END

    INSERT INTO @tb_HistoryRecords
    SELECT PositionId = @PositionId
         , Currency   = 2

    SET @PositionId = 0

--      EXEC [!ActiveSchema!].isp_PostToHistory @iv_Type, @iv_Code_01, @iv_Purchases_01, @iv_Sales_01, @iv_Cleared, @Value1, @Value2, @iv_Currency_01, @iv_Year, @iv_Period_01, @iv_DecimalPlaces, @ov_PreviousBalance, @ov_ErrorMessageCode
--      EXEC [!ActiveSchema!].isp_PostToHistory @iv_Type, @iv_Code_01, @iv_Purchases_01, @iv_Sales_01, @iv_Cleared, @Value1, @Value2, @iv_Currency_01, @iv_Year, @iv_Period_02, @iv_DecimalPlaces, @ov_PreviousBalance, @ov_ErrorMessageCode
--      EXEC [!ActiveSchema!].isp_PostToHistory @iv_Type, @iv_Code_01, @iv_Purchases_02, @iv_Sales_02, @iv_Cleared, @Value1, @Value2, @iv_Currency_02, @iv_Year, @iv_Period_01, @iv_DecimalPlaces, @ov_PreviousBalance, @ov_ErrorMessageCode
--      EXEC [!ActiveSchema!].isp_PostToHistory @iv_Type, @iv_Code_01, @iv_Purchases_02, @iv_Sales_02, @iv_Cleared, @Value1, @Value2, @iv_Currency_02, @iv_Year, @iv_Period_02, @iv_DecimalPlaces, @ov_PreviousBalance, @ov_ErrorMessageCode
  END

  IF NOT (@iv_Code_02 = 0x00)
  BEGIN

     SELECT @PositionId = [!ActiveSchema!].ifn_GetHistoryPositionId ( @iv_Type
                                                           , @iv_Code_02
                                                           , @iv_Currency_01
                                                           , @iv_Year
                                                           , @iv_Period_01 )

    IF @PositionId = 0
    BEGIN
      EXEC @Error = [!ActiveSchema!].[isp_AddHistory] @iv_Type
                                            , @iv_Code_02
                                            , @iv_Currency_01
                                            , @iv_Year
                                            , @iv_Period_01
                                            , @ov_PositionId = @PositionId OUTPUT
    END

    INSERT INTO @tb_HistoryRecords
    SELECT PositionId = @PositionId
         , Currency   =  1

    SET @PositionId = 0

    SELECT @PositionId = [!ActiveSchema!].ifn_GetHistoryPositionId ( @iv_Type
                                                           , @iv_Code_02
                                                           , @iv_Currency_01
                                                           , @iv_Year
                                                           , @iv_Period_02 )
    IF @PositionId = 0
    BEGIN
      EXEC @Error = [!ActiveSchema!].[isp_AddHistory] @iv_Type
                                            , @iv_Code_02
                                            , @iv_Currency_01
                                            , @iv_Year
                                            , @iv_Period_02
                                            , @ov_PositionId = @PositionId OUTPUT
    END

    INSERT INTO @tb_HistoryRecords
    SELECT PositionId = @PositionId
         , Currency   = 1

    SET @PositionId = 0

    -- Now for 2nd Currency
    SELECT @PositionId = [!ActiveSchema!].ifn_GetHistoryPositionId ( @iv_Type
                                                           , @iv_Code_02
                                                           , @iv_Currency_02
                                                           , @iv_Year
                                                           , @iv_Period_01 )

    IF @PositionId = 0
    BEGIN
      EXEC @Error = [!ActiveSchema!].[isp_AddHistory] @iv_Type
                                            , @iv_Code_02
                                            , @iv_Currency_02
                                            , @iv_Year
                                            , @iv_Period_01
                                            , @ov_PositionId = @PositionId OUTPUT
    END

    INSERT INTO @tb_HistoryRecords
    SELECT PositionId = @PositionId
         , Currency   = 2

    SET @PositionId = 0

    SELECT @PositionId = [!ActiveSchema!].ifn_GetHistoryPositionId ( @iv_Type
                                                           , @iv_Code_02
                                                           , @iv_Currency_02
                                                           , @iv_Year
                                                           , @iv_Period_02 )

    IF @PositionId = 0
    BEGIN
      EXEC @Error = [!ActiveSchema!].[isp_AddHistory] @iv_Type
                                            , @iv_Code_02
                                            , @iv_Currency_02
                                            , @iv_Year
                                            , @iv_Period_02
                                            , @ov_PositionId = @PositionId OUTPUT
    END

    INSERT INTO @tb_HistoryRecords
    SELECT PositionId = @PositionId
         , Currency   = 2

    SET @PositionId = 0

      --EXEC [!ActiveSchema!].isp_PostToHistory @iv_Type, @iv_Code_02, @iv_Purchases_01, @iv_Sales_01, @iv_Cleared, @Value1, @Value2, @iv_Currency_01, @iv_Year, @iv_Period_01, @iv_DecimalPlaces, @ov_PreviousBalance, @ov_ErrorMessageCode
      --EXEC [!ActiveSchema!].isp_PostToHistory @iv_Type, @iv_Code_02, @iv_Purchases_01, @iv_Sales_01, @iv_Cleared, @Value1, @Value2, @iv_Currency_01, @iv_Year, @iv_Period_02, @iv_DecimalPlaces, @ov_PreviousBalance, @ov_ErrorMessageCode
      --EXEC [!ActiveSchema!].isp_PostToHistory @iv_Type, @iv_Code_02, @iv_Purchases_02, @iv_Sales_02, @iv_Cleared, @Value1, @Value2, @iv_Currency_01, @iv_Year, @iv_Period_01, @iv_DecimalPlaces, @ov_PreviousBalance, @ov_ErrorMessageCode
      --EXEC [!ActiveSchema!].isp_PostToHistory @iv_Type, @iv_Code_02, @iv_Purchases_02, @iv_Sales_02, @iv_Cleared, @Value1, @Value2, @iv_Currency_01, @iv_Year, @iv_Period_02, @iv_DecimalPlaces, @ov_PreviousBalance, @ov_ErrorMessageCode
  END

  IF NOT (@iv_Code_03 = 0x00)
  BEGIN

    SELECT @PositionId = [!ActiveSchema!].ifn_GetHistoryPositionId ( @iv_Type
                                                           , @iv_Code_03
                                                           , @iv_Currency_01
                                                           , @iv_Year
                                                           , @iv_Period_01 )

    IF @PositionId = 0
    BEGIN
      EXEC @Error = [!ActiveSchema!].[isp_AddHistory] @iv_Type
                                            , @iv_Code_03
                                            , @iv_Currency_01
                                            , @iv_Year
                                            , @iv_Period_01
                                            , @ov_PositionId = @PositionId OUTPUT
    END

    INSERT INTO @tb_HistoryRecords
    SELECT PositionId = @PositionId
         , Currency   =  1

    SET @PositionId = 0

    SELECT @PositionId = [!ActiveSchema!].ifn_GetHistoryPositionId ( @iv_Type
                                                           , @iv_Code_03
                                                           , @iv_Currency_01
                                                           , @iv_Year
                                                           , @iv_Period_02 )
    IF @PositionId = 0
    BEGIN
      EXEC @Error = [!ActiveSchema!].[isp_AddHistory] @iv_Type
                                            , @iv_Code_03
                                            , @iv_Currency_01
                                            , @iv_Year
                                            , @iv_Period_02
                                            , @ov_PositionId = @PositionId OUTPUT
    END

    INSERT INTO @tb_HistoryRecords
    SELECT PositionId = @PositionId
         , Currency   = 1

    SET @PositionId = 0

    -- Now for 2nd Currency
    SELECT @PositionId = [!ActiveSchema!].ifn_GetHistoryPositionId ( @iv_Type
                                                           , @iv_Code_03
                                                           , @iv_Currency_02
                                                           , @iv_Year
                                                           , @iv_Period_01 )

    IF @PositionId = 0
    BEGIN
      EXEC @Error = [!ActiveSchema!].[isp_AddHistory] @iv_Type
                                            , @iv_Code_03
                                            , @iv_Currency_02
                                            , @iv_Year
                                            , @iv_Period_01
                                            , @ov_PositionId = @PositionId OUTPUT
    END

    INSERT INTO @tb_HistoryRecords
    SELECT PositionId = @PositionId
         , Currency   = 2

    SET @PositionId = 0

    SELECT @PositionId = [!ActiveSchema!].ifn_GetHistoryPositionId ( @iv_Type
                                                           , @iv_Code_03
                                                           , @iv_Currency_02
                                                           , @iv_Year
                                                           , @iv_Period_02 )

    IF @PositionId = 0
    BEGIN
      EXEC @Error = [!ActiveSchema!].[isp_AddHistory] @iv_Type
                                            , @iv_Code_03
                                            , @iv_Currency_02
                                            , @iv_Year
                                            , @iv_Period_02
                                            , @ov_PositionId = @PositionId OUTPUT
    END

    INSERT INTO @tb_HistoryRecords
    SELECT PositionId = @PositionId
         , Currency   = 2

    SET @PositionId = 0

      --EXEC [!ActiveSchema!].isp_PostToHistory @iv_Type, @iv_Code_03, @iv_Purchases_01, @iv_Sales_01, @iv_Cleared, @Value1, @Value2, @iv_Currency_01, @iv_Year, @iv_Period_01, @iv_DecimalPlaces, @ov_PreviousBalance, @ov_ErrorMessageCode
      --EXEC [!ActiveSchema!].isp_PostToHistory @iv_Type, @iv_Code_03, @iv_Purchases_01, @iv_Sales_01, @iv_Cleared, @Value1, @Value2, @iv_Currency_01, @iv_Year, @iv_Period_02, @iv_DecimalPlaces, @ov_PreviousBalance, @ov_ErrorMessageCode
      --EXEC [!ActiveSchema!].isp_PostToHistory @iv_Type, @iv_Code_03, @iv_Purchases_02, @iv_Sales_02, @iv_Cleared, @Value1, @Value2, @iv_Currency_01, @iv_Year, @iv_Period_01, @iv_DecimalPlaces, @ov_PreviousBalance, @ov_ErrorMessageCode
      --EXEC [!ActiveSchema!].isp_PostToHistory @iv_Type, @iv_Code_03, @iv_Purchases_02, @iv_Sales_02, @iv_Cleared, @Value1, @Value2, @iv_Currency_01, @iv_Year, @iv_Period_02, @iv_DecimalPlaces, @ov_PreviousBalance, @ov_ErrorMessageCode
  END

  IF NOT (@iv_Code_04 = 0x00)
  BEGIN

    SELECT @PositionId = [!ActiveSchema!].ifn_GetHistoryPositionId ( @iv_Type
                                                           , @iv_Code_04
                                                           , @iv_Currency_01
                                                           , @iv_Year
                                                           , @iv_Period_01 )

    IF @PositionId = 0
    BEGIN
      EXEC @Error = [!ActiveSchema!].[isp_AddHistory] @iv_Type
                                            , @iv_Code_04
                                            , @iv_Currency_01
                                            , @iv_Year
                                            , @iv_Period_01
                                            , @ov_PositionId = @PositionId OUTPUT
    END

    INSERT INTO @tb_HistoryRecords
    SELECT PositionId = @PositionId
         , Currency   =  1

    SET @PositionId = 0

    SELECT @PositionId = [!ActiveSchema!].ifn_GetHistoryPositionId ( @iv_Type
                                                           , @iv_Code_04
                                                           , @iv_Currency_01
                                                           , @iv_Year
                                                           , @iv_Period_02 )
    IF @PositionId = 0
    BEGIN
      EXEC @Error = [!ActiveSchema!].[isp_AddHistory] @iv_Type
                                            , @iv_Code_04
                                            , @iv_Currency_01
                                            , @iv_Year
                                            , @iv_Period_02
                                            , @ov_PositionId = @PositionId OUTPUT
    END

    INSERT INTO @tb_HistoryRecords
    SELECT PositionId = @PositionId
         , Currency   = 1

    SET @PositionId = 0

    -- Now for 2nd Currency
    SELECT @PositionId = [!ActiveSchema!].ifn_GetHistoryPositionId ( @iv_Type
                                                           , @iv_Code_04
                                                           , @iv_Currency_02
                                                           , @iv_Year
                                                           , @iv_Period_01 )

    IF @PositionId = 0
    BEGIN
      EXEC @Error = [!ActiveSchema!].[isp_AddHistory] @iv_Type
                                            , @iv_Code_04
                                            , @iv_Currency_02
                                            , @iv_Year
                                            , @iv_Period_01
                                            , @ov_PositionId = @PositionId OUTPUT
    END

    INSERT INTO @tb_HistoryRecords
    SELECT PositionId = @PositionId
         , Currency   = 2

    SET @PositionId = 0

    SELECT @PositionId = [!ActiveSchema!].ifn_GetHistoryPositionId ( @iv_Type
                                                           , @iv_Code_04
                                                           , @iv_Currency_02
                                                           , @iv_Year
                                                           , @iv_Period_02 )

    IF @PositionId = 0
    BEGIN
      EXEC @Error = [!ActiveSchema!].[isp_AddHistory] @iv_Type
                                            , @iv_Code_04
                                            , @iv_Currency_02
                                            , @iv_Year
                                            , @iv_Period_02
                                            , @ov_PositionId = @PositionId OUTPUT
    END

    INSERT INTO @tb_HistoryRecords
    SELECT PositionId = @PositionId
         , Currency   = 2

    SET @PositionId = 0


      --EXEC [!ActiveSchema!].isp_PostToHistory @iv_Type, @iv_Code_04, @iv_Purchases_01, @iv_Sales_01, @iv_Cleared, @Value1, @Value2, @iv_Currency_01, @iv_Year, @iv_Period_01, @iv_DecimalPlaces, @ov_PreviousBalance, @ov_ErrorMessageCode
      --EXEC [!ActiveSchema!].isp_PostToHistory @iv_Type, @iv_Code_04, @iv_Purchases_01, @iv_Sales_01, @iv_Cleared, @Value1, @Value2, @iv_Currency_01, @iv_Year, @iv_Period_02, @iv_DecimalPlaces, @ov_PreviousBalance, @ov_ErrorMessageCode
      --EXEC [!ActiveSchema!].isp_PostToHistory @iv_Type, @iv_Code_04, @iv_Purchases_02, @iv_Sales_02, @iv_Cleared, @Value1, @Value2, @iv_Currency_01, @iv_Year, @iv_Period_01, @iv_DecimalPlaces, @ov_PreviousBalance, @ov_ErrorMessageCode
      --EXEC [!ActiveSchema!].isp_PostToHistory @iv_Type, @iv_Code_04, @iv_Purchases_02, @iv_Sales_02, @iv_Cleared, @Value1, @Value2, @iv_Currency_01, @iv_Year, @iv_Period_02, @iv_DecimalPlaces, @ov_PreviousBalance, @ov_ErrorMessageCode
  END

  -- For Debug purposes
  --SELECT *
  --FROM   @tb_HistoryRecords

  -- Update History Table
  UPDATE H
  SET     hiPurchases = common.ifn_ExchRnd((hiPurchases + CASE
                                                          WHEN HR.CurrencyNo = 1 THEN common.ifn_ExchRnd(@iv_Purchases_01, 2)
                                                          ELSE common.ifn_ExchRnd(@iv_Purchases_02, 2)
                                                          END), 2)
        , hiSales     = common.ifn_ExchRnd((hiSales +     CASE
                                                          WHEN HR.CurrencyNo = 1 THEN common.ifn_ExchRnd(@iv_Sales_01, 2)
                                                          ELSE common.ifn_ExchRnd(@iv_Sales_02, 2)
                                                          END), 2)
        , hiCleared   = common.ifn_ExchRnd((hiCleared + common.ifn_ExchRnd(@iv_Cleared, @DecimalPlaces)), @DecimalPlaces)
  FROM [!ActiveSchema!].HISTORY H
  JOIN @tb_HistoryRecords HR ON H.PositionId = HR.PositionId

  RETURN @ReturnValue

END
