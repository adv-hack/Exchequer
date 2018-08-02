IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_CreatePayInControl]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].esp_CreatePayInControl
GO

CREATE PROCEDURE !ActiveSchema!.esp_CreatePayInControl ( @itvp_PayInLineTransactions common.edt_Integer READONLY
                                                  )
AS
BEGIN

  SET NOCOUNT ON;

  -- Declare Constants

  DECLARE @c_Today          VARCHAR(8)
        , @c_MaxDate        VARCHAR(8) = '20491231'
        , @c_True           BIT = 1
        , @c_False          BIT = 0
        , @c_BaseCurrencyId INT = 0
        , @c_YTDPeriod      INT = 254
        , @c_CTDPeriod      INT = 255

  SET @c_Today = CONVERT(VARCHAR(8), GETDATE(), 112)

  IF OBJECT_ID('tempdb..#PayInTransactions') IS NOT NULL
    DROP TABLE #PayInTransactions

  SELECT DTL.LineFolioNumber
       , DTL.LinePositionId
       , PayInReference           = CONVERT(CHAR(10), DTL.PayInReference)
       , PayInLinePositionId      = CONVERT(INT, NULL)
       , DTL.TransactionPeriodKey
       , DTL.CurrencyId
       , DTL.TransactionTypeCode
       , DTL.TransactionTypeSign
       , DTL.NominalCode
       , IsSingleItem = CASE
                        WHEN DTL.PayInReference IN ('', 0x0000000000) THEN @c_True
                        ELSE @c_False
                        END

       , HasPayInMode = ISNULL((SELECT TOP 1 @c_True
                                FROM [!ActiveSchema!].DETAILS PTL
                                WHERE DTL.NominalCode * -1 = PTL.tlGLCode
                                AND   PTL.tlNominalMode = 1
                               ), @c_False)
  INTO #PayInTransactions
  FROM !ActiveSchema!.evw_TransactionLine DTL (READUNCOMMITTED)
  WHERE EXISTS (SELECT TOP 1 1
                FROM @itvp_PayInLineTransactions PILT
                WHERE DTL.LinePositionId = PILT.IntegerValue
               )

  IF OBJECT_ID('tempdb..#PayInCount') IS NOT NULL
    DROP TABLE #PayInCount

  SELECT PayInReference = PIR.PayInReference 
       , CurrencyId = DTL.tlCurrency
       , NoOfItems = COUNT(*)

  INTO #PayInCount
  FROM  [!ActiveSchema!].DETAILS DTL (READUNCOMMITTED)
  CROSS APPLY ( SELECT IsPosted = CONVERT(BIT, CASE
                                               WHEN DTL.tlRunNo IN (0, -40, -41, -43, -50, -51, -53, -60, -100, -115, -118, -125, -128) THEN 0
                                               ELSE 1
                                               END)
              ) PS
  CROSS APPLY ( SELECT PayInReference     = CASE
                                            WHEN SUBSTRING(DTL.tlStockCodeComputed, 1, 1) IN (CHAR(1), CHAR(2)) 
                                            THEN CASE
                                                 WHEN PS.IsPosted = 0 THEN LTRIM(SUBSTRING(DTL.tlStockCodeComputed, 2, 10))
                                                 ELSE LTRIM(SUBSTRING(DTL.tlStockCodeComputed, 7, 10))
                                                 END
                                            ELSE ''
                                            END
              ) PIR
  WHERE DTL.tlRunNo <> -5
  AND   DTL.tlFolioNum <> 0
  AND PIR.PayInReference NOT IN ('', 0x0000000000)

  GROUP BY PIR.PayInReference
         , DTL.tlCurrency

  IF OBJECT_ID('tempdb..#PayInData') IS NOT NULL
    DROP TABLE #PayInData

  SELECT NominalCode        = DTL.tlGLCode
       , CurrencyId         = DTL.tlCurrency
       , PayInReference
       , PayInLinePositionId = MIN(PositionId)
  INTO #PayInData
  FROM [!ActiveSchema!].DETAILS DTL (READUNCOMMITTED)
  CROSS APPLY ( SELECT IsPosted = CONVERT(BIT, CASE
                                               WHEN DTL.tlRunNo IN (0, -40, -41, -43, -50, -51, -53, -60, -100, -115, -118, -125, -128) THEN 0
                                               ELSE 1
                                               END)
              ) PS
  CROSS APPLY ( SELECT PayInReference     = CASE
                                            WHEN SUBSTRING(DTL.tlStockCodeComputed, 1, 1) IN (CHAR(1), CHAR(2)) 
                                            THEN CASE
                                                 WHEN PS.IsPosted = 0 THEN LTRIM(SUBSTRING(DTL.tlStockCodeComputed, 2, 10))
                                                 ELSE LTRIM(SUBSTRING(DTL.tlStockCodeComputed, 7, 10))
                                                 END
                                            ELSE ''
                                            END
              ) PIR
  WHERE tlRunNo                = -5
  GROUP BY DTL.tlGLCode
         , DTL.tlCurrency
         , PIR.PayInReference

  UPDATE PIT
     SET PayInLinePositionId = DTL.PayInLinePositionId
  FROM #PayInTransactions PIT
  JOIN #PayInData DTL ON DTL.NominalCode          = PIT.NominalCode * -1
                     AND DTL.CurrencyId           = PIT.CurrencyId
                     AND DTL.PayInReference       = PIT.PayInReference COLLATE SQL_Latin1_General_CP437_BIN


  -- Process each line
  DECLARE @LineFolioNumber      INT
        , @LinePositionId       INT
        , @PayInRef             CHAR(10)
        , @PayInLinePositionId  INT
        , @CurrencyId           INT
        , @TransactionPeriodKey INT
        , @NominalCode          INT
        , @IsSingleItem         BIT
        , @HasPayInMode         BIT

  DECLARE curPayInLines CURSOR LOCAL FAST_FORWARD
      FOR SELECT LineFolioNumber
               , LinePositionId
               , PayInReference
               , PayInLinePositionId
               , CurrencyId
               , TransactionPeriodKey
               , NominalCode
               , IsSingleItem
               , HasPayInMode
          FROM #PayInTransactions
  
  OPEN curPayInLines

  FETCH NEXT FROM curPayInLines INTO @LineFolioNumber
                                   , @LinePositionId
                                   , @PayInRef
                                   , @PayInLinePositionId
                                   , @CurrencyId
                                   , @TransactionPeriodKey
                                   , @NominalCode
                                   , @IsSingleItem
                                   , @HasPayInMode

  WHILE @@FETCH_STATUS = 0
  BEGIN

    IF @IsSingleItem = @c_False OR @HasPayInMode = @c_True
    BEGIN
      IF @PayInRef IN ('', 0x0000000000)
      BEGIN
        DECLARE @APIRef VARCHAR(10)

        DECLARE @NextAPIRef TABLE
               ( APIRef VARCHAR(10) )
            
        UPDATE !ActiveSchema!.evw_ExchequerNumber
               SET NextCount = NextCount + 1
            OUTPUT deleted.FormattedNextCount
              INTO @NextAPIRef
             WHERE CountType = 'API'

        SELECT @APIRef = APIRef
        FROM @NextAPIRef  

        UPDATE PIT
        SET    PayInReference = @APIRef
        FROM   #PayInTransactions PIT
        WHERE  LineFolioNumber = @LineFolioNumber

        SET @PayInRef = @APIRef

      END

      /* Does this Pay In Reference exist for this currency and this period
         if so, UPDATE it, and remove from #PayInTransactions
      */

      IF @PayInLinePositionId IS NOT NULL
      BEGIN

      DECLARE @NoOfItems           INT = 0

      SELECT @NoOfitems = NoOfItems
      FROM #PayInCount
      WHERE PayInReference = @PayInRef
      AND   CurrencyId     = @CurrencyId

        UPDATE DTL
           SET tlNetValue            = DTL.tlNetValue  + ODTL.tlNetValue
             , tlDiscount            = DTL.tlDiscount  + ODTL.tlDiscount
             , tlVATAmount           = DTL.tlVATAmount + ODTL.tlVATAmount
             , tlQtyWOFF             = DTL.tlQtyWOFF   + ODTL.tlQty
             , tlDescription         = @PayInRef + ' ' + CONVERT(VARCHAR, @NoOfItems) + ' Item(s)'
        FROM [!ActiveSchema!].DETAILS DTL (READUNCOMMITTED)
        CROSS JOIN (SELECT tlNetValue  = tlNetValue  * TT.TransactionTypeSign
                         , tlDiscount  = tlDiscount  * TT.TransactionTypeSign
                         , tlVATAmount = tlVATAmount * TT.TransactionTypeSign
                         , tlQty
                    FROM [!ActiveSchema!].DETAILS D1 (READUNCOMMITTED)
                    JOIN common.evw_TransactionType       TT ON D1.tlDocType  = TT.TransactionTypeId
                    WHERE D1.PositionId = @LinePositionId
                   ) ODTL
        WHERE DTL.PositionId = @PayInLinePositionId

        -- Update existing PayInReference

        UPDATE DTL
        SET tlStockCode = CONVERT(VARBINARY(21),
                    0x10
                  + SUBSTRING(DTL.tlStockCodeComputed, 1, 1)
                  + SUBSTRING(CONVERT(VARBINARY(21), DTL.tlGLCode), 4, 1)
                  + SUBSTRING(CONVERT(VARBINARY(21), DTL.tlGLCode), 3, 1)
                  + SUBSTRING(CONVERT(VARBINARY(21), DTL.tlGLCode), 2, 1)
                  + SUBSTRING(CONVERT(VARBINARY(21), DTL.tlGLCode), 1, 1)
                  + CONVERT(VARBINARY(1), DTL.tlCurrency)
                  + CONVERT(VARBINARY(21), CONVERT(CHAR(10), @PayInRef))
                  + 0x00000000
                  )
        FROM [!ActiveSchema!].DETAILS DTL (READUNCOMMITTED)
        WHERE DTL.PositionId = @LinePositionId

        -- remove Row from #PayInTransactions

        DELETE
        FROM #PayInTransactions
        WHERE LinePositionId = @LinePositionId

      END

    END
    ELSE
    BEGIN
      -- remove Row from #PayInTransactions

      DELETE
      FROM #PayInTransactions
      WHERE LinePositionId = @LinePositionId

    END

    FETCH NEXT FROM curPayInLines INTO @LineFolioNumber
                                     , @LinePositionId
                                     , @PayInRef
                                     , @PayInLinePositionId
                                     , @CurrencyId
                                     , @TransactionPeriodKey
                                     , @NominalCode
                                     , @IsSingleItem
                                     , @HasPayInMode
  END

  CLOSE curPayInLines
  DEALLOCATE curPayInLines

  IF OBJECT_ID('tempdb..#NewPayInDETAILS') IS NOT NULL
    DROP TABLE #NewPayInDETAILS

  SELECT tlGLCode              = DTL.tlGLCode * -1
       , tlCurrency
       , tlYear                -- is it this or post year & period
       , tlPeriod
       , tlStockCode           = XData.StockCode
       , tlNetValue            = SUM(tlNetValue  * PIT.TransactionTypeSign)
       , tlDiscount            = SUM(tlDiscount  * PIT.TransactionTypesign)
       , tlVATAmount           = SUM(tlVATAmount * PIT.TransactionTypesign)
       , tlQtyWOFF             = SUM(tlQty)
       , tlItemNo
       , tlDescription         = PIT.PayInReference + ' ' + CONVERT(VARCHAR, COUNT(*)) + ' Item(s)'
       , tlJobCode
       , tlAnalysisCode
       , tlReconciliationDate  = XData.ReconciliationDate
  INTO #NewPayInDETAILS
  FROM   !ActiveSchema!.DETAILS DTL (READUNCOMMITTED)
  JOIN #PayInTransactions PIT ON PIT.LinePositionId = DTL.PositionId
  CROSS APPLY ( SELECT ReconciliationDate = CASE
                                            WHEN LTRIM(RTRIM(tlReconciliationDate)) = '' THEN CASE
                                                                                              WHEN DTL.tlRecStatus = 1 THEN @c_Today COLLATE SQL_Latin1_General_CP437_BIN
                                                                                              ELSE @c_MaxDate COLLATE SQL_Latin1_General_CP437_BIN
                                                                                              END
                                            ELSE DTL.tlReconciliationDate
                                            END
                     , StockCode          = CONVERT(VARBINARY(21),
                                            0x10
                                          + CASE
                                            WHEN SUBSTRING(DTL.tlStockCodeComputed, 1, 1) = CHAR(1) THEN 0x02
                                            ELSE 0x01
                                            END
                                          + SUBSTRING(CONVERT(VARBINARY(21), DTL.tlGLCode), 4, 1)
                                          + SUBSTRING(CONVERT(VARBINARY(21), DTL.tlGLCode), 3, 1)
                                          + SUBSTRING(CONVERT(VARBINARY(21), DTL.tlGLCode), 2, 1)
                                          + SUBSTRING(CONVERT(VARBINARY(21), DTL.tlGLCode), 1, 1)
                                           + CONVERT(VARBINARY(1), DTL.tlCurrency)
                                           + CONVERT(VARBINARY(21), CONVERT(CHAR(10), PIT.PayInReference))
                                           + 0x00000000
                                           )
              ) XData

  GROUP BY DTL.tlGLCode
         , DTL.tlCurrency
         , DTL.tlYear
         , DTL.tlPeriod
         , XData.StockCode
         , DTL.tlItemNo
         , PIT.PayInReference
         , DTL.tlJobCode
         , DTL.tlAnalysisCode
         , XData.ReconciliationDate

  -- Insert the Pay In Control Lines

  INSERT INTO !ActiveSchema!.DETAILS
       ( tlFolioNum
       , tlLineNo
       , tlRunNo
       , tlGLCode
       , tlNominalMode
       , tlCurrency
       , tlYear
       , tlPeriod
       , tlDepartment
       , tlCostCentre 
       , tlStockCode
       , tlABSLineNo   
       , tlLineType    
       , tlDocType     
       , tlDLLUpdate   
       , tlOldSerialQty
       , tlQty
       , tlQtyMul   
       , tlNetValue
       , tlDiscount
       , tlVATCode  
       , tlVATAmount
       , tlPaymentCode
       , tlOldPBal  
       , tlRecStatus
       , tlDiscFlag
       , tlQtyWOFF 
       , tlQtyDel  
       , tlCost    
       , tlAcCode
       , tlLineDate
       , tlItemNo
       , tlDescription
       , tlJobCode
       , tlAnalysisCode
       , tlCompanyRate
       , tlDailyRate
       , tlUnitWeight        
       , tlStockDeductQty    
       , tlBOMKitLink        
       , tlSOPFolioNum       
       , tlSOPABSLineNo      
       , tlLocation          
       , tlQtyPicked         
       , tlQtyPickedWO       
       , tlUsePack           
       , tlSerialQty         
       , tlCOSNomCode        
       , tlOurRef            
       , tlDocLTLink         
       , tlPrxPack
       , tlQtyPack
       , tlReconciliationDate
       , tlShowCase            
       , tlSdbFolio            
       , tlOriginalBaseValue   
       , tlUseOriginalRates    
       , tlUserField1          
       , tlUserField2          
       , tlUserField3          
       , tlUserField4          
       , tlSSDUpliftPerc       
       , tlSSDCountry          
       , tlInclusiveVATCode    
       , tlSSDCommodCode       
       , tlSSDSalesUnit        
       , tlPriceMultiplier     
       , tlB2BLinkFolio        
       , tlB2BLineNo           
       , tlTriRates            
       , tlTriEuro             
       , tlTriInvert           
       , tlTriFloat            
       , tlSpare1
       , tlSSDUseLineValues    
       , tlPreviousBalance     
       , tlLiveUplift          
       , tlCOSDailyRate        
       , tlVATIncValue         
       , tlLineSource          
       , tlCISRateCode         
       , tlCISRate             
       , tlCostApport          
       , tlNOMIOFlag           
       , tlBinQty              
       , tlCISAdjustment       
       , tlDeductionType       
       , tlSerialReturnQty     
       , tlBinReturnQty        
       , tlDiscount2           
       , tlDiscount2Chr        
       , tlDiscount3           
       , tlDiscount3Chr        
       , tlDiscount3Type       
       , tlECService           
       , tlServiceStartDate    
       , tlServiceEndDate    
       , tlECSalesTaxReported
       , tlPurchaseServiceTax
       , tlReference
       , tlReceiptNo
       , tlFromPostCode
       , tlToPostCode
       , tlUserField5
       , tlUserField6
       , tlUserField7
       , tlUserField8
       , tlUserField9
       , tlUserField10
       , tlThresholdCode
       , tlMaterialsOnlyRetention
       , tlIntrastatNoTC
       , tlTaxRegion
       )
  SELECT tlFolioNum            = 0
       , tlLineNo              = 0
       , tlRunNo               = -5
       , tlGLCode
       , tlNominalMode         = 1
       , tlCurrency
       , tlYear                -- is it this or post year & period
       , tlPeriod
       , tlDepartment          = ''
       , tlCostCentre          = ''
       , tlStockCode
       , tlABSLineNo           = 0
       , tlLineType            = ''
       , tlDocType             = 31
       , tlDLLUpdate           = 0
       , tlOldSerialQty        = 0
       , tlQty                 = 1
       , tlQtyMul              = 1
       , tlNetValue
       , tlDiscount
       , tlVATCode             = ''
       , tlVATAmount
       , tlPaymentCode         = ''
       , tlOldPBal             = 0
       , tlRecStatus           = 0
       , tlDiscFlag            = ''
       , tlQtyWOFF
       , tlQtyDel              = 0
       , tlCost                = 0
       , tlAcCode              = ''
       , tlLineDate            = @c_Today
       , tlItemNo
       , tlDescription
       , tlJobCode
       , tlAnalysisCode
       , tlCompanyRate         = C.CompanyRate
       , tlDailyRate           = C.DailyRate
       , tlUnitWeight          = 0
       , tlStockDeductQty      = 0
       , tlBOMKitLink          = 0
       , tlSOPFolioNum         = 0
       , tlSOPABSLineNo        = 0
       , tlLocation            = ''
       , tlQtyPicked           = 0
       , tlQtyPickedWO         = 0
       , tlUsePack             = 0
       , tlSerialQty           = 0
       , tlCOSNomCode          = 0
       , tlOurRef              = ''
       , tlDocLTLink           = 0
       , tlPrxPack             = 0
       , tlQtyPack             = 0
       , tlReconciliationDate
       , tlShowCase            = 0
       , tlSdbFolio            = 0
       , tlOriginalBaseValue   = 0
       , tlUseOriginalRates    = 0
       , tlUserField1          = ''
       , tlUserField2          = ''
       , tlUserField3          = ''
       , tlUserField4          = ''
       , tlSSDUpliftPerc       = 0
       , tlSSDCountry          = ''
       , tlInclusiveVATCode    = ''
       , tlSSDCommodCode       = ''
       , tlSSDSalesUnit        = 0
       , tlPriceMultiplier     = 1
       , tlB2BLinkFolio        = 0
       , tlB2BLineNo           = 0
       , tlTriRates            = 0
       , tlTriEuro             = 0
       , tlTriInvert           = 0
       , tlTriFloat            = 0
       , tlSpare1              = 0x00000000000000000000
       , tlSSDUseLineValues    = 0
       , tlPreviousBalance     = 0
       , tlLiveUplift          = 0
       , tlCOSDailyRate        = 0
       , tlVATIncValue         = 0
       , tlLineSource          = 0
       , tlCISRateCode         = ''
       , tlCISRate             = 0
       , tlCostApport          = 0
       , tlNOMIOFlag           = 0
       , tlBinQty              = 0
       , tlCISAdjustment       = 0
       , tlDeductionType       = 0
       , tlSerialReturnQty     = 0
       , tlBinReturnQty        = 0
       , tlDiscount2           = 0
       , tlDiscount2Chr        = ''
       , tlDiscount3           = 0
       , tlDiscount3Chr        = ''
       , tlDiscount3Type       = 0
       , tlECService           = 0
       , tlServiceStartDate    = ''
       , tlServiceEndDate      = ''
       , tlECSalesTaxReported  = 0
       , tlPurchaseServiceTax  = 0
       , tlReference           = ''
       , tlReceiptNo           = ''
       , tlFromPostCode        = ''
       , tlToPostCode          = ''
       , tlUserField5          = ''
       , tlUserField6          = ''
       , tlUserField7          = ''
       , tlUserField8          = ''
       , tlUserField9          = ''
       , tlUserField10         = ''
       , tlThresholdCode       = ''
       , tlMaterialsOnlyRetention = 0
       , tlIntrastatNoTC          = ''
       , tlTaxRegion              = 0

  FROM #NewPayInDETAILS NPID
  JOIN [!ActiveSchema!].CURRENCY C ON NPID.tlCurrency = C.CurrencyCode

  -- Update existing PayInReference

  UPDATE DTL
  SET tlStockCode = CONVERT(VARBINARY(21),
                    0x10
                  + SUBSTRING(DTL.tlStockCodeComputed, 1, 1)
                  + SUBSTRING(CONVERT(VARBINARY(21), DTL.tlGLCode), 4, 1)
                  + SUBSTRING(CONVERT(VARBINARY(21), DTL.tlGLCode), 3, 1)
                  + SUBSTRING(CONVERT(VARBINARY(21), DTL.tlGLCode), 2, 1)
                  + SUBSTRING(CONVERT(VARBINARY(21), DTL.tlGLCode), 1, 1)
                  + CONVERT(VARBINARY(1), DTL.tlCurrency)
                  + CONVERT(VARBINARY(21), CONVERT(CHAR(10), PIT.PayInReference))
                  + 0x00000000
                  )
  FROM   !ActiveSchema!.DETAILS DTL (READUNCOMMITTED)
  JOIN #PayInTransactions PIT ON PIT.LinePositionId = DTL.PositionId

END
GO
