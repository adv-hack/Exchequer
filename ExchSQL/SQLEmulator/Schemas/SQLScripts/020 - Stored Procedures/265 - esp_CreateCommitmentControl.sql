
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_CreateCommitmentControl]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].esp_CreateCommitmentControl
GO

CREATE PROCEDURE !ActiveSchema!.esp_CreateCommitmentControl ( @iv_CommitmentMode  INT
                                                            , @iv_SeparateControl BIT )
AS
BEGIN

  SET NOCOUNT ON;

  -- Declare Constants

  DECLARE @c_Today              VARCHAR(8)
        , @c_MaxDate            VARCHAR(8) = '20491231'
        , @c_True               BIT = 1
        , @c_False              BIT = 0
        , @c_BaseCurrencyId     INT = 0
        , @c_YTDPeriod          INT = 254
        , @c_CTDPeriod          INT = 255
        , @c_SORTransactionType INT = 8
        , @c_PORTransactionType INT = 23

  SET @c_Today = CONVERT(VARCHAR(8), GETDATE(), 112)

  DECLARE @ss_UseCCDept            BIT
        , @ss_PostToCCDept         BIT
        , @ss_SystemStartDate      DATE

  SELECT @ss_UseCCDept            = SS.UseCostCentreAndDepartments
       , @ss_PostToCCDept         = SS.PostToCostCentreAndDepartment
       , @ss_SystemStartDate      = SS.SystemStartDate
  FROM   !ActiveSchema!.evw_SystemSettings SS

  DECLARE @PaymentType VARCHAR(10) = ''

  SELECT @PaymentType = PaymentType 
  FROM common.evw_TransactionType TT 
  WHERE TT.TransactionTypeId = 31

  DECLARE @CommitmentTypes TABLE 
       ( TransactionTypeCode VARCHAR(3))

  IF @iv_CommitmentMode IN (2, 3)
  BEGIN
    INSERT INTO @CommitmentTypes
    SELECT 'SOR'
  END

  IF @iv_CommitmentMode IN (1, 3)
  BEGIN
    INSERT INTO @CommitmentTypes
    SELECT ListValue
    FROM   common.efn_TableFromList('PIN,PCR,PJI,PJC,PRF,PPI,POR,PDN')
  END

  IF OBJECT_ID('tempdb..#Commitments') IS NOT NULL
     DROP TABLE #Commitments

  SELECT NominalCode            = NominalCode
       , CurrencyCode           = CurrencyId
       , ExchequerYear          = FLOOR(ISNULL(PK.PeriodKey, THOR.TransactionPeriodKey) / 1000) - 1900
       , TransactionPeriod      = (ISNULL(PK.PeriodKey, THOR.TransactionPeriodKey) % 1000)
       , DepartmentCode
       , CostCentreCode
       , StockCode              = TL.StockCode
       , NetValue               = common.efn_ConvertToReal48(
                                  CASE 
                                  WHEN LineCalculatedNetValueOutstanding * TransactionTypeSign > 0 THEN ABS(LineCalculatedNetValueOutstanding)
                                  ELSE 0
                                  END
                                  )
       , Discount               = common.efn_ConvertToReal48(
                                  CASE 
                                  WHEN LineCalculatedNetValueOutstanding * TransactionTypeSign < 0 THEN ABS(LineCalculatedNetValueOutstanding)
                                  ELSE 0
                                  END
                                  )
       , Description            = CONVERT(VARCHAR(60), THOR.OurReference 
                                                     + ', '
                                                     + TL.StockCode
                                                     + ':' 
                                                     + CONVERT(VARCHAR, LineQuantityOutstanding)
                                                     + '. Commitment'
                                                     + ' as at '
                                                     + CONVERT(VARCHAR, GETDATE(), 103)
                                         )
       , CompanyRate            = ConversionRate
       , DailyRate              = ConversionRate
       , SOPFolioNumber         = LineFolioNumber
       , SOPLineNo              = TransactionLineNo
       , OurReference           = THOR.OurReference
       , IsSalesTransaction
       , TransactionTypeSign
       , LineCalculatedNetValueOutstanding = common.efn_ConvertToReal48(TL.LineCalculatedNetValueOutstanding)
       , LineQuantityOutstanding
       , SortType
       , GroupId                = 0
  INTO #Commitments
  FROM   [!ActiveSchema!].evw_TransactionLine TL (READUNCOMMITTED)
  CROSS APPLY ( SELECT OurReference         = thOurRef
                     , DueDate              = thDueDate
                     , PostedDate           = thPostedDate
                     , DocumentType         = thDocType
                     , TransactionPeriodKey = TPK.TransactionPeriodKey
                FROM [!ActiveSchema!].DOCUMENT TH (READUNCOMMITTED)
                CROSS APPLY ( SELECT TransactionPeriodKey = ((thYear + 1900) * 1000) + thPeriod
                            ) TPK
                WHERE TL.LineFolioNumber = TH.thFolioNum
              ) THOR
  OUTER APPLY ( SELECT InputDate = CASE
                                   -- WHEN PostedDate = '' AND DocumentType NOT IN (8, 9, 23, 24)
                                   -- THEN CASE
                                   --      WHEN ISDATE(DueDate)             = @c_True THEN DueDate             COLLATE SQL_Latin1_General_CP1_CI_AS
                                   --      WHEN ISDATE(TransactionLineDate) = @c_True THEN TransactionLineDate COLLATE SQL_Latin1_General_CP1_CI_AS
                                   --      END
                                   WHEN PostedDate = ''
                                   THEN CASE
                                        WHEN ISDATE(TransactionLineDate) = @c_True THEN TransactionLineDate COLLATE SQL_Latin1_General_CP1_CI_AS
                                        WHEN ISDATE(DueDate)             = @c_True THEN DueDate             COLLATE SQL_Latin1_General_CP1_CI_AS
                                        END
                                   END
              ) ID
  OUTER APPLY ( SELECT DiffMonths = DATEDIFF(mm, @ss_SystemStartDate, CONVERT(DATE, InputDate)) + 1
              ) DM
  LEFT JOIN ( SELECT P.PeriodKey
                   , PCount
              FROM ( SELECT PeriodKey
                          , ExchequerYear
                          , PeriodNo
                          , PCount = ROW_NUMBER() OVER(ORDER BY PeriodKey)
                     FROM   [!ActiveSchema!].evw_Period
                   ) P
            ) PK ON PK.PCount = DM.DiffMonths

  CROSS APPLY ( SELECT SortType = CASE
                                  WHEN @iv_SeparateControl = @c_True  THEN LinePositionId
                                  WHEN TransactionTypeCode IN ('SOR') THEN 1
                                  ELSE 2
                                  END
              ) ST
  WHERE  LineQuantityOutstanding >= 0.01
  AND    LineCalculatedNetValueOutstanding <> 0
  AND    TransactionTypeCode IN (SELECT TransactionTypeCode FROM @CommitmentTypes)
  AND    RunNo = 0
  AND    THOR.OurReference <> ''
  --AND    LineQuantityMultiplier <> 0

  IF OBJECT_ID('tempdb..#CommitmentGroup') IS NOT NULL
     DROP TABLE #CommitmentGroup

  SELECT GroupId = ROW_NUMBER() OVER(ORDER BY SortType
                                            , ExchequerYear
                                            , TransactionPeriod
                                            , CurrencyCode
                                            , DepartmentCode
                                            , CostCentreCode)
       , C.SortType
       , C.ExchequerYear
       , C.TransactionPeriod
       , C.CurrencyCode
       , C.DepartmentCode
       , C.CostCentreCode
  INTO  #CommitmentGroup
  FROM ( SELECT DISTINCT 
                SortType
              , ExchequerYear
              , TransactionPeriod
              , CurrencyCode
              , DepartmentCode
              , CostCentreCode
       FROM #Commitments ) C

  UPDATE C
     SET GroupId = CG.GroupId
  FROM #Commitments C
  JOIN #CommitmentGroup CG ON C.SortType          = CG.SortType
                          AND C.ExchequerYear     = CG.ExchequerYear
                          AND C.TransactionPeriod = CG.TransactionPeriod
                          AND C.CurrencyCode      = CG.CurrencyCode
                          AND C.DepartmentCode    = CG.DepartmentCode
                          AND C.CostCentreCode    = CG.CostCentreCode

  -- Create temp. table for Commitment Details

  IF OBJECT_ID('tempdb..#CommitmentDetail') IS NOT NULL
     DROP TABLE #CommitmentDetail

  SELECT C1.OurReference
       , C1.NominalCode
       , C1.CurrencyCode
       , C1.ExchequerYear
       , C1.TransactionPeriod
       , C1.DepartmentCode
       , C1.CostCentreCode
       , C1.NetValue
       , C1.Discount
       , C1.Description
       , C1.SOPFolioNumber
       , C1.SOPLineNo
       , C1.GroupId
  INTO #CommitmentDetail
  FROM #Commitments C1
  WHERE 1 = 0

  INSERT INTO #CommitmentDetail
  SELECT C1.OurReference
       , C1.NominalCode
       , C1.CurrencyCode
       , C1.ExchequerYear
       , C1.TransactionPeriod
       , C1.DepartmentCode
       , C1.CostCentreCode
       , C1.NetValue
       , C1.Discount
       , C1.Description 
       , C1.SOPFolioNumber
       , C1.SOPLineNo
       , C1.GroupId
  FROM #Commitments C1
  UNION 
  SELECT OurReference        = MAX(CASE
                                   WHEN @iv_SeparateControl = @c_True THEN OurReference
                                   ELSE ''
                                   END)
       , NominalCode         = MAX(NCode.NominalCode)
       , CurrencyCode        = MAX(C.CurrencyCode)
       , ExchequerYear       = MAX(C.ExchequerYear)
       , TransactionPeriod   = MAX(C.TransactionPeriod)
       , DepartmentCode      = MAX(C.DepartmentCode)
       , CostCentrecode      = MAX(C.CostCentreCode)
       , NetValue            = SUM(CASE
                                   WHEN C.LineCalculatedNetValueOutstanding * TransactionTypeSign * -1 > 0 THEN ABS(LineCalculatedNetValueOutstanding)
                                   ELSE 0
                                   END
                                  )
       , Discount            = SUM(CASE
                                   WHEN C.LineCalculatedNetValueOutstanding * TransactionTypeSign * -1 < 0 THEN ABS(LineCalculatedNetValueOutstanding)
                                   ELSE 0
                                   END
                                  )
       , Description         = CONVERT(VARCHAR(60),
                               CASE
                               WHEN @iv_SeparateControl = @c_True THEN MAX(C.OurReference )
                                                                     + ', '
                                                                     + MAX(C.StockCode)
                                                                     + ':' 
                                                                     + MAX(CONVERT(VARCHAR, C.LineQuantityOutstanding))
                                                                     + '. Commitment'
                               ELSE 'Commitment Posting Control'
                               END
                             + ' as at '
                             + CONVERT(VARCHAR, GETDATE(), 103)
                               )
       , SOPFolioNumber      = MAX(CASE
                                   WHEN @iv_SeparateControl = @c_True THEN C.SopFolioNumber
                                   ELSE 0
                                   END)
       , SOPLineNo           = MAX(CASE
                                   WHEN @iv_SeparateControl = @c_True THEN C.SOPLineNo
                                   ELSE 0
                                   END)
       , GroupId
  FROM #Commitments C
                       
  CROSS JOIN !ActiveSchema!.evw_NominalControl NC

  CROSS APPLY ( SELECT NominalCode = CASE
                                     WHEN C.IsSalesTransaction = @c_True THEN NC.SalesCommitment
                                     ELSE NC.PurchaseCommitment
                                     END
              ) NCode
  GROUP BY C.GroupId

  ORDER BY GroupId, OurReference Desc

  -- Create the DETAILS for Commitment Control Records
  
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
  SELECT FolioNumber            = 0
       , DisplayLineNo          = 0
       , RunNo                  = -53
       , NominalCode            = CD.NominalCode
       , NominalMode            = 0
       , CurrencyCode           = CD.CurrencyCode
       , ExchequerYear          = CD.ExchequerYear
       , TransactionPeriod      = CD.TransactionPeriod
       , DepartmentCode         = CD.DepartmentCode
       , CostCentreCode         = CD.CostCentreCode
       , tlStockCode            = CONVERT(VARBINARY(21), 0x000000000000000000000000000000000000000000)
       , TransactionLineNo      = 0
       , LineType               = ''
       , DocumentType           = 31
       , DLLUpdate              = 0
       , OldSerialQty           = 0 
       , LineQuantity           = 1
       , QuantityMultiplier     = 0
       , NetValue               = CD.NetValue
       , Discount               = CD.Discount
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
       , LineDate               = ''
       , ItemNo                 = ''
       , Description            = CD.Description
       , JobCode                = ''
       , AnalysisCode           = ''
       , CompanyRate            = C.CompanyRate
       , DailyRate              = C.DailyRate
       , UnitWeight             = 0
       , StockDeductQty         = 0
       , BOMKitLink             = 0
       , SOPFolioNum            = CD.SOPFolioNumber
       , SOPLineNo              = CD.SOPLineNo
       , LocationCode           = ''
       , QuantityPicked         = 0
       , QuantityPickedWriteOff = 0
       , UsePack                = 0
       , SerialQty              = 0
       , COSNomCode             = 0
       , OurReference           = CD.OurReference
       , DocLTLink              = 0
       , PricePerPack           = 0
       , QtyPack                = 0
       , ReconciliationDate     = @c_Today
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
       , TriRate                = 0
       , TriEuro                = 0
       , TriInvert              = 0
       , TriFloat               = 0
       , Spare1                 = CONVERT(VARBINARY(10), 0x00000000000000000000)
       , SSDUseLineValues       = 0
       , PreviousBalance        = 0
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
     
  FROM   #CommitmentDetail CD
  JOIN !ActiveSchema!.CURRENCY C ON CD.CurrencyCode = C.CurrencyCode

  -- Create commitment History

  DECLARE @PostCommitmentTransactions common.edt_Integer

  INSERT INTO @PostCommitmentTransactions
  SELECT PositionId
  FROM   !ActiveSchema!.DETAILS (READUNCOMMITTED)
  WHERE tlRunNo = -53

  -- Create temp. table for Commitment Details

  IF OBJECT_ID('tempdb..#TLHistoryData') IS NOT NULL
     DROP TABLE #TLHistoryData

  SELECT TL.NominalCode
       , TL.TransactionPeriodKey
       , TL.TransactionYear
       , TL.CostCentreCode
       , TL.DepartmentCode
       , TL.CurrencyId
       , TL.LineDiscount
       , TL.LineDiscountInBase
       , TL.LineNetValue
       , TL.LineNetValueInBase
  INTO #TLHistoryData
  FROM !ActiveSchema!.evw_TransactionLine TL (READUNCOMMITTED)
  WHERE EXISTS (SELECT TOP 1 1
                FROM @PostCommitmentTransactions PCT
                WHERE PCT.IntegerValue = TL.LinePositionId
                )

  INSERT INTO !ActiveSchema!.HISTORY
            ( hiCode
            , hiExClass
            , hiCurrency
            , hiYear
            , hiPeriod
            , hiSales
            , hiPurchases
            , hiBudget
            , hiCleared
            , hiRevisedBudget1
            , hiValue1
            , hiValue2
            , hiValue3
            , hiRevisedBudget2
            , hiRevisedBudget3
            , hiRevisedBudget4
            , hiRevisedBudget5
            , hiSpareV
            )
  SELECT      HC.HistoryCode
            , NC.HistoryClassificationId
            , C.CurrencyCode
            , HistoryYear   = FLOOR(CYP.TransactionPeriodKey / 1000) - 1900
            , HistoryPeriod = CYP.TransactionPeriodKey % 1000
            , SalesAmount    = SUM(CASE
                                   WHEN C.CurrencyCode = @c_BaseCurrencyId THEN ABS(TL.LineDiscountInBase)
                                   ELSE ABS(TL.LineDiscount)
                                   END)
            , PurchaseAmount = SUM(CASE
                                   WHEN C.CurrencyCode = @c_BaseCurrencyId THEN ABS(TL.LineNetValueInBase)
                                   ELSE ABS(TL.LineNetValue)
                                   END)
            , 0
            , 0
            , 0
            , 0
            , 0
            , 0
            , 0
            , 0
            , 0
            , 0
            , 0
  FROM #TLHistoryData TL
  JOIN !ActiveSchema!.CURRENCY C ON C.CurrencyCode IN (@c_BaseCurrencyId, TL.CurrencyId)
  JOIN !ActiveSchema!.evw_Nominal N ON TL.NominalCode = N.NominalCode
  CROSS APPLY ( SELECT CostCentreDepartmentFlag = CASE
                                                  WHEN @ss_PostToCCDept = @c_True AND TL.CostCentreCode IS NOT NULL THEN 'C'
                                                  END
                     , CostCentreCode           = CASE
                                                  WHEN @ss_PostToCCDept = @c_True AND TL.CostCentreCode IS NOT NULL THEN TL.CostCentreCode
                                                  END
                     , DepartmentCode           = CASE
                                                  WHEN @ss_PostToCCDept = @c_True AND TL.CostCentreCode IS NOT NULL THEN TL.DepartmentCode
                                                  END
                UNION
                SELECT CostCentreDepartmentFlag = CASE
                                                  WHEN @ss_UseCCDept = @c_True AND TL.CostCentreCode IS NOT NULL THEN 'C'
                                                  END
                     , CostCentreCode           = CASE
                                                  WHEN @ss_UseCCDept = @c_True AND TL.CostCentreCode IS NOT NULL THEN TL.CostCentreCode
                                                  END
                     , DepartmentCode           = NULL
                UNION
                SELECT CostCentreDepartmentFlag = CASE
                                                  WHEN @ss_PostToCCDept = @c_True AND TL.DepartmentCode IS NOT NULL THEN 'D'
                                                  END
                     , CostCentreCode           = CASE
                                                  WHEN @ss_PostToCCDept = @c_True AND TL.DepartmentCode IS NOT NULL THEN TL.CostCentreCode
                                                  END
                     , DepartmentCode           = CASE
                                                  WHEN @ss_PostToCCDept = @c_True AND TL.DepartmentCode IS NOT NULL THEN TL.DepartmentCode
                                                  END
                UNION
                SELECT CostCentreDepartmentFlag = CASE
                                                  WHEN @ss_UseCCDept = @c_True AND TL.DepartmentCode IS NOT NULL THEN 'D'
                                                  END
                     , CostCentreCode           = NULL
                     , DepartmentCode           = CASE
                                                  WHEN @ss_UseCCDept = @c_True AND TL.DepartmentCode IS NOT NULL THEN TL.DepartmentCode
                                                  END
                UNION
                SELECT CostCentreDepartmentFlag = NULL
                     , CostCentreCode           = NULL
                     , DepartmentCode           = NULL
              ) CD
  CROSS APPLY ( SELECT TL.TransactionPeriodKey
                UNION
                SELECT TransactionPeriodKey = (TL.TransactionYear * 1000) + @c_YTDPeriod
                FROM common.evw_HistoryClassification HCL
                WHERE HCL.HistoryClassificationId = ASCII(N.NominalTypeCode)
                AND   HCL.HasYTD = @c_True
                UNION
                SELECT TransactionPeriodKey = (TL.TransactionYear * 1000) + @c_CTDPeriod
                FROM common.evw_HistoryClassification HCL
                WHERE HCL.HistoryClassificationId = ASCII(N.NominalTypeCode)
                AND   HCL.HasCTD = @c_True
              ) CYP
  CROSS APPLY ( SELECT NominalCode             = NA.AscendantNominalCode
                     , HistoryClassificationId = ASCII(N.NominalTypeCode)
                FROM   !ActiveSchema!.evw_NominalAscendant NA
                JOIN   !ActiveSchema!.evw_Nominal N ON N.NominalCode = NA.AscendantNominalCode
                WHERE  TL.NominalCode = NA.NominalCode
              ) NC
  CROSS APPLY ( SELECT HistoryCode = common.efn_CreateNominalHistoryCode(NC.NominalCode, CD.CostCentreDepartmentFlag, CD.CostCentreCode, CD.DepartmentCode, @c_True)
              ) HC

  GROUP BY NC.HistoryClassificationId 
         , HC.HistoryCode
         , CYP.TransactionPeriodKey
         , C.CurrencyCode
  

  -- Insert the missing 255 rows

  DECLARE @MissingHistory TABLE
        ( HistoryClassificationId INT
        , HistoryCode             VARBINARY(21)
        , CurrencyId              INT
        , HistoryYear             INT
        )

  INSERT INTO @MissingHistory
  SELECT DISTINCT
         H.HistoryClassificationId
       , H.HistoryCode
       , H.CurrencyId
       , P.PeriodYear

  FROM !ActiveSchema!.evw_NominalHistory H (READUNCOMMITTED)
  JOIN (SELECT DISTINCT
               HistoryCode
        FROM   !ActiveSchema!.evw_NominalHistory
        WHERE HistoryPeriod = @c_CTDPeriod
        AND   IsCommitment  = @c_True
       ) SData ON H.HistoryCode = SData.HistoryCode

  JOIN common.evw_HistoryClassification HC ON HC.HistoryClassificationCode = H.HistoryClassificationCode
                                          AND HC.HasCTD = @c_True
  CROSS APPLY ( SELECT MinYear = MIN(HistoryYear)
                     , MaxYear = MAX(HistoryYear)
                FROM !ActiveSchema!.evw_History HMM (READUNCOMMITTED)
                WHERE H.HistoryClassificationCode = HMM.HistoryClassificationCode
                AND   H.HistoryCode               = HMM.HistoryCode
                AND   H.CurrencyId                = HMM.CurrencyId
              ) HMM

  JOIN (SELECT DISTINCT
               PeriodYear
        FROM   !ActiveSchema!.evw_Period
        CROSS APPLY ( SELECT PMinYear = MIN(PeriodYear)
                           , PMaxYear = MAX(PeriodYear)
                      FROM !ActiveSchema!.evw_Period 
                    ) PM
        WHERE PeriodYear BETWEEN PM.PMinYear AND PM.PMaxYear
       ) P ON P.PeriodYear BETWEEN HMM.MinYear AND HMM.MaxYear
     
  WHERE 1 = 1
  AND   H.HistoryPeriod = @c_CTDPeriod
  AND   HMM.MinYear <> HMM.MaxYear
  AND   HMM.MinYear + 1 <> HMM.MaxYear
  AND   H.IsCommitment = 1

  AND NOT EXISTS (SELECT TOP 1 1
                  FROM   !ActiveSchema!.evw_History H1 (READUNCOMMITTED)
                  WHERE H1.HistoryClassificationCode = H.HistoryClassificationCode
                  AND   H1.HistoryCode               = H.HistoryCode
                  AND   H1.CurrencyId                = H.CurrencyId
                  AND   H1.HistoryYear               = P.PeriodYear
                  AND   H1.HistoryPeriod             = @c_CTDPeriod)

  ORDER BY H.HistoryClassificationId
         , H.HistoryCode

  -- Insert Missing History Year Rows

  INSERT INTO !ActiveSchema!.HISTORY
       ( hiCode
       , hiExCLass
       , hiCurrency
       , hiYear
       , hiPeriod
       , hiSales
       , hiPurchases
       , hiBudget
       , hiCleared
       , hiRevisedBudget1
       , hiValue1
       , hiValue2
       , hiValue3
       , hiRevisedBudget2
       , hiRevisedBudget3
       , hiRevisedBudget4
       , hiRevisedBudget5
       , hiSpareV
       )
  SELECT H.hiCode
       , H.hiExCLass
       , H.hiCurrency
       , hiYear = MH.HistoryYear - 1900
       , H.hiPeriod
       , H.hiSales
       , H.hiPurchases
       , 0
       , 0
       , 0
       , 0
       , 0
       , 0
       , 0
       , 0
       , 0
       , 0
       , 0
     
  FROM   !ActiveSchema!.HISTORY H (READUNCOMMITTED)
  JOIN   @MissingHistory MH ON MH.HistoryClassificationId = H.hiExCLass
                           AND MH.HistoryCode             = H.hiCode
                           AND MH.CurrencyId              = H.hiCurrency

  WHERE 1 = 1
  AND   H.hiPeriod = @c_CTDPeriod
  AND   H.hiYear   = ( SELECT MAX(hiYear)
                       FROM !ActiveSchema!.HISTORY H1 (READUNCOMMITTED)
                       WHERE H.hiExCLass  = H1.hiExCLass
                       AND   H.hiCode     = H1.hiCode
                       AND   H.hiCurrency = H1.hiCurrency
                       AND   H1.hiYear    < MH.HistoryYear - 1900
                      ) 

  -- Update the 255 Rows

  DECLARE @UpdateCount INT = 1

  WHILE @UpdateCount <> 0
  BEGIN
    UPDATE NH
       SET SalesAmount    = (ISNULL(PYNH.SalesAmount, 0) + ISNULL(TYTotal.SalesAmount, 0))
         , PurchaseAmount = (ISNULL(PYNH.PurchaseAmount, 0) + ISNULL(TYTotal.Purchaseamount, 0))
     
      FROM   !ActiveSchema!.evw_NominalHistory NH (READUNCOMMITTED)
    CROSS APPLY ( SELECT SalesAmount    = SUM(SalesAmount)
                       , Purchaseamount = SUM(PurchaseAmount)
                  FROM   !ActiveSchema!.evw_NominalHistory TYSUM
                  WHERE TYSUM.HistoryClassificationId = NH.HistoryClassificationId
                  AND    TYSUM.HistoryCode             = NH.HistoryCode
                  AND    TYSUM.CurrencyCode            = NH.CurrencyCode
                  AND    TYSUM.HistoryPeriod           < 250
                  AND    TYSUM.HistoryYear             = NH.HistoryYear  
                ) TYTotal
    CROSS APPLY ( SELECT PreviousYear = MAX(HistoryYear)
                  FROM   !ActiveSchema!.evw_NominalHistory NHPY
                  WHERE  NHPY.HistoryClassificationId = NH.HistoryClassificationId
                  AND    NHPy.HistoryCode             = NH.HistoryCode
                  AND    NHPY.CurrencyCode            = NH.CurrencyCode
                  AND    NHPY.HistoryPeriod           = NH.HistoryPeriod
                  AND    NHPY.HistoryYear             < NH.HistoryYear
                ) PY
    JOIN   !ActiveSchema!.evw_NominalHistory PYNH ON PYNH.HistoryClassificationId = NH.HistoryClassificationId
                                         AND PYNH.HistoryCode             = NH.HistoryCode
                                         AND PYNH.CurrencyCode            = NH.CurrencyCode
                                         AND PYNH.HistoryPeriod           = NH.HistoryPeriod
                                         AND PYNH.HistoryYear             = PY.PreviousYear
    WHERE  1 = 1
    AND    NH.HistoryPeriod  = @c_CTDPeriod
    AND    NH.IsCommitment   = @c_True
    AND    PreviousYear      IS NOT NULL
    AND  ( NH.SalesAmount    <> (ISNULL(PYNH.SalesAmount, 0) + ISNULL(TYTotal.SalesAmount, 0))
     OR    NH.PurchaseAmount <> (ISNULL(PYNH.PurchaseAmount, 0) + ISNULL(TYTotal.Purchaseamount, 0))
         )
         
    SET @UpdateCount = @@ROWCOUNT
  END

  -- Insert Profit BF Records

  EXEC [!ActiveSchema!].esp_RecalculateProfitBF @iv_IsCommitment = @c_True

END
GO
