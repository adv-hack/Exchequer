IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_RecalculateCCDeptNominalBalances]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].[esp_RecalculateCCDeptNominalBalances]
GO

--
-- Recalculate CC & Dept. Nominal Balances
--
-- To reset an Individual Period pass in the Period (YYYYMMM) otherwise resets all Periods that require resetting.
--
-- Usage: EXEC !ActiveSchema!.esp_RecalculateCCDeptNominalBalances 0
--    or: EXEC !ActiveSchema!.esp_RecalculateCCDeptNominalBalances 0, 2010007
--    or: EXEC !ActiveSchema!.esp_RecalculateCCDeptNominalBalances 0, 2010007, 22010


CREATE PROCEDURE [!ActiveSchema!].[esp_RecalculateCCDeptNominalBalances] ( @iv_Mode        INT = 1
                                                         , @iv_Period      INT = NULL
                                                         , @iv_NominalCode INT = NULL
                                                         )
AS
BEGIN
  SET NOCOUNT ON;
  
-- For Debug Purposes 
-- DECLARE @iv_Period      INT = 2010007
--       , @iv_Mode        INT = 1
--       , @iv_NominalCode INT

-- Modes: 0 - Fix Data
--        1 - Report Data
--        2 - Debug

  DECLARE @c_Fix                INT = 0
        , @c_Report             INT = 1
        , @c_Debug              INT = 2
        , @UseCCDept            BIT
        , @UseSeparateDiscounts BIT
        , @PostToCCDept         BIT
        , @DiscGivenControl     INT
        , @DiscTakenControl     INT
        , @AuditYear            INT

  -- Determine if COMPANY use CC and Departments and Separate Discounts

  SELECT @UseCCDept            = UseCostCentreAndDepartments
       , @UseSeparateDiscounts = UseSeparateDiscounts
       , @PostToCCDept         = PostToCostCentreAndDepartment
       , @DiscGivenControl     = LineDiscountGivenControlNominalCode
       , @DiscTakenControl     = LineDiscountTakenControlNominalCode
       , @AuditYear            = AuditYear
  FROM   !ActiveSchema!.evw_SystemSettings

  IF OBJECT_ID('tempdb..#NominalTransactions') IS NOT NULL
     DROP TABLE #NominalTransactions

  CREATE TABLE #NominalTransactions
             ( PositionId               INT
             , OurReference             VARCHAR(10)
             , TransactionTypeCode      VARCHAR(10)
             , IsSalesTransaction       BIT NULL
             , IsPurchaseTransaction    BIT NULL
             , NominalCode              INT
             , TransactionPeriodKey     INT
             , CurrencyId               INT
             , CostCentreCode           VARCHAR(3) NULL
             , DepartmentCode           VARCHAR(3) NULL

             , PurchaseAmount           FLOAT DEFAULT 0.0
             , SalesAmount              FLOAT DEFAULT 0.0
             , DiscountAmount           FLOAT DEFAULT 0.0
           
             , PurchaseAmountInBase     FLOAT DEFAULT 0.0
             , SalesAmountInBase        FLOAT DEFAULT 0.0
             , DiscountAmountInBase     FLOAT DEFAULT 0.0

             )

  -- Load Qualifying data into temporary table

  INSERT INTO #NominalTransactions
        SELECT PositionId            = TL.LinePositionId
             , OurReference          = TL.OurReference
             , TransactionTypeCode   = TL.TransactionTypeCode
             , IsSalesTransaction    = TL.IsSalesTransaction
             , IsPurchaseTransaction = TL.IsPurchaseTransaction
             , NominalCode           = TL.NominalCode
             , TransactionPeriodKey  = TL.TransactionPeriodKey
             , CurrencyId            = TL.CurrencyId
             , CostCentreCode        = NULLIF(TL.CostCentreCode, '')
             , DepartmentCode        = NULLIF(TL.DepartmentCode, '')
