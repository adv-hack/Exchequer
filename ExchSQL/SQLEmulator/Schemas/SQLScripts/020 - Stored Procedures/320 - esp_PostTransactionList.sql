
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_PostTransactionList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].esp_PostTransactionList
GO

-- Posts a List of transaction Our references passed in as a comma-delimited list
-- Need to pass in Posting Year/Period as users can set up local year/period that are not saved in database

-- Usage: EXEC [!ActiveSchema!].esp_PostTransactionList 'SIN000885', 2016, 10, 1, 'GJ'


CREATE PROCEDURE [!ActiveSchema!].esp_PostTransactionList ( @iv_PostOurRefs VARCHAR(max)
                                        , @iv_PostingYear     INT         = 0
                                        , @iv_PostingPeriod   INT         = 0
                                        , @iv_SeparateControl BIT         = 0
                                        , @iv_LoginName       VARCHAR(20) = ''
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
  
  DECLARE @PostPositionId     INT

  -- Load Post Transaction References into table
  
  DECLARE @IncludedTransactionRefs common.edt_Varchar
  DECLARE @IncludedTransactionTypes common.edt_Varchar
  
  INSERT INTO @IncludedTransactionRefs
  SELECT ListValue
  FROM   common.efn_TableFromList(@iv_PostOurRefs)

  DECLARE @ExcludedTransactions TABLE
        ( HeaderPositionId      INT 
        , OurReference          VARCHAR(10)
        , ExclusionReason       VARCHAR(max)
        , ReportTrans           BIT
        )

  DECLARE @TTypes VARCHAR(max)

  INSERT INTO @IncludedTransactionTypes
  SELECT DISTINCT LEFT(VarcharValue, 3)
  FROM @IncludedTransactionRefs

  INSERT INTO @ExcludedTransactions
  EXEC [!ActiveSchema!].esp_PostingExclusion @IncludedTransactionTypes, @PostingPeriodKey

  -- Remove from Excluded List those that are not in passed-in transaction list

  DELETE ET
  FROM @ExcludedTransactions ET
  WHERE NOT EXISTS ( SELECT TOP 1 1
                     FROM @IncludedTransactionRefs ITR
                     WHERE ET.OurReference = ITR.VarcharValue
                   )

  DECLARE @IncludedTransactions TABLE
        ( HeaderPositionId      INT         PRIMARY KEY
        , HeaderFolioNumber     INT
        , OurReference          VARCHAR(10)
        , TransactionTypeCode   VARCHAR(3)
        )

  INSERT INTO @IncludedTransactions
  SELECT TH.HeaderPositionId
       , TH.HeaderFolioNumber
       , TH.OurReference
       , TH.TransactionTypeCode
  FROM   [!ActiveSchema!].evw_TransactionHeader TH
  JOIN @IncludedTransactionRefs ITX ON TH.OurReference = ITX.VarcharValue 
  WHERE TH.IsPosted = @c_False
  AND NOT EXISTS (SELECT TOP 1 1
                  FROM @ExcludedTransactions ET
                  WHERE TH.HeaderPositionId = ET.HeaderPositionId)

  BEGIN TRY
    BEGIN TRANSACTION
    
      --------------------------------
      -- Post Included Transactions --
      --------------------------------

      IF EXISTS(SELECT TOP 1 1
                FROM @IncludedTransactions)
      OR EXISTS(SELECT TOP 1 1
                FROM @ExcludedTransactions)
      BEGIN

        DECLARE @RunNo INT

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

        -------------------------------------
        -- Insert Excluded rows into Table --
        -------------------------------------

        IF EXISTS(SELECT TOP 1 1
                  FROM @ExcludedTransactions)
        BEGIN
          INSERT INTO [!ActiveSchema!].etb_PostingRunExclusion
                    ( RunNo
                    , OurReference
                    , ExclusionReason
                    , ExchequerLogonId
                    )
          SELECT RunNo            = @RunNo
               , OurReference
               , Exclusionreason
               , ExchequerLogonId = @iv_LoginName
          FROM @ExcludedTransactions
          --WHERE ReportTrans = @c_True

        END

        ----------------------------------
        -- Check for Auto-reverse NOM's --
        ----------------------------------

        IF EXISTS(SELECT TOP 1 1
                  FROM   [!ActiveSchema!].DOCUMENT DOC
                  JOIN @IncludedTransactions IT ON DOC.PositionId = IT.HeaderPositionId
                  WHERE DOC.thUnTagged         = @c_True
                  AND   IT.TransactionTypeCode = 'NOM'
                 )
        BEGIN

          DECLARE @AutoReversePositionId INT

          DECLARE curAutoReverseTrans CURSOR LOCAL FAST_FORWARD
              FOR SELECT DOC.PositionId
                  FROM [!ActiveSchema!].DOCUMENT DOC
                  JOIN   @IncludedTransactions IT ON DOC.PositionId = IT.HeaderPositionId
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

        IF EXISTS(SELECT TOP 1 1
                  FROM @IncludedTransactions)
        BEGIN
          DECLARE @PostTransactions common.edt_Integer

          INSERT INTO @PostTransactions
          SELECT HeaderPositionId
          FROM @IncludedTransactions

          EXEC [!ActiveSchema!].esp_PostTransaction @itvp_PostTransactions  = @PostTransactions
                                        , @iv_RunNo           = @RunNo
                                        , @iv_SeparateControl = @iv_SeparateControl

          -- Update Summary Values

          EXEC [!ActiveSchema!].esp_PostRunSummary @itvp_PostTransactions = @PostTransactions
                                               , @iv_RunNo = @RunNo

        END

        SELECT PostedRunNo = @RunNo

      END 

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
        
    SELECT @ErrorMessage = 'Transaction List Posting Error: '
                         + @ErrorMessage
                         + CASE
                           WHEN @ErrorProcedure IS NOT NULL THEN @CRLF + SPACE(18) + 'in Procedure: [!ActiveSchema!].' + @ErrorProcedure
                           ELSE ''
                           END
                         + @CRLF
                         + SPACE(23)
                         + 'on Line: ' + CONVERT(VARCHAR, @ErrorLine)
  
    RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState)

  END CATCH

  IF @@TRANCOUNT >0 
     COMMIT TRANSACTION;
  
END

GO

