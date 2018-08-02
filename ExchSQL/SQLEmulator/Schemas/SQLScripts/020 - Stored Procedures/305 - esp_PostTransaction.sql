IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_PostTransaction]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].esp_PostTransaction
GO

CREATE PROCEDURE !ActiveSchema!.esp_PostTransaction ( @itvp_PostTransactions  common.edt_Integer READONLY
                                            , @iv_RunNo           INT
                                            , @iv_SeparateControl BIT
                                            )
AS
BEGIN

/* Debug Purposes

  DECLARE @iv_PostThisPositionId INT = 7135
        , @iv_RunNo              INT = 1005
*/
  
  -- Declare Constants
  DECLARE @c_Today          VARCHAR(8)
        , @c_MaxDate        VARCHAR(8) = '20491231'
        , @c_True           BIT = 1
        , @c_False          BIT = 0
        , @c_BaseCurrencyId INT = 0
        , @c_YTDPeriod      INT = 254
        , @c_CTDPeriod      INT = 255

  -- Set-Up System Settings
  
  DECLARE @ss_DebtorCreditorCtrl INT
        , @ss_VATCtrl            INT
        , @ss_DiscountCtrl       INT
        , @ss_LineDiscountCtrl   INT
        , @ss_VATScheme          VARCHAR(1)
        , @ss_VATNextPeriod      INT
        , @ss_IntrastatEnabled   BIT
        , @ss_CISOn              BIT = @c_False
        , @ss_CISAutoSetPeriod   BIT
        , @ss_CISCurrentDate     VARCHAR(8)
        
        , @IsSalesTransaction    BIT
        , @PostedDate            VARCHAR(8)
        , @VATPostedDate         VARCHAR(8)
        , @OriginalDailyRate     FLOAT
        , @OriginalCompanyRate   FLOAT
        , @HeaderFolioNumber     INT
  
  SET @c_Today = CONVERT(VARCHAR(8), GETDATE(), 112)

  SET @ss_CISOn = ISNULL((SELECT @c_True
                          FROM   common.etb_Information
                          WHERE  InformationName          = 'Job Costing CIS/RCT'
                          AND    UPPER(InformationValue) IN ('Y', 'YES', 'TRUE')
                         ), @c_False)

  -- Get System Settings
  SELECT @ss_IntrastatEnabled = SS.IntrastatEnabled
  FROM !ActiveSchema!.evw_SystemSettings SS

  -- Get VAT System Settings
  
  SELECT @ss_VATScheme     = SS.VATScheme
       , @ss_VATNextPeriod = SS.VATNextPeriod
  FROM !ActiveSchema!.evw_VATSystemSettings SS
  
  -- Get CIS System settings
  SELECT @ss_CISAutoSetPeriod = SS.CISAutoSetPeriod
       , @ss_CISCurrentDate   = SS.CISCurrentDate
  FROM !ActiveSchema!.evw_CISSystemSettings SS

  -- Set Dates
