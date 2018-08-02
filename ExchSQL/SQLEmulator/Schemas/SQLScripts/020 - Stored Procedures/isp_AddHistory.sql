--/////////////////////////////////////////////////////////////////////////////
--// Filename    : isp_AddHistory.sql
--// Author    : 
--// Date    : 
--// Copyright Notice  : (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description  : SQL Script to add isp_AddHistory stored procedure
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//  1  : File Creation
--//  2  : Modifed for 5 Revised Budgets - 5th May 2016
--//
--/////////////////////////////////////////////////////////////////////////////

-- STATUS 
-- TODO Add structured exception handling

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[!ActiveSchema!].[isp_AddHistory]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
  DROP PROCEDURE [!ActiveSchema!].[isp_AddHistory]


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [!ActiveSchema!].[isp_AddHistory]
               ( @iv_Type        INT
               , @iv_Code        VARBINARY(21)
               , @iv_Currency    INT
               , @iv_Year        INT
               , @iv_Period      INT
               , @ov_PositionId  INT OUTPUT
               )
AS
BEGIN

  SET NOCOUNT ON

  DECLARE
      @Error          INT
    , @ReturnCode     INT
    , @TraceMessage   VARCHAR(255)
    , @Status         BIT
    , @YearGap        INT
    , @Counter        INT
    , @Year           INT
    , @AdjustedYear   INT
    , @LastPurchases  FLOAT
    , @LastSales      FLOAT
    , @LastCleared    FLOAT

  SELECT  
      @ov_PositionId  = 0
    , @Error          = 0
    , @ReturnCode     = 0
    , @TraceMessage   = ''
    , @Status         = 0
    , @YearGap        = 0
    , @Counter        = 0
    , @Year           = 0
    , @AdjustedYear   = 0
    , @LastPurchases  = 0
    , @LastSales      = 0
    , @LastCleared    = 0

  -- Declare and define constants
  DECLARE
      @c_Ytd            INT
    , @c_StkStkCode     INT
    , @c_StkBillCode    INT
    , @c_StkDListCode   INT
    , @c_StkGrpCode     INT
    , @c_StkDescCode    INT
    , @c_StkStkQCode    INT
    , @c_StkBillQCode   INT
    , @c_StkDLQCode     INT
    , @c_CuStkHistCode  INT
    , @c_CommitHCode    INT
    , @c_JobGrpCode     INT
    , @c_JobJobCode     INT
    , @c_CustHistCde  INT

  SELECT    
      @c_Ytd            = 255
    , @c_StkStkCode     = 80
    , @c_StkBillCode    = 77
    , @c_StkDListCode   = 88
    , @c_StkGrpCode     = 71
    , @c_StkDescCode    = 68
    , @c_StkStkQCode    = 239
    , @c_StkBillQCode   = 236
    , @c_StkDLQCode     = 247
    , @c_CuStkHistCode  = 69
    , @c_CommitHCode    = 91
    , @c_JobGrpCode     = 75
    , @c_JobJobCode     = 74
    , @c_CustHistCde  = 85

  -- TODO Call LLast_YTD, using sp instead of scalar UDF
  IF @iv_Year > 0 
  BEGIN --5
    IF  @iv_Period = @c_Ytd
    BEGIN --4
      SET @AdjustedYear = [!ActiveSchema!].[ifn_AdjustYear] (@iv_Year, 0)

      EXEC @Error = [!ActiveSchema!].[isp_LastYtd]
          @iv_Code
        , @iv_Type
        , @iv_Currency
        , @AdjustedYear
        , @iv_Period
        , 0                                               -- False, i.e. B_GetLessEq
        , @ov_PositionId  = @ov_PositionId  OUTPUT
        , @ov_Status      = @Status         OUTPUT

      IF @Status = 1
      BEGIN --3
        SELECT @Year    = hiYear
             , @YearGap = @iv_Year - hiYear
        FROM  [!ActiveSchema!].[HISTORY]
        WHERE PositionId = @ov_PositionId

        IF @YearGap > 1
        BEGIN --2
          -- TODO Implement recursive FOR loop, lines 24 and 25
          SET @Counter = [!ActiveSchema!].[ifn_AdjustYear](@Year, 1)

          WHILE (@Counter <= [!ActiveSchema!].[ifn_AdjustYear](@iv_Year, 0))
          BEGIN --1
            EXEC @Error = [!ActiveSchema!].[isp_AddHistory]
                @iv_Type
              , @iv_Code
              , @iv_Currency
              , @Counter
              , @iv_Period
              , @ov_PositionId = @ov_PositionId OUTPUT

            SET @Counter = @Counter + 1
          END   --1 
        END   --2

        SELECT @LastPurchases  = hiPurchases
             , @LastSales      = hiSales
             , @LastCleared    = CASE
                                 WHEN @iv_Type IN ( @c_CustHistCde 
                                                  , @c_StkStkQCode
                                                  , @c_StkBillQCode
                                                  , @c_StkDLQCode
                                                  , @c_JobGrpCode
                                                  , @c_JobJobCode
                                                  )
                                 THEN hiCleared
                                 ELSE @LastCleared
                                 END
        FROM  [!ActiveSchema!].[HISTORY]
        WHERE PositionId = @ov_PositionId

      END   
    END   

    BEGIN TRY

      SET @ov_PositionId = 0 -- In case INSERT fails, don't pass back previous value

      INSERT INTO [!ActiveSchema!].[HISTORY]
                ( [hiCode]
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
      VALUES    ( @iv_Code
                , @iv_Type
                , @iv_Currency
                , @iv_Year
                , @iv_Period
                , @LastSales
                , @LastPurchases
                , 0
                , @LastCleared
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

      SET @ov_PositionId = SCOPE_IDENTITY()

    END TRY

    BEGIN CATCH
      SET @ReturnCode = -1
    END CATCH

  END

  SET NOCOUNT OFF

  RETURN @ReturnCode
END
GO
