IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[efn_StockDiscount]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [!ActiveSchema!].[efn_StockDiscount]
GO

CREATE FUNCTION !ActiveSchema!.efn_StockDiscount 
     ( @iv_StockCode          VARCHAR(50) 
     , @iv_LocationCode       VARCHAR(50)
     , @iv_TraderCode         VARCHAR(10) 
     , @iv_StartDate          VARCHAR(8)
     , @iv_EndDate            VARCHAR(8)
     , @iv_Currency           INT 
     , @iv_StockQuantity      FLOAT
     , @iv_QuantityMultiplier FLOAT
     )
RETURNS FLOAT
AS
BEGIN

  -- For debug purposes
  /*
  DECLARE @iv_StockCode          VARCHAR(50) = 'FLD-HALO-PORT'
        , @iv_LocationCode       VARCHAR(50) = 'AAA'
        , @iv_TraderCode         VARCHAR(10) = 'GLEN01'
        , @iv_StartDate          VARCHAR(8)  = '20160314'
        , @iv_EndDate            VARCHAR(8)  = '20160314'
        , @iv_Currency           INT         = 1
        , @iv_StockQuantity      FLOAT       = 99
        , @iv_QuantityMultiplier FLOAT       = 1
  */

  DECLARE @HasInCurrencySupplierDiscounts           BIT
        , @HasInCurrencyCustomerDiscounts           BIT
        , @HasConsolidatedCurrencySupplierDiscounts BIT
        , @HasConsolidatedCurrencyCustomerDiscounts BIT

        , @IsSupplier                               BIT
        , @DiscountType                             VARCHAR(1)
        , @DiscountCurrency                         INT
        , @Price                                    FLOAT
        , @Band                                     VARCHAR(1)
        , @DiscountPercent                          FLOAT
        , @DiscountAmount                           FLOAT
        , @MarginOrMarkup                           FLOAT
        , @QtyBreakFolio                            INT   

        , @Rows                                     INT

  SET @IsSupplier = ISNULL((SELECT TOP 1 1
                            FROM   !ActiveSchema!.CUSTSUPP
                            WHERE acCode     = @iv_TraderCode
                            AND   acCustSupp = 'S'), 0)

  -- 6.15.4.19

  IF @IsSupplier = 1
  BEGIN

    SELECT TOP 1
           @DiscountType     = DiscountType
         , @DiscountCurrency = SD.Currency
         , @Price            = Price
         , @Band             = Band
         , @DiscountPercent  = DiscountP
         , @DiscountAmount   = DiscountA
         , @MarginOrMarkup   = Markup
       
    FROM   !ActiveSchema!.evw_SupplierDiscount SD
    JOIN   !ActiveSchema!.evw_StockAscendant   SA ON SD.StockCode = SA.AscendantStockCode
    WHERE (SD.SupplierCode  = @iv_TraderCode)
    AND   (SA.StockCode     = @iv_StockCode)  
    AND   ((SD.UseDates = 0) Or ((SD.UseDates = 1) And (SD.StartDate <= @iv_StartDate) And (SD.EndDate >= @iv_EndDate)))  
    AND   (SD.Currency = @iv_Currency)
    ORDER BY SA.AscendantHierarchyLevel DESC
  
    SET @Rows = @@ROWCOUNT
  
    IF @Rows = 0
    BEGIN
      SET @HasInCurrencySupplierDiscounts = 0
    
      -- 6.15.4.19.3 If the above doesn't return anything check consolidated discounts
      SELECT TOP 1
             @DiscountType     = DiscountType
           , @DiscountCurrency = SD.Currency
           , @Price            = Price
           , @Band             = Band
           , @DiscountPercent  = DiscountP
           , @DiscountAmount   = DiscountA
           , @MarginOrMarkup   = Markup
       
      FROM   !ActiveSchema!.evw_SupplierDiscount SD
      JOIN   !ActiveSchema!.evw_StockAscendant   SA ON SD.StockCode = SA.AscendantStockCode
      WHERE (SD.SupplierCode  = @iv_TraderCode)
      AND   (SA.StockCode     = @iv_StockCode)  
      AND   ((SD.UseDates = 0) Or ((SD.UseDates = 1) And (SD.StartDate <= @iv_StartDate) And (SD.EndDate >= @iv_EndDate)))  
      AND   (SD.Currency = 0)
      ORDER BY SA.AscendantHierarchyLevel DESC
    
      SET @Rows = @@ROWCOUNT
    
      IF @Rows = 0 
      BEGIN
        SET @HasConsolidatedCurrencySupplierDiscounts = 0
      
        -- 6.15.4.19.4 Now search for Supplier Quantity Breaks
      
        SELECT TOP 1 
               @DiscountType     = 'Q'
             , @DiscountCurrency = qbCurrency
             , @Price            = qbSpecialPrice
             , @Band             = qbPriceBand
             , @DiscountPercent  = qbDiscountPercent
             , @DiscountAmount   = qbDiscountAmount
             , @MarginOrMarkup   = qbMarginOrMarkup
           
        FROM   !ActiveSchema!.QTYBREAK             QB
        JOIN   !ActiveSchema!.evw_Stock           STK ON STK.FolioNumber = QB.qbStockFolio
        JOIN   !ActiveSchema!.evw_StockAscendant   SA ON STK.StockCode   = SA.AscendantStockCode
        CROSS  APPLY ( VALUES ( ( CASE
                                  WHEN STK.ShowQuantityAsPacks = 1 THEN @iv_StockQuantity * @iv_QuantityMultiplier
                                  ELSE @iv_StockQuantity
                                  END
                                )
                              )
                     ) SQ ( StockQuantity )
        WHERE   SA.StockCode           = @iv_StockCode
        AND     QB.qbCurrency          = @iv_currency
        AND     SQ.StockQuantity BETWEEN QB.qbQtyFrom   AND QB.qbQtyTo
        AND     ( QB.qbUseDates = 0 OR @iv_StartDate    BETWEEN QB.qbStartDate AND QB.qbEndDate)
        ORDER BY SA.AscendantHierarchyLevel DESC

        SET @Rows = @@ROWCOUNT

        IF @Rows = 0
        BEGIN
          SELECT TOP 1
                 @DiscountType     = 'Q'
               , @DiscountCurrency = qbCurrency
               , @Price            = qbSpecialPrice
               , @Band             = qbPriceBand
               , @DiscountPercent  = qbDiscountPercent
               , @DiscountAmount   = qbDiscountAmount
               , @MarginOrMarkup   = qbMarginOrMarkup
           
          FROM   !ActiveSchema!.QTYBREAK           QB
          JOIN   !ActiveSchema!.evw_Stock         STK ON STK.FolioNumber = QB.qbStockFolio
          JOIN   !ActiveSchema!.evw_StockAscendant SA ON STK.StockCode   = SA.AscendantStockCode
          CROSS   APPLY ( VALUES ( ( CASE
                                     WHEN STK.ShowQuantityAsPacks = 1 THEN @iv_StockQuantity * @iv_QuantityMultiplier
                                     ELSE @iv_StockQuantity
                                     END
                                   )
                                 )
                        ) SQ ( StockQuantity )
          WHERE   SA.StockCode           = @iv_StockCode
          AND     QB.qbCurrency          = 0
          AND     SQ.StockQuantity BETWEEN QB.qbQtyFrom   AND QB.qbQtyTo
          AND     ( QB.qbUseDates = 0 OR @iv_StartDate    BETWEEN QB.qbStartDate AND QB.qbEndDate)
          ORDER BY SA.AscendantHierarchyLevel DESC
        
        END
  
      END
      ELSE SET @HasConsolidatedCurrencySupplierDiscounts = 1
    
    END
    ELSE /* ROWCOUNT > 0 */
      SET @HasInCurrencySupplierDiscounts = 1
  END
  ELSE  /* Customers */
  BEGIN
    SELECT TOP 1
           @DiscountType     = DiscountType
         , @DiscountCurrency = CD.Currency
         , @Price            = Price
         , @Band             = Band
         , @DiscountPercent  = DiscountP
         , @DiscountAmount   = DiscountA
         , @MarginOrMarkup   = Markup
         , @QtyBreakFolio    = QtyBreakFolio
       
    FROM   !ActiveSchema!.CustomerDiscount   CD
    JOIN   !ActiveSchema!.evw_StockAscendant SA ON CD.StockCode = SA.AscendantStockCode
    WHERE (CD.CustCode      = @iv_TraderCode)
    AND   (SA.StockCode     = @iv_StockCode)  
    AND   ((CD.UseDates = 0) Or ((CD.UseDates = 1) And (CD.StartDate <= @iv_StartDate) And (CD.EndDate >= @iv_EndDate)))  
    AND   (CD.Currency = @iv_Currency)
    ORDER BY SA.AscendantHierarchyLevel DESC
  
    SET @Rows = @@ROWCOUNT
  
    IF @Rows = 0
    BEGIN
      SET @HasInCurrencyCustomerDiscounts = 0
    
      -- If the above doesn't return anything check consolidated discounts
      SELECT TOP 1
             @DiscountType     = DiscountType
           , @DiscountCurrency = CD.Currency
           , @Price            = Price
           , @Band             = Band
           , @DiscountPercent  = DiscountP
           , @DiscountAmount   = DiscountA
           , @MarginOrMarkup   = Markup
           , @QtyBreakFolio    = QtyBreakFolio
       
      FROM   !ActiveSchema!.CustomerDiscount   CD
      JOIN   !ActiveSchema!.evw_StockAscendant SA ON CD.StockCode = SA.AscendantStockCode
      WHERE (CD.CustCode      = @iv_TraderCode)
      AND   (SA.StockCode     = @iv_StockCode)  
      AND   ((CD.UseDates = 0) Or ((CD.UseDates = 1) And (CD.StartDate <= @iv_StartDate) And (CD.EndDate >= @iv_EndDate)))  
      AND   (CD.Currency = 0)
      ORDER BY SA.AscendantHierarchyLevel DESC
    
      SET @Rows = @@ROWCOUNT
    
      IF @Rows = 0 SET @HasConsolidatedCurrencyCustomerDiscounts = 0
      ELSE SET @HasConsolidatedCurrencyCustomerDiscounts = 1
    
    END
    ELSE /* ROWCOUNT > 0 */
    BEGIN
      SET @HasInCurrencyCustomerDiscounts = 1
    END
    
    -- 6.15.4.19.5 Look at Customer Quantity Breaks
    IF @DiscountType = 'Q'
    BEGIN
      SELECT TOP 1 
             @Price            = qbSpecialPrice
           , @DiscountCurrency = qbCurrency
           , @Band             = qbPriceBand
           , @DiscountPercent  = qbDiscountPercent
           , @DiscountAmount   = qbDiscountAmount
           , @MarginOrMarkup   = qbMarginOrMarkup
         
      FROM   !ActiveSchema!.QTYBREAK             QB
      JOIN   !ActiveSchema!.evw_Stock           STK ON STK.FolioNumber = QB.qbStockFolio

      CROSS  APPLY ( VALUES ( ( CASE
                                WHEN STK.ShowQuantityAsPacks = 1 THEN @iv_StockQuantity * @iv_QuantityMultiplier
                                ELSE @iv_StockQuantity
                                END
                              )
                            )
                   ) SQ ( StockQuantity )
      WHERE   QB.qbFolio             = @QtyBreakFolio
      AND     QB.qbCurrency          = @iv_currency
      AND     SQ.StockQuantity BETWEEN QB.qbQtyFrom   AND QB.qbQtyTo
      AND     ( QB.qbUseDates = 0 OR @iv_StartDate    BETWEEN QB.qbStartDate AND QB.qbEndDate)

      SET @Rows = @@ROWCOUNT

      IF @Rows = 0
      BEGIN
        SELECT TOP 1 
               @Price            = qbSpecialPrice
             , @DiscountCurrency = qbCurrency
             , @Band             = qbPriceBand
             , @DiscountPercent  = qbDiscountPercent
             , @DiscountAmount   = qbDiscountAmount
             , @MarginOrMarkup   = qbMarginOrMarkup
         
        FROM   !ActiveSchema!.QTYBREAK             QB
        JOIN   !ActiveSchema!.evw_Stock           STK ON STK.FolioNumber = QB.qbStockFolio
        CROSS  APPLY ( VALUES ( ( CASE
                                  WHEN STK.ShowQuantityAsPacks = 1 THEN @iv_StockQuantity * @iv_QuantityMultiplier
                                  ELSE @iv_StockQuantity
                                  END
                                )
                              )
                     ) SQ ( StockQuantity )
        WHERE   QB.qbFolio             = @QtyBreakFolio
        AND     QB.qbCurrency          = 0
        AND     SQ.StockQuantity BETWEEN QB.qbQtyFrom   AND QB.qbQtyTo
        AND     ( QB.qbUseDates = 0 OR @iv_StartDate    BETWEEN QB.qbStartDate AND QB.qbEndDate)
      END

    END -- If Discount Type = Q
   
  END

  DECLARE @UnitPrice FLOAT

  -- 6.15.34.19.7.1 Calculate Unit Price and Discount

  IF @DiscountType = 'P'
  BEGIN
    IF @iv_Currency IN (0,1)
    BEGIN
  
      IF @DiscountCurrency IN (0,1)
      BEGIN
        SET @UnitPrice = @Price
      END
      ELSE
      BEGIN
    
        SELECT @UnitPrice = common.efn_ExchequerCurrencyConvert( @Price
                                                               , ConversionRate
                                                               , @DiscountCurrency
                                                               , 0
                                                               , 0
                                                               , C.TriRate
                                                               , C.TriInverted
                                                               , C.TriCurrencyCode
                                                               , C.IsFloating)
  
        FROM   !ActiveSchema!.CURRENCY C
        CROSS JOIN !ActiveSchema!.evw_SystemSettings SS
        CROSS APPLY ( VALUES ( (CASE
                                WHEN UseCompanyRate = 1 THEN C.CompanyRate
                                WHEN UseCompanyRate = 0 THEN C.DailyRate
                                ELSE 1
                                END
                               )
                             )
                    ) CR (ConversionRate)
        WHERE C.CurrencyCode = @DiscountCurrency
      END
    END
    ELSE
    BEGIN
    
      -- convert from Discount Currency to Base
    
      SELECT  @UnitPrice = common.efn_ExchequerCurrencyConvert( @Price
                                                              , ConversionRate
                                                              , @DiscountCurrency
                                                              , 0
                                                              , 0
                                                              , C.TriRate
                                                              , C.TriInverted
                                                              , C.TriCurrencyCode
                                                              , C.IsFloating)
  
      FROM   !ActiveSchema!.CURRENCY C
      CROSS JOIN !ActiveSchema!.evw_SystemSettings SS
      CROSS APPLY ( VALUES ( (CASE
                              WHEN UseCompanyRate = 1 THEN C.CompanyRate
                              WHEN UseCompanyRate = 0 THEN C.DailyRate
                              ELSE 1
                              END
                             )
                           )
                  ) CR (ConversionRate)
      WHERE C.CurrencyCode = @DiscountCurrency
    
      -- convert from Base to Line Currency
    
      SELECT  @UnitPrice = common.efn_ExchequerCurrencyConvert( @UnitPrice
                                                              , ConversionRate
                                                              , @iv_Currency
                                                              , 0
                                                              , 1
                                                              , C.TriRate
                                                              , C.TriInverted
                                                              , C.TriCurrencyCode
                                                              , C.IsFloating)
  
      FROM   !ActiveSchema!.CURRENCY C
      CROSS JOIN !ActiveSchema!.evw_SystemSettings SS
      CROSS APPLY ( VALUES ( (CASE
                              WHEN UseCompanyRate = 1 THEN C.CompanyRate
                              WHEN UseCompanyRate = 0 THEN C.DailyRate
                              ELSE 1
                              END
                             )
                           )
                  ) CR (ConversionRate)
      WHERE C.CurrencyCode = @iv_Currency
     
    END
       
  END /* DiscountType = P */

  -- 6.15.4.19.7.2
