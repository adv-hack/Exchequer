/****** Object:  StoredProcedure [!ActiveSchema!].[esp_RecalculateJobActuals]    Script Date: 29/01/2015 14:29:12 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_RecalculateJobActuals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].[esp_RecalculateJobActuals]
GO

-- Recalculate Job Actuals 

-- Two Modes: 0 - Fix Data
--            1 - Report Data

-- Usage: EXEC !ActiveSchema!.esp_RecalculateJobActuals 1

CREATE PROCEDURE !ActiveSchema!.esp_RecalculateJobActuals (@iv_Mode INT = 0)
AS
BEGIN

  DECLARE @c_Fix    INT = 0
        , @c_Report INT = 1

  EXEC !ActiveSchema!.esp_RecalculateJobContractActuals @iv_Mode = @iv_Mode

  EXEC !ActiveSchema!.esp_RecalculateJobCostingActuals @iv_Mode = @iv_Mode

  EXEC !ActiveSchema!.esp_RecalculateEmployeeActuals @iv_Mode = @iv_Mode

  IF @iv_Mode = @c_Fix 
  BEGIN

    EXEC !ActiveSchema!.esp_RecalculateCTDJobActuals

    EXEC !ActiveSchema!.esp_RecalculateCTDJobCostingActuals

    EXEC !ActiveSchema!.esp_RecalculateCTDEmployeeActuals

  END

END
GO