/*
             , PurchaseAmount        = CASE
                                       WHEN TL.PaymentCode = 'N' AND Results.LineTotal * -1 > 0 THEN ABS(Results.LineTotal)
                                       WHEN TL.PaymentCode <> 'N' AND Results.LineTotal  > 0 THEN ABS(Results.LineTotal)
                                       ELSE 0
                                       END
             , SalesAmount           = CASE
                                       WHEN TL.PaymentCode = 'N' AND Results.LineTotal * -1 < 0 THEN ABS(Results.LineTotal)
                                       WHEN TL.PaymentCode <> 'N' AND Results.LineTotal < 0 THEN ABS(Results.LineTotal)
                                       ELSE 0
                                       END
*/
             , PurchaseAmount        = CASE
                                       WHEN Results.LineTotal > 0 THEN ABS(Results.LineTotal)
                                       ELSE 0
                                       END
             , SalesAmount           = CASE
                                       WHEN Results.LineTotal < 0 THEN ABS(Results.LineTotal)
                                       ELSE 0
                                       END
             , DiscountAmount        = Results.LineDiscount
/*
             , PurchaseAmountInBase  = CASE
                                       WHEN TL.PaymentCode = 'N' AND Results.LineTotalInBase * -1> 0 THEN ABS(Results.LineTotalInBase)
                                       WHEN TL.PaymentCode <> 'N' AND Results.LineTotalInBase > 0 THEN ABS(Results.LineTotalInBase)
                                       ELSE 0
                                       END
             , SalesAmountInBase     = CASE
                                       WHEN TL.PaymentCode = 'N' AND Results.LineTotalInBase * -1 < 0 THEN ABS(Results.LineTotalInBase)
                                       WHEN TL.PaymentCode <> 'N' AND Results.LineTotalInBase < 0 THEN ABS(Results.LineTotalInBase)
                                       ELSE 0
                                       END
*/
             , PurchaseAmountInBase  = CASE
                                       WHEN Results.LineTotalInBase > 0 THEN ABS(Results.LineTotalInBase)
                                       ELSE 0
                                       END
             , SalesAmountInBase     = CASE
                                       WHEN Results.LineTotalInBase < 0 THEN ABS(Results.LineTotalInBase)
                                       ELSE 0
                                       END
             , DiscountAmountInBase  = LineDiscountInBase
 
        FROM     !ActiveSchema!.evw_TransactionLine TL
        CROSS APPLY ( VALUES ( (CASE
                                WHEN @UseSeparateDiscounts = 1 THEN TL.LineNetValue 
                                ELSE TL.LineCalculatedNetValue
                                END * CASE
                                      WHEN TL.PaymentCode = 'N' THEN -1
                                      ELSE 1
                                      END
                               )
                             , (CASE
                                WHEN @UseSeparateDiscounts = 1 THEN TL.LineNetValueInBase
                                ELSE TL.LineCalculatedNetValueInBase
                                END * CASE
                                      WHEN TL.PaymentCode = 'N' THEN -1
                                      ELSE 1
                                      END
                               )
                             , (CASE
                                WHEN @UseSeparateDiscounts = 1 THEN TL.LineDiscount
                                ELSE 0
                                END
                               )
                             )
                     ) Results ( LineTotal
                               , LineTotalInBase
                               , LineDiscount
                               )
        WHERE TL.RunNo > 0
        AND  ( TL.TransactionYear > @AuditYear OR @AuditYear = 0)
    
        AND    ( TL.TransactionPeriodKey = @iv_Period      OR @iv_Period      IS NULL)
        AND    ( TL.NominalCode          = @iv_NominalCode OR @iv_NominalCode IS NULL)
        AND  ( ( TL.TransactionTypeCode   = 'RUN' AND TL.CurrencyId <> 0 )
              OR TL.TransactionTypeCode  <> 'RUN'
             )
        AND  (TL.CostCentreCode <> '' OR TL.DepartmentCode <> '')

  IF @iv_Mode = @c_Debug
  BEGIN
    SELECT 'After Initial Select'
         , *
    FROM   #NominalTransactions
  END

  IF OBJECT_ID('tempdb..#NominalTransSummary') IS NOT NULL
     DROP TABLE #NominalTransSummary

  CREATE TABLE #NominalTransSummary
             ( NominalCode              INT
             , NominalType              VARCHAR(1)
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
  LEFT JOIN !ActiveSchema!.evw_Nominal N ON NT.NominalCode = N.NominalCode
  
  GROUP BY NT.NominalCode
         , NT.TransactionPeriodKey
         , NT.CurrencyId
         , NT.CostCentreCode
         , NT.DepartmentCode


  IF @iv_Mode = @c_Debug
  BEGIN
    SELECT 'After Initial Summarisation'
         , *
    FROM   #NominalTransSummary
  END

  -- Add the Discount Line in if using Separate Discounts

  IF @UseSeparateDiscounts = 1
  BEGIN
    INSERT INTO #NominalTransSummary
              ( NominalCode
              , NominalType
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
    SELECT NominalCode = CASE
                         WHEN NT.TransactionTypeCode   = 'RUN' THEN NT.NominalCode
                         WHEN NT.IsSalesTransaction    = 1     THEN @DiscGivenControl
                         WHEN NT.IsPurchaseTransaction = 1     THEN @DiscTakenControl
                         END
         , NominalType          = MAX(N.NominalTypeCode)
         , NT.TransactionPeriodKey
         , NT.CurrencyId
         , CostCentreCode       = NT.CostCentreCode
         , DepartmentCode       = NT.DepartmentCode
       
         , PurchaseAmount = SUM(common.efn_ExchequerRoundUp(
                                CASE
                                WHEN NT.DiscountAmount > 0 THEN ABS(NT.DiscountAmount)
                                ELSE 0
                                END, 2))
         , SalesAmount    = SUM(common.efn_ExchequerRoundUp(
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
    JOIN   !ActiveSchema!.evw_Nominal N ON N.NominalCode = CASE
                                                   WHEN NT.TransactionTypeCode   = 'RUN' THEN NT.NominalCode
                                                   WHEN NT.IsSalesTransaction    = 1     THEN @DiscGivenControl
                                                   WHEN NT.IsPurchaseTransaction = 1     THEN @DiscTakenControl
                                                   END
    
    WHERE  NT.DiscountAmount <> 0.0
  
    GROUP BY CASE
             WHEN NT.TransactionTypeCode   = 'RUN' THEN NT.NominalCode
             WHEN NT.IsSalesTransaction    = 1     THEN @DiscGivenControl
             WHEN NT.IsPurchaseTransaction = 1     THEN @DiscTakenControl
             END
           , NT.TransactionPeriodKey
           , NT.CurrencyId
           , NT.CostCentreCode
           , NT.DepartmentCode

  END

  IF @iv_Mode = @c_Debug
  BEGIN
    SELECT 'After Separate Discounts added'
         , *
    FROM   #NominalTransSummary
  END

  -- Now Insert Base Currency equivalent Records for non-base records

  INSERT INTO #NominalTransSummary
            ( NominalCode
            , NominalType
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
       , TransactionPeriodKey
       , CurrencyId = 0
       , CostCentreCode
       , DepartmentCode
       , PurchaseAmount       = PurchaseAmountInBase
       , SalesAmount          = SalesAmountInBase
       , PurchaseAmountInBase = PurchaseAmountInBase
       , SalesAmountInBase    = SalesAmountInBase
       , TransLineCount       = TransLineCount
  FROM   #NominalTransSummary
  WHERE  CurrencyId <> 0

  IF @iv_Mode = @c_Debug
  BEGIN
    SELECT 'After addition of Base Transactions'
         , *
    FROM   #NominalTransSummary
  END

  IF OBJECT_ID('tempdb..#NominalHistory') IS NOT NULL
     DROP TABLE #NominalHistory

  CREATE TABLE #NominalHistory
             ( NominalCode              INT
             , NominalType              VARCHAR(1)
             , TransactionPeriodKey     INT
             , CurrencyId               INT
             , CostCentreDepartmentFlag VARCHAR(1) NULL
             , CostCentreCode           VARCHAR(3) NULL
             , DepartmentCode           VARCHAR(3) NULL

             , SalesAmount              FLOAT DEFAULT 0.0
             , PurchaseAmount           FLOAT DEFAULT 0.0

             , TransLineCount           INT   DEFAULT 0
             )

  -- Insert NominalHistory Records

  -- CC = NULL, DEP = NULL
  /*
  INSERT INTO #NominalHistory
            ( NominalCode
            , NominalType
            , TransactionPeriodKey
            , CurrencyId
            , SalesAmount
            , PurchaseAmount
            )
  SELECT NominalCode
       , MAX(NominalType)
       , TransactionPeriodKey
       , CurrencyId
       , SUM(SalesAmount)
       , SUM(PurchaseAmount)
  FROM   #NominalTransSummary
  GROUP BY NominalCode
         , TransactionPeriodKey
         , CurrencyId
  */

  IF @UseCCDept = 1
  BEGIN
    -- CC, DEP = NULL

    INSERT INTO #NominalHistory
              ( NominalCode
              , NominalType
              , TransactionPeriodKey
              , CurrencyId
              , CostCentreDepartmentFlag
              , CostCentreCode
              , SalesAmount
              , PurchaseAmount
              
              , TransLineCount
              )
    SELECT NominalCode
         , MAX(NominalType)
         , TransactionPeriodKey
         , CurrencyId
         , 'C'
         , CostCentreCode
         , SUM(SalesAmount)
         , SUM(PurchaseAmount)
         , SUM(TransLineCount)
    FROM   #NominalTransSummary
    WHERE CostCentreCode IS NOT NULL
    GROUP BY NominalCode
           , TransactionPeriodKey
           , CurrencyId
           , CostCentreCode

    -- CC = NULL, DP

    INSERT INTO #NominalHistory
              ( NominalCode
              , NominalType
              , TransactionPeriodKey
              , CurrencyId
              , CostCentreDepartmentFlag
              , DepartmentCode
              , SalesAmount
              , PurchaseAmount
              , TransLineCount
              )
    SELECT NominalCode
         , MAX(NominalType)
         , TransactionPeriodKey
         , CurrencyId
         , 'D'
         , DepartmentCode
         , SUM(SalesAmount)
         , SUM(PurchaseAmount)
         , SUM(TransLineCount)
    FROM   #NominalTransSummary
    WHERE DepartmentCode IS NOT NULL
    GROUP BY NominalCode
           , TransactionPeriodKey
           , CurrencyId
           , DepartmentCode

    IF @PostToCCDept = 1
    BEGIN
      -- CC, DEP
      INSERT INTO #NominalHistory
                ( NominalCode
                , NominalType
                , TransactionPeriodKey
                , CurrencyId
                , CostCentreDepartmentFlag
                , CostCentreCode
                , DepartmentCode
                , SalesAmount
                , PurchaseAmount
                , TransLineCount
                )
      SELECT NominalCode
           , MAX(NominalType)
           , TransactionPeriodKey
           , CurrencyId
           , 'C'
           , CostCentreCode
           , DepartmentCode
           , SUM(SalesAmount)
           , SUM(PurchaseAmount)
           , SUM(TransLineCount)
      FROM   #NominalTransSummary
      WHERE CostCentreCode IS NOT NULL
      GROUP BY NominalCode
             , TransactionPeriodKey
             , CurrencyId
             , CostCentreCode
             , DepartmentCode

      INSERT INTO #NominalHistory
                ( NominalCode
                , NominalType
                , TransactionPeriodKey
                , CurrencyId
                , CostCentreDepartmentFlag
                , CostCentreCode
                , DepartmentCode
                , SalesAmount
                , PurchaseAmount
                , TransLineCount
                )
      SELECT NominalCode
           , MAX(NominalType)
           , TransactionPeriodKey
           , CurrencyId
           , 'D'
           , CostCentreCode
           , DepartmentCode
           , SUM(SalesAmount)
           , SUM(PurchaseAmount)
           , SUM(TransLineCount)
      FROM   #NominalTransSummary
      WHERE  DepartmentCode IS NOT NULL
      GROUP BY NominalCode
             , TransactionPeriodKey
             , CurrencyId
             , CostCentreCode
             , DepartmentCode

      END
  END
 

  IF @iv_Mode = @c_Debug
  BEGIN
    SELECT 'After History Summarisation'
         , *
    FROM   #NominalHistory
  END

  -- Insert the Nominal Headers -- only do this where parameter @iv_NominalCode is NULL

  IF @iv_NominalCode IS NULL
  BEGIN
    INSERT INTO #NominalHistory
              ( NominalCode
              , NominalType
              , TransactionPeriodKey
              , CurrencyId
              , CostCentreDepartmentFlag
              , CostCentreCode
              , DepartmentCode
              , SalesAmount
              , PurchaseAmount
              , TransLineCount
              )
    SELECT NominalCode = NA.AscendantNominalCode
         , NominalType = 'H'
         , TransactionPeriodKey
         , NH.CurrencyId
         , NH.CostCentreDepartmentFlag
         , NH.CostCentreCode
         , NH.DepartmentCode
         , SUM(SalesAmount)
         , SUM(PurchaseAmount)
         , SUM(TransLineCount)
    FROM   #NominalHistory NH
    JOIN   !ActiveSchema!.evw_NominalAscendant NA ON NH.NominalCode = NA.NominalCode
    WHERE  NA.NominalCode <> NA.AscendantNominalCode

    GROUP BY NA.AscendantNominalCode
           , NH.TransactionPeriodKey
           , NH.CurrencyId
           , NH.CostCentreDepartmentFlag
           , NH.CostCentreCode
           , NH.DepartmentCode


    IF @iv_Mode = @c_Debug
    BEGIN
      SELECT 'After Nominal Rollup'
          , *
      FROM   #NominalHistory
    END
  END

  -- Insert Rows that exist in Nominal History but do NOT exist in temp. table. - these rows need to be reset to 0 (Zero)

  INSERT INTO #NominalHistory
              ( NominalCode
              , NominalType
              , TransactionPeriodKey
              , CurrencyId
              , CostCentreDepartmentFlag
              , CostCentreCode
              , DepartmentCode
              , SalesAmount
              , PurchaseAmount
              , TransLineCount
              )
    SELECT NH.NominalCode
         , NominalType = NH.HistoryClassificationCode
         , NH.HistoryPeriodKey
         , NH.CurrencyId
         , NH.CostCentreDepartmentFlag
         , NH.CostCentreCode
         , NH.DepartmentCode
         , NewSalesAmount    = 0
         , NewPurchaseAmount = 0
         , TransLineCount    = 0

    FROM !ActiveSchema!.evw_NominalHistory NH
    WHERE (NH.HistoryPeriodKey = @iv_Period      OR @iv_Period        IS NULL)
    AND   (NH.NominalCode      = @iv_NominalCode OR @iv_NominalCode   IS NULL)
    AND   (NH.SalesAmount     <> 0               OR NH.PurchaseAmount <> 0)
    AND   (NH.HistoryYear      > @AuditYear      OR @AuditYear         = 0)
    AND    NH.HistoryPeriod    < 250
    AND   (NH.CostCentreCode  <> ''              OR NH.DepartmentCode <> '')

    AND NOT EXISTS (SELECT TOP 1 1
                    FROM #NominalHistory TNH
                    WHERE TNH.NominalCode                          = NH.NominalCode
                      AND TNH.NominalType                          = NH.HistoryClassificationCode  COLLATE Latin1_General_CI_AS
                      AND TNH.TransactionPeriodKey                 = NH.HistoryPeriodKey
                      AND TNH.CurrencyId                           = NH.CurrencyId
                      AND TNH.CostCentreDepartmentFlag             = NH.CostCentreDepartmentFlag   COLLATE Latin1_General_CI_AS
                      AND ISNULL(TNH.CostCentreCode, '')           = ISNULL(NH.CostCentreCode, '') COLLATE Latin1_General_CI_AS
                      AND ISNULL(TNH.DepartmentCode, '')           = ISNULL(NH.DepartmentCode, '') COLLATE Latin1_General_CI_AS
                   )

  -- Return Problem Rows
  IF @iv_Mode IN (@c_Debug, @c_Report)
  BEGIN
    SELECT TNH.NominalCode
         , TNH.NominalType
         , TNH.TransactionPeriodKey
         , TNH.CurrencyId
         , TNH.CostCentreDepartmentFlag
         , TNH.CostCentreCode
         , TNH.DepartmentCode
         , OldSalesAmount    = NH.SalesAmount
         , NewSalesAmount    = TNH.SalesAmount
         , OldPurchaseAmount = NH.PurchaseAmount
         , NewPurchaseAmount = TNH.PurchaseAmount
         , NH.HistoryPositionId
         , SalesDiff    = ROUND(ISNULL(TNH.SalesAmount, 0)    - ISNULL(NH.SalesAmount, 0), 2)
         , PurchaseDiff = ROUND(ISNULL(TNH.PurchaseAmount, 0) - ISNULL(NH.PurchaseAmount, 0), 2)
         , TransLineCount

    FROM #NominalHistory TNH
    LEFT JOIN !ActiveSchema!.evw_NominalHistory NH ON TNH.NominalCode                          = NH.NominalCode
                                          AND TNH.NominalType                          = NH.HistoryClassificationCode   COLLATE Latin1_General_CI_AS
                                          AND TNH.TransactionPeriodKey                 = NH.HistoryPeriodKey
                                          AND TNH.CurrencyId                           = NH.CurrencyId
                                          AND TNH.CostCentreDepartmentFlag             = NH.CostCentreDepartmentFlag    COLLATE Latin1_General_CI_AS
                                          AND ISNULL(TNH.CostCentreCode, '')           = ISNULL(NH.CostCentreCode, '')  COLLATE Latin1_General_CI_AS
                                          AND ISNULL(TNH.DepartmentCode, '')           = ISNULL(NH.DepartmentCode, '')  COLLATE Latin1_General_CI_AS

    WHERE 1 = 1 
    AND ( ROUND(ABS(ISNULL(TNH.SalesAmount, 0)    - ISNULL(NH.SalesAmount, 0)), 2)    > 0.005
    OR    ROUND(ABS(ISNULL(TNH.PurchaseAmount, 0) - ISNULL(NH.PurchaseAmount, 0)), 2) > 0.005
        )

    ORDER BY CONVERT(VARCHAR(10), TNH.NominalCode)
           , TNH.TransactionPeriodKey
           , TNH.CurrencyId
           , TNH.CostCentreCode
           , TNH.DepartmentCode
  END
  
  --Update Problem Rows
  
  IF @iv_Mode = @c_Fix
  BEGIN

    MERGE !ActiveSchema!.HISTORY H
    USING
    ( SELECT NHC.NewHistoryCode
           , TNH.NominalType
           , TNH.CurrencyId
           , P.ExchequerYear
           , P.PeriodNo
           , TNH.SalesAmount
           , TNH.PurchaseAmount
           , NH.HistoryPositionId
      FROM #NominalHistory TNH
      LEFT JOIN !ActiveSchema!.evw_NominalHistory NH ON TNH.NominalCode                          = NH.NominalCode
                                            AND TNH.NominalType                          = NH.HistoryClassificationCode            COLLATE Latin1_General_CI_AS
                                            AND TNH.TransactionPeriodKey                 = NH.HistoryPeriodKey
                                            AND TNH.CurrencyId                           = NH.CurrencyId
                                            AND TNH.CostCentreDepartmentFlag             = NH.CostCentreDepartmentFlag             COLLATE Latin1_General_CI_AS
                                            AND ISNULL(TNH.CostCentreCode, '')           = ISNULL(NH.CostCentreCode, '')           COLLATE Latin1_General_CI_AS
                                            AND ISNULL(TNH.DepartmentCode, '')           = ISNULL(NH.DepartmentCode, '')           COLLATE Latin1_General_CI_AS

      LEFT JOIN !ActiveSchema!.evw_Period P ON TNH.TransactionPeriodKey = P.PeriodKey
      CROSS APPLY ( VALUES ( (CONVERT(VARCHAR, CONVERT(VARBINARY(21), TNH.NominalCode), 2))
                     )
                  ) NC (BinCode)
      CROSS APPLY ( VALUES ( ( CONVERT(VARBINARY(21),
                               0x14 + CONVERT(VARBINARY(max), ISNULL(TNH.CostCentreDepartmentFlag, ''))
                             + CONVERT(VARBINARY(max), SUBSTRING(BinCode, 7, 2), 2)
                             + CONVERT(VARBINARY(max), SUBSTRING(BinCode, 5, 2), 2)
                             + CONVERT(VARBINARY(max), SUBSTRING(BinCode, 3, 2), 2)
                             + CONVERT(VARBINARY(max), SUBSTRING(BinCode, 1, 2), 2)
                             + CASE
                               WHEN TNH.CostCentreDepartmentFlag = 'C' THEN CONVERT(VARBINARY(max), CONVERT(CHAR(3), ISNULL(TNH.CostCentreCode, '')))
                               WHEN TNH.CostCentreDepartmentFlag = 'D' THEN CONVERT(VARBINARY(max), CONVERT(CHAR(3), ISNULL(TNH.DepartmentCode, '')))
                               ELSE CONVERT(VARBINARY(max), '')
                               END
                             + CASE
                               WHEN TNH.CostCentreDepartmentFlag = 'C' AND TNH.DepartmentCode IS NOT NULL THEN 0x02 + CONVERT(VARBINARY(max), CONVERT(CHAR(3), ISNULL(TNH.DepartmentCode, '')))
                               WHEN TNH.CostCentreDepartmentFlag = 'D' AND TNH.CostCentreCode IS NOT NULL THEN 0x01 + CONVERT(VARBINARY(max), CONVERT(CHAR(3), ISNULL(TNH.CostCentreCode, '')))
                               ELSE CONVERT(VARBINARY(max), '')
                               END
                             + CONVERT(VARBINARY(max), SPACE(21))
                               )
                             )
                           )
                  ) NHC (NewHistoryCode)
      WHERE 1 = 1 
      AND ( ROUND(ABS(ISNULL(TNH.SalesAmount, 0)    - ISNULL(NH.SalesAmount, 0)), 2)    > 0.005
      OR    ROUND(ABS(ISNULL(TNH.PurchaseAmount, 0) - ISNULL(NH.PurchaseAmount, 0)), 2) > 0.005
          )
    ) HData ON HData.HistoryPositionId = H.PositionId
    WHEN MATCHED THEN
         UPDATE
            SET hiSales     = HData.SalesAmount
              , hiPurchases = HData.PurchaseAmount
    WHEN NOT MATCHED BY TARGET THEN
         INSERT ( hiCode
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
         VALUES ( NewHistoryCode
                , ASCII(NominalType)
                , CurrencyId
                , ExchequerYear
                , PeriodNo
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
                )
         ;
  END

  -- Now recalculate YTD (254) and CTD (255)

  IF @iv_Mode = @c_Fix
  BEGIN

    EXEC !ActiveSchema!.esp_RecalculateYTDNominalHistory

    EXEC !ActiveSchema!.esp_RecalculateCTDNominalHistory
  END

END

GO

