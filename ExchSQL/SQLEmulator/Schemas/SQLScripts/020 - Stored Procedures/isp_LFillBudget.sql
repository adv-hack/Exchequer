--/////////////////////////////////////////////////////////////////////////////
--// Filename        : isp_LFillBudget.sql
--// Author        : Nilesh Desai 
--// Date        : 24 July 2008
--// Copyright Notice    : (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description    : SQL Script to add isp_LFillBudget stored procedure.
--//                  This SP will calculate values and insert/update to History 
--//                  table for All Period Data and YTD Period.
--// Usage : EXEC @ReturnValue = [!ActiveSchema!].[isp_LFillBudget] 56, 0x380101040000003030313420202020202020202020006901, 0, 103, 1, 12, 0, 1, 0 
--//         EXEC [!ActiveSchema!].[isp_LFillBudget] 56, 0x380101040000003030313420202020202020202020006901, 0, 103, 1, 12, 0, 1, 0 
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//    1    : File Creation
--//
--/////////////////////////////////////////////////////////////////////////////

IF EXISTS ( SELECT    TOP 1 1
            FROM    dbo.sysobjects 
            WHERE    id = OBJECT_ID(N'[!ActiveSchema!].[isp_LFillBudget]') 
            AND        OBJECTPROPERTY(id,N'IsProcedure') = 1
          )

DROP PROCEDURE [!ActiveSchema!].[isp_LFillBudget]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [!ActiveSchema!].[isp_LFillBudget]    (
        @iv_Type              INT
      , @iv_Code              VARBINARY(21)
      , @iv_Currency          INT
      , @iv_Year              INT
      , @iv_Period            INT
      , @iv_PeriodInYear      INT
      , @iv_CalcPurgeOB       BIT        
      , @iv_Range             BIT        
      , @iv_PPr2              INT        -- 0 in this case
  )
