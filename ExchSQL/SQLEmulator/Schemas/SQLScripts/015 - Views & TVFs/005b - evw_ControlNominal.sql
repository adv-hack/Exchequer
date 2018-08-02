
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_ControlNominal]'))
DROP VIEW [!ActiveSchema!].evw_ControlNominal
GO

CREATE VIEW !ActiveSchema!.evw_ControlNominal WITH VIEW_METADATA
AS
SELECT P.ControlType
     , P.NominalCode
FROM   !ActiveSchema!.evw_NominalControl
UNPIVOT
(
  NominalCode
  FOR ControlType IN ([Debtor],[Creditor],[PLStart],[PLEnd],[DiscountGiven],[DiscountTaken],[ProfitBF]
                     ,[LineDiscountGiven],[LinediscountTaken],[InputVAT],[OutputVAT],[FreightUplift]
                     ,[SalesCommitment],[PurchaseCommitment],[currencyVariance],[UnrealisedcurrencyVariance]
                     )
) AS P

GO