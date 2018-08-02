
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_UpdateTraderHistory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].esp_UpdateTraderHistory
GO

CREATE PROCEDURE !ActiveSchema!.esp_UpdateTraderHistory ( @iv_Mode INT
                                                , @iv_PositionId INT
                                                )
AS
BEGIN

  SET NOCOUNT ON;

  -- Update Trader History
  --DECLARE @iv_Mode    INT = 2

  -- Declare Constants

  DECLARE @c_Today          VARCHAR(8)
        , @c_MaxDate        VARCHAR(8) = '20491231'
        , @c_True           BIT = 1
        , @c_False          BIT = 0
        , @c_BaseCurrencyId INT = 0
        , @c_YTDPeriod      INT = 254
        , @c_CTDPeriod      INT = 255

  SET @c_Today = CONVERT(VARCHAR(8), GETDATE(), 112)

  DECLARE @ControlGLNominalCode INT

  SELECT @ControlGLNominalCode = CASE
                                 WHEN ControlGLNominalCode IN ((SELECT SS.CreditorControlNominalCode FROM !ActiveSchema!.evw_SystemSettings SS)
                                                              ,(SELECT SS.DebtorControlNominalCode FROM !ActiveSchema!.evw_SystemSettings SS)
                                                              ) THEN 0
                                 ELSE ControlGLNominalCode
                                 END
  FROM   !ActiveSchema!.evw_TransactionHeader (READUNCOMMITTED)
  WHERE  HeaderPositionId = @iv_PositionId

  DECLARE @HistoryClassRequired TABLE
         ( HistoryClassificationCode VARCHAR(1)
         , ControlGLNominalCode      INT        NULL
         )

  IF @iv_Mode IN (0, 2)
  BEGIN
    INSERT INTO @HistoryClassRequired
    SELECT 'U', NULL
  
    INSERT INTO @HistoryClassRequired
    SELECT 'U', @ControlGLNominalCode
  END

  IF @iv_Mode IN ( 0, 1)
  BEGIN
    INSERT INTO @HistoryClassRequired
    SELECT 'V', NULL
  
    INSERT INTO @HistoryClassRequired
    SELECT 'V', @ControlGLNominalCode
  END

  IF EXISTS ( SELECT TOP 1 1
              FROM !ActiveSchema!.evw_TransactionHeader TH (READUNCOMMITTED)
              WHERE TH.HeaderPositionId   = @iv_PositionId
              AND   TH.TransactionTypeCode IN ('SIN','SCR','SRF','SRI','SJI','SJC','SDN', 'PIN','PDN','PCR','PRF','PPI','PJI','PJC')
            )
  BEGIN
    INSERT INTO @HistoryClassRequired
    SELECT 'W', NULL
  END

  MERGE !ActiveSchema!.HISTORY H
  USING ( SELECT HR.HistoryClassificationCode
               , HistoryClassificationId   = ASCII(HR.HistoryClassificationCode)
               , TraderCode
               , HR.ControlGLNominalCode
               , HistoryCode               = CAST(0x14 + CONVERT(VARBINARY(21), CONVERT(CHAR(6), TraderCode) )
                                                       + CASE
                                                         WHEN HR.ControlGLNominalCode IS NOT NULL THEN CONVERT(VARBINARY(21), REVERSE(CONVERT(VARBINARY(4), HR.ControlGLNominalCode)))
                                                         ELSE 0x
                                                         END
                                                       + CONVERT(VARBINARY(21), SPACE(14)) AS VARBINARY(21) )
               , TH.ExchequerYear
               , YP.ExchequerPeriod
               , currencyId                = @c_BaseCurrencyId
               
               -- hiSales
               , DebitAmountInBase         = CASE
                                             WHEN HR.HistoryClassificationCode = 'W' THEN TH.TotalCostInBase
                                             ELSE TH.DebitAmountInBase
                                             END
               -- hiPurchases
               , CreditAmountInBase        = CASE
                                             WHEN HR.HistoryClassificationCode = 'W' THEN TH.TotalCalculatedNetValueInBase
                                             ELSE TH.CreditAmountInBase
                                             END

               , TotalCalculatedNetValueInBase
               , TotalCostInBase
      
          FROM   !ActiveSchema!.evw_TransactionHeader TH (READUNCOMMITTED)
          CROSS JOIN @HistoryClassRequired HR
          CROSS APPLY ( SELECT TH.ExchequerYear
                        UNION
                        SELECT CASE 
                               WHEN HR.HistoryClassificationCode = 'W' THEN @c_YTDPeriod
                               ELSE @c_CTDPeriod
                               END
                       ) YP ( ExchequerPeriod )
          WHERE  TH.HeaderPositionId = @iv_PositionId) HData ON HData.HistoryClassificationId = H.hiExCLass
                                                            AND HData.HistoryCode             = H.hiCode
                                                            AND HData.ExchequerYear           = H.hiYear
                                                            AND HData.ExchequerPeriod         = H.hiPeriod
                                                            AND HData.CurrencyId              = H.hiCurrency
  WHEN NOT MATCHED BY TARGET THEN
       INSERT ( hiCode
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
       VALUES ( HData.HistoryCode
              , HData.HistoryClassificationId
              , HData.CurrencyId
              , HData.ExchequerYear
              , HData.ExchequerPeriod
              , HData.DebitAmountInBase
              , HData.CreditAmountInBase
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
  WHEN MATCHED THEN
       UPDATE
          SET hiSales     = H.hiSales + HData.DebitAmountInBase
            , hiPurchases = H.hiPurchases + HData.CreditAmountInBase
  ;
  
END

GO
