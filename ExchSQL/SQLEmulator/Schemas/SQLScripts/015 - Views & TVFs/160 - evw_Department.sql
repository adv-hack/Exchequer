IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_Department]'))
DROP VIEW [!ActiveSchema!].[evw_Department]
GO

CREATE VIEW !ActiveSchema!.evw_Department
AS
SELECT DepartmentId   = DP.PositionId
     , DepartmentCode = common.GetString(DP.EXCHQCHKCode1, 1)
     , DepartmentName = RTRIM(DP.CCDescTrans)
     , IsActive       = ~(CONVERT(BIT, DP.HideAC))
     , IsTagged       = DP.CCTag

FROM   !ActiveSchema!.EXCHQCHK DP
WHERE DP.RecPFix       = 'C'
AND   CHAR(DP.SubType) = 'D'

GO
