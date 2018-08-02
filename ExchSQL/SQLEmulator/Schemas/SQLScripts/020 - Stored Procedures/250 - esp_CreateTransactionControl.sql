
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_CreateTransactionControl]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].esp_CreateTransactionControl
GO

CREATE PROCEDURE [!ActiveSchema!].esp_CreateTransactionControl ( @itvp_PostTransactions [common].edt_Integer READONLY
                                                        , @iv_RunNo           INT
                                                        , @iv_SeparateControl BIT
                                                        )
AS
BEGIN

  SET NOCOUNT ON;

  /* For Debug Purposes
     DECLARE @itvp_PostTransactions [common].edt_Integer

     INSERT INTO @itvp_PostTransactions
     SELECT 7146

     DECLARE @iv_RunNo INT = 1017
  */

  -- Declare Constants

  DECLARE @c_Today          VARCHAR(8)
        , @c_MaxDate        VARCHAR(8) = '20491231'
        , @c_True           BIT = 1
        , @c_False          BIT = 0
        , @c_BaseCurrencyId INT = 0
        , @c_YTDPeriod      INT = 254
        , @c_CTDPeriod      INT = 255

  SET @c_Today = CONVERT(VARCHAR(8), GETDATE(), 112)

  DECLARE @ss_VATCurrency                INT
        , @ss_UseCompanyRate             BIT
        , @ss_UseSeparateDiscounts       BIT
        , @ss_NoOfDPQuantity             INT
        , @ss_NoOfDPNet                  INT
        , @nc_UnrealisedCurrencyVariance INT = 0
        , @nc_CurrencyVariance           INT = 0

  SELECT @ss_VATCurrency          = SS.VATCurrency
       , @ss_UseCompanyRate       = SS.UseCompanyRate
       , @ss_UseSeparateDiscounts = SS.UseSeparateDiscounts
       , @ss_NoOfDPQuantity       = SS.NoOfDPQuantity
       , @ss_NoOfDPNet            = SS.NoOfDPNet

  FROM   [!ActiveSchema!].evw_SystemSettings SS

  SELECT @nc_UnrealisedCurrencyVariance = NC.UnrealisedCurrencyVariance
       , @nc_CurrencyVariance           = NC.CurrencyVariance
  FROM   [!ActiveSchema!].evw_NominalControl NC

  DECLARE @PaymentType VARCHAR(10) = ''

  SELECT @PaymentType = PaymentType 
  FROM [common].evw_TransactionType TT 
  WHERE TT.TransactionTypeId = 31

  -- Create temp. table of Transaction Header Data

  IF OBJECT_ID('tempdb..#THControlData') IS NOT NULL
     DROP TABLE #THControlData

  CREATE TABLE #THControlData
       ( PositionId           INT
       , NominalCode          INT
       , TransactionPeriodKey INT
       , CurrencyCode         INT
       , DailyRate            FLOAT
       , CompanyRate          FLOAT
       , OurReference         VARCHAR(10)
       , TransactionTypeSign  INT
       , RunNo                INT
       , PostAmount           FLOAT
       , SeparateControl      BIT
       , THControlDataId      INT IDENTITY(1, 1)
       , ProcessOrder         INT DEFAULT(0)
       )

  -- Insert VAT Control

  INSERT INTO #THControlData
            ( PositionId
            , NominalCode
            , TransactionPeriodKey
            , CurrencyCode
            , DailyRate
            , CompanyRate
            , OurReference
            , TransactionTypeSign
            , RunNo
            , PostAmount
            , SeparateControl
            )
  SELECT HeaderPositionId
       , VATControl             = CASE
                                  WHEN TH.TransactionTypeCode IN ('SIN','SRC','SCR','SJI','SJC','SRF','SRI','SQU','SOR','SDN','SBT') THEN NC.OutputVAT
                                  WHEN TH.TransactionTypeCode IN ('PIN','PPY','PCR','PJI','PJC','PRF','PPI','PQU','POR','PDN','PBT') THEN NC.InputVAT
                                  WHEN TH.TransactionTypeCode IN ('NOM','NMT') THEN CASE
                                                                                    WHEN TH.IsNominalInputVAT  = @c_True THEN NC.InputVAT
                                                                                    WHEN TH.IsNominalOutputVAT = @c_True THEN NC.outputVAT
                                                                                    END
                                  END
       , TransactionPeriodKey
       , CurrencyCode           = @c_BaseCurrencyId
       , DailyRate              = 1
       , CompanyRate            = 1
       , OurReference
       , TransactionTypeSign
       , RunNo
       , TotalVATInBase         = [common].efn_ConvertToReal48(TH.TotalVATInBase) * TransactionTypeSign
       , SeparateControl        = @iv_SeparateControl

  FROM [!ActiveSchema!].evw_TransactionHeader TH (READUNCOMMITTED)
  JOIN @itvp_PostTransactions PLT ON PLT.IntegerValue = TH.HeaderPositionId
  CROSS JOIN [!ActiveSchema!].evw_NominalControl NC
  WHERE 1 = 1
  --AND EXISTS ( SELECT TOP 1 1
  --               FROM @itvp_PostTransactions PLT
  --               WHERE PLT.IntegerValue = TH.HeaderPositionId
  --            )
  AND TH.TransactionTypeCode IN ('NOM','NMT','SIN','SRC','SCR','SJI','SJC','SRF','SRI','SQU','SOR','SDN','SBT'
                                            ,'PIN','PPY','PCR','PJI','PJC','PRF','PPI','PQU','POR','PDN','PBT')

  IF @ss_VATCurrency <> @c_BaseCurrencyId
  BEGIN
    INSERT INTO #THControlData
              ( PositionId
              , NominalCode
              , TransactionPeriodKey
              , CurrencyCode
              , DailyRate
              , CompanyRate
              , OurReference
              , TransactionTypeSign
              , RunNo
              , PostAmount
              , SeparateControl
              )
    SELECT HeaderPositionId
         , VATControl             = CASE
                                    WHEN TH.TransactionTypeCode IN ('SIN','SRC','SCR','SJI','SJC','SRF','SRI','SQU','SOR','SDN','SBT') THEN NC.OutputVAT
                                    WHEN TH.TransactionTypeCode IN ('PIN','PPY','PCR','PJI','PJC','PRF','PPI','PQU','POR','PDN','PBT') THEN NC.InputVAT
                                    WHEN TH.TransactionTypeCode IN ('NOM','NMT') THEN CASE
                                                                                      WHEN TH.IsNominalInputVAT  = @c_True THEN NC.InputVAT
                                                                                      WHEN TH.IsNominalOutputVAT = @c_True THEN NC.outputVAT
                                                                                      END
                                    END
         , TransactionPeriodKey
         , CurrencyCode           = @ss_VATCurrency
         , DailyRate              = [common].efn_ConvertToReal48(C.DailyRate)
         , CompanyRate            = [common].efn_ConvertToReal48(C.CompanyRate)
         , OurReference
         , TransactionTypeSign
         , RunNo
         , TotalVATInCurrency     = [common].efn_ExchequerCurrencyConvert( [common].efn_ConvertToReal48(TH.TotalVATInBase)
                                                                       , R.ConversionRate
                                                                       , @ss_VATCurrency
                                                                       , @c_False
                                                                       , @c_True
                                                                       , C.TriInverted
                                                                       , C.TriRate
                                                                       , C.TriCurrencyCode
                                                                       , C.IsFloating
                                                                       )
         
                                  * TransactionTypeSign
         , SeparateControl        = @iv_SeparateControl 

    FROM [!ActiveSchema!].evw_TransactionHeader TH (READUNCOMMITTED)
    JOIN @itvp_PostTransactions PLT ON PLT.IntegerValue = TH.HeaderPositionId
    CROSS JOIN [!ActiveSchema!].evw_NominalControl NC
    JOIN [!ActiveSchema!].CURRENCY C ON C.CurrencyCode = @ss_VATCurrency
    
    CROSS APPLY ( VALUES ( (CASE
                            WHEN @ss_UsecompanyRate = @c_True THEN C.CompanyRate
                            ELSE C.DailyRate
                            END
                           )
                         )
                 ) R (ConversionRate)
    
    WHERE 1 = 1
    --AND EXISTS ( SELECT TOP 1 1
    --               FROM @itvp_PostTransactions PLT
    --               WHERE PLT.IntegerValue = TH.HeaderPositionId
    --             )
    AND TH.TransactionTypeCode IN ('NOM','NMT','SIN','SRC','SCR','SJI','SJC','SRF','SRI','SQU','SOR','SDN','SBT'
                                              ,'PIN','PPY','PCR','PJI','PJC','PRF','PPI','PQU','POR','PDN','PBT')

  END

  -- Debtors/Creditor Control or ControlGL on Transaction

  -- Put Qualifying Transactions into temp table for performance reasons

  IF OBJECT_ID('tempdb..#THData1') IS NOT NULL
     DROP TABLE #THData1

  SELECT HeaderPositionId
       , TransactionPeriodKey
       , TransactionTypeCode
       , ControlGLNominalCode
       , CurrencyId
       , OurReference
       , TransactionTypeSign
       , RunNo
       , TransactionTotalInBase
       , TransactionTotal
       , RevaluationAdjustmentInBase
       , TotalGrossValue
       , CompanyRate
       , DailyRate
  INTO #THData1
  FROM [!ActiveSchema!].evw_TransactionHeader TH (READUNCOMMITTED)
  WHERE EXISTS ( SELECT TOP 1 1
                 FROM @itvp_PostTransactions PLT
                 WHERE PLT.IntegerValue = TH.HeaderPositionId
               )
  AND ( TH.TransactionTypeId NOT IN (5,6,20,21)
     -- OR TH.ControlGLNominalCode <> 0
      )

  INSERT INTO #THControlData
            ( PositionId
            , NominalCode
            , TransactionPeriodKey
            , CurrencyCode
            , DailyRate
            , CompanyRate
            , OurReference
            , TransactionTypeSign
            , RunNo
            , PostAmount
            , SeparateControl
            )
  SELECT HeaderPositionId
       , ControlNominalCode     = CASE
                                  WHEN TH.ControlGLNominalCode <> 0 THEN TH.ControlGLNominalCode
                                  WHEN TH.TransactionTypeCode IN ('SIN','SRC','SCR','SJI','SJC','SRF','SRI','SQU','SOR','SDN','SBT') THEN NC.Debtor
                                  WHEN TH.TransactionTypeCode IN ('PIN','PPY','PCR','PJI','PJC','PRF','PPI','PQU','POR','PDN','PBT') THEN NC.Creditor
                                  END
       , TransactionPeriodKey
       , CurrencyCode           = C.CurrencyCode
       , DailyRate              = CASE
                                  WHEN C.CurrencyCode = @c_BaseCurrencyId THEN 1
                                  WHEN @ss_UseCompanyRate = @c_True THEN [common].efn_ConvertToReal48(C.CompanyRate)
                                  ELSE [common].efn_ConvertToReal48(TH.DailyRate)
                                  END
       , CompanyRate            = CASE
                                  WHEN C.CurrencyCode = @c_BaseCurrencyId THEN 1
                                  WHEN @ss_UseCompanyRate = @c_False THEN [common].efn_ConvertToReal48(C.DailyRate)
                                  ELSE [common].efn_ConvertToReal48(TH.CompanyRate)
                                  END
       , OurReference
       , TransactionTypeSign
       , TH.RunNo
       , PostAmount             = CASE
                                  WHEN C.CurrencyCode = @c_BaseCurrencyId THEN [common].efn_ConvertToReal48(TH.TransactionTotalInBase - TH.RevaluationAdjustmentInBase)
                                  ELSE [common].efn_ConvertToReal48(TH.TransactionTotal)
                                  END * TransactionTypeSign * -1
       , SeparateControl        = @iv_SeparateControl 

  FROM #THData1 TH
  CROSS JOIN [!ActiveSchema!].evw_NominalControl NC
  JOIN [!ActiveSchema!].CURRENCY C ON C.CurrencyCode IN (@c_BaseCurrencyId, TH.CurrencyId)
  WHERE 1 = 1
  -- AND   TH.TotalGrossValue <> 0 -- commented out for ABSEXCH-19663
  AND ( TH.TransactionTypeCode IN ('SIN','SRC','SCR','SJI','SJC','SRF','SRI','SQU','SOR','SDN','SBT'
                                  ,'PIN','PPY','PCR','PJI','PJC','PRF','PPI','PQU','POR','PDN','PBT')
   OR   TH.ControlGLNominalCode <> 0
      )

  -- Add any Settlement Discounts
  
  INSERT INTO #THControlData
            ( PositionId
            , NominalCode
            , TransactionPeriodKey
            , CurrencyCode
            , DailyRate
            , CompanyRate
            , OurReference
            , TransactionTypeSign
            , RunNo
            , PostAmount
            , SeparateControl
            )
  SELECT HeaderPositionId
       , ControlNominalCode     = CASE
                                  WHEN TH.TransactionTypeCode IN ('SIN','SRC','SCR','SJI','SJC','SRF','SRI','SQU','SOR','SDN','SBT') THEN NC.DiscountGiven
                                  WHEN TH.TransactionTypeCode IN ('PIN','PPY','PCR','PJI','PJC','PRF','PPI','PQU','POR','PDN','PBT') THEN NC.DiscountTaken
                                  END
       , TransactionPeriodKey
       , CurrencyCode           = C.CurrencyCode
       , DailyRate              = CASE
                                  WHEN C.CurrencyCode = @c_BaseCurrencyId THEN 1 
                                  ELSE [common].efn_ConvertToReal48(TH.DailyRate)
                                  END
       , CompanyRate            = CASE
                                  WHEN C.CurrencyCode = @c_BaseCurrencyId THEN 1 
                                  ELSE [common].efn_ConvertToReal48(TH.CompanyRate)
                                  END
       , OurReference
       , TransactionTypeSign
       , TH.RunNo
       , PostAmount             = CASE
                                  WHEN C.CurrencyCode = @c_BaseCurrencyId THEN [common].efn_ConvertToReal48(TH.SettleDiscountAmountInBase)
                                  ELSE [common].efn_ConvertToReal48(TH.SettleDiscountAmount)
                                  END * TransactionTypeSign * -1
       , SeparateControl        = @iv_SeparateControl 

  FROM [!ActiveSchema!].evw_TransactionHeader TH (READUNCOMMITTED)
  CROSS JOIN [!ActiveSchema!].evw_NominalControl NC
  JOIN [!ActiveSchema!].CURRENCY C ON C.CurrencyCode IN (@c_BaseCurrencyId, TH.CurrencyId)
  WHERE EXISTS ( SELECT TOP 1 1
                 FROM @itvp_PostTransactions PLT
                 WHERE PLT.IntegerValue = TH.HeaderPositionId
               )
  AND TH.SettleDiscountAmount <> 0
  AND TH.SettleDiscountTaken   = @c_True
  AND TH.TransactionTypeCode   IN ('SIN','SRC','SCR','SJI','SJC','SRF','SRI','SQU','SOR','SDN','SBT'
                                  ,'PIN','PPY','PCR','PJI','PJC','PRF','PPI','PQU','POR','PDN','PBT')

  -- Add Line Discounts

  IF @ss_UseSeparateDiscounts = @c_True
  BEGIN
  
    INSERT INTO #THControlData
              ( PositionId
              , NominalCode
              , TransactionPeriodKey
              , CurrencyCode
              , DailyRate
              , CompanyRate
              , OurReference
              , TransactionTypeSign
              , RunNo
              , PostAmount
              , SeparateControl
              )
    SELECT HeaderPositionId
         , ControlNominalCode     = CASE
                                    WHEN TH.TransactionTypeCode IN ('SIN','SRC','SCR','SJI','SJC','SRF','SRI','SQU','SOR','SDN','SBT') THEN NC.LineDiscountGiven
                                    WHEN TH.TransactionTypeCode IN ('PIN','PPY','PCR','PJI','PJC','PRF','PPI','PQU','POR','PDN','PBT') THEN NC.LineDiscountTaken
                                    END
         , TransactionPeriodKey
         , CurrencyCode           = C.CurrencyCode
         , DailyRate              = CASE
                                    WHEN C.CurrencyCode = @c_BaseCurrencyId THEN 1 
                                    ELSE [common].efn_ConvertToReal48(TH.DailyRate)
                                    END
         , CompanyRate            = CASE
                                    WHEN C.CurrencyCode = @c_BaseCurrencyId THEN 1 
                                    ELSE [common].efn_ConvertToReal48(TH.CompanyRate)
                                    END
         , OurReference
         , TransactionTypeSign
         , TH.RunNo
         , PostAmount             = CASE
                                    WHEN C.CurrencyCode = @c_BaseCurrencyId THEN [common].efn_ConvertToReal48(TH.TotalDiscountInBase)
                                    ELSE [common].efn_ConvertToReal48(TH.TotalDiscount)
                                    END * TransactionTypeSign * -1
         , SeparateControl        = @iv_SeparateControl

    FROM [!ActiveSchema!].evw_TransactionHeader TH (READUNCOMMITTED)
    CROSS JOIN [!ActiveSchema!].evw_NominalControl NC
    JOIN [!ActiveSchema!].CURRENCY C ON C.CurrencyCode IN (@c_BaseCurrencyId, TH.CurrencyId)
    WHERE EXISTS ( SELECT TOP 1 1
                   FROM @itvp_PostTransactions PLT
                   WHERE PLT.IntegerValue = TH.HeaderPositionId
                 )
    AND TH.TotalDiscount <> 0
    AND TH.TransactionTypeCode IN ('SIN','SRC','SCR','SJI','SJC','SRF','SRI','SQU','SOR','SDN','SBT'
                                  ,'PIN','PPY','PCR','PJI','PJC','PRF','PPI','PQU','POR','PDN','PBT')

  END

  -----------------------------------------------------------------------------------------------------
  -- Add any Unrealised Currency differences
  -----------------------------------------------------------------------------------------------------

  IF @nc_UnrealisedCurrencyVariance > 0
  BEGIN

    IF OBJECT_ID('tempdb..#UnRealData') IS NOT NULL
       DROP TABLE #UnRealData

    SELECT thFolioNum
         , TotalGrossAmountInBase
         , TotalVATAmountInBase  = VATInBase
         , LineGrossAmountInBase = CONVERT(FLOAT, NULL)

    INTO #UnRealData

    FROM [!ActiveSchema!].DOCUMENT  TH (READUNCOMMITTED)
    JOIN common.evw_TransactionType TT ON TH.thDocType  = TT.TransactionTypeId
    JOIN [!ActiveSchema!].CURRENCY   C ON TH.thCurrency = C.CurrencyCode
    CROSS APPLY (SELECT ConversionRate = common.efn_ConvertToReal48(
                                         CASE
                                         WHEN thCurrency NOT IN (0, 1) AND thCompanyRate = 0 AND thDailyRate = 0 AND @ss_UseCompanyRate = @c_True  THEN C.CompanyRate
                                         WHEN thCurrency NOT IN (0, 1) AND thCompanyRate = 0 AND @ss_UseCompanyRate = @c_True  THEN thDailyRate
                                         WHEN thCurrency NOT IN (0, 1) AND thDailyRate   = 0 AND thCompanyRate = 0 AND @ss_UseCompanyRate = @c_False THEN C.DailyRate
                                         WHEN thCurrency NOT IN (0, 1) AND thDailyRate   = 0 AND @ss_UseCompanyRate = @c_False THEN thCompanyRate
                                         WHEN @ss_UseCompanyRate = @c_True THEN CASE 
                                                                                WHEN thCompanyRate = 0 THEN 1
                                                                                ELSE thCompanyRate
                                                                                END
                                         WHEN @ss_UseCompanyRate = @c_False THEN CASE 
                                                                                 WHEN thDailyRate = 0 THEN 1
                                                                                 ELSE thDailyRate
                                                                                 END
                                         ELSE 1
                                         END)
                ) CR
    CROSS APPLY (SELECT NetValueInBase         = common.efn_ExchequerRoundUp(
                                                 common.efn_ExchequerCurrencyConvert( thNetValue
                                                                                    , ConversionRate
                                                                                    , thCurrency
                                                                                    , thUseOriginalRates
                                                                                    , 0
                                                                                    , C.TriRate
                                                                                    , C.TriInverted
                                                                                    , C.TriCurrencyCode
                                                                                    , C.IsFloating)
                                                 , 2)
                      , VATInBase              = common.efn_ExchequerRoundUp(
                                                 common.efn_ExchequerCurrencyConvert( thTotalVAT
                                                                                    , ConversionRate
                                                                                    , thCurrency
                                                                                    , thUseOriginalRates
                                                                                    , 0
                                                                                    , C.TriRate
                                                                                    , C.TriInverted
                                                                                    , C.TriCurrencyCode
                                                                                    , C.IsFloating)
                                                 , 2)
                      , DiscountInBase         = common.efn_ExchequerRoundUp(
                                                 common.efn_ExchequerCurrencyConvert( thTotalLineDiscount
                                                                                    , ConversionRate
                                                                                    , thCurrency
                                                                                    , thUseOriginalRates
                                                                                    , 0
                                                                                    , C.TriRate
                                                                                    , C.TriInverted
                                                                                    , C.TriCurrencyCode
                                                                                    , C.IsFloating)
                                                 , 2)
                      --, RevaluationAdjustmentInBase = common.efn_ExchequerRoundUp(thRevalueAdj, 2)
                      , VarianceInBase         = common.efn_ExchequerRoundUp(thVariance, 2)
                      , PostedDiscountInBase   = common.efn_ExchequerRoundUp(PostDiscAm, 2)
               ) BaseValues
    CROSS APPLY( SELECT TotalGrossAmountInBase = NetValueInBase
                                               + VATInBase 
                                               - DiscountInBase
                                               + VarianceInBase
                                               --+ RevaluationAdjustmentInBase
                                               + PostedDiscountInBase


               ) TGIB
    WHERE EXISTS ( SELECT TOP 1 1
                   FROM @itvp_PostTransactions PLT
                   WHERE PLT.IntegerValue = TH.PositionId
                 )
    AND ( TH.thCurrency NOT IN (0,1)
     OR ( TT.TransactionTypeCode = 'NOM' AND TH.thCurrency = 0 ) -- ABSEXCH-18915
        )

    -- Update the Sum of Lines

    UPDATE URD
       SET LineGrossAmountInBase = ISNULL(LineCalculatedNetValueInBase, 0) + TotalVATAmountInBase
    FROM #UnRealData URD
    LEFT JOIN ( SELECT tlFolioNum
                     , LineCalculatedNetValueInBase = common.efn_ExchequerRoundUp(SUM(CNVIB.CalcNetValueInBase), 2)

                FROM [!ActiveSchema!].DETAILS   TL (READUNCOMMITTED)
                JOIN [!ActiveSchema!].DOCUMENT  TH (READUNCOMMITTED) ON TH.thFolioNum = TL.tlFolioNum
                JOIN common.evw_TransactionType TT ON TL.tlDocType  = TT.TransactionTypeId
                JOIN [!ActiveSchema!].CURRENCY   C ON TL.tlCurrency = C.CurrencyCode
                CROSS APPLY (SELECT tlNetValue  = common.efn_ConvertToReal48(tlNetValue)
                                  , tlVATAmount = common.efn_ConvertToReal48(tlVATAmount)
                                  , tlQty       = common.efn_ConvertToReal48(tlQty)
                                  , tlQtyMul    = common.efn_ConvertToReal48(tlQtyMul)
                                  , tlDiscount  = common.efn_ConvertToReal48(tlDiscount)
                                  , tlDiscount2 = common.efn_ConvertToReal48(tlDiscount2)
                                  , tlDiscount3 = common.efn_ConvertToReal48(tlDiscount3)
                            ) CTR48
                CROSS APPLY (SELECT LineQuantity =  CASE
                                                    WHEN TL.tlUsePack = 1 THEN CTR48.tlQty * CTR48.tlQtyMul
                                                    ELSE CTR48.tlQty
                                                    END
                            ) LQ
                CROSS APPLY ( SELECT LineQuantity = CASE
                                                    WHEN TL.tlPrxPack = 1 AND TL.tlQtyPack <> 0 AND CTR48.tlQtyMul <> 0 AND TL.tlShowCase = 1
                                                    THEN common.efn_SafeDivide(LQ.LineQuantity, TL.tlQtyPack)
                                                    ELSE LQ.LineQuantity
                                                    END
                            ) LQ1
                CROSS APPLY (SELECT LineDiscount = common.efn_CalculateDiscount( CTR48.tlNetValue
                                                                               , CTR48.tlDiscount
                                                                               , tlDiscFlag
                                                                               , CTR48.tlDiscount2
                                                                               , tlDiscount2Chr
                                                                               , CTR48.tlDiscount3
                                                                               , tlDiscount3chr
                                                                               )
                            ) LD
                CROSS APPLY (SELECT LineNetValue = common.efn_ExchequerRoundUp(LQ1.LineQuantity * CTR48.tlNetValue, 2)
                                  , LineDiscount = LQ1.LineQuantity * LD.LineDiscount
                            ) S
                CROSS APPLY (SELECT LineCalculatedNetValue = common.efn_ExchequerRoundUp((S.LineNetValue - S.LineDiscount), 2)
                                  , ConversionRate         = common.efn_ConvertToReal48(
                                                             CASE
                                                             WHEN tlCurrency NOT IN (0, 1) AND tlCompanyRate = 0 AND @ss_UseCompanyRate = @c_True  THEN C.CompanyRate
                                                             WHEN tlCurrency NOT IN (0, 1) AND tlDailyRate   = 0 AND @ss_UseCompanyRate = @c_False THEN C.DailyRate
                                                             WHEN @ss_UseCompanyRate = @c_True THEN CASE 
                                                                                                    WHEN tlCompanyRate = 0 THEN 1
                                                                                                    ELSE tlCompanyRate
                                                                                                    END
                                                             WHEN @ss_UseCompanyRate = @c_False THEN CASE 
                                                                                                     WHEN tlDailyRate = 0 THEN 1
                                                                                                     ELSE tlDailyRate
                                                                                                     END
                                                             ELSE 1
                                                             END)
                            ) TG
                CROSS APPLY (SELECT LineCalculatedNetValueInBase = common.efn_ExchequerRoundUp(common.efn_ExchequerCurrencyConvert( TG.LineCalculatedNetValue
                                                                                                                                  , ConversionRate
                                                                                                                                  , tlCurrency
                                                                                                                                  , tlUseOriginalRates
                                                                                                                                  , 0
                                                                                                                                  , C.TriRate
                                                                                                                                  , C.TriInverted
                                                                                                                                  , C.TriCurrencyCode
                                                                                                                                  , C.IsFloating)
                                                                  , 2)
                            ) BaseValues
                CROSS APPLY ( SELECT LineCalcNetValueInBase = CASE
                                                              WHEN TransactionTypeCode NOT IN ('SRF','SRI','PRF','PPI') THEN LineCalculatedNetValueInBase
                                                              WHEN TransactionTypeCode = 'SRF' AND tlPaymentCode <> 'N' THEN LineCalculatedNetValueInBase
                                                              WHEN TransactionTypeCode = 'SRI' AND tlPaymentCode <> 'Y' THEN LineCalculatedNetValueInBase
                                                              WHEN TransactionTypeCode = 'PRF' AND tlPaymentCode <> 'Y' THEN LineCalculatedNetValueInBase
                                                              WHEN TransactionTypeCode = 'PPI' AND tlPaymentCode <> 'N' THEN LineCalculatedNetValueInBase
                                                              ELSE 0
                                                              END
                            ) LCNVIB
                CROSS APPLY ( SELECT CalcNetValueInBase = CASE
                                                          WHEN TL.tlCurrency IN (0,1) AND ROUND((LCNVIB.LineCalcNetValueInBase - TG.LineCalculatedNetValue),2) <> 0.0 THEN (LCNVIB.LineCalcNetValueInBase - TG.LineCalculatedNetValue)
                                                          ELSE LCNVIB.LineCalcNetValueInBase 
                                                          END
                            ) CNVIB
                WHERE EXISTS ( SELECT TOP 1 1
                               FROM @itvp_PostTransactions PLT
                               WHERE PLT.IntegerValue = TH.PositionId
                             )
              GROUP BY tlFolioNum) LineData ON URD.thFolioNum = LineData.tlFolioNum

    INSERT INTO #THControlData
              ( PositionId
              , NominalCode
              , TransactionPeriodKey
              , CurrencyCode
              , DailyRate
              , CompanyRate
              , OurReference
              , TransactionTypeSign
              , RunNo
              , PostAmount
              , SeparateControl
              )
    SELECT HeaderPositionId
         , ControlNominalCode   = @nc_UnrealisedCurrencyVariance
         , TransactionPeriodKey
         , @c_BaseCurrencyId
         , DailyRate            = 1
         , CompanyRate          = 1
         , OurReference
         , TransactionTypeSign
         , RunNo
         , PostedAmount         = CASE
                                  WHEN TH.TransactionTypeCode IN ('SRF','SRI','PRF','PPI')
                                  THEN common.efn_ConvertToReal48(URD.LineGrossAmountInBase * TH.TransactionTypeSign * -1)
                                  ELSE common.efn_ConvertToReal48(common.efn_ExchequerRoundUp(URD.TotalGrossAmountInBase - URD.LineGrossAmountInBase, 2)) * TH.TransactionTypeSign
                                  END
         , SeparateControl      = @c_True

    FROM [!ActiveSchema!].evw_TransactionHeader TH (READUNCOMMITTED)
    JOIN #UnrealData URD ON TH.HeaderFolioNumber = URD.thFolioNum
    WHERE EXISTS ( SELECT TOP 1 1
                   FROM @itvp_PostTransactions PLT
                   WHERE PLT.IntegerValue = TH.HeaderPositionId
                 )
           AND ( TH.CurrencyId NOT IN (0,1) 
            OR ( TH.TransactionTypeCode = 'NOM' AND TH.CurrencyId = 0 ) -- ABSEXCH-18915
               )
    AND ABS(common.efn_ExchequerRoundUp((URD.TotalGrossAmountInBase - URD.LineGrossAmountInBase), 2)) >= 0.01

  END

  -- Update process Order
  UPDATE THC
     SET ProcessOrder = NewOrder.ProcessOrder
  FROM #THControlData THC
  JOIN (SELECT THControlDataId
             , ProcessOrder = ROW_NUMBER() OVER (ORDER BY OurReference
                                                        , TransactionPeriodKey
                                                        , NominalCode DESC
                                                        , CurrencyCode DESC
                                                )
        FROM #THControlData
       ) NewOrder ON THC.THControlDataId = NewOrder.THControlDataId

  -- Create temp. table of rows to be inserted into DETAILS
  
  IF OBJECT_ID('tempdb..#THControlDETAIL') IS NOT NULL
     DROP TABLE #THControlDETAIL
     
  SELECT RunNo                  = @iv_RunNo
       , NominalCode            = THC.NominalCode
       , CurrencyCode           = THC.CurrencyCode
       , ExchequerYear          = FLOOR(THC.TransactionPeriodKey/1000) - 1900
       , TransactionPeriod      = THC.TransactionPeriodKey % 1000
       , TransactionPeriodKey   = THC.TransactionPeriodKey
       , NetValue               = SUM(CASE
                                      WHEN THC.PostAmount > 0 THEN ABS(THC.PostAmount)
                                      ELSE 0
                                      END)
       , Discount               = SUM(CASE
                                      WHEN THC.PostAmount < 0 THEN ABS(THC.PostAmount)
                                      ELSE 0
                                      END)
       , PaymentCode            = @PaymentType
       , LineDate               = RIGHT(SPACE(8) + CONVERT(VARCHAR(8), @iv_RunNo), 8)
       , Description            = MAX(TLD.LineDescription)
       , CompanyRate            = THC.CompanyRate
       , DailyRate              = THC.DailyRate
       , OurReference           = TLD.OurReference
       , ReconciliationDate     = @c_Today
       , TriRate                = (ISNULL(C.TriRate , 0))
       , TriEuro                = (ISNULL(C.TriCurrencyCode, 0))
       , TriInvert              = (ISNULL(C.TriInverted, 0))
       , TriFloat               = (ISNULL(C.IsFloating, 0))
       
       , PreviousBalance        = CONVERT(FLOAT, 0) --MAX(ISNULL(PB.BalanceAmount, 0))
       , ProcessOrder           = ROW_NUMBER() OVER (ORDER BY TLD.OurReference
                                                            , THC.TransactionPeriodKey
                                                            , THC.NominalCode DESC
                                                            , THC.CurrencyCode DESC
                                                 )


  INTO  #THControlDETAIL
  FROM   #THControlData THC
  JOIN  [!ActiveSchema!].CURRENCY C ON THC.CurrencyCode = C.CurrencyCode
  CROSS APPLY ( SELECT LineDescription = CASE
                                         WHEN THC.SeparateControl = @c_True THEN THC.OurReference + ' - Posting Run Control'
                                         ELSE ''
                                         END
                     , OurReference    = CASE
                                         WHEN THC.SeparateControl = @c_True THEN THC.OurReference
                                         ELSE ''
                                         END
              ) TLD
  WHERE 1 = 1
  AND THC.PostAmount <> 0
  AND EXISTS (SELECT TOP 1 1
              FROM @itvp_PostTransactions PLT
              WHERE PLt.IntegerValue = THC.PositionId
             )
  GROUP BY TLD.OurReference
         , THC.NominalCode
         , THC.CurrencyCode
         , THC.TransactionPeriodKey
         , THC.CompanyRate
         , THC.DailyRate
         , C.TriInverted
         , C.TriRate
         , C.TriCurrencyCode
         , C.IsFloating 

  -- Update Previous Balance

  UPDATE THC
     SET PreviousBalance = common.efn_ExchequerRoundUp(ISNULL(PB.BalanceAmount, 0) + ISNULL(TBA.ThisBatchAmount, 0), 2)
  FROM   #THControlDETAIL THC
  OUTER APPLY ( SELECT MaxHistoryPeriodKey = MAX(HistoryPeriodKey)
                FROM   [!ActiveSchema!].evw_NominalHistory PBal
                WHERE  PBal.HistoryCode               = common.efn_CreateNominalHistoryCode(THC.NominalCode, NULL, NULL, NULL, 0)
                AND    PBal.CurrencyCode              = THC.currencyCode
                AND    PBal.HistoryClassificationCode IN ('A','B','C')
                AND    PBal.HistoryPeriodKey         <= CASE
                                                        WHEN THC.CurrencyCode = 0
                                                        THEN FLOOR(THC.TransactionPeriodKey / 1000) * 1000 + CASE
                                                                                                             WHEN PBal.HistoryClassificationCode = 'A' THEN 254
                                                                                                             ELSE 255
                                                                                                             END
                                                        ELSE THC.TransactionPeriodKey
                                                        END
              ) MHPK
    OUTER APPLY ( SELECT BalanceAmount
                FROM   [!ActiveSchema!].evw_NominalHistory PBal
                WHERE  PBal.HistoryCode               = common.efn_CreateNominalHistoryCode(THC.NominalCode, NULL, NULL, NULL, 0)
                AND    PBal.CurrencyCode              = THC.CurrencyCode
                AND    PBAL.HistoryClassificationCode IN ('A','B','C')
                AND    PBal.HistoryPeriodKey          = MHPK.MaxHistoryPeriodKey
              ) PB
    OUTER APPLY ( SELECT ThisBatchAmount = SUM(PostAmount)
                  FROM   #THControlData T1
                  WHERE  T1.ProcessOrder < THC.ProcessOrder
                  AND    T1.NominalCode  = THC.NominalCode
                  AND    T1.CurrencyCode = THC.CurrencyCode
                ) TBA

  -- Create the DETAILS for Control Records
  
  INSERT INTO [!ActiveSchema!].DETAILS
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
  SELECT FolioNumber            = 0
       , DisplayLineNo          = 0
       , RunNo                  = THD.RunNo
       , NominalCode            = THD.NominalCode
       , NominalMode            = 0
       , CurrencyCode           = THD.CurrencyCode
       , ExchequerYear          = THD.ExchequerYear
       , TransactionPeriod      = THD.TransactionPeriod
       , DepartmentCode         = ''
       , CostCentreCode         = ''
       , tlStockCode            = CONVERT(VARBINARY(21), 0x000000000000000000000000000000000000000000)
       , TransactionLineNo      = 0
       , LineType               = ''
       , DocumentType           = 31
       , DLLUpdate              = 0
       , OldSerialQty           = 0 
       , LineQuantity           = 1
       , QuantityMultiplier     = 0
       , NetValue               = THD.NetValue
       , Discount               = THD.Discount
       , VATCode                = ''
       , VATAmount              = 0
       , PaymentCode            = @PaymentType
       , OldPBal                = 0
       , RecStatus              = 1
       , DiscFlag               = ''
       , QuantityWOFF           = 0
       , QuantityDelivered      = 0
       , Cost                   = 0
       , TraderCode             = ''
       , LineDate               = THD.LineDate
       , ItemNo                 = ''
       , Description            = THD.Description
       , JobCode                = ''
       , AnalysisCode           = ''
       , CompanyRate            = THD.CompanyRate
       , DailyRate              = THD.DailyRate
       , UnitWeight             = 0
       , StockDeductQty         = 0
       , BOMKitLink             = 0
       , SOPFolioNum            = 0
       , SOPLineNo              = 0
       , LocationCode           = ''
       , QuantityPicked         = 0
       , QuantityPickedWriteOff = 0
       , UsePack                = 0
       , SerialQty              = 0
       , COSNomCode             = 0
       , OurReference           = THD.OurReference
       , DocLTLink              = 0
       , PricePerPack           = 0
       , QtyPack                = 0
       , ReconciliationDate     = THD.ReconciliationDate
       , ShowCase               = 0
       , SdbFolio               = 0
       , OriginalBaseValue      = 0
       , UseOriginalRates       = 0
       , UserField1             = ''
       , UserField2             = ''
       , UserField3             = ''
       , UserField4             = ''
       , SSDUpliftPerc          = 0
       , SSDCountry             = ''
       , IncVATCode             = ''
       , SSDCommodCode          = ''
       , SSDSalesUnit           = 0
       , PriceMultiplier        = 0
       , B2BLinkFolio           = 0
       , B2BLineNo              = 0
       , TriRate                = THD.TriRate
       , TriEuro                = THD.TriEuro
       , TriInvert              = THD.TriInvert
       , TriFloat               = THD.TriFloat
       , Spare1                 = CONVERT(VARBINARY(10), 0x00000000000000000000)
       , SSDUseLineValues       = 0
       , PreviousBalance        = THD.PreviousBalance
       , LiveUplift             = 0
       , COSDailyRate           = 0
       , VATIncValue            = 0
       , LineSource             = 0
       , CISRateCode            = ''
       , CISRate                = 0
       , CostApportionment      = 0
       , NOMIOFlag              = 0
       , BinQuantity            = 0
       , CISAdjustment          = 0
       , DeductionType          = 0
       , SerialReturnQty        = 0
       , BinReturnQty           = 0
       , Discount2              = 0
       , DiscountFlag2          = ''
       , Discount3              = 0
       , DiscountFlag3          = ''
       , Discount3Type          = 0
       , ECService              = 0
       , ServiceStartDate       = ''
       , ServiceEndDate         = ''
       , ECSalesTaxReported     = 0
       , PurchaseServiceTax     = 0
       , Reference              = ''
       , ReceiptNo              = ''
       , FromPostCode           = ''
       , ToPostCode             = ''
       , UserField5             = ''
       , UserField6             = ''
       , UserField7             = ''
       , UserField8             = ''
       , UserField9             = ''
       , UserField10            = ''
       , ThresholdCode          = ''
       , MaterialsOnlyRetention = 0
       , IntrastatNoTC          = ''
       , TaxRegion              = 0
     
  FROM   #THControlDETAIL THD
  WHERE 1 = 1
  ORDER BY ProcessOrder

END
GO
