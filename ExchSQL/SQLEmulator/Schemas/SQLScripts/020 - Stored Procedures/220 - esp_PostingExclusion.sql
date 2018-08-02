
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_PostingExclusion]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].esp_PostingExclusion
GO

-- Produces a list of Transactions and the reason they cannot be posted.
--
-- Receives a comma-separated list of Transaction Types that are due to be posted, e.g. ,SIN,PIN,SCR, ....

CREATE PROCEDURE [!ActiveSchema!].esp_PostingExclusion ( @itvp_IncludedTransactionTypes common.edt_Varchar READONLY
                                                       , @iv_PostingPeriodKey INT = 0 )
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

  IF @iv_PostingPeriodKey = 0
  BEGIN
    SELECT @iv_PostingPeriodKey = PeriodKey
    FROM [!ActiveSchema!].evw_Period
    WHERE IsCurrentPeriod = 1
  END

  DECLARE @AuditDate                  VARCHAR(8)
        , @AllowPostToPreviousPeriods BIT
        , @AuditPeriodKey             INT

  SELECT @AuditDate                  = AuditDate
       , @AllowPostToPreviousPeriods = AllowPostToPreviousPeriods
       , @AuditPeriodKey             = AuditPeriodKey
  FROM [!ActiveSchema!].evw_SystemSettings

  DECLARE @IncludedTransactionTypes TABLE
        ( TransactionTypeCode VARCHAR(3)
        , TransactionGroup    VARCHAR(1)
        )
  
  INSERT INTO @IncludedTransactionTypes
  SELECT VarcharValue
       , LEFT(VarcharValue, 1)
  FROM   @itvp_IncludedTransactionTypes

  -- Load Post Transaction Types into table
  
  DECLARE @ExcludedTransactions TABLE
        ( HeaderPositionId INT
        , OurReference     VARCHAR(10)
        , ExclusionReason  VARCHAR(max)
        , ReportTrans      BIT
        )

  -- Load Header Data into temp. table for Performance purposes

  IF OBJECT_ID('tempdb..#ExTransHead') IS NOT NULL
    DROP TABLE #ExTransHead

  SELECT HeaderPositionId     = D.PositionId
       , OurReference         = D.thOurRef
       , HoldStatus           = D.thHoldFlag
       , IsPosted
       , TransactionTypeCode
       , RunNo                = D.thRunNo
       , HeaderFolioNumber    = D.thFolioNum
       , TransactionDate      = D.thTransDate
       , TransactionPeriodKey = ((D.thYear + 1900) * 1000) + D.thPeriod
       , TransactionTotal     = ( thNetValue
                                - thTotalLineDiscount
                                + thTotalVAT
                                )
                                - ( thSettleDiscAmount
                                  * thSettleDiscTaken
                                  )
  INTO #ExTransHead
  FROM  [!ActiveSchema!].DOCUMENT D (READUNCOMMITTED)
  CROSS APPLY ( SELECT IsPosted = CONVERT(BIT, CASE
                                               WHEN thRunNo IN (0, -40, -41, -43, -50, -51, -53, -60, -100, -115, -118, -125, -128) THEN 0
                                               ELSE 1
                                               END)
              ) IsP
  JOIN common.evw_TransactionType TT ON D.thDocType = TT.TransactionTypeId
  JOIN @itvp_IncludedTransactionTypes ITT ON TT.TransactionTypeCode = ITT.VarcharValue
  WHERE IsPosted                    = @c_False
  AND   TT.TransactionTypeCode NOT IN ('POR','SOR','PQU','SQU')
  AND   D.thFolioNum               <> 0
  AND   D.thRunNo                  <> -43

  -- Transaction Posting exclusion rules

  -- Look for Transactions on hold

  INSERT INTO @ExcludedTransactions
  SELECT HeaderPositionId
       , OurReference
       , ExclusionReason = CONVERT(VARCHAR(max), 'Transaction on Hold')
       , ReportTrans     = @c_True
  FROM   #ExTransHead TH
  JOIN   common.evw_HoldStatus HS ON TH.HoldStatus = HS.HoldStatusId
  WHERE  HS.OnHold   = @c_True

  -- Look for Suspended Transactions
  IF EXISTS(SELECT TOP 1 1
            FROM   #ExTransHead TH
            JOIN   common.evw_HoldStatus HS ON TH.HoldStatus = HS.HoldStatusId
            WHERE  HS.IsSuspended = @c_True
           )
  BEGIN

    DECLARE @SuspendedTransactions TABLE
          ( HeaderPositionId INT
          , OurReference     VARCHAR(10)
          , TransactionGroup VARCHAR(1)
          , HoldStatus       INT
          , IsSuspended      BIT
          , ReportTrans      BIT
          , RowNo            INT
          )

    INSERT INTO @SuspendedTransactions
         SELECT HeaderPositionId
              , OurReference
              , TG.TransactionGroup
              , HoldStatus
              , IsSuspended
              , ReportTrans      = @c_True
              , RowNo            = ROW_NUMBER() OVER (ORDER BY RunNo
                                                             , TG.TransactionGroup
                                                             , HeaderFolioNumber
                                                             , HeaderPositionId)
         FROM   #ExTransHead TH
         CROSS APPLY ( SELECT TransactionGroup = LEFT(OurReference, 1)
                     ) TG
         JOIN   common.evw_HoldStatus HS ON TH.HoldStatus = HS.HoldStatusId
         JOIN @IncludedTransactionTypes ITT ON TG.TransactionGroup = ITT.TransactionGroup

    UPDATE ST
       SET IsSuspended = @c_True
         , ReportTrans = @c_False
      FROM @SuspendedTransactions ST
      JOIN (SELECT TransactionGroup
                 , MinRowNo         = MIN(RowNo)
            FROM   @SuspendedTransactions
            WHERE  IsSuspended = @c_True
            GROUP BY TransactionGroup
           ) MRN ON ST.RowNo > MRN.MinRowNo

    DELETE 
    FROM @SuspendedTransactions
    WHERE IsSuspended = @c_False

    INSERT INTO @ExcludedTransactions
    SELECT HeaderPositionId
         , OurReference
         , ExclusionReason = 'Transaction is suspended.  This and all subsequent Transactions are NOT posted.'
         , ReportTrans
    FROM   @SuspendedTransactions
  END

  -- Check for Future Postings

  INSERT INTO @ExcludedTransactions
  SELECT HeaderPositionId
       , OurReference
       , ExclusionReason  = 'Transaction Date (' + CONVERT(VARCHAR(10), TransactionDate) + ') is in future.  Future postings are NOT allowed.'
       , ReportTrans      = @c_True
  FROM   #ExTransHead TH
  WHERE  TransactionDate > CONVERT(VARCHAR(8), GETDATE(), 112)


  INSERT INTO @ExcludedTransactions
  SELECT HeaderPositionId
       , OurReference
       , ExclusionReason  = 'Future Period (' + CONVERT(VARCHAR(10), TransactionPeriodKey) + ') transaction. Posting to future periods is NOT allowed.'
       , ReportTrans      = @c_True
  FROM   #ExTransHead TH
  WHERE  TransactionPeriodKey > @iv_PostingPeriodKey

  INSERT INTO @ExcludedTransactions
  SELECT HeaderPositionId
       , OurReference
       , ExclusionReason  = 'Previous Period (' + CONVERT(VARCHAR(10), TransactionPeriodKey) + ') transaction. Posting to previous periods is NOT allowed.'
       , ReportTrans      = @c_True
  FROM   #ExTransHead TH
  WHERE  TransactionPeriodKey        < @iv_PostingPeriodKey
  AND    @AllowPostToPreviousPeriods = @c_False
  

  INSERT INTO @ExcludedTransactions
  SELECT HeaderPositionId
       , OurReference
       , ExclusionReason  = 'Transaction is in Purged Period (' + CONVERT(VARCHAR(10), TransactionPeriodKey) + '). Posting to purged periods is NOT allowed.'
       , ReportTrans      = @c_True
  FROM   #ExTransHead TH
  WHERE  TransactionPeriodKey < @AuditPeriodKey
 

  INSERT INTO @ExcludedTransactions
  SELECT HeaderPositionId 
       , OurReference
       , ExclusionReason  = 'Transaction Date before Audit Date (' + TransactionDate + '). Posting a transaction dated before the Audit date is NOT allowed.'
       , ReportTrans      = @c_True
  FROM   #ExTransHead TH
  WHERE  TransactionDate <= @AuditDate COLLATE SQL_Latin1_General_CP1_CI_AS
  
  ORDER BY OurReference
  
  -- Check to see if Line Period is the same as Header Period - if not then exclude - ABSEXCH18817

  INSERT INTO @ExcludedTransactions
  SELECT DISTINCT
         TH.HeaderPositionId
       , TH.OurReference
       , ExclusionReason = 'The Header transaction period ('
                         + CONVERT(VARCHAR(10), TH.TransactionPeriodKey) 
                         + ') is different to Line Transaction Period ('
                         + CONVERT(VARCHAR(10), tlTransactionPeriodKey)
                         + '). Transaction cannot be posted.'
       , ReportTrans      = @c_True
  FROM   #ExTransHead TH
  JOIN [!ActiveSchema!].DETAILS TL ON TH.HeaderFolioNumber = TL.tlFolioNum
  CROSS APPLY ( SELECT tlTransactionPeriodKey = ((tlYear + 1900) * 1000) + tlPeriod
              ) TLP
  WHERE TH.TransactionPeriodKey <> tlTransactionPeriodKey

  -- Check to see if SRC & PPY Transactions have lines ... if not then Exclude - ABSEXCH19127

  INSERT INTO @ExcludedTransactions
  SELECT TH.HeaderPositionId
       , TH.OurReference
       , ExclusionReason = 'The Header Transaction ' 
                         + TH.OurReference
                         + ' does NOT have any DETAIL lines.'
       , ReportTrans     = @c_True
  FROM #ExTransHead TH
  WHERE TH.TransactionTypeCode IN ('SRC','PPY')
  AND   NOT EXISTS (SELECT TOP 1 1
                    FROM [!ActiveSchema!].DETAILS TL
                    WHERE TH.HeaderFolioNumber = TL.tlFolioNum
                   )
  AND TH.TransactionTotal <> 0

  SELECT *
  FROM @ExcludedTransactions

END
GO
