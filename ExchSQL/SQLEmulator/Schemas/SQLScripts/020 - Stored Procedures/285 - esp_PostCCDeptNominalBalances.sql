IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_PostCCDeptNominalBalances]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].[esp_PostCCDeptNominalBalances]
GO

--
-- Post CC & Dept. Nominal Balances
--

CREATE PROCEDURE [!ActiveSchema!].[esp_PostCCDeptNominalBalances] ( @itvp_PostLineTransactions [common].edt_Integer READONLY
                                                                  , @iv_IsControl BIT = 0
                                                                  )
AS
BEGIN
  SET NOCOUNT ON;

/*  
  INSERT INTO [common].etb_AuditLog
            ( TableName
            , AuditText
            , AuditDate
            )
  VALUES    ( '!ActiveSchema!.esp_PostCCDeptNominalBalances'
            , '<LOG><AUDIT_TYPE>LOG   </AUDIT_TYPE></LOG>'
            , GETDATE()
            )
*/

  -- Declare Constants
  DECLARE @c_Today          VARCHAR(8)
        , @c_MaxDate        VARCHAR(8) = '20491231'
        , @c_True           BIT = 1
        , @c_False          BIT = 0
        , @c_BaseCurrencyId INT = 0
        , @c_YTDPeriod      INT = 254
        , @c_CTDPeriod      INT = 255

  DECLARE @UseCCDept            BIT
        , @UseSeparateDiscounts BIT
        , @PostToCCDept         BIT
        , @PostToCCOrDept       BIT
        , @DiscGivenControl     INT
        , @DiscTakenControl     INT
        , @ProfitBFcontrol      INT
        , @AuditYear            INT
        , @PLStart              INT
        , @PLHierarchy          VARCHAR(10)

  -- Determine if COMPANY use CC and Departments and Separate Discounts

  SELECT @UseCCDept            = UseCostCentreAndDepartments
       , @UseSeparateDiscounts = UseSeparateDiscounts
       , @PostToCCDept         = PostToCostCentreAndDepartment
       , @PostToCCOrDept       = PostToCostCentreOrDepartment
       , @DiscGivenControl     = LineDiscountGivenControlNominalCode
       , @DiscTakenControl     = LineDiscountTakenControlNominalCode
       , @ProfitBFControl      = ProfitBFControlNominalCode
       , @AuditYear            = AuditYear
  FROM   [!ActiveSchema!].evw_SystemSettings

  SET @c_Today = CONVERT(VARCHAR(8), GETDATE(), 112)

  SELECT @PLStart = PLStart
  FROM   [!ActiveSchema!].evw_NominalControl

  SET @PLHierarchy = '~' + CONVERT(VARCHAR, @PLStart) + '~%'

  IF OBJECT_ID('tempdb..#PostLineTransactions') IS NOT NULL
    DROP TABLE #PostLineTransactions

  CREATE TABLE #PostLineTransactions
       ( IntegerValue INTEGER )

  INSERT INTO #PostLineTransactions
  SELECT * FROM @itvp_PostLineTransactions

  CREATE INDEX idx_PLT ON #PostLineTransactions(IntegerValue)

  -- For performance Reasons load TL data from view into Temp table

 IF OBJECT_ID('tempdb..#PostLineData') IS NOT NULL
    DROP TABLE #PostLineData

  CREATE TABLE #PostLineData
       ( LinePositionId               INTEGER
       , LineNetValue                 FLOAT
       , LineCalculatedNetValue       FLOAT
       , LineNetValueInBase           FLOAT
       , LineCalculatedNetValueInBase FLOAT
       , LineDiscount                 FLOAT
       , LineDiscountInBase           FLOAT
       )

  INSERT INTO #PostLineData
  SELECT LinePositionId
       , LineNetValue                 
       , LineCalculatedNetValue       
       , LineNetValueInBase           
       , LineCalculatedNetValueInBase
       , LineDiscount
       , LineDiscountInBase

  FROM [!ActiveSchema!].evw_TransactionLine TL (NOLOCK)
  WHERE EXISTS (SELECT TOP 1 1
                FROM #PostLineTransactions PLT 
                WHERE TL.LinePositionId = PLT.IntegerValue)

  CREATE INDEX idx_PLD ON #PostLineData(LinePositionId)


  IF OBJECT_ID('tempdb..#NominalTransactions') IS NOT NULL
    DROP TABLE #NominalTransactions

  -- Load Qualifying data into temporary table

  SELECT PositionId            = TL.PositionId
       , OurReference          = TL.tlOurRef
       , TransactionTypeCode   = TT.TransactionTypeCode
       , IsSalesTransaction    = CONVERT(BIT, CASE
                                              WHEN TT.ParentTransactionTypeId = 100 THEN 1
                                              ELSE 0
                                              END)
       , IsPurchaseTransaction = CONVERT(BIT, CASE
                                              WHEN TT.ParentTransactionTypeId = 101 THEN 1
                                              ELSE 0
                                              END)
       , IsCommitment          = CASE
                                 WHEN TL.tlRunNo = -53 THEN @c_True
                                 ELSE @c_False
                                 END
       , NominalCode           = TL.tlGLCode
       , TransactionPeriodKey  = ((TL.tlYear + 1900) * 1000) + TL.tlPeriod
       , CurrencyId            = TL.tlCurrency
       , CostCentreCode        = NULLIF(TL.tlCostCentre, '')
       , DepartmentCode        = NULLIF(TL.tlDepartment, '')
       , PaymentCode           = TL.tlPaymentCode
       , PurchaseAmount        = CASE
                                 WHEN Results.LineTotal > 0 THEN ABS(Results.LineTotal)
                                 ELSE 0
                                 END
       , SalesAmount           = CASE
                                 WHEN Results.LineTotal < 0 THEN ABS(Results.LineTotal)
                                 ELSE 0
                                 END
       , DiscountAmount        = Results.LineDiscount

       , PurchaseAmountInBase  = CASE
                                 WHEN Results.LineTotalInBase > 0 THEN ABS(Results.LineTotalInBase)
                                 ELSE 0
                                 END
       , SalesAmountInBase     = CASE
                                 WHEN Results.LineTotalInBase < 0 THEN ABS(Results.LineTotalInBase)
                                 ELSE 0
                                 END
       , DiscountAmountInBase  = LineDiscountInBase
  INTO #NominalTransactions
  FROM [!ActiveSchema!].DETAILS TL (NOLOCK)
  JOIN #PostLineData PLD ON TL.PositionId = PLD.LinePositionId
  JOIN common.evw_TransactionType TT ON TL.tlDocType = TT.TransactionTypeId
  CROSS APPLY ( VALUES ( (CASE
                          WHEN @UseSeparateDiscounts = @c_True THEN PLD.LineNetValue 
                          ELSE PLD.LineCalculatedNetValue
                          END * CASE
                                WHEN TL.tlPaymentCode = 'N' THEN -1
                                ELSE 1
                                END
                         )
                       , (CASE
                          WHEN @UseSeparateDiscounts = @c_True THEN PLD.LineNetValueInBase
                          ELSE PLD.LineCalculatedNetValueInBase
                          END * CASE
                                WHEN TL.tlPaymentCode = 'N' THEN -1
                                ELSE 1
                                END
                         )
                       , (CASE
                          WHEN @UseSeparateDiscounts = @c_True THEN PLD.LineDiscount
                          ELSE 0
                          END
                         )
                       )
               ) Results ( LineTotal
                         , LineTotalInBase
                         , LineDiscount
                         )
  WHERE  TL.tlGLCode <> 0

  IF OBJECT_ID('tempdb..#NominalTransSummary') IS NOT NULL
    DROP TABLE #NominalTransSummary

  CREATE TABLE #NominalTransSummary
        ( NominalCode              INT
        , NominalType              VARCHAR(1)
        , IsCommitment             BIT
        , TransactionPeriodKey     INT
        , CurrencyId               INT
        , CostCentreDepartmentFlag VARCHAR(1) NULL
        , CostCentreCode           VARCHAR(3) NULL
        , DepartmentCode           VARCHAR(3) NULL

        , PurchaseAmount           FLOAT DEFAULT 0.0
        , SalesAmount              FLOAT DEFAULT 0.0
        , DiscountAmount           FLOAT DEFAULT 0.0
           
        , PurchaseAmountInBase     FLOAT DEFAULT 0.0
        , SalesAmountInBase        FLOAT DEFAULT 0.0
        , DiscountAmountInBase     FLOAT DEFAULT 0.0

        , TransLineCount           INT   DEFAULT 0
        )

  -- Insert Transaction Summary

  INSERT INTO #NominalTransSummary
            ( NominalCode
            , NominalType
            , IsCommitment
            , TransactionPeriodKey
            , CurrencyId
            , CostCentreCode
            , DepartmentCode
            , PurchaseAmount
            , SalesAmount
            , DiscountAmount
            , PurchaseAmountInBase
            , SalesAmountInBase
            , DiscountAmountInBase
            
            , TransLineCount
            )
  SELECT NT.NominalCode
       , NominalType = MAX(N.NominalTypeCode)
       , NT.IsCommitment
       , NT.TransactionPeriodKey
       , NT.CurrencyId
       , NULLIF(NT.CostCentreCode, '')
       , NULLIF(NT.DepartmentCode, '')
       , SUM(NT.PurchaseAmount)
       , SUM(NT.SalesAmount)
       , SUM(NT.DiscountAmount)

       , SUM(NT.PurchaseAmountInBase)
       , SUM(NT.SalesAmountInBase)
       , SUM(NT.DiscountAmountInBase)
       
       , COUNT(*)

  FROM #NominalTransactions NT
  LEFT JOIN [!ActiveSchema!].evw_Nominal N ON NT.NominalCode = N.NominalCode

  GROUP BY NT.NominalCode
         , NT.IsCommitment
         , NT.TransactionPeriodKey
         , NT.CurrencyId
         , NT.CostCentreCode
         , NT.DepartmentCode

  -- Add the Discount Line in if using Separate Discounts

  IF @UseSeparateDiscounts = @c_True
  BEGIN
    INSERT INTO #NominalTransSummary
              ( NominalCode
              , NominalType
              , IsCommitment
              , TransactionPeriodKey
              , CurrencyId
              , CostCentreCode
              , DepartmentCode
              , PurchaseAmount
              , SalesAmount
              , PurchaseAmountInBase
              , SalesAmountInBase
              
              , TransLineCount
              )
    SELECT NominalCode          = NP.PostNominalCode
         , NominalType          = MAX(N.NominalTypeCode)
         , NT.IsCommitment
         , NT.TransactionPeriodKey
         , NT.CurrencyId
         , CostCentreCode       = NT.CostCentreCode
         , DepartmentCode       = NT.DepartmentCode

         , PurchaseAmount       = SUM(common.efn_ExchequerRoundUp(
                                      CASE
                                      WHEN NT.DiscountAmount > 0 THEN ABS(NT.DiscountAmount)
                                      ELSE 0
                                      END, 2))
         , SalesAmount          = SUM(common.efn_ExchequerRoundUp(
                                      CASE
                                      WHEN NT.DiscountAmount < 0 THEN ABS(NT.DiscountAmount)
                                      ELSE 0
                                      END, 2))
         , PurchaseAmountInBase = SUM(common.efn_ExchequerRoundUp(
                                      CASE
                                      WHEN NT.DiscountAmountInBase > 0 THEN ABS(NT.DiscountAmountInBase)
                                      ELSE 0
                                      END, 2))
         , SalesAmountInBase    = SUM(common.efn_ExchequerRoundUp(
                                      CASE
                                      WHEN NT.DiscountAmountInBase < 0 THEN ABS(NT.DiscountAmountInBase)
                                      ELSE 0
                                      END, 2))		      
         , TransLineCount       = COUNT(*)

    FROM   #NominalTransactions NT
    CROSS APPLY ( SELECT PostNominalCode = CASE
                                           WHEN NT.TransactionTypeCode   = 'RUN'   THEN NT.NominalCode
                                           WHEN NT.IsSalesTransaction    = @c_True THEN @DiscGivenControl
                                           WHEN NT.IsPurchaseTransaction = @c_True THEN @DiscTakenControl
                                           END
                ) NP
    JOIN   [!ActiveSchema!].evw_Nominal N ON N.NominalCode = NP.PostNominalCode

    WHERE  NT.DiscountAmount      <> 0.0

    GROUP BY NP.PostNominalCode
           , NT.IsCommitment
           , NT.TransactionPeriodKey
           , NT.CurrencyId
           , NT.CostCentreCode
           , NT.DepartmentCode

  END

  -- Now Insert Base Currency equivalent Records for non-base records

  IF @iv_IsControl = @c_False
  BEGIN
    UPDATE NTS
       SET PurchaseAmount       = NTS.PurchaseAmount       + ISNULL(BaseData.PurchaseAmountInBase, 0)
         , SalesAmount          = NTS.SalesAmount          + ISNULL(BaseData.SalesAmountInBase, 0)
         , PurchaseAmountInBase = NTS.PurchaseAmountInBase + ISNULL(BaseData.PurchaseAmountInBase, 0)
         , SalesAmountInBase    = NTS.SalesAmountInBase    + ISNULL(BaseData.SalesAmountInBase, 0)
    FROM #NominalTransSummary NTS
    OUTER APPLY ( SELECT PurchaseAmountInBase = SUM(PurchaseAmountInBase)
                       , SalesAmountInBase    = SUM(SalesAmountInBase)
                  FROM   #NominalTransSummary NTS1
                  WHERE  NTS1.CurrencyId                         <> @c_BaseCurrencyId
                  AND    NTS.NominalCode                          = NTS1.NominalCode
                  AND    NTS.IsCommitment                         = NTS1.IsCommitment
                  AND    NTS.TransactionPeriodKey                 = NTS1.TransactionPeriodKey
                  AND    ISNULL(NTS.CostCentreDepartmentFlag, '') = ISNULL(NTS1.CostCentreDepartmentFlag, '')
                  AND    ISNULL(NTS.CostCentreCode, '')           = ISNULL(NTS1.CostCentreCode, '')
                  AND    ISNULL(NTS.DepartmentCode, '')           = ISNULL(NTS1.DepartmentCode, '')
                ) BaseData
    WHERE NTS.CurrencyId = @c_BaseCurrencyId
  END

  INSERT INTO #NominalTransSummary
            ( NominalCode
            , NominalType
            , IsCommitment
            , TransactionPeriodKey
            , CurrencyId
            , CostCentreCode
            , DepartmentCode
            , PurchaseAmount
            , SalesAmount
            , PurchaseAmountInBase
            , SalesAmountInBase
            , TransLineCount
            )
  SELECT NominalCode
       , NominalType 
       , IsCommitment
       , TransactionPeriodKey
       , CurrencyId = @c_BaseCurrencyId
       , CostCentreCode
       , DepartmentCode
       , PurchaseAmount       = SUM(PurchaseAmountInBase)
       , SalesAmount          = SUM(SalesAmountInBase)
       , PurchaseAmountInBase = SUM(PurchaseAmountInBase)
       , SalesAmountInBase    = SUM(SalesAmountInBase)
       , TransLineCount       = SUM(TransLineCount)
  FROM   #NominalTransSummary NTS
  WHERE  CurrencyId <> @c_BaseCurrencyId

  AND NOT EXISTS (SELECT TOP 1 1
                  FROM   #NominalTransSummary NTS1
                  WHERE  NTS.NominalCode                          = NTS1.NominalCode
                  AND    NTS.IsCommitment                         = NTS1.IsCommitment
                  AND    NTS.TransactionPeriodKey                 = NTS1.TransactionPeriodKey
                  AND    @c_BaseCurrencyId                        = NTS1.CurrencyId
                  AND    ISNULL(NTS.CostCentreDepartmentFlag, '') = ISNULL(NTS1.CostCentreDepartmentFlag, '')
                  AND    ISNULL(NTS.CostCentreCode, '')           = ISNULL(NTS1.CostCentreCode, '')
                  AND    ISNULL(NTS.DepartmentCode, '')           = ISNULL(NTS1.DepartmentCode, '')
                 )
  GROUP BY NominalCode
         , NominalType 
         , IsCommitment
         , TransactionPeriodKey
         , CostCentreCode
         , DepartmentCode

 IF OBJECT_ID('tempdb..#NominalHistory') IS NOT NULL
    DROP TABLE #NominalHistory

  -- Insert NominalHistory Records
  
  SELECT HistoryPositionId = CONVERT(INT, NULL)
       , HC.HistoryCode
       , NC.HistoryClassificationId
       , NC.NominalCode
       , NTS.TransactionPeriodKey
       , ExchequerYear = FLOOR(NTS.TransactionPeriodKey / 1000) - 1900
       , HistoryPeriod = (NTS.TransactionPeriodKey % 1000)
       , CurrencyId
       , CD.CostCentreDepartmentFlag
       , CD.CostCentreCode
       , CD.DepartmentCode
       , SalesAmount    = SUM(SalesAmount)
       , PurchaseAmount = SUM(PurchaseAmount)
  INTO #NominalHistory
  FROM   #NominalTransSummary NTS

  CROSS APPLY ( SELECT CostCentreDepartmentFlag = CASE
                                                  WHEN @PostToCCDept = @c_True AND NTS.CostCentreCode IS NOT NULL THEN 'C'
                                                  END
                     , CostCentreCode           = CASE
                                                  WHEN @PostToCCDept = @c_True AND NTS.CostCentreCode IS NOT NULL THEN NTS.CostCentreCode
                                                  END
                     , DepartmentCode           = CASE
                                                  WHEN @PostToCCDept = @c_True AND NTS.CostCentreCode IS NOT NULL THEN NTS.DepartmentCode
                                                  END
                UNION
                SELECT CostCentreDepartmentFlag = CASE
                                                  WHEN @PostToCCOrDept = @c_True AND NTS.CostCentreCode IS NOT NULL THEN 'C'
                                                  END
                     , CostCentreCode           = CASE
                                                  WHEN @PostToCCOrDept= @c_True AND NTS.CostCentreCode IS NOT NULL THEN NTS.CostCentreCode
                                                  END
                     , DepartmentCode           = NULL
                UNION
                SELECT CostCentreDepartmentFlag = CASE
                                                  WHEN @PostToCCDept = @c_True AND NTS.DepartmentCode IS NOT NULL THEN 'D'
                                                  END
                     , CostCentreCode           = CASE
                                                  WHEN @PostToCCDept = @c_True AND NTS.DepartmentCode IS NOT NULL THEN NTS.CostCentreCode
                                                  END
                     , DepartmentCode           = CASE
                                                  WHEN @PostToCCDept = @c_True AND NTS.DepartmentCode IS NOT NULL THEN NTS.DepartmentCode
                                                  END
                UNION
                SELECT CostCentreDepartmentFlag = CASE
                                                  WHEN @PostToCCOrDept = @c_True AND NTS.DepartmentCode IS NOT NULL THEN 'D'
                                                  END
                     , CostCentreCode           = NULL
                     , DepartmentCode           = CASE
                                                  WHEN @PostToCCOrDept = @c_True AND NTS.DepartmentCode IS NOT NULL THEN NTS.DepartmentCode
                                                  END
                UNION
                SELECT CostCentreDepartmentFlag = NULL
                     , CostCentreCode           = NULL
                     , DepartmentCode           = NULL
              ) CD

  CROSS APPLY ( SELECT NominalCode             = NA.AscendantNominalCode
                     , HistoryClassificationId = ASCII(N.NominalTypeCode)
                FROM   [!ActiveSchema!].evw_NominalAscendant NA
                JOIN   [!ActiveSchema!].evw_Nominal N ON N.NominalCode = NA.AscendantNominalCode
                WHERE  NTS.NominalCode = NA.NominalCode
              ) NC
  OUTER APPLY ( SELECT HistoryCode = [common].efn_CreateNominalHistoryCode(NC.NominalCode, CD.CostCentreDepartmentFlag, CD.CostCentreCode, CD.DepartmentCode, NTS.IsCommitment)
              ) HC
  GROUP BY HC.HistoryCode
       , NC.HistoryClassificationId
       , NC.NominalCode
       , NTS.TransactionPeriodKey
       , CurrencyId
       , CD.CostCentreDepartmentFlag
       , CD.CostCentreCode
       , CD.DepartmentCode

  -- Insert YTD figures for P & L - Updated later in the process

  INSERT INTO #NominalHistory
  SELECT DISTINCT
         NH.HistoryPositionId
       , NH.HistoryCode
       , NH.HistoryClassificationId
       , NH.NominalCode
       , HPK.HistoryPeriodKey
       , NH.ExchequerYear
       , HistoryPeriod = @c_YTDPeriod
       , NH.CurrencyId
       , NH.CostCentreDepartmentFlag
       , NH.CostCentreCode
       , NH.DepartmentCode
       , SalesAmount    = 0
       , PurchaseAmount = 0
  FROM   #NominalHistory NH
  CROSS APPLY ( SELECT HistoryPeriodKey = ((FLOOR(NH.TransactionPeriodKey / 1000) * 1000) + @c_YTDPeriod)
              ) HPK
  CROSS APPLY ( SELECT IsPandL = CONVERT(BIT, CASE
                                              WHEN NHIER.NominalHierarchy LIKE @PLHierarchy THEN 1
                                              ELSE 0
                                              END
                                        )
                FROM [!ActiveSchema!].evw_NominalHierarchy NHIER
                WHERE NHIER.NominalCode = NH.NominalCode
              ) IsPL
  WHERE IsPL.IsPandL = 1
  AND NH.HistoryPeriod < 250

  -- Insert CTD record for Balance Sheet & Control - This gets updated later.

  INSERT INTO #NominalHistory
  SELECT HistoryPositionId          = CONVERT(INT, NULL)
       , NH.HistoryCode
       , NH.HistoryClassificationId
       , NominalCode                = NominalCode
       , NH.HistoryPeriodKey
       , ExchequerYear              = FLOOR(NH.HistoryPeriodKey / 1000) - 1900
       , HistoryPeriod              = @c_CTDPeriod
       , NH.CurrencyId
       , CostCentreDepartmentFlag   = CONVERT(VARCHAR, NULL)
       , CostCentreCode             = CONVERT(VARCHAR, NULL)
       , DepartmentCode             = CONVERT(VARCHAR, NULL)
       , SalesAmount                = 0 
       , PurchaseAmount             = 0 

  FROM (SELECT DISTINCT 
               HistoryClassificationId
             , HistoryCode
             , NominalCode
             , HistoryPeriodKey
             , CurrencyId
        FROM #NominalHistory NH2
        CROSS APPLY ( SELECT HistoryPeriodKey = ((FLOOR(NH2.TransactionPeriodKey / 1000) * 1000) + 255)
                    ) HPK
        WHERE HistoryPeriod < 250
       ) NH
  CROSS APPLY ( SELECT IsPandL = CONVERT(BIT, CASE
                                              WHEN NHIER.NominalHierarchy LIKE @PLHierarchy THEN 1
                                              ELSE 0
                                              END
                                        )
                FROM [!ActiveSchema!].evw_NominalHierarchy NHIER
                WHERE NHIER.NominalCode = NH.NominalCode
              ) IsPL

  WHERE IsPL.IsPandL = @c_False

  -- Insert any future 255 records that need to be updated too

  INSERT INTO #NominalHistory
  SELECT NH.HistoryPositionId
       , NH.HistoryCode
       , NH.HistoryClassificationId
       , NH.NominalCode
       , NHV.HistoryPeriodKey
       , NHV.ExchequerYear
       , NHV.HistoryPeriod
       , NH.CurrencyId
       , NH.CostCentreDepartmentFlag
       , NH.CostCentreCode
       , NH.DepartmentCode
       , NH.SalesAmount
       , NH.PurchaseAmount
  FROM   #NominalHistory NH
  JOIN   [!ActiveSchema!].evw_NominalHistory NHV (READUNCOMMITTED) ON NH.HistoryClassificationId = NHV.HistoryClassificationId
                                      AND NH.CurrencyId              = NHV.CurrencyId
                                      AND NH.HistoryCode             = NHV.HistoryCode
                                      AND NH.HistoryPeriod           = NHV.HistoryPeriod
                                      AND NH.ExchequerYear           < NHV.ExchequerYear
  WHERE NH.HistoryPeriod = @c_CTDPeriod
  AND NOT EXISTS ( SELECT TOP 1 1
                   FROM #NominalHistory NH1
                   WHERE NH1.HistoryClassificationId = NH.HistoryClassificationId
                   AND NH1.CurrencyId                = NH.CurrencyId
                   AND NH1.HistoryCode               = NH.HistoryCode
                   AND NH1.TransactionPeriodKey      = NHV.HistoryPeriodKey
                 )


  CREATE NONCLUSTERED INDEX idx_NH1 ON #NominalHistory(HistoryCode)

  -- Set Position Id

  UPDATE TNH
     SET HistoryPositionId = NH.HistoryPositionId
  FROM #NominalHistory TNH
  JOIN [!ActiveSchema!].evw_NominalHistory NH ON TNH.HistoryCode          = NH.HistoryCode
                                   AND TNH.HistoryClassificationId      = NH.HistoryClassificationId
                                   AND TNH.TransactionPeriodKey         = NH.HistoryPeriodKey
                                   AND TNH.CurrencyId                   = NH.CurrencyId
  
  CREATE NONCLUSTERED INDEX idx_NH2 ON #NominalHistory (HistoryPositionId) 

  -- Update History

  UPDATE H
     SET hiSales     = hiSales     + HData.SalesAmount
       , hiPurchases = hiPurchases + HData.PurchaseAmount
  FROM [!ActiveSchema!].HISTORY H
  JOIN #NominalHistory HData ON HData.HistoryPositionId = H.PositionId

  -- Insert any new History Records

  INSERT INTO [!ActiveSchema!].HISTORY
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
  SELECT      HistoryCode
            , HistoryClassificationId
            , CurrencyId
            , ExchequerYear
            , HistoryPeriod
            , SalesAmount
            , PurchaseAmount
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
  FROM #NominalHistory TNH
  WHERE TNH.HistoryPositionId IS NULL
  AND   TNH.NominalCode <> 0

  -- Insert missing HISTORY Year rows

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
     
  FROM [!ActiveSchema!].evw_History H (READUNCOMMITTED)
  JOIN (SELECT DISTINCT
               HistoryCode
        FROM   #NominalHistory
        WHERE (TransactionPeriodKey%1000) = @c_CTDPeriod
       ) SData ON H.HistoryCode = SData.HistoryCode

  JOIN [common].evw_HistoryClassification HC ON HC.HistoryClassificationCode = H.HistoryClassificationCode
                                          AND HC.HasCTD = @c_True
  CROSS APPLY ( SELECT MinYear = MIN(HistoryYear)
                     , MaxYear = MAX(HistoryYear)
                FROM [!ActiveSchema!].evw_History HMM (READUNCOMMITTED)
                WHERE H.HistoryClassificationCode = HMM.HistoryClassificationCode
                AND   H.HistoryCode               = HMM.HistoryCode
                AND   H.CurrencyId                = HMM.CurrencyId
              ) HMM

  JOIN (SELECT DISTINCT
               PeriodYear
        FROM   [!ActiveSchema!].evw_Period
        CROSS APPLY ( SELECT PMinYear = MIN(PeriodYear)
                           , PMaxYear = MAX(PeriodYear)
                      FROM [!ActiveSchema!].evw_Period 
                    ) PM
        WHERE PeriodYear BETWEEN PM.PMinYear AND PM.PMaxYear
       ) P ON P.PeriodYear BETWEEN HMM.MinYear AND HMM.MaxYear
     
  WHERE 1 = 1
  AND   H.HistoryPeriod = @c_CTDPeriod
  AND   HMM.MinYear <> HMM.MaxYear
  AND   HMM.MinYear + 1 <> HMM.MaxYear

  AND NOT EXISTS (SELECT TOP 1 1
                  FROM   [!ActiveSchema!].evw_History H1 (READUNCOMMITTED)
                  WHERE H1.HistoryClassificationCode = H.HistoryClassificationCode
                  AND   H1.HistoryCode               = H.HistoryCode
                  AND   H1.CurrencyId                = H.CurrencyId
                  AND   H1.HistoryYear               = P.PeriodYear
                  AND   H1.HistoryPeriod             = @c_CTDPeriod)

  ORDER BY H.HistoryClassificationId
         , H.HistoryCode

  -- Insert Missing History Year Rows

  INSERT INTO [!ActiveSchema!].HISTORY
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
     
  FROM   [!ActiveSchema!].HISTORY H (READUNCOMMITTED)
  JOIN   @MissingHistory MH ON MH.HistoryClassificationId = H.hiExCLass
                           AND MH.HistoryCode             = H.hiCode
                           AND MH.CurrencyId              = H.hiCurrency

  WHERE 1 = 1
  AND   H.hiPeriod = @c_CTDPeriod
  AND   H.hiYear   = ( SELECT MAX(hiYear)
                       FROM [!ActiveSchema!].HISTORY H1 (READUNCOMMITTED)
                       WHERE H.hiExCLass  = H1.hiExCLass
                       AND   H.hiCode     = H1.hiCode
                       AND   H.hiCurrency = H1.hiCurrency
                       AND   H1.hiYear    < MH.HistoryYear - 1900
                      ) 

  -- Set Starting position for new 255 records

  UPDATE ThisYear
     SET hiSales     = ThisYear.hiSales     + ISNULL(LastYear.SalesAmount, 0)
       , hiPurchases = ThisYear.hiPurchases + ISNULL(LastYear.PurchaseAmount, 0)

  FROM   [!ActiveSchema!].HISTORY ThisYear (READUNCOMMITTED)
  JOIN   #NominalHistory SPH ON ThisYear.hiExCLass  = SPH.HistoryClassificationId
                            AND ThisYear.hiCurrency = SPH.CurrencyId
                            AND ThisYear.hiCode     = SPH.HistoryCode
                            AND (((ThisYear.hiYear + 1900) * 1000) + ThisYear.hiPeriod) = SPH.TransactionPeriodKey
  LEFT JOIN   [!ActiveSchema!].evw_History LastYear (READUNCOMMITTED) ON ThisYear.hiExCLass  = LastYear.HistoryClassificationId
                                          AND ThisYear.hiCurrency = LastYear.CurrencyId
                                          AND ThisYear.hiCode     = LastYear.HistoryCode
                                          AND ThisYear.hiYear - 1 = LastYear.ExchequerYear
                                          AND ThisYear.hiPeriod   = LastYear.ExchequerPeriod

  WHERE SPH.HistoryPositionId IS NULL 
  AND (SPH.TransactionPeriodKey%1000) = @c_CTDPeriod

  -- Ensure that YTD Rows add up to sum of child periods

  UPDATE NH
     SET SalesAmount    = ROUND(CTDValues.SalesAmount, 2)
       , PurchaseAmount = ROUND(CTDValues.PurchaseAmount, 2)
  FROM [!ActiveSchema!].evw_NominalHistory NH
  CROSS APPLY ( SELECT SalesAmount    = SUM(CSH.SalesAmount)
                     , PurchaseAmount = SUM(CSH.PurchaseAmount)
                FROM [!ActiveSchema!].evw_NominalHistory CSH (READUNCOMMITTED)
                WHERE NH.HistoryClassificationId = CSH.HistoryClassificationId
                AND   NH.HistoryCode             = CSH.HistoryCode
                AND   NH.CurrencyId              = CSH.CurrencyId
                AND   NH.HistoryYear             = CSH.HistoryYear
                AND   ISNULL(NH.CostCentreDepartmentFlag, '') = ISNULL(CSH.CostCentreDepartmentFlag, '')
                AND   ISNULL(NH.CostCentreCode, '')           = ISNULL(CSH.CostCentreCode, '')
                AND   ISNULL(NH.DepartmentCode, '')           = ISNULL(CSH.DepartmentCode, '')
                AND   CSH.HistoryPeriod         < 250
              ) CTDValues
  WHERE NH.HistoryPeriod = @c_YTDPeriod
  AND ( ROUND(NH.SalesAmount, 2)    <> ROUND(CTDValues.SalesAmount, 2)
   OR   ROUND(NH.PurchaseAmount, 2) <> ROUND(CTDValues.PurchaseAmount, 2)
      )
  AND EXISTS (SELECT TOP 1 1
              FROM   #NominalHistory TNH
              WHERE  NH.HistoryClassificationId = TNH.HistoryClassificationId
              AND    NH.HistoryCode             = TNH.HistoryCode
              AND    NH.CurrencyId              = TNH.CurrencyId
              AND    NH.HistoryPeriodKey        = TNH.TransactionPeriodKey
             )

  -- Ensure that CTD Rows add up to sum of child periods for non-P&L

  UPDATE NH
     SET SalesAmount    = ROUND(CTDValues.SalesAmount, 2)
       , PurchaseAmount = ROUND(CTDValues.PurchaseAmount, 2)
  FROM [!ActiveSchema!].evw_NominalHistory NH
  CROSS APPLY ( SELECT SalesAmount    = SUM(CSH.SalesAmount)
                     , PurchaseAmount = SUM(CSH.PurchaseAmount)
                FROM [!ActiveSchema!].evw_NominalHistory CSH (READUNCOMMITTED)
                WHERE NH.HistoryClassificationId = CSH.HistoryClassificationId
                AND   NH.HistoryCode             = CSH.HistoryCode
                AND   NH.CurrencyId              = CSH.CurrencyId
                AND   NH.HistoryYear            >= CSH.HistoryYear
                AND   ISNULL(NH.CostCentreDepartmentFlag, '') = ISNULL(CSH.CostCentreDepartmentFlag, '')
                AND   ISNULL(NH.CostCentreCode, '')           = ISNULL(CSH.CostCentreCode, '')
                AND   ISNULL(NH.DepartmentCode, '')           = ISNULL(CSH.DepartmentCode, '')
                AND   CSH.HistoryPeriod         < 250
              ) CTDValues
  CROSS APPLY ( SELECT IsPandL = CONVERT(BIT, CASE
                                              WHEN NHIER.NominalHierarchy LIKE @PLHierarchy THEN 1
                                              ELSE 0
                                              END
                                        )
                FROM [!ActiveSchema!].evw_NominalHierarchy NHIER
                WHERE NHIER.NominalCode = NH.NominalCode
              ) IsPL

  WHERE IsPL.IsPandL     = @c_False
  AND   NH.HistoryPeriod = @c_CTDPeriod
  AND ( ROUND(NH.SalesAmount, 2)    <> ROUND(CTDValues.SalesAmount, 2)
   OR   ROUND(NH.PurchaseAmount, 2) <> ROUND(CTDValues.PurchaseAmount, 2)
      )
  AND EXISTS (SELECT TOP 1 1
              FROM   #NominalHistory TNH
              WHERE  NH.HistoryClassificationId = TNH.HistoryClassificationId
              AND    NH.HistoryCode             = TNH.HistoryCode
              AND    NH.CurrencyId              = TNH.CurrencyId
              --AND    NH.HistoryPeriodKey        = TNH.TransactionPeriodKey -- Commented out ABSEXCH-18665
             )

  -- Recalculate Profit BF Balances

  EXEC [!ActiveSchema!].esp_RecalculateProfitBF @iv_IsCommitment = @c_False


/*
  INSERT INTO [common].etb_AuditLog
            ( TableName
            , AuditText
            , AuditDate
            )
  VALUES    ( '!ActiveSchema!.esp_PostCCDeptNominalBalances'
            , '<LOG><AUDIT_TYPE>LOGEND</AUDIT_TYPE></LOG>'
            , GETDATE()
            )
*/

END

GO