AS
BEGIN
    -- Constants
    DECLARE     @c_NomHedCode       INT
              , @c_YTD              INT
              , @c_YTDNCF           INT
              , @c_BankNHCode       INT
              , @c_CtrlNHCode       INT
              , @c_StkStkQCode      INT
              , @c_StkBillQCode     INT
              , @c_StkDLQCode       INT
              , @c_JobGrpCode       INT
              , @c_JobPhzCode       INT
              , @c_JobJobCode       INT
              , @c_ViewHedCode      INT
              , @c_ViewBalCode      INT
              , @c_CustHistGPCde    INT
              , @c_StkGrpCode       INT
              , @c_StkStkCode       INT
              , @c_StkDescCode      INT
              , @c_StkBillCode      INT
              , @c_StkDListCode     INT
              , @c_PLNHCode         INT

    -- Assigning Constants values
    SELECT      @c_ViewHedCode      = 57
              , @c_ViewBalCode      = 56
              , @c_PLNHCode         = 65
              , @c_BankNHCode       = 66        
              , @c_CtrlNHCode       = 67        
              , @c_StkDescCode      = 68
              , @c_StkGrpCode       = 71
              , @c_NomHedCode       = 72 
              , @c_JobGrpCode       = 75        
              , @c_JobJobCode       = 74
              , @c_StkBillCode      = 77 
              , @c_StkStkCode       = 80
              , @c_CustHistGPCde    = 87
              , @c_StkDListCode     = 88
              , @c_JobPhzCode       = 90        
              , @c_StkBillQCode     = 236
              , @c_StkStkQCode      = 239        
              , @c_StkDLQCode       = 247        
              , @c_YTDNCF           = 254        -- YTD Weighting for History, but not carry forward bal type
              , @c_YTD              = 255        -- YTD Weighting for history
              
    -- Local Variables
    DECLARE     @CRLF               NVARCHAR(5)    
              , @ReturnCode         INT
              , @Error              INT
              , @PositionId         INT
              , @hiCodeComputed     VARBINARY(20)
              , @PeriodCounter      INT
              , @IsExistYTDEntry    BIT
              , @ISExistYTDNCFEntry BIT
              , @NeedYTD            INT

    -- Assigning default values
    SELECT      @PeriodCounter      = 1 
              , @ReturnCode         = 0
              , @Error              = 0
              , @hiCodeComputed     = CONVERT(VARBINARY(20), SUBSTRING(@iv_Code, 2, 20), 0)
              , @PositionId         = 0
              , @IsExistYTDEntry    = 0
              , @ISExistYTDNCFEntry = 0
              , @NeedYTD            = 0

    BEGIN TRY
        
        -- Looping thought all the Period from 1 to passed PeriodInYear    (12)
        WHILE @PeriodCounter <= @iv_PeriodInYear
        BEGIN

            -- Looking for existing record 
            SELECT @PositionId = [!ActiveSchema!].ifn_GetHistoryPositionId 
            (
                  @iv_Type
                , @iv_Code
                , @iv_Currency
                , @iv_Year
                , @PeriodCounter
            )

            -- If doesn't exists record in History table then Insert a blank records
            IF @PositionId = 0
            BEGIN
                EXEC @Error = [!ActiveSchema!].[isp_AddHistory]        @iv_Type
                                                          , @iv_Code
                                                          , @iv_Currency
                                                          , @iv_Year
                                                          , @PeriodCounter
                                                          , @ov_PositionId = @PositionId OUTPUT
            END
            SET @PeriodCounter = @PeriodCounter + 1
            -- PRINT CONVERT(VARCHAR(MAX), @PositionId)
        END

        -- Checking for hiExClass 'H' [No data will be exists for this kind of type and raising an exception need to investigate while actual testing]
        IF (@iv_Type = @c_NomHedCode) 
        BEGIN

            -- Per spec Raising an Error for hiExClass - 'H'
            RAISERROR('Investigation need to be done for ExClass Type H', 1, 1) 
            
            -- Following logic is already written in Betrieve code; so i have wrote but not executed
            IF EXISTS ( SELECT    TOP 1 1
                        FROM    [!ActiveSchema!].HISTORY
                        WHERE    Cast(Cast(Cast(Reverse(SubString(hiCodeComputed, 1, 4)) As Char(4)) As Binary(4)) As int) = Cast(Cast(Cast(Reverse(SubString(@iv_Code, 2, 4)) As Char(4)) As Binary(4)) As int)
                        AND        hiExClass = @iv_Type
                        AND        hiPeriod  = @c_YTD
                      )
            BEGIN
                SELECT @IsExistYTDEntry = 1
            END

            IF EXISTS ( SELECT    TOP 1 1
                        FROM    [!ActiveSchema!].HISTORY
                        WHERE    Cast(Cast(Cast(Reverse(SubString(hiCodeComputed, 1, 4)) As Char(4)) As Binary(4)) As int) = Cast(Cast(Cast(Reverse(SubString(@iv_Code, 2, 4)) As Char(4)) As Binary(4)) As int)
                        AND        hiExClass = @iv_Type
                        AND        hiPeriod  = @c_YTDNCF
                      )
            BEGIN
                SELECT @ISExistYTDNCFEntry = 1
            END
        END
        
        -- Don't create YTD entries for G/L Views (these will be created elsewhere).
        IF NOT (@iv_Type IN ( @c_ViewBalCode, @c_ViewHedCode))
        BEGIN
            -- Checking for Given type and @IsExistYTDEntry = 1 then setting YTD period to 255
            IF (@iv_Type  IN ( @c_BankNHCode
                             , @c_CtrlNHCode
                             , @c_StkStkQCode
                             , @c_StkBillQCode
                             , @c_StkDLQCode
                             , @c_JobGrpCode
                             , @c_JobPhzCode
                             , @c_JobJobCode
                             )
                ) 
                OR 
                ( 
                    @IsExistYTDEntry = 1 
                )
            BEGIN
                SELECT @NeedYTD = @c_YTD
            END
            ELSE
            BEGIN
                -- Checking for Given type and @ISExistYTDNCFEntry = 1 then setting YTD period to 254
                IF ( @iv_Type IN ( @c_CustHistGPCde
                                 , @c_StkGrpCode
                                 , @c_StkStkCode
                                 , @c_StkDescCode
                                 , @c_StkBillCode
                                 , @c_StkDListCode
                                 , @c_PLNHCode 
                                 )
                    ) 
                    OR 
                    ( @ISExistYTDNCFEntry = 1 )        
                BEGIN
                    SELECT @NeedYTD = @c_YTDNCF
                END        
            END    
        END    

        -- If NeedYTD period is greater then 0 
        IF ( @NeedYTD > 0 )
        BEGIN
        
            -- Checking for Existing records for YTD period
            SELECT @PositionId = [!ActiveSchema!].ifn_GetHistoryPositionId 
            (
                  @iv_Type
                , @iv_Code
                , @iv_Currency
                , @iv_Year
                , @NeedYTD
            )

            -- If not found then insert recrods to History
            IF @PositionId = 0
            BEGIN

                DECLARE @hiSales      float
                      , @hiPurchases  float
                      , @hiCleared    float
                      , @lType        CHAR(1)

                -- Getting figures for YTD/YTDNCF balance
                SELECT @lType = CHAR(@iv_Type)
                EXEC [!ActiveSchema!].[isp_TotalProfitToDateRange]    @lType
                                                          , @hiCodeComputed
                                                          , @iv_Currency
                                                          , @iv_Year
                                                          , @iv_Period
                                                          , @iv_PPr2                         -- @iv_PPr2
                                                          , @iv_Range                        -- @iv_Range
                                                          , @iv_CalcPurgeOB                  -- @iv_SetACHist
                                                          , @ov_Purch       = @hiPurchases   OUTPUT 
                                                          , @ov_PSales      = @hiSales       OUTPUT
                                                          , @ov_PCleared    = @hiCleared     OUTPUT


                INSERT INTO [!ActiveSchema!].[HISTORY]
                (
                      [hiCode]
                    , [hiExCLass]
                    , [hiCurrency]
                    , [hiYear]
                    , [hiPeriod]
                    , [hiSales]
                    , [hiPurchases]
                    , [hiBudget]
                    , [hiCleared]
                    , [hiRevisedBudget1]
                    , [hiValue1]
                    , [hiValue2]
                    , [hiValue3]
                    , [hiRevisedBudget2]
                    , [hiRevisedBudget3]
                    , [hiRevisedBudget4]
                    , [hiRevisedBudget5]
                    , [hiSpareV]
                )
                VALUES 
                (
                      @iv_Code
                    , @iv_Type
                    , @iv_Currency
                    , @iv_Year
                    , @NeedYTD
                    , ISNULL(@hiSales, 0)
                    , ISNULL(@hiPurchases, 0)
                    , 0
                    , ISNULL(@hiCleared, 0)
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

            END
        END
    END TRY
    BEGIN CATCH
           -- Execute error logging routine
        EXEC common.isp_RaiseError   @iv_IRISExchequerErrorMessage = 'Procedure [!ActiveSchema!].[isp_LFillBudget]' -- Include optional message...?
        -- SP failed - error raised
        SET @ReturnCode = -1    
    END CATCH

    SET NOCOUNT OFF
    RETURN @ReturnCode
END
GO