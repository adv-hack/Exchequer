/****** Object:  StoredProcedure [!ActiveSchema!].[esp_RollupJobBudgets]    Script Date: 04/26/2016 08:13:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_RollupJobBudgets]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].[esp_RollupJobBudgets]
GO

CREATE PROCEDURE [!ActiveSchema!].[esp_RollupJobBudgets] ( @iv_CategoriesOnly BIT         = 0
                                                , @iv_JobCode        VARCHAR(10) = NULL)
AS
BEGIN

  SET NOCOUNT ON;
  
  IF (SELECT PeriodBud
      FROM !ActiveSchema!.EXCHQSS
      WHERE common.GetString(IDCode, 1) = 'JOB') = 1
  BEGIN
    -- Period Job Budgets
    EXEC !ActiveSchema!.esp_UpdateJobCategoryLevelPeriodBudgets @iv_JobCode

    IF (@iv_CategoriesOnly = 0)
    BEGIN
      EXEC !ActiveSchema!.esp_UpdateParentJobPeriodBudgets
    END
  END
  ELSE
  BEGIN
    -- Non Period Job Budgets
    EXEC !ActiveSchema!.isp_UpdateCategoryLevel @iv_JobCode

    IF (@iv_CategoriesOnly = 0)
    BEGIN
      EXEC !ActiveSchema!.esp_UpdateParentJobNonPeriodBudgets
    END
  END

  -- Recalculate CTD Values

  EXEC !ActiveSchema!.esp_RecalculateCTDJobBudgets

END

GO


