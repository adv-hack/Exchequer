IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_JobType]'))
DROP VIEW [!ActiveSchema!].[evw_JobType]
GO

CREATE VIEW !ActiveSchema!.evw_JobType WITH VIEW_METADATA
AS
SELECT JobTypeId          = JT.PositionId
     , JobTypeCode        = JT.var_code1Trans1
     , JobTypeDescription = JT.JTypeName
     , IsTagged           = JT.JTTag

FROM !ActiveSchema!.JOBMISC JT
WHERE JT.RecPfix = 'J'
AND   JT.SubType = 'T'

GO