/*
  IF @DiscountType = 'B'
  BEGIN
    
    -- Check for Multi-Locations

    DECLARE @SalesBandCurrency INT
          , @SalesBandPrice    FLOAT

    IF (SELECT UseMultiLocations
        FROM !ActiveSchema!.evw_SystemSettings) = 1
    AND @iv_LocationCode <> ''
    BEGIN

      SELECT @SalesBandCurrency = SalesBandCurrency
           , @SalesBandPrice    = SalesBandPrice

      FROM   !ActiveSchema!.evw_StockLocationPriceBand
      WHERE StockCode    = @iv_StockCode
      AND   LocationCode = @iv_LocationCode
      AND   SalesBand    = @Band

    END
    ELSE
    BEGIN

      SELECT @SalesBandCurrency = SalesBandCurrency
           , @SalesBandPrice    = SalesBandPrice

      FROM   !ActiveSchema!.evw_StockPriceBand
      WHERE StockCode    = @iv_StockCode
      AND   SalesBand    = @Band

    END
  END -- Discount Type = B
*/

  -- 6.15.4.19.7.3 & 4

  IF @DiscountType IN ('M', 'U') /* Margin or Markup */
  BEGIN

    SET @UnitPrice = ( SELECT CostPrice
                       FROM ( ( SELECT LoUseCPrice
                                FROM   !ActiveSchema!.Location
                                WHERE  loCode = @iv_LocationCode
                              )
                            ) UCP    ( UseLocationPrice )
                       OUTER APPLY ( ( SELECT CostPrice = CASE
                                                          WHEN UseLocationPrice = 1 THEN LsCostPrice
                                                          ELSE stCostPrice
                                                          END / CASE
                                                                WHEN STK.stCalcPack = 1 THEN STK.stPurchaseUnits
                                                                ELSE 1
                                                                END
                                       FROM   !ActiveSchema!.STOCK STK
                                       LEFT JOIN !ActiveSchema!.StockLocation SL ON STK.stCode   = SL.LsStkCode
                                                                        AND SL.LsLocCode = @iv_LocationCode
                                       WHERE STK.stCode = @iv_StockCode
                                      )
                                   ) CP ( CostPrice )
                     ) * (1 - (@MarginOrMarkup / 100.0))
  END /* DiscountType = M */

  RETURN ISNULL(@UnitPrice, 0)

END

GO


