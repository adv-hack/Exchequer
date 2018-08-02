IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_PostLiveCommitments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].[esp_PostLiveCommitments]
GO

--
-- Post Live Commitments
--

CREATE PROCEDURE [!ActiveSchema!].[esp_PostLiveCommitments] ( @itvp_PostLineTransactions common.edt_Integer READONLY )
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

  DECLARE @ss_UseCCDept     BIT = 0
        , @ss_PostToCCDept  BIT = 0
        , @CCDeptMode       VARCHAR(max)

  -- Set up System Settings
  SELECT @ss_UseCCDept    = SS.UseCostCentreAndDepartments
       , @ss_PostToCCDept = SS.PostToCostCentreAndDepartment
  FROM !ActiveSchema!.evw_SystemSettings SS

  SELECT @CCDeptMode = 'Summary'

  IF @ss_UseCCDept = @c_True
  BEGIN
    SET @CCDeptMode = @CCDeptMode +',CC,DP'
    IF @ss_PostToCCDept = @c_True SET @CCDeptMode = @CCDeptMode + ',CC+DP,DP+CC'
  END

  IF OBJECT_ID('tempdb..#LiveCommitments') IS NOT NULL
    DROP TABLE #LiveCommitments

  SELECT NH.HistoryPositionId
       , HC.HistoryCode
       , TL.NominalCode
       , TL.ExchequerYear
       , P.PostingPeriod
       , HistoryClassificationCode = 'M'
       , CurrencyId                = C.CurrencyCode
       , CCDP.CostCentreDepartmentFlag       
       , CCDP.CostCentreCode
       , CCDP.DepartmentCode
       , PurchaseAmount            = SUM(CASE
                                         WHEN OS.OSValue > 0 THEN ABS(OS.OSValue)
                                         ELSE 0 
                                         END)
       , SalesAmount               = SUM(CASE
                                         WHEN OS.OSValue < 0 THEN ABS(OS.OSValue)
                                         ELSE 0 
                                         END)
  
  INTO #LiveCommitments

  FROM !ActiveSchema!.evw_TransactionLine TL
  JOIN !ActiveSchema!.CURRENCY C ON C.CurrencyCode IN (@c_BaseCurrencyId, TL.CurrencyId)
  CROSS APPLY ( SELECT OSValue = CASE
                                 WHEN C.CurrencyCode = @c_BaseCurrencyId THEN TL.LineCalculatedNetValueoutstandingInBase
                                 ELSE TL.LineCalculatedNetValueOutstanding
                                 END * TransactionTypeSign * -1
              ) OS
  CROSS APPLY( SELECT PostingPeriod = TL.TransactionPeriod
               UNION
               SELECT PostingPeriod = @c_YTDPeriod
             ) P
  CROSS JOIN common.efn_TableFromList(@CCDeptMode) CDM
  CROSS APPLY ( SELECT CostCentreDepartmentFlag  = CASE
                                                   WHEN CDM.ListValue LIKE 'CC%'  THEN 'C'
                                                   WHEN CDM.ListValue LIKE 'DP%'  THEN 'D'
                                                   ELSE NULL
                                                   END
                     , CostCentreCode            = CASE
                                                   WHEN CDM.ListValue LIKE '%CC%' THEN NULLIF(TL.CostCentreCode, '')
                                                   ELSE NULL
                                                   END
                     , DepartmentCode            = CASE
                                                   WHEN CDM.ListValue LIKE '%DP%' THEN NULLIF(TL.DepartmentCode, '')
                                                   ELSE NULL
                                                   END
              ) CCDP
  CROSS APPLY ( SELECT HistoryCode = common.efn_CreateNominalHistoryCode(TL.NominalCode,CCDP.CostCentreDepartmentFlag,CCDP.CostCentreCode,CCDP.DepartmentCode, @c_True)
              ) HC
              
  LEFT JOIN !ActiveSchema!.evw_NominalHistory NH ON NH.HistoryCode               = HC.HistoryCode
                                        AND NH.ExchequerYear             = TL.ExchequerYear
                                        AND NH.HistoryPeriod             = P.PostingPeriod
                                        AND NH.CurrencyId                = C.CurrencyCode
                                        AND NH.HistoryClassificationCode = 'M'
                                        
  WHERE TL.LinePositionId IN (SELECT IntegerValue
                              FROM @itvp_PostLineTransactions)
  AND   TL.NominalCode <> 0
  AND   Tl.TransactionTypeCode IN ('PIN','PCR','PJI','PJC','PRF','PPI','POR','PDN')

  GROUP BY NH.HistoryPositionId
         , HC.HistoryCode
         , TL.NominalCode
         , TL.ExchequerYear
         , P.PostingPeriod
         , C.CurrencyCode
         , CCDP.CostCentreDepartmentFlag       
         , CCDP.CostCentreCode
         , CCDP.DepartmentCode

  -- Update History

  UPDATE H
     SET hiSales     = hiSales     + HData.SalesAmount
       , hiPurchases = hiPurchases + HData.PurchaseAmount
  FROM !ActiveSchema!.HISTORY H
  JOIN #LiveCommitments HData ON HData.HistoryPositionId = H.PositionId

  -- Insert any new History Records

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
  SELECT      HistoryCode
            , HistoryClassificationId = ASCII(LC.HistoryClassificationCode)
            , CurrencyId
            , ExchequerYear
            , PostingPeriod
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
  FROM #Livecommitments LC
  WHERE LC.HistoryPositionId IS NULL

END

GO

