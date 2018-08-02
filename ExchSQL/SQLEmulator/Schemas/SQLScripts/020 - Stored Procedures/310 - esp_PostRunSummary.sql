
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_PostRunSummary]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].esp_PostRunSummary
GO

-- Usage: EXEC [!ActiveSchema!].esp_PostRunSummary 1007


CREATE PROCEDURE [!ActiveSchema!].esp_PostRunSummary ( @itvp_PostTransactions common.edt_Integer READONLY
                                                   , @iv_RunNo INT 
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

  DECLARE @Creditor      INT
        , @Debtor        INT
        , @InputVAT      INT
        , @OutputVAT     INT
        , @DiscountGiven INT
        , @DiscountTaken INT

  SELECT @Creditor      = Creditor
       , @Debtor        = Debtor
       , @InputVAT      = InputVAT
       , @OutputVAT     = OutputVAT
       , @DiscountGiven = DiscountGiven
       , @DiscountTaken = DiscountTaken
  FROM [!ActiveSchema!].evw_NominalControl

  DECLARE @tvp_SalesControlGL    common.edt_Integer
        , @tvp_PurchaseControlGL common.edt_Integer

  INSERT INTO @tvp_SalesControlGL
  SELECT DISTINCT
         ControlGLNominalCode
  FROM [!ActiveSchema!].evw_TransactionHeader TH (READUNCOMMITTED)
  WHERE TH.RunNo                 = @iv_RunNo
  AND   TH.IsSalesTransaction = 1
  AND   TH.ControlGLNominalCode <> 0

  INSERT INTO @tvp_PurchaseControlGL
  SELECT DISTINCT
         ControlGLNominalCode
  FROM [!ActiveSchema!].evw_TransactionHeader TH (READUNCOMMITTED)
  WHERE TH.RunNo                 = @iv_RunNo
  AND   TH.IsPurchaseTransaction = 1
  AND   TH.ControlGLNominalCode <> 0

  INSERT INTO [!ActiveSchema!].etb_PostingRunSummary
            ( RunNo
            , PostAnalysisType
            , BFwdAmount
            )
  SELECT RunNo = @iv_RunNo
       , PAT.PostAnalysisType
       , BFwdAmount = ISNULL(ENUM.ssLastValue, 0)

  FROM [common].evw_PostAnalysisType PAT
  LEFT JOIN [!ActiveSchema!].EXCHQNUM ENUM ON ENUM.ssCountType = PAT.PostAnalysisType


  IF OBJECT_ID('tempdb..#PATData') IS NOT NULL
    DROP TABLE #PATData

  SELECT RunNo
              , PostAnalysisType
              , PostAmount = SUM(LineGrossValueInBase * TransactionTypeSign)
  INTO #PATData
  FROM   [!ActiveSchema!].evw_TransactionLine TL (READUNCOMMITTED)
  CROSS APPLY (SELECT PostAnalysisType =      CASE
                                              WHEN NominalCode  = @Creditor THEN 'CRE'
                                              WHEN NominalCode IN (SELECT IntegerValue
                                                                   FROM   @tvp_PurchaseControlGL
                                                                  ) THEN 'CRE'
                                              WHEN NominalCode = @Debtor THEN 'DEB'
                                              WHEN NominalCode IN (SELECT IntegerValue
                                                                   FROM @tvp_SalesControlGL
                                                                  ) THEN 'DEB'
                                              WHEN NominalCode = @InputVAT THEN 'IVT'
                                              WHEN NominalCode = @OutputVAT THEN 'OVT'
                                              WHEN NominalCode = @DiscountGiven AND IsSalesTransaction = @c_True THEN 'SDG'
                                              WHEN NominalCode = @DiscountTaken AND IsSalesTransaction = @c_False THEN 'SDT'
                                              END
               ) PAT
  WHERE 1 = 1
  AND TL.RunNo               = @iv_RunNo
  AND PAT.PostAnalysisType   IS NOT NULL
  AND TL.TransactionTypeCode = 'RUN'
  AND TL.CurrencyId          = @c_BaseCurrencyId

  GROUP BY RunNo
         , PostAnalysisType

  -- Update Posted Amount

  UPDATE PRS
     SET PostAmount = NewData.PostAmount
  FROM [!ActiveSchema!].etb_PostingRunSummary PRS
  JOIN #PATData NewData ON NewData.PostAnalysisType = PRS.PostAnalysisType
                       AND NewData.RunNo            = PRS.RunNo

  IF OBJECT_ID('tempdb..#PRSCalcData') IS NOT NULL
    DROP TABLE #PRSCalcData

  -- For Performance reasons put calculated data into temp. table.
  SELECT HeaderPositionId
       , RunNo
       , TransactionTypeCode
       , IsSalesTransaction
       , TotalNetValueInBase        = ISNULL((SELECT TotalNetValueInBase FROM [!ActiveSchema!].evw_TransactionHeaderValues THV WHERE  THV.HeaderPositionId = D.PositionId) , 0)
       , VarianceAmountInBase       = ISNULL((SELECT VarianceAmountInBase FROM [!ActiveSchema!].evw_TransactionHeaderValues THV WHERE  THV.HeaderPositionId = D.PositionId) , 0)
       , SettleDiscountAmountInBase = ISNULL((SELECT SettleDiscountAmountInBase FROM [!ActiveSchema!].evw_TransactionHeaderValues THV WHERE  THV.HeaderPositionId = D.PositionId) , 0)
  INTO #PRSCalcData
  FROM [!ActiveSchema!].DOCUMENT D
  JOIN [!ActiveSchema!].evw_TransactionHeader TH1 (READUNCOMMITTED) ON D.PositionId = TH1.HeaderPositionId
  WHERE D.thRunNo     = @iv_RunNo
  AND   D.thDocType  <> 31
  AND   D.thCurrency <> @c_BaseCurrencyId
 
  IF OBJECT_ID('tempdb..#PRSCalcValue') IS NOT NULL
    DROP TABLE #PRSCalcValue

  SELECT RunNo
       , PostAnalysisType
       , PostAmount = SUM((TotalNetValueInBase
                         + SettleDiscountAmountInBase
                         + VarianceAmountInBase
                         )
                         * T1.TransactionTypeSign)
  INTO #PRSCalcValue
  FROM #PRSCalcData THData
  CROSS APPLY (SELECT PostAnalysisType = CASE
                                         WHEN THData.TransactionTypeCode IN ('SRI','PPI') AND IsSalesTransaction = @c_True  THEN 'SIN'
                                         WHEN THData.TransactionTypeCode IN ('SRI','PPI') AND IsSalesTransaction = @c_False THEN 'PIN'
                                         WHEN THData.TransactionTypeCode IN ('SRF','PRF') AND IsSalesTransaction = @c_True  THEN 'SCR'
                                         WHEN THData.TransactionTypeCode IN ('SRF','PRF') AND IsSalesTransaction = @c_False THEN 'PCR'
                                         ELSE THData.TransactionTypeCode
                                         END
              ) PAT
  JOIN common.evw_TransactionType T1 ON PAT.PostAnalysisType = T1.TransactionTypeCode

  GROUP BY THData.RunNo
         , PAT.PostAnalysisType

  -- Add Discounts

  INSERT INTO #PRSCalcValue
  SELECT RunNo            = D.thRunNo
       , PostAnalysisType
       , PostAmount       = SUM(TotalDiscountInBase * TT.TransactionTypeSign * -1)
  FROM [!ActiveSchema!].DOCUMENT D
  JOIN common.evw_TransactionType TT ON D.thDocType = TT.TransactionTypeId
  LEFT JOIN [!ActiveSchema!].CURRENCY C ON D.thCurrency = C.CurrencyCode
  CROSS JOIN [!ActiveSchema!].evw_SystemSettings SS

  CROSS APPLY ( VALUES ( (common.efn_ConvertToReal48(
                          CASE
                          WHEN CurrencyCode NOT IN (0, 1) AND thCompanyRate = 0 AND UseCompanyRate = @c_True THEN C.CompanyRate
                          WHEN CurrencyCode NOT IN (0, 1) AND thDailyRate = 0 AND UseCompanyRate = @c_False   THEN C.DailyRate
                          WHEN UseCompanyRate = @c_True THEN CASE 
                                                             WHEN thCompanyRate = 0 THEN 1
                                                             ELSE thCompanyRate
                                                             END
                          WHEN UseCompanyRate = @c_False THEN CASE 
                                                              WHEN thDailyRate = 0 THEN 1
                                                              ELSE thDailyRate
                                                              END
                          ELSE 1
                          END)
                         )
                       )
              ) Rates ( ConversionRate
                     )
  CROSS APPLY ( VALUES ( (common.efn_ConvertToReal48(thTotalLineDiscount) )
                       )
              ) CTR48  ( TotalDiscount
                       )

  CROSS APPLY ( SELECT TotalDiscountInBase = common.efn_ExchequerCurrencyConvert( TotalDiscount
                                                                                , ConversionRate
                                                                                , thCurrency
                                                                                , 0
                                                                                , 0
                                                                                , C.TriRate
                                                                                , C.TriInverted
                                                                                , C.TriCurrencyCode
                                                                                , C.IsFloating)
              ) BaseValues 

  CROSS APPLY (SELECT PostAnalysisType = CASE
                                         WHEN TT.ParentTransactionTypeId = 100 THEN 'NDG'
                                         ELSE 'NDT'
                                         END
              ) PAT

  WHERE D.thRunNo     = @iv_RunNo
  AND   D.thDocType  <> 31
  AND   D.thCurrency <> @c_BaseCurrencyId

  GROUP BY D.thRunNo
         , PAT.PostAnalysisType

  -- Update for Calculated Value

  UPDATE PRS
         SET PostAmount = PRS.PostAmount + NewData.PostAmount
  FROM [!ActiveSchema!].etb_PostingRunSummary PRS
  JOIN #PRSCalcValue NewData ON NewData.PostAnalysisType = PRS.PostAnalysisType
                AND NewData.RunNo            = PRS.RunNo
  WHERE PRS.RunNo = @iv_RunNo

  -- Run it for Gross Value for Direct Set ('SRI', 'PPI', 'SRF', 'PRF') only

  MERGE [!ActiveSchema!].etb_PostingRunSummary RS
  USING (SELECT RunNo
              , PostAnalysisType
              , PostAmount = SUM((TotalGrossValueInBase * TH.TransactionTypeSign) * T1.TransactionTypeSign * PAM.PostAnalysisMultiplier)
    
         FROM   [!ActiveSchema!].evw_TransactionHeader TH
         CROSS APPLY (SELECT PostAnalysisType = CASE
                                                WHEN TransactionTypeCode IN ('SRI','PPI') AND IsSalesTransaction = @c_True  THEN 'SRC'
                                                WHEN TransactionTypeCode IN ('SRI','PPI') AND IsSalesTransaction = @c_False THEN 'PPY'
                                                WHEN TransactionTypeCode IN ('SRF','PRF') AND IsSalesTransaction = @c_True  THEN 'SRC'
                                                WHEN TransactionTypeCode IN ('SRF','PRF') AND IsSalesTransaction = @c_False THEN 'PPY'
                                                END
                     ) PAT
         LEFT JOIN common.evw_TransactionType T1 ON PAT.PostAnalysisType = T1.TransactionTypeCode
         CROSS APPLY (SELECT PostAnalysisMultiplier = CASE
                                                      WHEN TH.TransactionTypeCode IN ('SRI','PPI') AND IsSalesTransaction = @c_True  THEN -1
                                                      WHEN TH.TransactionTypeCode IN ('SRI','PPI') AND IsSalesTransaction = @c_False THEN 1
                                                      WHEN TH.TransactionTypeCode IN ('SRF','PRF') AND IsSalesTransaction = @c_True  THEN -1
                                                      WHEN TH.TransactionTypeCode IN ('SRF','PRF') AND IsSalesTransaction = @c_False THEN 1
                                                      ELSE T1.TransactionTypeSign
                                                      END
                     ) PAM
         WHERE 1 = 1
         AND   TH.RunNo               = @iv_RunNo
         AND   PAT.PostAnalysisType    IS NOT NULL
         AND   TH.TransactionTypeCode IN ('SRI', 'PPI', 'SRF', 'PRF')
         AND   TH.CurrencyId          <> @c_BaseCurrencyId
         --AND   EXISTS ( SELECT TOP 1 1
         --               FROM @itvp_PostTransactions PT
         --               WHERE TH.HeaderPositionId = PT.IntegerValue
         --             )
         GROUP BY RunNo
                , PostAnalysisType
        ) PData ON RS.RunNo            = PData.RunNo
               AND RS.PostAnalysisType = PData.PostAnalysisType
  WHEN MATCHED THEN
       UPDATE
          SET PostAmount = RS.PostAmount + PData.PostAmount
  WHEN NOT MATCHED BY TARGET THEN
       INSERT ( RunNo
              , PostAnalysisType
              , PostAmount
              )
       VALUES ( PData.RunNo
              , PData.PostAnalysisType
              , PData.PostAmount
              ) 
  ;

  -- Update [!ActiveSchema!].EXCHQNUM

  UPDATE ENUM
     SET ssLastValue = ssLastValue + common.efn_ConvertToReal48(RS.PostAmount)
  FROM [!ActiveSchema!].EXCHQNUM ENUM
  JOIN [!ActiveSchema!].etb_PostingRunSummary RS (READUNCOMMITTED) ON ENUM.ssCountType = RS.PostAnalysisType
  WHERE RS.RunNo = @iv_RunNo

END

GO

