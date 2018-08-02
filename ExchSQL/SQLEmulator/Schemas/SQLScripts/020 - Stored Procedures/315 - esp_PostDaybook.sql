
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_PostDaybook]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].esp_PostDaybook
GO

-- Posts a List of transaction types passed in as a comma-delimited list
-- Need to pass in Posting Year/Period as users can set up local year/period that are not saved in database

-- Usage: EXEC [!ActiveSchema!].esp_PostDaybook 'JRN,SBT,SCR,SIN,SJC,SJI,SOR,SRC,SRF,SRI', 1


CREATE PROCEDURE [!ActiveSchema!].esp_PostDaybook ( @iv_PostTransactionTypes VARCHAR(max)
                                        , @iv_PostingYear     INT         = 0
                                        , @iv_PostingPeriod   INT         = 0
                                        , @iv_PostingMode     INT         = 0
                                        , @iv_SeparateControl BIT         = 0
                                        , @iv_LoginName       VARCHAR(20) = ''
                                        )
AS
BEGIN

  SET NOCOUNT ON;
  SET LOCK_TIMEOUT -1;

  -- Declare Constants

  DECLARE @c_Today          VARCHAR(8)
        , @c_MaxDate        VARCHAR(8) = '20491231'
        , @c_True           BIT = 1
        , @c_False          BIT = 0
        , @c_BaseCurrencyId INT = 0
        , @c_YTDPeriod      INT = 254
        , @c_CTDPeriod      INT = 255

  SET @c_Today = CONVERT(VARCHAR(8), GETDATE(), 112)

  DECLARE @ss_CommitmentAccounting BIT = @c_False
        , @ss_HasSPOP              BIT = @c_False

  SELECT @ss_CommitmentAccounting = ISNULL((SELECT @c_True 
                                            FROM common.etb_Information CI
                                            WHERE CI.InformationName = 'Commitment Accounting' 
                                            AND UPPER(CI.InformationValue) IN ('Y','1','TRUE') ), @c_False)
  SELECT @ss_HasSPOP              = ISNULL((SELECT @c_True 
                                            FROM common.etb_Information CI
                                            WHERE CI.InformationName = 'Sales/Purchase Order Processing' 
                                            AND UPPER(CI.InformationValue) IN ('Y','1','TRUE') ), @c_False)

  /* For debug purposes

  DECLARE @iv_PostTransactionTypes VARCHAR(max) = 'JRN,SBT,SCR,SIN,SJC,SJI,SOR,SRC,SRF,SRI' -- Sales
        , @iv_PostingYear          INT          = 111
        , @iv_PostingPeriod        INT          = 4

  */

  SET NOCOUNT ON;
  
  DECLARE @PostingPeriodKey     INT

  IF @iv_PostingYear > 0 AND @iv_PostingPeriod > 0
  BEGIN
    SET @PostingPeriodKey = (((@iv_PostingYear + 1900) * 1000) + @iv_PostingPeriod)
  END
  ELSE
  BEGIN
    SELECT @PostingPeriodKey = PeriodKey
    FROM [!ActiveSchema!].evw_Period
    WHERE IsCurrentPeriod = @c_True
  END
  
  DECLARE @AutoCreate BIT = @c_False

  IF @iv_PostingMode > 10 SET @AutoCreate = @c_True

  -- Load Post Transaction Types into table ignoring Job Posting Run and Quotes at the moment
  
  DECLARE @IncludedTransactionTypes common.edt_Varchar
  
  INSERT INTO @IncludedTransactionTypes
  SELECT ListValue
  FROM   common.efn_TableFromList(@iv_PostTransactionTypes)
  WHERE  ListValue NOT IN ('JRN','SQU','PQU')

  --SELECT *
  --FROM @IncludedTransactionTypes

    -- Fix Transaction Lines where line period/year does not match header period/year
  UPDATE [!ActiveSchema!].DETAILS
	SET  tlPeriod = (SELECT thPeriod FROM [!ActiveSchema!].DOCUMENT WHERE tlfolioNum = thFolioNum)
		,tlYear = (SELECT thYear FROM [!ActiveSchema!].DOCUMENT WHERE tlfolioNum = thFolioNum)
	WHERE (tlPeriod <> (SELECT thPeriod FROM [!ActiveSchema!].DOCUMENT WHERE tlfolioNum = thFolioNum)
	OR tlYear <> (SELECT thYear FROM [!ActiveSchema!].DOCUMENT WHERE tlfolioNum = thFolioNum))
	AND tlRunNo NOT IN (-1, -2, -42, -52, -62) AND tlRunNo <= 0 
			AND tlDocType NOT IN (46, 47, 48, 49, 50, 10, 25)
	AND tlFolioNum <> 0 

  IF OBJECT_ID('tempdb..#ExcludedTransactions') IS NOT NULL
    DROP TABLE #ExcludedTransactions

  CREATE TABLE #ExcludedTransactions
        ( HeaderPositionId      INT 
        , OurReference          VARCHAR(10)
        , ExclusionReason       VARCHAR(max)
        , ReportTrans           BIT
        )

  INSERT INTO #ExcludedTransactions
  EXEC [!ActiveSchema!].esp_PostingExclusion @IncludedTransactionTypes, @PostingPeriodKey

  CREATE INDEX idx_ExcTrans ON #ExcludedTransactions (HeaderPositionId)

  IF OBJECT_ID('tempdb..#IncludedTransactions') IS NOT NULL
    DROP TABLE #IncludedTransactions

  CREATE TABLE #IncludedTransactions
        ( HeaderPositionId      INT         PRIMARY KEY
        , HeaderFolioNumber     INT
        , TransactionTypeCode   VARCHAR(3)
        , OurReference          VARCHAR(10)
        , RunNo                 INT
        )

  INSERT INTO #IncludedTransactions
  SELECT HeaderPositionId        = PositionId
       , HeaderFolioNumber       = thFolioNum
       , TT.TransactionTypeCode
       , OurReference            = TH.thRunNo
       , RunNo                   = TH.thRunNo
  FROM   [!ActiveSchema!].DOCUMENT TH
  CROSS APPLY ( SELECT IsPosted = CONVERT(BIT, CASE
                                               WHEN thRunNo IN (0, -40, -41, -43, -50, -51, -53, -60, -100, -115, -118, -125, -128) THEN 0
                                               ELSE 1
                                               END)
            ) IsP
  JOIN   common.evw_TransactionType TT ON TH.thDocType = TT.TransactionTypeId
  JOIN @IncludedTransactionTypes ITT ON TT.TransactionTypeCode = ITT.VarcharValue
  WHERE IsP.IsPosted = @c_False
  AND   TT.TransactionTypeCode NOT IN ('POR','SOR','PQU','SQU')
  AND   TH.thOurRef <> ''
  AND   TH.thRunNo        <> -43 -- Ignore Telesales Transactions

  AND NOT EXISTS (SELECT TOP 1 1
                  FROM #ExcludedTransactions ET
                  WHERE TH.PositionId = ET.HeaderPositionId)

  --SELECT *
  --FROM #IncludedTransactions

  BEGIN TRY
    BEGIN TRANSACTION
    
      ------------------------------
      -- Create Auto Transactions --
      ------------------------------

      IF EXISTS(SELECT TOP 1 1
                FROM [!ActiveSchema!].evw_AutoTransaction AT
                JOIN @IncludedTransactionTypes ITT ON AT.TransactionTypeCode = ITT.VarcharValue COLLATE Latin1_General_CI_AS
                WHERE AT.OnHold = @c_False
                AND @AutoCreate = @c_True)
      BEGIN

        DECLARE @AutoPositionId INT

        DECLARE curAutoTrans CURSOR LOCAL FAST_FORWARD
            FOR SELECT AT.HeaderPositionId
                FROM [!ActiveSchema!].evw_AutoTransaction AT
                JOIN   @IncludedTransactionTypes ITT ON AT.TransactionTypeCode = ITT.VarcharValue COLLATE Latin1_General_CI_AS
                WHERE  AT.OnHold = @c_False

        OPEN curAutoTrans

        FETCH NEXT FROM curAutoTrans INTO @AutoPositionId

        WHILE @@FETCH_STATUS = 0
        BEGIN

          EXEC [!ActiveSchema!].esp_CreateAutoTransaction @iv_AutoPositionId = @AutoPositionId
                                               , @iv_LoginName    = @iv_LoginName

          FETCH NEXT FROM curAutoTrans INTO @AutoPositionId
        END        

        CLOSE curAutoTrans
        DEALLOCATE curAutoTrans

      END -- Create Auto Trans

      ----------------------------------------
      -- Add any Batch Transactions to list --
      ----------------------------------------

      IF EXISTS(SELECT TOP 1 1
                FROM #IncludedTransactions
                WHERE ( TransactionTypeCode IN ('SBT','PBT') )
               )
      BEGIN
  
        INSERT INTO #IncludedTransactions
        SELECT TH.HeaderPositionId
             , TH.HeaderFolioNumber
             , TH.TransactionTypeCode
             , TH.OurReference
             , TH.RunNo
        FROM [!ActiveSchema!].evw_TransactionHeader TH
        JOIN #IncludedTransactions IT ON TH.BatchDocumentReference = IT.OurReference
        WHERE ( IT.TransactionTypeCode IN ('SBT','PBT') )

        -- Update Batch Transactions
        DECLARE @BatchDocumentReference VARCHAR(10)

        DECLARE curBatchTrans CURSOR  LOCAL FAST_FORWARD
            FOR SELECT IT.OurReference
                FROM #IncludedTransactions IT
                WHERE ( IT.TransactionTypeCode IN ('SBT','PBT') )

        OPEN curBatchTrans

        FETCH NEXT FROM curBatchTrans INTO @BatchDocumentReference 

        WHILE @@FETCH_STATUS = 0
        BEGIN

          EXEC [!ActiveSchema!].esp_UpdateBatchTransaction @iv_BatchDocumentReference = @BatchDocumentReference
                                               , @iv_LoginName    = @iv_LoginName

          FETCH NEXT FROM curBatchTrans INTO @BatchDocumentReference 
        END        

        CLOSE curBatchTrans
        DEALLOCATE curBatchTrans

        -- Remove Batch(s) from Included Documents
    
        DELETE IT
        FROM #IncludedTransactions IT
        WHERE ( IT.TransactionTypeCode IN ('SBT','PBT') )

      END  -- Batch Transactions

      --------------------------------
      -- Post Adjustments - Phase 2 --
      --------------------------------
