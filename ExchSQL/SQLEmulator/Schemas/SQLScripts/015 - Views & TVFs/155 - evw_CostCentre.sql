IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_CostCentre]'))
DROP VIEW [!ActiveSchema!].[evw_CostCentre]
GO

CREATE VIEW !ActiveSchema!.evw_CostCentre
AS
SELECT CostCentreId   = CC.PositionId
     , CostCentreCode = common.GetString(CC.EXCHQCHKCode1, 1)
     , CostCentreName = RTRIM(CC.CCDescTrans)
     , IsActive       = ~(CONVERT(BIT, CC.HideAC))
     , IsTagged       = CC.CCTag

FROM   !ActiveSchema!.EXCHQCHK CC
WHERE CC.RecPFix       = 'C'
AND   CHAR(CC.SubType) = 'C'

GO
