--/////////////////////////////////////////////////////////////////////////////
--// Filename        : ifn_TotalProfitToDateRange.sql
--// Author        : 
--// Date        : 
--// Copyright Notice    : (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description    : SQL Script to add ifn_TotalProfitToDateRange functions
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//    1    : File Creation
--//
--/////////////////////////////////////////////////////////////////////////////

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[ifn_TotalProfitToDateRange_236]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [!ActiveSchema!].[ifn_TotalProfitToDateRange_236]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[ifn_TotalProfitToDateRange_239]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [!ActiveSchema!].[ifn_TotalProfitToDateRange_239]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[ifn_TotalProfitToDateRange_247]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [!ActiveSchema!].[ifn_TotalProfitToDateRange_247]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[ifn_TotalProfitToDateRange_56]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [!ActiveSchema!].[ifn_TotalProfitToDateRange_56]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[ifn_TotalProfitToDateRange_57]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [!ActiveSchema!].[ifn_TotalProfitToDateRange_57]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[ifn_TotalProfitToDateRange_69_0x01]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [!ActiveSchema!].[ifn_TotalProfitToDateRange_69_0x01]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[ifn_TotalProfitToDateRange_69_0x02]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [!ActiveSchema!].[ifn_TotalProfitToDateRange_69_0x02]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[ifn_TotalProfitToDateRange_69_0x41]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [!ActiveSchema!].[ifn_TotalProfitToDateRange_69_0x41]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[ifn_TotalProfitToDateRange_69_Other]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [!ActiveSchema!].[ifn_TotalProfitToDateRange_69_Other]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[ifn_TotalProfitToDateRange_74]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [!ActiveSchema!].[ifn_TotalProfitToDateRange_74]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[ifn_TotalProfitToDateRange_85]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [!ActiveSchema!].[ifn_TotalProfitToDateRange_85]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[ifn_TotalProfitToDateRange_86]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [!ActiveSchema!].[ifn_TotalProfitToDateRange_86]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[ifn_TotalProfitToDateRange_90]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [!ActiveSchema!].[ifn_TotalProfitToDateRange_90]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[ifn_TotalProfitToDateRangeOther]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [!ActiveSchema!].[ifn_TotalProfitToDateRangeOther]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[ifn_TotalProfitToDateRange]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [!ActiveSchema!].[ifn_TotalProfitToDateRange]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date : 29th Jul 2008
-- Author       : Nilesh Desai
-- Description : This function will return values for given parameter passed 
-- Note           : I take return value as "TABLE", so that i can use this function as OUTER APPLY and will be called 
--                 one time for each row. And value will be assign to multiple fields at a time.        
-- Updated     : James Waygood - 11th Nov 2009 - Changed to use clustered view HISTORY_90 based on NType
-- Updated     : Glen Jones - 3rd May 2016 - Changed to include new Revised Budget Columns
-- =============================================
CREATE FUNCTION [!ActiveSchema!].[ifn_TotalProfitToDateRange]
(
      @iv_NType            Char(1)
    , @iv_NCode            binary(20)            
    , @iv_PCr            INT                    -- Currency
    , @iv_PYr            INT                    -- hiYear
        , @iv_PPr            INT                    -- hiPeriod
    , @iv_PPr2            INT                    -- hiPreviousPeriod
        , @iv_Range            BIT                
    , @iv_SetACHist        BIT
)
RETURNS @ov_TotalProfitToDateRange TABLE
( 
      NType          CHAR(1)
    , NCode          BINARY(20)            
    , PCr            INT                    -- Currency
    , PYr            INT                    -- hiYear
    , PPr            INT                    -- hiPeriod
    , PPr2           INT                    -- hiPreviousPeriod
    , Range          BIT
    , SetACHist      BIT
    , Purch          FLOAT 
    , PSales         FLOAT 
    , Balance        FLOAT 
    , PCleared       FLOAT 
    , PBudget        FLOAT 
    , PRBudget1      FLOAT 
    , PRBudget2      FLOAT 
    , PRBudget3      FLOAT 
    , PRBudget4      FLOAT 
    , PRBudget5      FLOAT 
    , BValue1        FLOAT 
    , BValue2        FLOAT 
      
)
AS
BEGIN    



    -- Declare constants
    DECLARE        @c_hiPeriodYTD    INT
              , @c_CRLF            NVARCHAR(5)    
              , @c_NType_56        VARCHAR(1)        -- '8'
              , @c_NType_57        VARCHAR(1)        -- '9'
              , @c_NType_66        VARCHAR(1)        -- 'B'
              , @c_NType_67        VARCHAR(1)        -- 'C'
              , @c_NType_72        VARCHAR(1)        -- 'H'
              , @c_NType_74        VARCHAR(1)        -- 'J'    [JobJobCode]
              , @c_NType_75        VARCHAR(1)        -- 'K'    [JobGrpCode]
              , @c_NType_85        VARCHAR(1)        -- 'U'
              , @c_NType_86        VARCHAR(1)        -- 'V'
              , @c_NType_90        VARCHAR(1)        -- 'Z'
              , @c_NType_91        VARCHAR(1)        -- '['    [CommitHCode]
              , @c_NType_236       VARCHAR(1)        --        [StkBillQCode]
              , @c_NType_239       VARCHAR(1)        -- '?'  [StkStkQCode]
              , @c_NType_247       VARCHAR(1)        --        [StkDLQCode]


    -- Assigning values to constants
    SELECT        @c_hiPeriodYTD = 255
              , @c_CRLF            = CHAR(13) + CHAR(10)
              , @c_NType_56        = CHAR(56)
              , @c_NType_57        = CHAR(57)
              , @c_NType_66        = CHAR(66)
              , @c_NType_67        = CHAR(67)
              , @c_NType_72        = CHAR(72)
              , @c_NType_74        = CHAR(74) 
              , @c_NType_75        = CHAR(75)
              , @c_NType_85        = CHAR(85)
              , @c_NType_86        = CHAR(86)
              , @c_NType_90        = CHAR(90)
              , @c_NType_91        = CHAR(91)
              , @c_NType_236       = CHAR(236)
              , @c_NType_239       = CHAR(239)
              , @c_NType_247       = CHAR(247)

    -- Declare local variables
    DECLARE     @ReturnCode         INT
              , @Previous_hiYear    INT
              , @PreviousYear       INT
              , @ParmDefinition     NVARCHAR(500)
              , @PPrYear            INT

    -- Assigning default value  
    SELECT      @Previous_hiYear = 0
              , @ReturnCode      = 0

    -- If Range parameter is true     
    IF @iv_Range = 1
    BEGIN    
        SELECT @PreviousYear = @iv_PYr - 1

        -- Checking input paramter NType with constants values i.e. hiExClass and Range is true
        IF (@iv_NType IN (  @c_NType_56
                          , @c_NType_57
                          , @c_NType_66
                          , @c_NType_67
                          , @c_NType_72
                          , @c_NType_74
                          , @c_NType_75
                          , @c_NType_85
                          , @c_NType_86
                          , @c_NType_90
                          , @c_NType_91
                          , @c_NType_236
                          , @c_NType_239
                          , @c_NType_247
                         )
            )
            AND (@iv_Range = 1)
        BEGIN
            -- Getting Previous year values for entries is exist for given paramter            
            SELECT        @Previous_hiYear = hiYear 
            FROM        ( SELECT    MAX(hiYear) AS hiYear
                          FROM      [!ActiveSchema!].HISTORY_All HST WITH (NOEXPAND, READUNCOMMITTED)        
                          WHERE      HST.hiExClass      = ASCII(@iv_NType)
                          AND        HST.hiCodeComputed = @iv_NCode
                          AND        HST.hiCurrency     = @iv_PCr
                          AND        HST.hiYear        <= @PreviousYear
                          AND        HST.hiPeriod       = @c_hiPeriodYTD        
                          GROUP BY  hiCodeComputed
                                  , hiExClass
                                  , hiYear
                        ) Data

            SELECT @PreviousYear = @Previous_hiYear
        END
    END                          
    
    IF @iv_Range = 0
    BEGIN
        IF (@iv_PPr2 > @iv_PPr) AND (@iv_PPr2 <> 0) AND (@iv_Range = 0)
        BEGIN
            SET @PPrYear = @iv_PPr2
            INSERT INTO @ov_TotalProfitToDateRange 
            ( 
                  NType            
                , NCode            
                , PCr            
                , PYr            
                , PPr            
                , PPr2    
                , Range    
                , SetACHist    
                , Purch            
                , PSales        
                , Balance        
                , PCleared        
                , PBudget        
                , PRBudget1
                , PRBudget2
                , PRBudget3
                , PRBudget4
                , PRBudget5        
                , BValue1        
                , BValue2        
            ) 
            SELECT    NType     = MAX(@iv_NType)         
                    , NCode     = MAX(@iv_NCode) 
                    , PCr       = @iv_PCr 
                    , PYr       = MAX(@iv_PYr) 
                    , PPr       = MAX(@iv_PPr) 
                    , PPr2      = MAX(@iv_PPr2) 
                    , Range     = @iv_Range
                    , SetACHist = @iv_SetACHist
                    , Purch     = SUM( CASE
                                       WHEN ((@iv_NType <> 'U') OR (HST.hiPeriod NOT IN (254, 255))) OR (@iv_SetACHist = 1) THEN ISNULL(hiPurchases, 0) 
                                       ELSE 0 
                                       END 
                                     ) 
                    , PSales    = SUM( CASE 
                                       WHEN ((@iv_NType <> 'U') OR (HST.hiPeriod NOT IN (254, 255))) OR (@iv_SetACHist = 1) THEN ISNULL(hiSales, 0) 
                                       ELSE 0 
                                       END 
                                     )  
                    , Balance   = SUM(ISNULL(hiPurchases, 0)) - SUM(ISNULL(hiSales, 0))
                    , PCleared  = SUM(hiCleared) 
                    , PBudget   = SUM( CASE 
                                       WHEN HST.hiPeriod NOT IN (254, 255) THEN ISNULL(hiBudget, 0) 
                                       ELSE 0 
                                       END 
                                     ) 
                    , PRBudget1 = SUM( CASE 
                                       WHEN HST.hiPeriod NOT IN (254, 255) THEN hiRevisedBudget1 
                                       ELSE 0 
                                       END 
                                     )
                    , PRBudget2 = SUM( CASE 
                                       WHEN HST.hiPeriod NOT IN (254, 255) THEN hiRevisedBudget2 
                                       ELSE 0 
                                       END 
                                     )
                    , PRBudget3 = SUM( CASE 
                                       WHEN HST.hiPeriod NOT IN (254, 255) THEN hiRevisedBudget3
                                       ELSE 0 
                                       END 
                                     )
                    , PRBudget4 = SUM( CASE 
                                       WHEN HST.hiPeriod NOT IN (254, 255) THEN hiRevisedBudget4
                                       ELSE 0 
                                       END 
                                     )
                    , PRBudget5 = SUM( CASE 
                                       WHEN HST.hiPeriod NOT IN (254, 255) THEN hiRevisedBudget5
                                       ELSE 0 
                                       END 
                                     )
                    , BValue1   = SUM(hiValue1) 
                    , BValue2   = SUM(hiValue2) 
             FROM       [!ActiveSchema!].[HISTORY_All] HST WITH (NOEXPAND, READUNCOMMITTED) 
             WHERE       hiExClass = ASCII(@iv_NType) 
             AND       HST.hiCodeComputed = @iv_NCode
             AND       HST.hiCurrency = @iv_PCr
             AND       (((HST.hiYear = @iv_PYr) and ((HST.hiPeriod <= @PPrYear) AND (HST.hiPeriod >= @iv_PPr))) 
             OR           ((HST.hiYear = @PreviousYear) and (HST.hiPeriod = @c_hiPeriodYTD)))
        END
        ELSE    
        BEGIN
            SET @PPrYear = @iv_PPr
            
            INSERT INTO @ov_TotalProfitToDateRange 
            ( 
                  NType            
                , NCode            
                , PCr            
                , PYr            
                , PPr            
                , PPr2    
                , Range    
                , SetACHist    
                , Purch            
                , PSales        
                , Balance        
                , PCleared        
                , PBudget        
                , PRBudget1
                , PRBudget2
                , PRBudget3
                , PRBudget4
                , PRBudget5        
                , BValue1        
                , BValue2        
            ) 
            SELECT    NType     = MAX(@iv_NType)         
                    , NCode     = MAX(@iv_NCode) 
                    , PCr       = @iv_PCr 
                    , PYr       = MAX(@iv_PYr) 
                    , PPr       = MAX(@iv_PPr) 
                    , PPr2      = MAX(@iv_PPr2) 
                    , Range     = @iv_Range
                    , SetACHist = @iv_SetACHist
                    , Purch     = SUM( CASE
                                       WHEN ((@iv_NType <> 'U') OR (HST.hiPeriod NOT IN (254, 255))) OR (@iv_SetACHist = 1) THEN ISNULL(hiPurchases, 0) 
                                       ELSE 0 
                                       END 
                                     ) 
                    , PSales    = SUM( CASE 
                                       WHEN ((@iv_NType <> 'U') OR (HST.hiPeriod NOT IN (254, 255))) OR (@iv_SetACHist = 1) THEN ISNULL(hiSales, 0) 
                                       ELSE 0 
                                       END 
                                     )  
                    , Balance   = SUM(ISNULL(hiPurchases, 0)) - SUM(ISNULL(hiSales, 0))
                    , PCleared  = SUM(hiCleared) 
                    , PBudget   = SUM( CASE 
                                       WHEN HST.hiPeriod NOT IN (254, 255) THEN ISNULL(hiBudget, 0) 
                                       ELSE 0 
                                       END 
                                     ) 
                    , PRBudget1 = SUM( CASE 
                                       WHEN HST.hiPeriod NOT IN (254, 255) THEN hiRevisedBudget1
                                       ELSE 0 
                                       END 
                                     ) 
                    , PRBudget2 = SUM( CASE 
                                       WHEN HST.hiPeriod NOT IN (254, 255) THEN hiRevisedBudget2 
                                       ELSE 0 
                                       END 
                                     )
                    , PRBudget3 = SUM( CASE 
                                       WHEN HST.hiPeriod NOT IN (254, 255) THEN hiRevisedBudget3
                                       ELSE 0 
                                       END 
                                     )
                    , PRBudget4 = SUM( CASE 
                                       WHEN HST.hiPeriod NOT IN (254, 255) THEN hiRevisedBudget4
                                       ELSE 0 
                                       END 
                                     )
                    , PRBudget5 = SUM( CASE 
                                       WHEN HST.hiPeriod NOT IN (254, 255) THEN hiRevisedBudget5
                                       ELSE 0 
                                       END 
                                     )
                    , BValue1   = SUM(hiValue1) 
                    , BValue2   = SUM(hiValue2)

             FROM       [!ActiveSchema!].[HISTORY_All] HST WITH (NOEXPAND, READUNCOMMITTED) 
             WHERE       hiExClass = ASCII(@iv_NType) 
             AND       HST.hiCodeComputed = @iv_NCode
             AND       HST.hiCurrency = @iv_PCr
             AND       ((HST.hiYear = @iv_PYr) and (HST.hiPeriod = @PPrYear))
        END    
    END
    ELSE
    BEGIN
        SET @PPrYear = @iv_PPr

        INSERT INTO @ov_TotalProfitToDateRange 
        ( 
              NType            
            , NCode            
            , PCr            
            , PYr            
            , PPr            
            , PPr2    
            , Range    
            , SetACHist    
            , Purch            
            , PSales        
            , Balance        
            , PCleared        
            , PBudget        
            , PRBudget1
            , PRBudget2
            , PRBudget3
            , PRBudget4
            , PRBudget5     
            , BValue1        
            , BValue2        
        ) 
        SELECT    NType     = MAX(@iv_NType)         
                , NCode     = MAX(@iv_NCode) 
                , PCr       = @iv_PCr 
                , PYr       = MAX(@iv_PYr) 
                , PPr       = MAX(@iv_PPr) 
                , PPr2      = MAX(@iv_PPr2) 
                , Range     = @iv_Range
                , SetACHist = @iv_SetACHist
                , Purch     = SUM( CASE
                            WHEN ((@iv_NType <> 'U') OR (HST.hiPeriod NOT IN (254, 255))) OR (@iv_SetACHist = 1) THEN 
                                ISNULL(hiPurchases, 0) 
                            ELSE         
                                0 
                            END 
                     ) 
                , PSales    = SUM( CASE 
                            WHEN ((@iv_NType <> 'U') OR (HST.hiPeriod NOT IN (254, 255))) OR (@iv_SetACHist = 1) THEN 
                                ISNULL(hiSales, 0) 
                            ELSE         
                                0 
                            END 
                    )  
                , Balance   = SUM(ISNULL(hiPurchases, 0)) - SUM(ISNULL(hiSales, 0)) 
                , PCleared  = SUM(hiCleared) 
                , PBudget   = SUM( CASE 
                                   WHEN HST.hiPeriod NOT IN (254, 255) THEN ISNULL(hiBudget, 0) 
                                   ELSE 0 
                                   END 
                                 ) 
                , PRBudget  = SUM( CASE 
                                   WHEN HST.hiPeriod NOT IN (254, 255) THEN hiRevisedBudget1 
                                   ELSE 0 
                                   END 
                                 )
                , PRBudget2 = SUM( CASE 
                                   WHEN HST.hiPeriod NOT IN (254, 255) THEN hiRevisedBudget2 
                                   ELSE 0 
                                   END 
                                 )
                , PRBudget3 = SUM( CASE 
                                   WHEN HST.hiPeriod NOT IN (254, 255) THEN hiRevisedBudget3
                                   ELSE 0 
                                   END 
                                 )
                , PRBudget4 = SUM( CASE 
                                   WHEN HST.hiPeriod NOT IN (254, 255) THEN hiRevisedBudget4
                                   ELSE 0 
                                   END 
                                 )
                , PRBudget5 = SUM( CASE 
                                   WHEN HST.hiPeriod NOT IN (254, 255) THEN hiRevisedBudget5
                                   ELSE 0 
                                   END 
                                 )
                , BValue1   = SUM(hiValue1) 
                , BValue2   = SUM(hiValue2) 
         FROM       [!ActiveSchema!].[HISTORY_All] HST WITH (NOEXPAND, READUNCOMMITTED) 
         WHERE       hiExClass = ASCII(@iv_NType) 
         AND       HST.hiCodeComputed = @iv_NCode
         AND       HST.hiCurrency = @iv_PCr
         AND       (((HST.hiYear = @iv_PYr) and (HST.hiPeriod <= @PPrYear)) 
         OR           ((HST.hiYear = @PreviousYear) and (HST.hiPeriod = @c_hiPeriodYTD)))
    END
    RETURN
END
GO

