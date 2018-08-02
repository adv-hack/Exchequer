IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_CreateJCUpliftControl]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].esp_CreateJCUpliftControl
GO

CREATE PROCEDURE !ActiveSchema!.esp_CreateJCUpliftControl ( @itvp_PostJobCostUpliftTransactions common.edt_Integer READONLY
                                          , @iv_RunNo           INT
                                          , @iv_SeparateControl BIT
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

  DECLARE @ss_UsecompanyRate BIT

  SELECT @ss_UseCompanyRate = SS.UseCompanyRate
  FROM   !ActiveSchema!.evw_SystemSettings SS

  IF OBJECT_ID('tempdb..#JCUpliftTransactions') IS NOT NULL
    DROP TABLE #JCUpliftTransactions

  SELECT tlGLCode              = GL.NominalCode
       , C.CurrencyCode
       , tlYear                -- is it this or post year & period
       , tlPeriod
       , tlDepartment
       , tlCostCentre
       , tlNetValue            = CASE
                                 WHEN GL.NominalCode = DTL.tlGLCode THEN common.efn_ExchequerRoundUp(
                                                                         CASE
                                                                         WHEN DTL.tlCurrency <> @c_BaseCurrencyId THEN JACT.UpliftTotal
                                                                         ELSE UTIB.UpliftTotalInBase
                                                                         END * JACT.Quantity
                                                                         , 2) * TT.TransactionTypeSign
                                 ELSE 0
                                 END
       , tlDiscount            = CASE
                                 WHEN GL.NominalCode <> DTL.tlGLCode THEN common.efn_ExchequerRoundUp(
                                                                          CASE
                                                                          WHEN DTL.tlCurrency <> @c_BaseCurrencyId THEN JACT.UpliftTotal
                                                                          ELSE UTIB.UpliftTotalInBase
                                                                          END * JACT.Quantity
                                                                          , 2) * TT.TransactionTypeSign
                                 ELSE 0
                                 END
       , tlAcCode              = CASE
                                 WHEN @iv_SeparateControl = @c_True THEN tlAcCode
                                 ELSE ''
                                 END
       , tlLineDate            = RIGHT(SPACE(8) + CONVERT(VARCHAR(8), @iv_RunNo) ,8)
       , tlItemNo              = ''
       , tlDescription         = CASE
                                 WHEN @iv_SeparateControl = @c_True THEN tlOurRef + ' - '
                                 ELSE ''
                                 END
                               + 'Job Uplift Adjustment to Cost'
       , tlCompanyRate         = C.CompanyRate
       , tlDailyRate           = C.DailyRate
       , tlOurRef              = CASE
                                 WHEN @iv_SeparateControl = @c_True THEN tlOurRef
                                 ELSE ''
                                 END
       , tlPreviousBalance     = ISNULL(PB.BalanceAmount, 0)
  INTO #JCUpliftTransactions
  FROM !ActiveSchema!.DETAILS DTL
  JOIN common.evw_TransactionType TT ON DTL.tlDocType = TT.TransactionTypeId
  JOIN !ActiveSchema!.CURRENCY C ON C.CurrencyCode IN (0, DTL.tlCurrency)
  JOIN !ActiveSchema!.evw_Job JOB ON DTL.tlJobCode = JOB.JobCode
  JOIN !ActiveSchema!.evw_JobActual  JACT  ON DTL.tlJobCode = JAct.JobCode
                                  AND DTL.tlFolioNum  = JACT.TransactionLineFolio
                                  AND DTL.tlABSLineNo = JACT.TransactionLineNumber
  CROSS APPLY ( VALUES ( (CASE
                          WHEN @ss_UsecompanyRate = @c_True THEN C.CompanyRate
                          ELSE C.DailyRate
                          END
                         )
                       )
              ) R (ConversionRate)
  CROSS APPLY ( SELECT UpliftTotalInBase = common.efn_ExchequerCurrencyConvert( JACT.UpliftTotal
                                                                              , R.ConversionRate
                                                                              , DTL.tlCurrency
                                                                              , @c_False
                                                                              , @c_True
                                                                              , C.TriInverted
                                                                              , C.TriRate
                                                                              , C.TriCurrencyCode
                                                                              , C.IsFloating
                                                                              )
              ) UTIB
  CROSS APPLY ( SELECT NominalCode = CASE
                                     WHEN JACT.UpliftGL <> 0 THEN JACT.UpliftGL
                                     --ELSE DTL.tlGLCode
                                     END
                UNION
                SELECT NominalCode = DTL.tlGLCode
              ) GL
  OUTER APPLY ( SELECT BalanceAmount
                FROM   !ActiveSchema!.evw_NominalHistory PBal
                WHERE  PBal.HistoryCode               = common.efn_CreateNominalHistoryCode(GL.NominalCode, NULL, NULL, NULL, 0)
                AND    PBal.CurrencyCode              = C.currencyCode
                AND    PBAL.HistoryClassificationCode IN ('A','B','C')
                AND    PBal.HistoryPeriodKey          = CASE
                                                        WHEN C.CurrencyCode = @c_BaseCurrencyId
                                                        THEN (DTL.tlyear + 1900) * 1000 + CASE
                                                                                          WHEN PBal.HistoryClassificationCode = 'A' THEN @c_YTDPeriod
                                                                                          ELSE @c_CTDPeriod
                                                                                          END
                                                        ELSE (DTL.tlyear + 1900) * 1000 + DTL.tlPeriod
                                                        END
              ) PB
  WHERE  JOB.JobStat       < 4 -- Job Complete
  AND    JACT.UpliftTotal <> 0

  AND EXISTS ( SELECT TOP 1 1
               FROM @itvp_PostJobCostUpliftTransactions JCUT
               WHERE DTL.PositionId = JCUT.IntegerValue)


  -- Insert the Job Costing Uplift Control Lines

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
       , tlRunNo               = @iv_RunNo
       , tlGLCode              = JCUT.tlGLCode
       , tlNominalMode         = 0
       , CurrencyCode          = JCUT.CurrencyCode        
       , tlYear                = JCUT.tlYear            -- is it this or post year & period
       , tlPeriod              = JCUT.tlPeriod
       , tlDepartment          = JCUT.tlDepartment
       , tlCostCentre          = JCUT.tlCostCentre
       , tlStockCode           = CONVERT(VARBINARY(21), 0x000000000000000000000000000000000000000000)
       , tlABSLineNo           = 0
       , tlLineType            = ''
       , tlDocType             = 31
       , tlDLLUpdate           = 0
       , tlOldSerialQty        = 0
       , tlQty                 = 1
       , tlQtyMul              = 0
       , tlNetValue            = SUM(JCUT.tlNetValue)
       , tlDiscount            = SUM(JCUT.tlDiscount)
       , tlVATCode             = ''
       , tlVATAmount           = 0
       , tlPaymentCode         = 'C'
       , tlOldPBal             = 0
       , tlRecStatus           = 1
       , tlDiscFlag            = ''
       , tlQtyWOFF             = 0
       , tlQtyDel              = 0
       , tlCost                = 0
       , tlAcCode              = JCUT.tlAcCode
       , tlLineDate            = RIGHT(SPACE(8) + CONVERT(VARCHAR(8), @iv_RunNo) ,8)
       , tlItemNo              = ''
       , tlDescription         = JCUT.tlDescription
       , tlJobCode             = ''
       , tlAnalysisCode        = ''
       , tlCompanyRate         = JCUT.tlCompanyRate
       , tlDailyRate           = JCUT.tlDailyRate
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
       , tlOurRef              = JCUT.tlOurRef
       , tlDocLTLink           = 0
       , tlPrxPack             = 0
       , tlQtyPack             = 0
       , tlReconciliationDate  = @c_Today
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
       , tlPriceMultiplier     = 0
       , tlB2BLinkFolio        = 0
       , tlB2BLineNo           = 0
       , tlTriRates            = 0
       , tlTriEuro             = 0
       , tlTriInvert           = 0
       , tlTriFloat            = 0
       , tlSpare1              = CONVERT(VARBINARY(10), 0x00000000000000000000)
       , tlSSDUseLineValues    = 0
       , tlPreviousBalance     = MAX(JCUT.tlPreviousBalance)
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

  FROM #JCUpliftTransactions JCUT

  GROUP BY JCUT.tlGLCode
         , JCUT.CurrencyCode        
         , JCUT.tlYear
         , JCUT.tlPeriod
         , JCUT.tlDepartment
         , JCUT.tlCostCentre
         , JCUT.tlAcCode
         , JCUT.tlDescription
         , JCUT.tlCompanyRate
         , JCUT.tlDailyRate
         , JCUT.tlOurRef

END
GO
