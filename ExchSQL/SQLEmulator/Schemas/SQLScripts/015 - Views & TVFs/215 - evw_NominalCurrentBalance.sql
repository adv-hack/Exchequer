IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_NominalCurrentBalance]'))
DROP VIEW [!ActiveSchema!].[evw_NominalCurrentBalance]
GO

CREATE VIEW !ActiveSchema!.evw_NominalCurrentBalance WITH VIEW_METADATA
AS
SELECT NH.NominalCode
     , BalanceAmount
 FROM   !ActiveSchema!.evw_NominalHistory NH
 JOIN (SELECT NominalCode
            , MaxHistoryPeriodKey = MAX(HistoryPeriodKey)
       FROM   !ActiveSchema!.evw_NominalHistory MNH
       WHERE  MNH.HistoryPeriod  IN (254, 255)
       AND    MNH.CurrencyId     = 0
       AND    MNH.DepartmentCode IS NULL
       AND    MNH.CostCentreCode IS NULL

       GROUP BY NominalCode) MPK ON MPK.NominalCode         = NH.NominalCode
                                 AND MPK.MaxHistoryPeriodKey = NH.HistoryPeriodKey
WHERE NH.CurrencyId     = 0
AND   NH.DepartmentCode IS NULL
AND   NH.CostCentreCode IS NULL

GO