/*
      IF EXISTS(SELECT TOP 1 1
                FROM   #IncludedTransactions
                WHERE  TransactionTypeCode = 'ADJ')
      BEGIN

        -- Create a Nominal Transaction from ADJ

        -- If NOM in Transaction Type List add them to included transactions if not in excluded List

        -- Remove ADJ's from included Transactions

        -- Set Run No = -30 for ADJ's

      END 
*/
      ----------------------------------
      -- Check for Auto-reverse NOM's --
      ----------------------------------

      IF EXISTS(SELECT TOP 1 1
                FROM   [!ActiveSchema!].DOCUMENT DOC
                JOIN #IncludedTransactions IT ON DOC.PositionId = IT.HeaderPositionId
                WHERE DOC.thUnTagged         = @c_True
                AND   IT.TransactionTypeCode = 'NOM'
               )
      BEGIN

        DECLARE @AutoReversePositionId INT

        DECLARE curAutoReverseTrans CURSOR LOCAL FAST_FORWARD
            FOR SELECT DOC.PositionId
                FROM [!ActiveSchema!].DOCUMENT DOC
                JOIN   #IncludedTransactions IT ON DOC.PositionId = IT.HeaderPositionId
                WHERE DOC.thUnTagged         = @c_True
                AND   IT.TransactionTypeCode = 'NOM'

        OPEN curAutoReverseTrans

        FETCH NEXT FROM curAutoReverseTrans INTO @AutoReversePositionId

        WHILE @@FETCH_STATUS = 0
        BEGIN

          EXEC [!ActiveSchema!].esp_CreateAutoReverseTransaction @iv_AutoReversePositionId = @AutoReversePositionId
                                               , @iv_LoginName    = @iv_LoginName

          FETCH NEXT FROM curAutoReverseTrans INTO @AutoReversePositionId
        END        

        CLOSE curAutoReverseTrans
        DEALLOCATE curAutoReverseTrans

      END -- Create Auto Reverse Trans

      ----------------------------
      -- Create Next Run Number --
      ----------------------------

      IF EXISTS(SELECT TOP 1 1
                FROM #IncludedTransactions)
      OR EXISTS(SELECT TOP 1 1
                FROM #ExcludedTransactions)
      BEGIN

        -- Only need to generate next number if required 

        DECLARE @RunNo INT = 0

        IF @iv_PostingMode <> 4
        BEGIN

          DECLARE @NextRunNo TABLE
                ( RunNo INT )
            
          -- Get the Next Run No. - need to do this here as it is used for all transactions posted in this process.

          UPDATE [!ActiveSchema!].evw_ExchequerNumber
             SET NextCount = NextCount + 1
          OUTPUT deleted.NextCount
            INTO @NextRunNo
           WHERE CountType = 'RUN'

          SELECT @RunNo = RunNo
          FROM @NextRunNo  
        END

      END

      -------------------------------------
      -- Insert Excluded rows into Table --
      -------------------------------------

      IF EXISTS(SELECT TOP 1 1
                FROM #ExcludedTransactions)
      BEGIN

        INSERT INTO [!ActiveSchema!].etb_PostingRunExclusion
                  ( RunNo
                  , OurReference
                  , ExclusionReason
                  , ExchequerLogonId
                  )
        SELECT RunNo            = @RunNo
             , OurReference
             , ExclusionReason
             , ExchequerLogonId = @iv_LoginName
        FROM #ExcludedTransactions
        WHERE ReportTrans = @c_True

      END

      --------------------------------
      -- Post Included Transactions --
      --------------------------------

      IF EXISTS(SELECT TOP 1 1
                FROM #IncludedTransactions)
      BEGIN

        DECLARE @PostTransactions common.edt_Integer

        INSERT INTO @PostTransactions
        SELECT HeaderPositionId
        FROM #IncludedTransactions

        --SELECT * FROM @PostTransactions

        EXEC [!ActiveSchema!].esp_PostTransaction @itvp_PostTransactions  = @PostTransactions
                                      , @iv_RunNo           = @RunNo
                                      , @iv_SeparateControl = @iv_SeparateControl
        -- Update Summary Values

        EXEC [!ActiveSchema!].esp_PostRunSummary @itvp_PostTransactions  = @PostTransactions
                                      ,@iv_RunNo = @RunNo

      END 

      -----------------------------
      -- Post Commitments if any --
      -----------------------------

      IF (@ss_CommitmentAccounting = @c_True
      AND @ss_HasSPOP              = @c_True
      AND EXISTS ( SELECT TOP 1 1
                   FROM @IncludedTransactionTypes ITT
                   WHERE VarcharValue IN ('SOR','POR')
                 )
         )
      BEGIN

        -- Clear down existing Commitment Control DETAILS and HISTORY

        EXEC [!ActiveSchema!].isp_RemovedLastCommit

        -- Create Commitment DETAILS
        DECLARE @CommitmentMode INT = 0 

        SELECT @CommitmentMode = @CommitmentMode + ISNULL((SELECT TOP 1 1
                                                           FROM @IncludedTransactionTypes ITT
                                                           WHERE VarcharValue IN ('POR','PDN','PIN')) , 0)

        SELECT @CommitmentMode = @CommitmentMode + ISNULL((SELECT TOP 1 2
                                                           FROM @IncludedTransactionTypes ITT
                                                           WHERE VarcharValue IN ('SOR')) , 0)

        EXEC [!ActiveSchema!].esp_CreateCommitmentControl @iv_CommitmentMode  = @CommitmentMode
                                                        , @iv_SeparateControl = @iv_SeparateControl

        EXEC [!ActiveSchema!].esp_UpdateTraderCommitments
      END

      ------------------------------
      -- Return the Posting RunNo --
      ------------------------------

      SELECT PostedRunNo = @RunNo

  END TRY
  BEGIN CATCH

    IF @@TRANCOUNT >0
       ROLLBACK TRANSACTION;

    DECLARE @CRLF VARCHAR(2) = CHAR(13) + CHAR(10)

    DECLARE @ErrorNumber    INT           = ERROR_NUMBER()
          , @ErrorSeverity  INT           = ERROR_SEVERITY()  
          , @ErrorState     INT           = ERROR_STATE()  
          , @ErrorProcedure VARCHAR(1000) = ERROR_PROCEDURE()  
          , @ErrorLine      INT           = ERROR_LINE() 
          , @ErrorMessage   VARCHAR(1000) = ERROR_MESSAGE()
        
    SELECT @ErrorMessage = 'Daybook Posting Error: '
                         + @ErrorMessage
                         + CASE
                           WHEN @ErrorProcedure IS NOT NULL THEN @CRLF + SPACE(9) + 'in Procedure: [!ActiveSchema!].' + @ErrorProcedure
                           ELSE ''
                           END
                         + @CRLF
                         + SPACE(14)
                         + 'on Line: ' + CONVERT(VARCHAR, @ErrorLine)
  
    RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState)

  END CATCH

  IF @@TRANCOUNT >0 
     COMMIT TRANSACTION;
  
END

GO

