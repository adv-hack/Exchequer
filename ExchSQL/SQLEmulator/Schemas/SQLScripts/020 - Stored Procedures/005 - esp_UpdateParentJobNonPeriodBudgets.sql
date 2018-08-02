
/****** Object:  StoredProcedure [!ActiveSchema!].[esp_UpdateParentJobNonPeriodBudgets]    Script Date: 12/12/2014 11:37:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_UpdateParentJobNonPeriodBudgets]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].[esp_UpdateParentJobNonPeriodBudgets]
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_UpdateParentJobNonPeriodBudgets]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [!ActiveSchema!].[esp_UpdateParentJobNonPeriodBudgets]
AS 
BEGIN

SET NOCOUNT ON;

  -- Roll up job Tree

MERGE !ActiveSchema!.JobTotalsBudget JTB 
USING (SELECT JobCode           = JA.AscendantJobCode
            , JTB.AnalHed
            , CategoryHistoryId = JTB.HistFolio
            --, Currency          = ACB.JBudgetCurr
            , OriginalQuantity  = SUM(JTB.BoQty)
            , RevisedQuantity   = SUM(JTB.BrQty)
            , OriginalBudget    = SUM(JTB.BoValue)
            , RevisedBudget     = SUM(JTB.BrValue)

       FROM   !ActiveSchema!.JobTotalsBudget    JTB
       JOIN   !ActiveSchema!.evw_Job              J ON JTB.JobCode           = J.JobCode
                                                   AND J.JobContractTypeCode = ''J''
       JOIN   !ActiveSchema!.evw_JobAscendant    JA ON JTB.JobCode = JA.JobCode
       WHERE  (JTB.BoQty   <> 0
          OR   JTB.BrQty   <> 0
          OR   JTB.BoValue <> 0
          OR   JTB.BrValue <> 0
              )

       GROUP BY JA.AscendantJobCode
              , JTB.AnalHed
              , JTB.HistFolio
                               ) BData ON BData.JobCode           = JTB.JobCode
                                      AND BData.CategoryHistoryId = JTB.HistFolio
                                      --AND BData.Currency          = JTB.JBudgetCurr
WHEN NOT MATCHED BY TARGET THEN
    INSERT ( AnalCode
           , HistFolio
           , JobCode
           , StockCode
           , BType
           , ReCharge
           , OverCost
           , UnitPrice
           , BoQty
           , BRQty
           , BoValue
           , BRValue
           , CurrBudg
           , PayRMode
           , CurrPType
           , AnalHed
           , OrigValuation
           , RevValuation
           , JBUpliftP
           , JAPcntApp
           , JABBasis
           , JBudgetCurr)
     VALUES ( ''''
            , BData.CategoryHistoryId
            , BDATA.JobCode
            , ''''
            , 0
            , 0
            , 0
            , 0
            , BData.OriginalQuantity
            , BData.RevisedQuantity
            , BData.OriginalBudget
            , BData.RevisedBudget
            , 0
            , 0
            , 0
            , BData.AnalHed
            , 0
            , 0
            , 0
            , 0
            , 0
            , 0 
            )
WHEN MATCHED THEN
     UPDATE 
        SET BRQty   = BData.RevisedQuantity
          , BoQty   = BData.OriginalQuantity
          , BRValue = BData.RevisedBudget
          , BoValue = BData.OriginalBudget
          ;

END

' 
END
GO


