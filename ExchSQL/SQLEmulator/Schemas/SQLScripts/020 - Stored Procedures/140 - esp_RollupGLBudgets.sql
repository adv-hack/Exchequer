/****** Object:  StoredProcedure [!ActiveSchema!].[esp_RollupGLBudgets]    Script Date: 04/25/2016 08:37:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_RollupGLBudgets]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].[esp_RollupGLBudgets]
GO

/****** Object:  StoredProcedure [!ActiveSchema!].[esp_RollupGLBudgets]    Script Date: 04/25/2016 08:37:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [!ActiveSchema!].[esp_RollupGLBudgets] ( @iv_SummarisationLevel VARCHAR(3) = 'C' )
AS
BEGIN

  -- Summarisation Levels
  
  -- C   - summarise Cost Centre
  -- D   - summarise Department 
  -- G   - summarise GL Only
  -- C+D - Summarise CC + Dept

  -- For debug purposes
  -- DECLARE @iv_SummarisationLevel VARCHAR(1) = 'C'
  --       , @iv_Mode               INT        = 0
        
  SET NOCOUNT ON;

  DECLARE @c_Fix    INT = 0
        , @c_Report INT = 1
        , @c_Debug  INT = 2


  IF @iv_SummarisationLevel IN ('C','D')
  BEGIN
  
    EXEC !ActiveSchema!.esp_RollupGLCCDeptBudgets @iv_SummarisationLevel = @iv_SummarisationLevel
  
  END
  
  IF @iv_SummarisationLevel = 'C+D'
  BEGIN
  
    EXEC !ActiveSchema!.esp_RollupGLCCDeptBudgets @iv_SummarisationLevel = 'C'

    EXEC !ActiveSchema!.esp_RollupGLCCDeptBudgets @iv_SummarisationLevel = 'D'

  END
  
  EXEC !ActiveSchema!.esp_RollupGLSummaryBudgets @iv_summarisationLevel = @iv_SummarisationLevel

    -- Now Summarize the CTD rows - summary not done in current system so commented out for the moment

    -- EXEC [!ActiveSchema!].esp_RecalculateCTDNominalBudgets

    -- Now Summarize the YTD rows - summary not done in current system so commented out for the moment

    -- EXEC [!ActiveSchema!].esp_RecalculateYTDNominalBudgets
  
END


GO