/*
  UPDATE DOC
     SET thPostedDate          = PDate.PostedDate
       , thVATPostDate         = CASE
                                 WHEN @ss_VATScheme <> 'C'
                                 AND DOC.thVATPostDate = ''
                                 AND ( TT.TransactionTypeCode NOT IN ('SRC','PPY','NOM','NMT')
                                  OR ( TT.TransactionTypeCode IN ('NOM','NMT') AND DOC.thNOMVATIO NOT IN ('', CHAR(0)) )
                                     )
                                 THEN VP.VATPeriodDate COLLATE SQL_Latin1_General_CP437_BIN
                                 ELSE DOC.thVATPostDate
                                 END
       , thOriginalCompanyRate = CASE
                                 WHEN PDate.PostedDate = @c_Today AND thOriginalCompanyRate = 0.0 THEN common.efn_ConvertToReal48(C.CompanyRate)
                                 ELSE DOC.thOriginalCompanyRate
                                 END
       , thOriginalDailyRate   = CASE
                                 WHEN PDate.PostedDate = @c_Today THEN DOC.thDailyRate
                                 ELSE DOC.thOriginalDailyRate
                                 END
  FROM !ActiveSchema!.DOCUMENT    DOC
  CROSS APPLY ( SELECT TransactionPeriodKey = CASE
                                              WHEN ISDATE(DOC.thTransDate) = @c_True THEN (YEAR(CONVERT(DATE, DOC.thTransDate)) * 1000) + (MONTH(CONVERT(DATE, DOC.thTransDate)))
                                              ELSE 0
                                              END
              ) TPK
  CROSS APPLY ( SELECT PostedDate           = CASE 
                                              WHEN DOC.thPostedDate = '' THEN @c_Today
                                              ELSE DOC.thPostedDate
                                              END
                     , TransactionPeriodKey = CASE
                                              WHEN TPK.TransactionPeriodKey <> 0 THEN TPK.TransactionPeriodKey
                                              ELSE (((DOC.thYear + 1900) * 1000) + DOC.thPeriod)
                                              END
              ) PDate
  JOIN @itvp_PostTransactions     PT ON DOC.PositionId = PT.IntegerValue
  JOIN common.evw_TransactionType TT ON DOC.thDocType  = TT.TransactionTypeId
  JOIN !ActiveSchema!.CURRENCY    C  ON C.CurrencyCode = DOC.thCurrency

  JOIN !ActiveSchema!.evw_VATPeriod VP ON PDate.TransactionPeriodKey = VP.TransactionPeriodKey
*/
  -- Post Detail Lines
  
  DECLARE @tvp_PostLineTransactions common.edt_Integer

  INSERT INTO @tvp_PostLineTransactions
  SELECT DTL.PositionId
  FROM   @itvp_PostTransactions PT
  JOIN   !ActiveSchema!.DOCUMENT DOC ON DOC.PositionId = PT.IntegerValue
  JOIN   !ActiveSchema!.DETAILS  DTL ON DOC.thFolioNum = DTL.tlFolioNum
  WHERE 1 = 1
  AND   ( DTL.tlNetValue <> 0    -- Required so we ignore Description Only TL's
   OR     DTL.tlDiscount <> 0
   OR     DTL.tlQty      <> 0
   OR     DTL.tlLineNo    = -1
        )
  AND   DTL.tlYear   <> 0
  AND   DTL.tlPeriod <> 0

  EXEC !ActiveSchema!.esp_PostTransactionDetail @itvp_PostLineTransactions = @tvp_PostLineTransactions
                               , @iv_RunNo           = @iv_RunNo
                               , @iv_SeparateControl = @iv_SeparateControl

  -- Post Individual VAT History
  EXEC !ActiveSchema!.esp_PostVATHeader @itvp_PostTransactions = @itvp_PostTransactions

  -- Post Trader History
  EXEC !ActiveSchema!.esp_PostTrader @itvp_PostTransactions = @itvp_PostTransactions

  -- Create & Post Control Records

  EXEC !ActiveSchema!.esp_CreateTransactionControl @itvp_PostTransactions  = @itvp_PostTransactions
                             , @iv_RunNo           = @iv_RunNo
                             , @iv_SeparateControl = @iv_SeparateControl 

  DECLARE @tvp_PostControlLineTransactions common.edt_Integer

  INSERT INTO @tvp_PostControlLineTransactions
  SELECT PositionId
  FROM !ActiveSchema!.DETAILS (READUNCOMMITTED)
  CROSS JOIN !ActiveSchema!.evw_NominalControl NC
  WHERE tlRunNo    = @iv_RunNo
  AND   tlFolioNum = 0
  AND   tlLineNo   = 0
  AND   tlGLCode NOT IN (NC.LineDiscountGiven, NC.LineDiscountTaken)

  EXEC !ActiveSchema!.esp_PostCCDeptNominalBalances @itvp_PostLineTransactions = @tvp_PostControlLineTransactions
                                                  , @iv_IsControl              = @c_True

  -- Update Transaction Header
  
  -- Set Dates

  UPDATE DOC
     SET thPostedDate          = PDate.PostedDate
       , thVATPostDate         = CASE
                                 WHEN @ss_VATScheme <> 'C'
                                 AND DOC.thVATPostDate = ''
                                 AND ( TT.TransactionTypeCode NOT IN ('SRC','PPY','NOM','NMT')
                                  OR ( TT.TransactionTypeCode IN ('NOM','NMT') AND DOC.thNOMVATIO NOT IN ('', CHAR(0)) )
                                     )
                                 THEN [!ActiveSchema!].efn_CalculateVATPeriod (DOC.thTransDate) COLLATE SQL_Latin1_General_CP437_BIN
                                 ELSE DOC.thVATPostDate
                                 END
       , thOriginalCompanyRate = CASE
                                 WHEN PDate.PostedDate = @c_Today AND thOriginalCompanyRate = 0.0 THEN common.efn_ConvertToReal48(C.CompanyRate)
                                 ELSE DOC.thOriginalCompanyRate
                                 END
       , thOriginalDailyRate   = CASE
                                 WHEN PDate.PostedDate = @c_Today THEN DOC.thDailyRate
                                 ELSE DOC.thOriginalDailyRate
                                 END
  FROM !ActiveSchema!.DOCUMENT    DOC
  CROSS APPLY ( SELECT PostedDate = CASE 
                                    WHEN DOC.thPostedDate = '' THEN @c_Today
                                    ELSE DOC.thPostedDate
                                    END
              ) PDate
  JOIN @itvp_PostTransactions     PT ON DOC.PositionId = PT.IntegerValue
  JOIN common.evw_TransactionType TT ON DOC.thDocType  = TT.TransactionTypeId
  JOIN !ActiveSchema!.CURRENCY    C  ON C.CurrencyCode = DOC.thCurrency

  UPDATE DOC
     SET thRunNo                = CASE
                                  WHEN DOC.thRunNo = -10 THEN -11
                                  WHEN DOC.thRunNo = -40 THEN -42
                                  WHEN DOC.thRunNo = -50 THEN -52
                                  WHEN DOC.thRunNo = -60 THEN -62
                                  WHEN DOC.thRunNo = -70 THEN -72
                                  WHEN DOC.thRunNo = -115 THEN -116
                                  WHEN DOC.thRunNo = -118 THEN -119
                                  WHEN DOC.thRunNo = -125 THEN -126
                                  WHEN DOC.thRunNo = -128 THEN -129
                                  ELSE @iv_RunNo
                                  END

       , thIntrastatOutOfPeriod = CASE
                                  WHEN @ss_IntrastatEnabled            = @c_True
                                   AND ISNULL(CS.acECMember, @c_False) = @c_True
                                   AND EXISTS(SELECT TOP 1 1
                                              FROM   !ActiveSchema!.DETAILS DTL
                                              WHERE  DTL.tlFolioNUm = DOC.thFolioNum
                                              AND    DTl.tlVATCode IN ('A','D') 
                                             )
                                  THEN CASE
                                       WHEN TT.TransactionTypeCode IN ('PIN', 'PJI', 'PCR', 'PJC', 'PPI', 'PRF')
                                        AND thTransDate <= (SELECT TOP 1 sysValue
                                                            FROM   !ActiveSchema!.SystemSetup
                                                            WHERE  sysName = 'isLastClosedArrivalsDate') THEN @c_True
                                       
                                       WHEN TT.TransactionTypeCode IN ('SIN', 'SJI', 'SCR', 'SJC', 'SRI', 'SRF')
                                        AND thTransDate <= (SELECT TOP 1 sysValue
                                                            FROM   !ActiveSchema!.SystemSetup
                                                            WHERE  sysName = 'isLastClosedDispatchesDate') THEN @c_True
                                       ELSE @c_False
                                       END
                                  ELSE @c_False
                                  END

       , thCISDate              = CASE
                                  WHEN @ss_CISOn = @c_True
                                   AND TT.TransactionTypeCode IN ('PIN','PCR','PJI','PJC','PRF','PPI')
                                  THEN CASE
                                       WHEN thCurrSettled <> thCISTaxDeclared THEN CASE
                                                                                   WHEN @ss_CISAutoSetPeriod = @c_True THEN [!ActiveSchema!].efn_CalculateCISDate(@c_Today)
                                                                                   ELSE @ss_CISCurrentDate
                                                                                   END
                                       ELSE ''
                                       END
                                  ELSE thCISDate
                                  END

    FROM !ActiveSchema!.DOCUMENT DOC
    LEFT JOIN !ActiveSchema!.CUSTSUPP CS ON DOC.thAcCode = CS.acCode

    LEFT JOIN common.evw_TransactionType TT ON TT.TransactionTypeId = DOC.thDocType

    WHERE EXISTS (SELECT TOP 1 1
                  FROM @itvp_PostTransactions  PT 
                  WHERE DOC.PositionId = PT.IntegerValue
                 )
  
END

GO

