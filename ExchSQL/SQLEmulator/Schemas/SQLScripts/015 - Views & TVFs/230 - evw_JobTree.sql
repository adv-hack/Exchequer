
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_JobTree]'))
DROP VIEW [!ActiveSchema!].[evw_JobTree]
GO

CREATE VIEW !ActiveSchema!.evw_JobTree
AS
SELECT *
FROM   !ActiveSchema!.efn_JobTree()

GO

