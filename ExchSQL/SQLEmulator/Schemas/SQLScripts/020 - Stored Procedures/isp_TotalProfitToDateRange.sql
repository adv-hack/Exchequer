--/////////////////////////////////////////////////////////////////////////////
--// Filename        : isp_TotalProfitToDateRange.sql
--// Author        : Nilesh Desai
--// Date        : 17 July 2008
--// Copyright Notice    : (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description    : SQL Script to add isp_TotalProfitToDateRange stored procedure.
--//                  This SP will calculate Balance by calling the 
--//                  TotalProfitToDateRange functions based on parameter passed
--//
--// Usage        : EXEC [!ActiveSchema!].[isp_TotalProfitToDateRange] 'U', 0x4146454C3031, 0, 106, 253, 0, 1, 0 , @ov_Purch    OUTPUT 
--//                                                                                                  , @ov_PSales      OUTPUT
--//                                                                                                  , @ov_Balance    OUTPUT
--//                                                                                                  , @ov_PCleared    OUTPUT
--//                                                                                                  , @ov_PBudget    OUTPUT 
--//                                                                                                  , @ov_PRBudget1    OUTPUT 
--//                                                                                                  , @ov_PRBudget2    OUTPUT 
--//                                                                                                  , @ov_PRBudget3    OUTPUT 
--//                                                                                                  , @ov_PRBudget4    OUTPUT 
--//                                                                                                  , @ov_PRBudget5    OUTPUT
--//                                                                                                  , @ov_BValue1    OUTPUT
--//                                                                                                  , @ov_BValue2    OUTPUT
--// 
--//                 EXEC [!ActiveSchema!].[isp_TotalProfitToDateRange] 'W', 0x414241503031, 0, 106, 253, 0, 1, 0,  @ov_Purch    OUTPUT 
--//                                                                                                  , @ov_PSales      OUTPUT
--//                                                                                                  , @ov_Balance    OUTPUT
--//                                                                                                  , @ov_PCleared    OUTPUT
--//                                                                                                  , @ov_PBudget    OUTPUT 
--//                                                                                                  , @ov_PRBudget1    OUTPUT 
--//                                                                                                  , @ov_PRBudget2    OUTPUT 
--//                                                                                                  , @ov_PRBudget3    OUTPUT 
--//                                                                                                  , @ov_PRBudget4    OUTPUT 
--//                                                                                                  , @ov_PRBudget5    OUTPUT
--//                                                                                                  , @ov_BValue1    OUTPUT
--//                                                                                                  , @ov_BValue2    OUTPUT
--// 
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//    1    : 17 July 2008 : Nilesh Desai : File Creation
--//  2 : 29 July 2008 : Amended
--//  3 :  9 September 2008 : James Waygood : Changed NCode from varchar to varbinary
--//
--/////////////////////////////////////////////////////////////////////////////

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[isp_TotalProfitToDateRange]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].[isp_TotalProfitToDateRange]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [!ActiveSchema!].[isp_TotalProfitToDateRange]    (
      @iv_NType          Char(1)
    , @iv_NCode          VARBINARY(20)            
    , @iv_PCr            INT                    -- Currency
    , @iv_PYr            INT                    -- hiYear
    , @iv_PPr            INT                    -- hiPeriod
    , @iv_PPr2           INT                    -- hiPreviousPeriod
    , @iv_Range          BIT                
    , @iv_SetACHist      BIT
    , @ov_Purch          float = 0 OUTPUT
    , @ov_PSales         float = 0 OUTPUT
    , @ov_Balance        float = 0 OUTPUT
    , @ov_PCleared       float = 0 OUTPUT
    , @ov_PBudget        float = 0 OUTPUT 
    , @ov_PRBudget1      float = 0 OUTPUT
    , @ov_PRBudget2      float = 0 OUTPUT
    , @ov_PRBudget3      float = 0 OUTPUT
    , @ov_PRBudget4      float = 0 OUTPUT
    , @ov_PRBudget5      float = 0 OUTPUT
    , @ov_BValue1        float = 0 OUTPUT
    , @ov_BValue2        float = 0 OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON
    -- Delcare Variable
    DECLARE        @ReturnCode INT
    
    -- Setting default values 
    SELECT        @ReturnCode = 0

    BEGIN TRY
            
        -- Calling TotalProfitToDateRange Function
            SELECT  @ov_Purch     = ISNULL(Purch,0)
                  , @ov_PSales    = ISNULL(PSales,0)
                  , @ov_Balance   = ISNULL(Balance,0)
                  , @ov_PCleared  = ISNULL(PCleared,0)
                  , @ov_PBudget   = ISNULL(PBudget,0)
                  , @ov_PRBudget1 = ISNULL(PRBudget1,0)
                  , @ov_PRBudget2 = ISNULL(PRBudget2,0)
                  , @ov_PRBudget3 = ISNULL(PRBudget3,0)
                  , @ov_PRBudget4 = ISNULL(PRBudget4,0)
                  , @ov_PRBudget5 = ISNULL(PRBudget5,0)
                  , @ov_BValue1   = ISNULL(BValue1,0)
                  , @ov_BValue2   = ISNULL(BValue2,0)            
            FROM [!ActiveSchema!].[ifn_TotalProfitToDateRange] ( @iv_NType
                                                               , @iv_NCode
                                                               , @iv_PCr
                                                               , @iv_PYr
                                                               , @iv_PPr
                                                               , @iv_PPr2
                                                               , @iv_Range
                                                               , @iv_SetACHist
                                                               )
            
    END TRY
    BEGIN CATCH
         -- Execute error logging routine
        EXEC common.isp_RaiseError   @iv_IRISExchequerErrorMessage = 'Procedure [!ActiveSchema!].[isp_TotalProfitToDateRange]' -- Include optional message...?
        -- SP failed - error raised
        SET @ReturnCode = -1    
    END CATCH

    SET NOCOUNT OFF
    RETURN @ReturnCode
END

GO